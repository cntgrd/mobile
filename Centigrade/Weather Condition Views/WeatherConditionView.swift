//
//  WeatherConditionView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-01.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

enum WeatherCondition {
	case sunny, cloudy
}

struct WeatherConditionViewModel: ViewModel {
	var title: String
	var condition: WeatherCondition
	
	func makeView(from view: UIView?) -> UIView {
		let v = (view as? WeatherConditionView) ?? WeatherConditionView()
		v.titleLabel.text = title
		switch condition {
		case .sunny:
			v.backgroundColor = Colors.weatherSunnyBackground
			v.conditionIconView.image = UIImage(imageLiteralResourceName: "condition-sunny-icon-64")
		case .cloudy:
			v.backgroundColor = Colors.weatherCloudyBackground
			v.conditionIconView.image = UIImage(imageLiteralResourceName: "condition-cloudy-icon-64")
		}
		return v
	}
}

class WeatherConditionView: UIView {
	
	var titleLabel: UILabel!
	var conditionIconView: UIImageView!
	
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
		
		conditionIconView = {
			let iv = UIImageView()
			iv.translatesAutoresizingMaskIntoConstraints = false
			iv.contentMode = .center
			return iv
		}()
		addSubview(conditionIconView)
		
		setupConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupConstraints() {
		constrainToHeight(221)
		constrainToWidth(196)
		
		let inset: CGFloat = 20
		
		titleLabel.constrainEdgesToSuperview([.top, .leading, .trailing], inset: inset)
		
		conditionIconView.constrainToSize(CGSize(width: 64, height: 64))
		conditionIconView.constrainEdgesToSuperview([.leading], inset: inset)
		conditionIconView.makeConstraintBelow(view: titleLabel, offset: 11).isActive = true
	}
}
