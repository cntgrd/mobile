//
//  CardView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-01.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class CardView: UIView {
	var contentView: UIView? = nil {
		willSet {
			if let contentView = contentView {
				contentView.removeFromSuperview()
			}
		}
		didSet {
			if let contentView = contentView {
				addSubview(contentView)
			}
			invalidateIntrinsicContentSize()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		if let contentView = contentView {
			let b = contentView.bounds
			return CGSize(width: b.width, height: b.height)
		}
		return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		invalidateIntrinsicContentSize()
		contentView?.frame.origin = self.bounds.origin
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
