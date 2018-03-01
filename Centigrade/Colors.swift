//
//  Colors.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-02-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class Colors {
	static func makeP3Color(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: CGFloat) -> UIColor {
		let f = { (x: UInt8) in CGFloat(x)/255 }
		return UIColor(displayP3Red: f(r), green: f(g), blue: f(b), alpha: a)
	}
	
	static let circleButtonDefaultBackground = UIColor(white: 0.9, alpha: 1)
	static let circleUserTrackingButtonBackground = makeP3Color(0, 122, 255, 1.0)
	
	static let weatherSunnyBackground  = makeP3Color(248, 231, 28, 1.0)
	static let weatherCloudyBackground = makeP3Color(54, 223, 196, 1.0)
}
