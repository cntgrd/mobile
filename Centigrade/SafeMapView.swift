//
//  SafeMapView.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-11-02.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import UIKit
import MapKit

class SafeMapView: MKMapView {
	
	private var attributionLabel: UIView {
		get {
			return self.subviews[1]
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		attributionLabel.isHidden = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		attributionLabel.isHidden = true
	}
}
