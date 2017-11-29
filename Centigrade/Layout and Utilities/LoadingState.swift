//
//  LoadingState.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-11-28.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import Foundation

protocol LoadingState: class {
	var isLoading: Bool { set get }
}
