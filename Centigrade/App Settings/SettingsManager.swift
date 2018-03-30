//
//  SettingsManager.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-30.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation

class Setting<T: Codable> {
	private let defaults = UserDefaults.standard
	let options: [T]
	let defaultValue: T
	let key: String
	var value: T {
		get {
			guard let defaultsString = defaults.string(forKey: key) else {
				value = defaultValue
				return defaultValue
			}
			do {
				return try JSONDecoder().decode(T, from: defaultsString)
			} catch {
				print("Warning: could not decode Setting `\(key)` from UserDefaults.")
				return defaultValue
			}
		}
		set {
			do {
				let defaultsString = try JSONEncoder().encode(newValue)
				defaults.set(defaultsString, forKey: key)
			} catch {
				print("Warning: could not encode Setting `\(key)` for UserDefaults.")
			}
		}
	}
	init(options: [T], defaultValue: T, key: String) {
		options = options
		defaultValue = defaultValue
		key = key
	}
}

class SettingsManager {
	struct Units {
		var temperature = Setting(
			options: Temperature.Unit.allValues,
			defaultValue: .fahrenheit,
			key: "Settings.units.temperature"
		)
	}
	
	var units: Units
}
