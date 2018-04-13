//
//  TextToSpeech.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech {
	private static let speechSynthesizer = AVSpeechSynthesizer()
	static func speak(_ string: String) {
		speechSynthesizer.speak(AVSpeechUtterance(string: string))
	}
}
