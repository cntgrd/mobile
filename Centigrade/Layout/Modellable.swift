//
//  Modellable.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-02-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

protocol Modellable: class {
	associatedtype ViewModel
	func load(viewModel: ViewModel)
}
