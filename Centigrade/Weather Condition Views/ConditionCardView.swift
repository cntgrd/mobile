//
//  ConditionCardView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-02-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

enum WeatherTemperatureUnit {
	case c, f
}

enum WeatherCondition {
	case sunny, cloudy
}

struct ConditionCardViewModel {
	var title: String
	var condition: WeatherCondition
	var temperature: Int
	var temperatureUnit: WeatherTemperatureUnit
	var highTemperature: Int
	var lowTemperature: Int
	var percentRain: Int
	var percentHumidity: Int
	var atmosphericPressure: Double
}

class ConditionCardView: UIView {
	
	var titleLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		setupShadow()
		
		titleLabel = {
			let l = UILabel()
			l.translatesAutoresizingMaskIntoConstraints = false
			l.numberOfLines = 1
			l.text = "Today"
			return l
		}()
		addSubview(titleLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	private func setupShadow() {
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowRadius = 8
		layer.shadowOffset = CGSize(width: 0, height: 5)
		layer.shadowOpacity = 0.3
		layer.masksToBounds = false
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		constrainToHeight(221)
		constrainToWidth(196)
		
		titleLabel.constrainEdgesToSuperview([.top, .leading, .trailing], inset: 20)
	}
}

extension ConditionCardView: Modellable {
	typealias ViewModel = ConditionCardViewModel
	
	func load(viewModel: ConditionCardViewModel) {
//		var title: String
		titleLabel.text = viewModel.title
		
//		var condition: WeatherCondition
//		var temperature: Int
//		var temperatureUnit: WeatherTemperatureUnit
//		var highTemperature: Int
//		var lowTemperature: Int
//		var percentRain: Int
//		var percentHumidity: Int
//		var atmosphericPressure: Double
	}
}
