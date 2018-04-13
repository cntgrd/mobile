//
//  SafeMapView.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-11-02.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
	var attributionLabel: UIView {
		get {
			return self.subviews[1]
		}
	}
}
