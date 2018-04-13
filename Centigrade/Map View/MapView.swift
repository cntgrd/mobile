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
	var mapBlurBar: UIView!
	var buttonStack: UIStackView!
	var locationButton: CircleUserTrackingButton!
	var appSettingsButton: CircleButton!
	var cardScrollView: CardScrollView!
	
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
		
		mapBlurBar = {
			if UIAccessibilityIsReduceTransparencyEnabled() {
				let v = UIView()
				v.translatesAutoresizingMaskIntoConstraints = false
				v.backgroundColor = .white
				return v
			} else {
				let effect = UIBlurEffect(style: .light)
				let v = UIVisualEffectView(effect: effect)
				v.translatesAutoresizingMaskIntoConstraints = false
				return v
			}
		}()
		
		addSubview(mapBlurBar)
		
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
			let c = CardScrollView()
			return c
		}()
		addSubview(cardScrollView)
		
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
		
		mapBlurBar.constrainEdgesToSuperview([.leading, .top, .trailing], inset: 0, usingMargins: false)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		setNeedsUpdateConstraints()
		if traitCollection.verticalSizeClass == .regular {
			cardScrollView.direction = .horizontal
		} else {
			cardScrollView.direction = .vertical
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
			traitConstraints = cardScrollView.constrainEdgesToSuperview([.leading, .trailing], inset: 0, usingMargins: false)
			
			let safeBottomConstraint = cardScrollView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)
			safeBottomConstraint.isActive = true
			
			traitConstraints.append(safeBottomConstraint)
		} else {
			// vertical cards at left when landscape
			traitConstraints =
				cardScrollView.constrainEdgesToSuperview([.top, .bottom], inset: 0, usingMargins: false)
			
			let safeLeadingConstraint = cardScrollView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor)
			safeLeadingConstraint.isActive = true
			
			traitConstraints.append(safeLeadingConstraint)
		}
		
		traitConstraints.append(contentsOf: mapBlurBar.constrainToHeight(UIApplication.shared.statusBarFrame.height))
	}
}
