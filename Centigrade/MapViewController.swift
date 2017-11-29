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
	
	var mapView: MKMapView!
	var locationButton: MKUserTrackingButton!
	var testCircle: CircleButton!
	
	lazy var locationManager: CLLocationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.requestWhenInUseAuthorization()
		mapView = {
			let m = MKMapView()
			m.attributionLabel.isHidden = true
			m.translatesAutoresizingMaskIntoConstraints = false
			return m
		}()
		view.addSubview(mapView)
		
//		locationButton = {
//			let b = MKUserTrackingButton(mapView: self.mapView!)
//			b.translatesAutoresizingMaskIntoConstraints = false
//			return b
//		}()
//		view.addSubview(locationButton)
//		locationButton.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//		locationButton.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
		
		testCircle = {
			let c = CircleButton()
			c.translatesAutoresizingMaskIntoConstraints = false
			c.backgroundColor = view.tintColor
			c.tintColor = .white
			c.icon = UIImage(imageLiteralResourceName: "location")
			return c
		}()
		view.addSubview(testCircle)
		
	}

	override func updateViewConstraints() {
		mapView.constrainEdgesToSuperview()
		testCircle.constrainEdgesToSuperview([.top, .trailing], usingMargins: true)
		super.updateViewConstraints()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

