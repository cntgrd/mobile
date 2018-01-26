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
	var cardView: UIView!
	
	lazy var locationManager: CLLocationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.requestWhenInUseAuthorization()
		mapView = {
			let m = MKMapView()
			m.showsCompass = false
			m.attributionLabel.isHidden = true
			m.translatesAutoresizingMaskIntoConstraints = false
			return m
		}()
		view.addSubview(mapView)
		
		locationButton = {
			let c = CircleUserTrackingButton(mapView: self.mapView)
			c.translatesAutoresizingMaskIntoConstraints = false
			return c
		}()
		view.addSubview(locationButton)
		
		cardView = {
			let v = UIView()
			v.translatesAutoresizingMaskIntoConstraints = false
			v.backgroundColor = .red
			return v
		}()
		view.addSubview(cardView)
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

