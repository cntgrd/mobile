//
//  API.swift
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
	case unknown, sunny, cloudy, clear
}

struct Temperature: CustomDebugStringConvertible {
	var debugDescription: String {
		switch unit {
		case .fahrenheit:
			return "Temperature(\(value)°F)"
		case .celsius:
			return "Temperature(\(value)°C)"
		}
	}
	
	enum Unit { case fahrenheit, celsius }
	
	private var value: Int
	private var unit: Unit
	init(degreesFahrenheit: Int) {
		value = degreesFahrenheit
		unit = .fahrenheit
	}
	init(degreesCelsius: Int) {
		value = degreesCelsius
		unit = .celsius
	}
	
	var inCelsius: Int {
		switch unit {
		case .celsius:
			return value
		case .fahrenheit:
			// C = 5/9 (F-32)
			
			return Int((5.0/9.0) * Double(value - 32))
		}
	}
	
	var inFahrenheit: Int {
		switch unit {
		case .celsius:
			// F = 1.8 C + 32
			return Int((1.8 * Double(value)) + 32)
		case .fahrenheit:
			return value
		}
	}
}

enum APIError: Error {
	case malformedURL, malformedDate, unexpectedValue(String)
}

extension APIError: LocalizedError {
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

fileprivate func decodeNWSDate(_ dateString: String) -> Date? {
	// "2018-03-05T18:00:00-06:00"
	let isoFormatter = ISO8601DateFormatter()
	return isoFormatter.date(from: dateString)
}

// this struct mirrors the format of the JSON response
// (it is a subset of it). We only use this as an intermediary
// format before converting it to the more friendly NWSForecast
fileprivate struct RawNWSForecastResponse: Decodable {
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

struct NWSForecast {
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
	
	fileprivate init(fromRawForecast rawForecast: RawNWSForecastResponse) throws {
		periods = try rawForecast.properties.periods.map { period in
			guard
				let start = decodeNWSDate(period.startTime),
				let end = decodeNWSDate(period.endTime)
			else {
				throw APIError.malformedDate
			}
			
			let temperature: Temperature = try {
				if period.temperatureUnit == "F" {
					return Temperature(degreesFahrenheit: period.temperature)
				} else if period.temperatureUnit == "C" {
					return Temperature(degreesCelsius: period.temperature)
				} else {
					throw APIError.unexpectedValue("Given temperatureUnit '\(period.temperatureUnit)'")
				}
			}()
			
			let (conditionDescription, condition) = API.parseCondition(
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

class API {
	
	// the root URL of the National Weather Service API
	static let nwsRoot: URL? = URL(string: "https://api.weather.gov/")
	
	static let locationManager = CLLocationManager()
	
	static func getCurrentLocation() -> Promise<CLLocation> {
		return CLLocationManager.promise().lastValue
	}
	
	static func getForecast(atLocation location: CLLocation) -> Promise<NWSForecast> {
		// build the URL corresponding to the given coordinate
		let (lat, lon) = (location.coordinate.latitude, location.coordinate.longitude)
		let path = "points/\(lat),\(lon)/forecast"
		
		guard let url = nwsRoot?.appendingPathComponent(path) else {
			 return Promise(error: APIError.malformedURL)
		}
		
		let request = URLRequest(url: url)
		return URLSession.shared.dataTask(.promise, with: request).map {
			try JSONDecoder().decode(RawNWSForecastResponse.self, from: $0.data)
		}.map {
			try NWSForecast(fromRawForecast: $0)
		}
	}
	
	static func getForecastAtCurrentLocation() -> Promise<NWSForecast> {
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
		
		for k in conditions.keys {
			print(k)
		}
		
		// there may be a comma after the condition part, as below:
		//     Mostly sunny, with a high near 71.
		// or just a sentence:
		//     Sunny. High near 82, ...
		let sentences: [Substring] = message.split(separator: ".")
		
		// ["Mostly sunny", " with a high near 71"]
		// potentialCondition = "mostly sunny" -- note the lowercase
		if let description = sentences.first?.split(separator: ",").first?.lowercased(),
		   let condition = conditions[description]
		{
			let titleDescription = description.capitalized
			return (titleDescription, condition)
		}
		
		print("API.parseCondition(fromForecastMessage:) could not interpret condition:\n")
		print("\t\(message)\n")
		
		return ("Unknown", .unknown)
	}
}
