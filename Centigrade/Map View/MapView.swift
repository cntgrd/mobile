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
	
	// dimensional constants
	let conditionCardSpacing: CGFloat = 18
	let conditionCardHeight: CGFloat  = 221
	
	var map: MKMapView!
	var buttonStack: UIStackView!
	var locationButton: CircleUserTrackingButton!
	var appSettingsButton: CircleButton!
	var cardScrollView: UIScrollView!
	var cardStack: UIStackView!
	
	var cards: [ConditionCardView] = []
	
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
		
		cardScrollView = {
			let v = UIScrollView()
			v.translatesAutoresizingMaskIntoConstraints = false
			v.showsVerticalScrollIndicator = false
			v.showsHorizontalScrollIndicator = false
			v.bounces = true
			v.alwaysBounceHorizontal = true
			return v
		}()
		addSubview(cardScrollView)
		
		for _ in 1...5 {
			let v = ConditionCardView()
			v.translatesAutoresizingMaskIntoConstraints = false
			cards.append(v)
		}
		
		cardStack = {
			let s = UIStackView(arrangedSubviews: cards)
			s.translatesAutoresizingMaskIntoConstraints = false
			s.backgroundColor = .red
			s.axis = .horizontal
			s.spacing = 15
			s.alignment = .fill
			s.distribution = .fill
			return s
		}()
		cardScrollView.addSubview(cardStack)
		
		setNeedsUpdateConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		
		map.constrainEdgesToSuperview()
		
		buttonStack.constrainEdgesToSuperview([.trailing], inset: conditionCardSpacing, usingMargins: false)
		buttonStack.constrainEdgesToSuperview([.top], inset: 10, usingMargins: true)
		
		// Based on
		// [CITE] https://developer.apple.com/library/content/technotes/tn2154/_index.html
		cardScrollView.constrainEdgesToSuperview([.leading, .trailing, .bottom], inset: 0, usingMargins: false)
		cardScrollView.constrainToHeight(conditionCardSpacing + conditionCardHeight)
		cardStack.constrainEdgesToSuperview([.leading, .trailing, .bottom], inset: conditionCardSpacing)
		cardStack.constrainEdgesToSuperview([.top], inset: 0)
	}
}
