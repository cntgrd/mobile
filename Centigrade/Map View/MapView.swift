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
	let conditionCardWidth: CGFloat   = 196
	
	var map: MKMapView!
	var buttonStack: UIStackView!
	var locationButton: CircleUserTrackingButton!
	var appSettingsButton: CircleButton!
	var cardScrollView: UIScrollView!
	var cardStack: UIStackView!
	
	var cards: [ConditionCardView] = []
	
	var traitConstraints: [NSLayoutConstraint] = []
	
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
			v.layer.masksToBounds = false
			v.showsVerticalScrollIndicator = false
			v.showsHorizontalScrollIndicator = false
			v.bounces = true
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
			s.layer.masksToBounds = false
			s.axis = .horizontal
			s.spacing = 15
			s.alignment = .fill
			s.distribution = .fill
			return s
		}()
		cardScrollView.addSubview(cardStack)
		
		setupConstraints()
		setNeedsUpdateConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints() {
		// one-time, permanent constraints
		map.constrainEdgesToSuperview()
		
		buttonStack.constrainEdgesToSuperview([.trailing], inset: conditionCardSpacing, usingMargins: false)
		buttonStack.constrainEdgesToSuperview([.top], inset: 10, usingMargins: true)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		setNeedsUpdateConstraints()
		
		if traitCollection.verticalSizeClass == .regular {
			// horizontal stack
			cardStack.axis = .horizontal
			cardScrollView.alwaysBounceHorizontal = true
			cardScrollView.alwaysBounceVertical = false
		} else {
			// vertical stack
			cardStack.axis = .vertical
			cardScrollView.alwaysBounceHorizontal = false
			cardScrollView.alwaysBounceVertical = true
		}
	}
	
	override func updateConstraints() {
		// variable constraints
		super.updateConstraints()
		
		_ = traitConstraints.map { $0.isActive = false }
		traitConstraints.removeAll()
		
		// Based on
		// [CITE] https://developer.apple.com/library/content/technotes/tn2154/_index.html
		if traitCollection.verticalSizeClass == .regular {
			// horizontal cards at bottom when portrait
			traitConstraints =
				cardScrollView.constrainEdgesToSuperview([.leading, .bottom, .trailing], inset: 0, usingMargins: false) +
				cardScrollView.constrainToHeight(conditionCardSpacing + conditionCardHeight) +
				cardStack.constrainEdgesToSuperview([.leading, .bottom, .trailing], inset: conditionCardSpacing) +
				cardStack.constrainEdgesToSuperview([.top], inset: 0)
		} else {
			// vertical cards at left when landscape
			traitConstraints =
				cardScrollView.constrainEdgesToSuperview([.top, .leading, .bottom], inset: 0, usingMargins: false) +
				cardScrollView.constrainToWidth(conditionCardSpacing + conditionCardWidth) +
				cardStack.constrainEdgesToSuperview([.top, .leading, .bottom], inset: conditionCardSpacing) +
				cardStack.constrainEdgesToSuperview([.trailing], inset: 0)
		}
	}
}
