//
//  WeatherConditionView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-01.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

struct WeatherConditionViewModel: ViewModel {
	var title: String
	
	func makeView(from view: UIView?) -> UIView {
		let v = (view as? WeatherConditionView) ?? WeatherConditionView()
		v.titleLabel.text = title
		return v
	}
}

class WeatherConditionView: UIView {
	
	var titleLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel = {
			let l = UILabel()
			l.translatesAutoresizingMaskIntoConstraints = false
			l.numberOfLines = 1
			l.text = "Today"
			return l
		}()
		addSubview(titleLabel)
		
		setupConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupConstraints() {
		constrainToHeight(221)
		constrainToWidth(196)
		
		titleLabel.constrainEdgesToSuperview([.top, .leading, .trailing], inset: 20)
	}
}
