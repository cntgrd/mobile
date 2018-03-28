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

enum APIError: Error {
	case malformedURL
}

extension APIError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .malformedURL:
			return "The given URL was malformed or nil."
//		default:
//			return nil
		}
	}
}

class API {
	
	// this struct mirrors the format of the JSON response
	// (it is a subset of it). We only use this as an intermediary
	// format before converting it to the more friendly NWSForecast
	fileprivate struct RawNWSForecastResponse: Decodable {
		var updated: String
		
		
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
			var periods: [Period]
		}
		
		var properties: Properties
	}
	
	struct NWSForecast {
		struct Period {
			var name: String
		}
		
		var periods: [Period]
		
		fileprivate init(fromRawForecast rawForecast: RawNWSForecastResponse) {
			periods = rawForecast.properties.periods.map {
				Period(name: $0.name)
			}
		}
	}
	
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
			NWSForecast(fromRawForecast: $0)
		}
	}
	
	static func getForecastAtCurrentLocation() -> Promise<NWSForecast> {
		return getCurrentLocation().then { location in
			getForecast(atLocation: location)
		}
	}
}
