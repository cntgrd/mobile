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
	
	var temperatureAndConditionStack: UIStackView!
	var temperatureLabel: UILabel!
	var conditionLabel: UILabel!
	
	var humidityMeasurementLabel: UILabel!
	var humidityWordLabel: UILabel!
	
	var pressureMeasurementLabel: UILabel!
	var pressureWordLabel: UILabel!
	
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
		
		temperatureLabel = {
			let l = UILabel()
			l.numberOfLines = 1
			l.translatesAutoresizingMaskIntoConstraints = false
			l.text = "68°F"
			let em = UIFont.systemFontSize
			l.font = UIFont.systemFont(ofSize: 2.2 * em, weight: .medium)
			return l
		}()
		
		conditionLabel = {
			let l = UILabel()
			l.numberOfLines = 1
			l.translatesAutoresizingMaskIntoConstraints = false
			l.text = "Sunny"
			return l
		}()
		
		temperatureAndConditionStack = {
			// UIView()s are spacers
			let s = UIStackView(arrangedSubviews: [UIView(), temperatureLabel, conditionLabel, UIView()])
			s.translatesAutoresizingMaskIntoConstraints = false
			s.axis = .vertical
			s.alignment = .leading
			return s
		}()
		addSubview(temperatureAndConditionStack)
		
		let (hA, hB) = makeMeasurementLabelPair("49%", "HUMIDITY")
		humidityMeasurementLabel = hA
		humidityWordLabel = hB
		addSubview(humidityMeasurementLabel)
		addSubview(humidityWordLabel)
		
		let (pA, pB) = makeMeasurementLabelPair("30.1 inHG", "PRESSURE")
		pressureMeasurementLabel = pA
		pressureWordLabel = pB
		addSubview(pressureMeasurementLabel)
		addSubview(pressureWordLabel)
		
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
		
		temperatureAndConditionStack.constrainEdgesToSuperview([.trailing], inset: inset)
		temperatureAndConditionStack.makeConstraintTrailing(view: conditionIconView, offset: -10).isActive = true
		temperatureAndConditionStack.centerYAnchor.constraint(equalTo: conditionIconView.centerYAnchor).isActive = true
		
		pressureMeasurementLabel.constrainEdgesToSuperview([.leading, .bottom], inset: inset)
		pressureWordLabel.makeConstraintTrailing(view: pressureMeasurementLabel, offset: 0).isActive = true
		pressureWordLabel.constrainEdgesToSuperview([.bottom, .trailing], inset: inset)
		
		humidityMeasurementLabel.constrainEdgesToSuperview([.leading], inset: inset)
		humidityWordLabel.makeConstraintTrailing(view: humidityMeasurementLabel, offset: 0).isActive = true
		humidityWordLabel.constrainEdgesToSuperview([.trailing], inset: inset)
		
		for v in [humidityMeasurementLabel, humidityWordLabel] {
			v!.makeConstraintAbove(view: pressureMeasurementLabel, offset: 8).isActive = true
		}
		
	}
	
	func makeMeasurementLabelPair(_ messageA: String, _ messageB: String) -> (UILabel, UILabel) {
		let em = UIFont.systemFontSize
		let a: UILabel = {
			let l = UILabel()
			l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			l.translatesAutoresizingMaskIntoConstraints = false
			l.numberOfLines = 1
			l.text = messageA
			l.font = UIFont.systemFont(ofSize: 1.1 * em)
			return l
		}()
		
		let b: UILabel = {
			let l = UILabel()
			l.textAlignment = .right
			l.translatesAutoresizingMaskIntoConstraints = false
			l.numberOfLines = 1
			l.text = messageB
			l.font = UIFont.systemFont(ofSize: 1.1 * em)
			return l
		}()
		
		return (a,b)
	}
}
