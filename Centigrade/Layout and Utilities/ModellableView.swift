//
//  ModellableView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-25.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

protocol ModellableView {
	init(fromModel: ViewModelType)
	associatedtype ViewModelType
}
