//
//  MapView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-30.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class MapView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setNeedsUpdateConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateConstraints() {
		super.updateConstraints()
		
		
	}
}
