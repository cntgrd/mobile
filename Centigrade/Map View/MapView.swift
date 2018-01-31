//
//  MapView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-30.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {
	
	var map: MKMapView!
	var buttonStack: UIStackView!
	var locationButton: CircleUserTrackingButton!
	var appSettingsButton: CircleButton!
	var cardView: CardView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		map = {
			let m = MKMapView()
			m.showsCompass = false
			m.attributionLabel.isHidden = true
			m.translatesAutoresizingMaskIntoConstraints = false
			return m
		}()
		addSubview(map)
		
		locationButton = {
			let c = CircleUserTrackingButton(mapView: self.map)
			c.translatesAutoresizingMaskIntoConstraints = false
			return c
		}()
		
		appSettingsButton = {
			let a = CircleButton()
			a.icon = UIImage(imageLiteralResourceName: "app-settings")
			return a
		}()
		
		buttonStack = {
			let s = UIStackView(arrangedSubviews: [locationButton, appSettingsButton])
			s.translatesAutoresizingMaskIntoConstraints = false
			s.axis = .vertical
			s.spacing = 10
			return s
		}()
		addSubview(buttonStack)
		
		cardView = {
			let v = CardView(size: CGSize(width: 193, height: 217))
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()
		addSubview(cardView)
		
		setNeedsUpdateConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		
		map.constrainEdgesToSuperview()
		
		buttonStack.constrainEdgesToSuperview([.trailing], inset: 15, usingMargins: false)
		buttonStack.constrainEdgesToSuperview([.top], inset: 10, usingMargins: true)
		
		cardView.constrainEdgesToSuperview([.leading, .trailing], inset: 0, usingMargins: false)
		cardView.constrainEdgesToSuperview([.bottom], inset: 15, usingMargins: true)
	}
}
