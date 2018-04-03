//
//  NationalWeatherServiceAPI.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation
import PromiseKit
import PMKCoreLocation
import PMKFoundation

enum WeatherCondition {
	case unknown, sunny, cloudy, clear, rain, snow, thunderstorms, fog
}

extension NationalWeatherServiceAPI.ErrorType: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .malformedURL:
			return "The given URL was malformed or nil."
		case .malformedDate:
			return "The date string from the server could not be converted into a native date format."
		case let .unexpectedValue(message):
			return "Unexpected value: \(message)"
		}
	}
}

class NationalWeatherServiceAPI {
	
	// this struct mirrors the format of the JSON response
	// (it is a subset of it). We only use this as an intermediary
	// format before converting it to the more friendly NWSForecast
	fileprivate struct RawForecastResponse: Decodable {
		struct Period: Decodable {
			// for ordering
			var number: Int
			// "This Afternoon", "Tonight", "Tuesday", "Tuesday Night", etc.
			var name: String
			// "2018-03-05T18:00:00-06:00"
			var startTime: String
			var endTime: String
			
			var isDaytime: Bool
			var temperature: Int
			
			// "F"
			var temperatureUnit: String
			
			// "falling", null
			var temperatureTrend: String?
			
			// "5 to 15 mph"
			var windSpeed: String
			
			// "ENE"
			var windDirection: String
			
			// "Partly Sunny then Slight Chance Rain Showers"
			var shortForecast: String
			
			// "A slight chance of rain showers after 1pm. Partly sunny.
			// High near 72, with temperatures falling to around 68 in the
			// afternoon. Northwest wind 5 to 15 mph, with gusts as high as
			// 25 mph. Chance of precipitation is 20%."
			var detailedForecast: String
		}
		
		struct Properties: Decodable {
			// "2018-03-05T18:00:00-06:00"
			var updated: String
			
			var periods: [Period]
		}
		
		var properties: Properties
	}
	
	enum ErrorType: Error {
		case malformedURL, malformedDate, unexpectedValue(String)
	}
	
	struct Forecast {
		struct Period {
			var number: Int
			var name: String
			var interval: DateInterval
			var isDaytime: Bool
			var temperature: Temperature
			var condition: WeatherCondition
			var conditionDescription: String
		}
		
		var periods: [Period]
		
		fileprivate init(fromRawForecast rawForecast: RawForecastResponse) throws {
			periods = try rawForecast.properties.periods.map { period in
				guard
					let start = decodeNWSDate(period.startTime),
					let end = decodeNWSDate(period.endTime)
					else {
						throw ErrorType.malformedDate
				}
				
				let temperature: Temperature = try {
					if period.temperatureUnit == "F" {
						return Temperature(degreesFahrenheit: period.temperature)
					} else if period.temperatureUnit == "C" {
						return Temperature(degreesCelsius: period.temperature)
					} else {
						throw ErrorType.unexpectedValue("Given temperatureUnit '\(period.temperatureUnit)'")
					}
					}()
				
				let (conditionDescription, condition) = NationalWeatherServiceAPI.parseCondition(
					fromForecastMessage: period.detailedForecast
				)
				
				return Period(
					number: period.number,
					name: period.name,
					interval: DateInterval(start: start, end: end),
					isDaytime: period.isDaytime,
					temperature: temperature,
					condition: condition,
					conditionDescription: conditionDescription
				)
				}.sorted(by: {
					// areInIncreasingOrder
					$0.number < $1.number
				})
		}
	}
	
	// the root URL of the National Weather Service API
	static let nwsRoot: URL? = URL(string: "https://api.weather.gov/")
	
	static let locationManager = CLLocationManager()
	
	fileprivate static func decodeNWSDate(_ dateString: String) -> Date? {
		// "2018-03-05T18:00:00-06:00"
		let isoFormatter = ISO8601DateFormatter()
		return isoFormatter.date(from: dateString)
	}
	
	static func getCurrentLocation() -> Promise<CLLocation> {
		return CLLocationManager.promise().lastValue
	}
	
	static func getForecast(atLocation location: CLLocation) -> Promise<Forecast> {
		// build the URL corresponding to the given coordinate
		let (lat, lon) = (location.coordinate.latitude, location.coordinate.longitude)
		let path = "points/\(lat),\(lon)/forecast"
		
		guard let url = nwsRoot?.appendingPathComponent(path) else {
			 return Promise(error: ErrorType.malformedURL)
		}
		
		let request = URLRequest(url: url)
		return URLSession.shared.dataTask(.promise, with: request).map {
			try JSONDecoder().decode(RawForecastResponse.self, from: $0.data)
		}.map {
			try Forecast(fromRawForecast: $0)
		}
	}
	
	static func getForecastAtCurrentLocation() -> Promise<Forecast> {
		return getCurrentLocation().then { location in
			getForecast(atLocation: location)
		}
	}
	
	static func parseCondition(fromForecastMessage message: String) -> (String, WeatherCondition) {
		var conditions = [String: WeatherCondition]()
		let basicConditions: [String: WeatherCondition] = [
			"sunny": .sunny,
			"cloudy": .cloudy,
			"clear": .clear
		]
		
		// accept variants of conditions "mostly —" and "partly —"
		for word in ["", "partly ", "mostly "] {
			for (k,v) in basicConditions {
				conditions["\(word)\(k)"] = v
			}
		}
		
		// there may be a comma after the condition part, as below:
		//     Mostly sunny, with a high near 71.
		// or just a sentence:
		//     Sunny. High near 82, ...
		let sentences: [Substring] = message.split(separator: ".")
		
		// sometimes the first sentence may be an additional one about rain ongoing
		// or the chance of rain, rather than the general conditions.
		guard let firstSentence = sentences.first?.lowercased() else {
			print("API.parseCondition(fromForecastMessage:) could not separate sentences from given condition message.\n")
			return ("Unknown", .unknown)
		}
		
		let firstSentenceCommaParts = firstSentence.split(separator: ",")
		let lastCommaPart = firstSentenceCommaParts.last ?? ""
		
		if lastCommaPart.contains("patchy fog") {
			return ("Patchy Fog", .fog)
		} else if lastCommaPart.contains("fog") {
			return ("Fog", .fog)
		}
		
		for (precipitationType, condition) in [
			"rain": WeatherCondition.rain,
			"snow": WeatherCondition.snow,
			"showers and thunderstorms": WeatherCondition.thunderstorms,
			"thunderstorms": WeatherCondition.thunderstorms,
			"showers": WeatherCondition.rain
		] {
			if
				lastCommaPart.contains("slight chance of \(precipitationType)") ||
				lastCommaPart.contains("chance of \(precipitationType)")
			{
				return ("Chance \(precipitationType.localizedCapitalized)", condition)
			} else if
				lastCommaPart.contains("\(precipitationType) likely") ||
				lastCommaPart.contains(precipitationType)
			{
				return (precipitationType.localizedCapitalized, condition)
			}
		}
		
		// ["Mostly sunny", " with a high near 71"]
		// potentialCondition = "mostly sunny" -- note the lowercase
		if let description = firstSentenceCommaParts.first,
		   let condition = conditions[String(description)]
		{
			let titleDescription = description.capitalized
			return (titleDescription, condition)
		}
		
		print("API.parseCondition(fromForecastMessage:) could not interpret condition:\n")
		print("\t\(message)\n")
		print("LASTCOMMAPART: '\(lastCommaPart)'")
		return ("Unknown", .unknown)
	}
}
