//
//  SettingsManager.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-30.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation

class OptionSetting<T> {
	typealias EncodeFunction = (T) -> String?
	typealias DecodeFunction = (String) -> T?
	
	private let defaults = UserDefaults.standard
	
	let options: [T]
	let defaultValue: T
	let key: String
	let encode: EncodeFunction
	let decode: DecodeFunction
	let nameForOption: EncodeFunction
	
	var value: T {
		get {
			guard let defaultsString = defaults.string(forKey: key) else {
				print("Warning: could not find Setting `\(key)` in UserDefaults. Returning defaultValue.")
				return defaultValue
			}
			guard let decoded: T = decode(defaultsString) else {
				print("Warning: could not decode Setting `\(key)` from UserDefaults. Returning defaultValue.")
				return defaultValue
			}
			return decoded
		}
		set {
			guard let defaultsString = encode(newValue) else {
				print("Warning: could not encode Setting `\(key)` for UserDefaults. Exiting without setting the setting.")
				return
			}
			defaults.set(defaultsString, forKey: key)
		}
	}
	
	init(options o: [T], defaultValue d: T, key k: String, encodeFunction: @escaping EncodeFunction, decodeFunction: @escaping DecodeFunction, nameFunction: @escaping EncodeFunction) {
		options = o
		defaultValue = d
		key = k
		decode = decodeFunction
		encode = encodeFunction
		nameForOption = nameFunction
		
		// check if the key is set, otherwise set the defaultValue
		guard defaults.string(forKey: key) == nil else { return }
		guard let defaultsString = encode(defaultValue) else {
			print("Warning: tried to set defaultValue for setting `\(key)` as it was not found in UserDefaults, but failed to encode it.")
			return
		}
		defaults.set(defaultsString, forKey: key)
	}
}

class SettingsManager {
	struct Units {
		var temperature = OptionSetting(
			options: Temperature.Unit.allValues,
			defaultValue: Temperature.Unit.fahrenheit,
			key: "Settings.units.temperature",
			encodeFunction: { $0.rawValue },
			decodeFunction: { Temperature.Unit(rawValue: $0) },
			nameFunction: { $0.rawValue }
		)
	}
	
	let units = Units()
	
	private init() {}
	static let shared = SettingsManager()
}
