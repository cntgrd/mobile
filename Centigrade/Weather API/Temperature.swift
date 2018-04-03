//
//  Temperature.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-04-02.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation

struct Temperature: CustomDebugStringConvertible {
	var debugDescription: String {
		switch unit {
		case .fahrenheit:
			return "Temperature(\(value)°F)"
		case .celsius:
			return "Temperature(\(value)°C)"
		}
	}
	
	enum Unit: String {
		case fahrenheit = "Fahrenheit", celsius = "Celsius"
		static var allValues: [Unit] { return [.fahrenheit, .celsius] }
	}
	
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
