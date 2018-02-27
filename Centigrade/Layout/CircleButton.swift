//
//  CircleButton.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-11-16.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import UIKit

// Rounded corners + shadows
// https://stackoverflow.com/a/34986304/3592716

class CircleButton: UIControl, LoadingState {
	
	var isLoading: Bool = false {
		didSet {
			if isLoading {
				iconView.isHidden = true
				loadingView.isHidden = false
				loadingView.startAnimating()
			} else {
				iconView.isHidden = false
				loadingView.isHidden = true
				loadingView.stopAnimating()
			}
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: size, height: size)
	}
	
	var size: CGFloat = 50 {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	private var iconView: UIImageView!
	private var loadingView: UIActivityIndicatorView!
	private var highlightView: UIView!
	
	static let defaultIconColor = UIColor(white: 0.3, alpha: 1)
	var iconColor: UIColor = CircleButton.defaultIconColor {
		didSet { didSetIcon() }
	}
	
	static let defaultBackgroundColor: UIColor = UIColor(white: 0.9, alpha: 1)
	override var backgroundColor: UIColor? {
		set {
			iconView.backgroundColor = newValue
		}
		get {
			return iconView.backgroundColor
		}
	}
	
	var icon: UIImage? = nil {
		didSet { didSetIcon() }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupAppearance()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupAppearance()
	}
	
	private func setupAppearance() {
		layer.shadowOffset = CGSize(width: 0, height: 5)
		layer.shadowRadius = 8
		layer.shadowOpacity = 0.5
		
		iconView = {
			let c = UIImageView()
			c.translatesAutoresizingMaskIntoConstraints = false
			c.contentMode = .center
			c.frame.size = CGSize(width: size, height: size)
			c.clipsToBounds = true
			c.backgroundColor = CircleButton.defaultBackgroundColor
			c.layer.cornerRadius = size / 2.0
			return c
		}()
		addSubview(iconView)
		
		loadingView = {
			let a = UIActivityIndicatorView(activityIndicatorStyle: .white)
			a.translatesAutoresizingMaskIntoConstraints = false
			a.isHidden = true
			return a
		}()
		iconView.addSubview(loadingView)
		
		highlightView = {
			let h = UIView()
			h.isHidden = true
			h.translatesAutoresizingMaskIntoConstraints = false
			return h
		}()
		iconView.addSubview(highlightView)
	}
	
	override func updateConstraints() {
		iconView.constrainEdgesToSuperview()
		loadingView.centerInSuperview()
		highlightView.constrainEdgesToSuperview()
		super.updateConstraints()
	}
	
	private func didSetIcon() {
		highlightView.backgroundColor = iconColor.withAlphaComponent(0.3)
		
		guard let icon = icon else {
			iconView.image = UIImage()
			return
		}
		
		let tintedIcon = ImageTools.tintIcon(icon, usingColor: iconColor)
		iconView.image = tintedIcon
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		highlightView.isHidden = false
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		highlightView.isHidden = true
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.count == 1, let touch = touches.first else { return }
		let point = touch.location(in: self)
		highlightView.isHidden = true
		if self.bounds.contains(point) {
			sendActions(for: .touchUpInside)
		} else {
			sendActions(for: .touchUpOutside)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		iconView.layer.cornerRadius = bounds.width / 2.0
	}
}
