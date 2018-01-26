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
	var cardView: UICollectionView!
	
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
			let v = UICollectionView(frame: .zero, collectionViewLayout: CardScrollLayout())
			v.translatesAutoresizingMaskIntoConstraints = false
			v.layer.masksToBounds = false
			v.dataSource = self
			v.delegate = self
			v.backgroundColor = .clear
			v.bounces = true
			v.showsHorizontalScrollIndicator = false
			v.showsVerticalScrollIndicator = false
			v.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "card")
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
		cardView.constrainToHeight(250)
		
		super.updateViewConstraints()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension MapViewController: UICollectionViewDelegate {}

extension MapViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 200, height: 250)
	}
}

extension MapViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let card = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath)
		card.contentView.backgroundColor = .white
		card.layer.masksToBounds = false
		card.layer.shadowOffset = CGSize(width: 0, height: 5)
		card.layer.shadowRadius = 8
		card.layer.shadowOpacity = 0.5
		return card
	}
}

