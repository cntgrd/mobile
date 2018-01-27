//
//  MainConditionView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

enum MainConditionViewSize { case compact, large }

class MainConditionView: UIView {
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 153, height: 64) // compact
	}
	
	var iconView: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .green
		iconView = {
			let iv = UIImageView(image: UIImage())
			iv.translatesAutoresizingMaskIntoConstraints = false
			iv.backgroundColor = .red
			return iv
		}()
		addSubview(iconView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		iconView.constrainEdgesToSuperview([.top, .leading, .bottom], inset: 0, usingMargins: true)
		iconView.constrainToAspectRatio(1.0) // square
	}
}
