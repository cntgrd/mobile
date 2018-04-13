//
//  RandomUtilities.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-25.
//  Copyright © 2018 Centigrade. All rights reserved.
//

// https://gist.github.com/phrz/823afe778556113cbe79c6e8c87ce554

import Foundation

func random(_ r: ClosedRange<Int>) -> Int {
	let span = abs(r.upperBound-r.lowerBound)
	return Int(arc4random_uniform(UInt32(span)))+r.lowerBound
}
