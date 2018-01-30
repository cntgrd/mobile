//
//  CircleUserTrackingButton.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-24.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit
import MapKit

class CircleUserTrackingButton: CircleButton {
	
	let defaultBlue: UIColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
	
	private typealias ButtonStateMachine = EventStateMachine<TrackingButtonStates, TrackingButtonEvents>
	
	private enum TrackingButtonStates: States { case noTracking, trackingLocation/*, trackingOrientation*/ }
	private enum TrackingButtonEvents: Events { case push }
	
	private let mapView: MKMapView?
	private var buttonStateMachine: ButtonStateMachine
	
	init(mapView: MKMapView?) {
		self.mapView = mapView
		buttonStateMachine = ButtonStateMachine(state: .noTracking)
		super.init(frame: .zero)
		
		iconColor = .white
		
		addTarget(self, action: #selector(didPressTrackingButton(sender:)), for: .touchUpInside)
		setupStateMachine()
		updateStyle(forState: buttonStateMachine.state)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupStateMachine() {
		buttonStateMachine.on(event: .push, transitions: [
			.noTracking: .trackingLocation,
			/*
			.trackingLocation: .trackingOrientation,
			.trackingOrientation: .noTracking
			*/
			.trackingLocation: .noTracking
			])
		buttonStateMachine.when(stateBecomes: .noTracking) {
			self.mapView?.setUserTrackingMode(.none, animated: true)
			self.mapView?.showsUserLocation = false
			self.updateStyle(forState: .noTracking)
		}
		buttonStateMachine.when(stateBecomes: .trackingLocation) {
			self.mapView?.setUserTrackingMode(.follow, animated: true)
			self.mapView?.showsUserLocation = true
			self.updateStyle(forState: .trackingLocation)
		}
		/*
		buttonStateMachine.when(stateBecomes: .trackingOrientation) {
			self.mapView?.setUserTrackingMode(.followWithHeading, animated: true)
			self.mapView?.showsUserLocation = true
			self.updateStyle(forState: .trackingOrientation)
		}
		*/
	}
	
	private func updateStyle(forState state: TrackingButtonStates) {
		let c = self
		switch state {
		case .noTracking:
			c.backgroundColor = defaultBlue
			c.icon = UIImage(imageLiteralResourceName: "location-empty")
		case .trackingLocation:
			c.backgroundColor = defaultBlue
			c.icon = UIImage(imageLiteralResourceName: "location")
		/*
		case .trackingOrientation:
			c.backgroundColor = .red
			c.icon = UIImage(imageLiteralResourceName: "location")
		*/
		}
	}
	
	@objc private func didPressTrackingButton(sender: Any?) {
		try? buttonStateMachine.trigger(event: .push)
	}
}
