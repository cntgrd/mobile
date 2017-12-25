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
	var locationButton: CircleButton!
	
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
		
		locationButton = {
			let c = CircleButton()
			c.translatesAutoresizingMaskIntoConstraints = false
			c.backgroundColor = view.tintColor
			c.tintColor = .white
			c.icon = UIImage(imageLiteralResourceName: "location")
			c.addTarget(self, action: #selector(didPressLocationButton(sender:)), for: .touchUpInside)
			return c
		}()
		view.addSubview(locationButton)
		
	}
	
	@objc func didPressLocationButton(sender: Any?) {
		mapView.setUserTrackingMode(.follow, animated: true)
	}

	override func updateViewConstraints() {
		mapView.constrainEdgesToSuperview()
		locationButton.constrainEdgesToSuperview([.top, .trailing], inset: 10, usingMargins: true)
		super.updateViewConstraints()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

