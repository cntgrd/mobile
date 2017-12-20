//
//  HashablePair.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-12-19.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import Foundation

struct HashablePair<FirstType: Hashable, SecondType: Hashable>: Hashable {
	let first: FirstType
	let second: SecondType
	init(_ first: FirstType, _ second: SecondType) {
		self.first = first
		self.second = second
	}
	var hashValue: Int {
		get {
			// Truncates both hash values to 16 bits,
			// then "appends" {firstHash}{secondHash}
			// by shifting the fromHash over 16 bits
			// and performing a bitwise OR with the toHash.
			
			let mask = (1<<16)-1 // 16 1's
			let firstHash = first.hashValue & mask
			let secondHash = second.hashValue & mask
			
			return firstHash << 16 | secondHash
		}
	}
	
	static func ==(lhs: HashablePair<FirstType,SecondType>, rhs: HashablePair<FirstType,SecondType>) -> Bool {
		return lhs.first == rhs.first && lhs.second == rhs.second
	}
}
