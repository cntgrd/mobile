//
//  MapViewController.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-10-31.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	var mapView: SafeMapView!
	var locationButton: MKUserTrackingButton!
	lazy var locationManager: CLLocationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let margins = view.layoutMarginsGuide
		locationManager.requestWhenInUseAuthorization()
		mapView = {
			let m = SafeMapView()
//			m.showsUserLocation = true
			m.translatesAutoresizingMaskIntoConstraints = false
			return m
		}()
		view.addSubview(mapView)
		mapView.constrainEdgesToSuperview()
		
		locationButton = {
			let b = MKUserTrackingButton(mapView: self.mapView!)
			b.translatesAutoresizingMaskIntoConstraints = false
			return b
		}()
		view.addSubview(locationButton)
		locationButton.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
		locationButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

