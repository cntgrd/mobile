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
	var cardView: CardView!
	
	lazy var locationManager: CLLocationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.requestWhenInUseAuthorization()
		mapView = {
			let m = MKMapView()
			m.delegate = self
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
			let v = CardView(size: CGSize(width: 193, height: 217))
			v.translatesAutoresizingMaskIntoConstraints = false
			v.dataSource = self
			v.register(ConditionCardCell.self, forCellWithReuseIdentifier: "condition-cell")
			return v
		}()
		view.addSubview(cardView)
	}

	override func updateViewConstraints() {
		mapView.constrainEdgesToSuperview()
		
		locationButton.constrainEdgesToSuperview([.trailing], inset: 15, usingMargins: false)
		locationButton.constrainEdgesToSuperview([.top], inset: 10, usingMargins: true)
		
		cardView.constrainEdgesToSuperview([.leading, .trailing], inset: 0, usingMargins: false)
		cardView.constrainEdgesToSuperview([.bottom], inset: 15, usingMargins: true)
		
		super.updateViewConstraints()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension MapViewController: MKMapViewDelegate {
	// [CITE] https://stackoverflow.com/a/32503189/3592716
	// Make the current location dot centered between the top of screen
	// and the top of the cards
	/*
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		guard mapView.userTrackingMode == .follow || mapView.userTrackingMode == .followWithHeading else {
			return
		}
		// Define a span (for zoom)
		let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		
		// Get user location
		let location = CLLocationCoordinate2D(
			latitude: userLocation.coordinate.latitude,
			longitude: userLocation.coordinate.longitude
		)
		
		// Get the close region for the user's location
		// This zooms into the user's tracked location
		let region = MKCoordinateRegion(center: location, span: span)
		let adjusted = mapView.regionThatFits(region)
		mapView.setRegion(adjusted, animated: true)
		
		var rect = mapView.visibleMapRect
		let point = MKMapPointForCoordinate(location)
		rect.origin.x = point.x - rect.size.width * 0.50
		rect.origin.y = point.y - rect.size.height * 0.25
		mapView.setVisibleMapRect(rect, animated: true)
	}
	*/
}

extension MapViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "condition-cell", for: indexPath)
		return cell
	}
}




