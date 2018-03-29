//
//  WeatherConditionView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-01.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

enum WeatherCondition {
	case unknown, sunny, cloudy
}

struct WeatherConditionViewModel: ViewModel {
	var title: String
	var condition: WeatherCondition
	var temperature: Temperature
	
	func makeView(from view: UIView?) -> UIView {
		let v = (view as? WeatherConditionView) ?? WeatherConditionView()
		v.titleLabel.text = title
		
		// set condition styling
		switch condition {
		case .unknown:
			v.backgroundColor = .white
			v.conditionIconView.image = UIImage()
			v.conditionLabel.text = "—"
		case .sunny:
			v.backgroundColor = Colors.weatherSunnyBackground
			v.conditionIconView.image = UIImage(imageLiteralResourceName: "condition-sunny-icon-64")
			v.conditionLabel.text = "Sunny"
		case .cloudy:
			v.backgroundColor = Colors.weatherCloudyBackground
			v.conditionIconView.image = UIImage(imageLiteralResourceName: "condition-cloudy-icon-64")
			v.conditionLabel.text = "Cloudy"
		}
		
		// set temperature
		// TODO user-defined unit preference
		v.temperatureLabel.text = "\(temperature.inFahrenheit)°F"
		
		return v
	}
	
	init(fromNWSPeriod period: NWSForecast.Period) {
		title = period.name
		temperature = period.temperature
		condition = .unknown
	}
}

class WeatherConditionView: UIView {
	
	let measurementLabelSize = 1.1 * UIFont.systemFontSize
	
	var titleLabel: UILabel!
	var conditionIconView: UIImageView!
	
	var temperatureAndConditionStack: UIStackView!
	var temperatureLabel: UILabel!
	var conditionLabel: UILabel!
	
	var highLowTemperatureLabel: UILabel!
	var precipitationLabel: UILabel!
	
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
			l.text = "—"
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
			l.text = "—°F"
			let em = UIFont.systemFontSize
			l.font = UIFont.systemFont(ofSize: 2.2 * em, weight: .medium)
			return l
		}()
		
		conditionLabel = {
			let l = UILabel()
			l.numberOfLines = 1
			l.translatesAutoresizingMaskIntoConstraints = false
			l.text = "—"
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
		
		// Create temporary constants and reassign them to existing vars
		// (for some reason tuple pattern matching falls apart when the lvalues
		// are optional and the return type is not...)
		let (hilo, precip) = makeMeasurementLabelPair("", "")
		highLowTemperatureLabel = hilo
		precipitationLabel = precip
		addSubview(highLowTemperatureLabel)
		addSubview(precipitationLabel)
		
		let (hA, hB) = makeMeasurementLabelPair("—%", "HUMIDITY")
		humidityMeasurementLabel = hA
		humidityWordLabel = hB
		addSubview(humidityMeasurementLabel)
		addSubview(humidityWordLabel)
		
		let (pA, pB) = makeMeasurementLabelPair("— inHG", "PRESSURE")
		pressureMeasurementLabel = pA
		pressureWordLabel = pB
		addSubview(pressureMeasurementLabel)
		addSubview(pressureWordLabel)
		
		setupConstraints()
		
		setTemperatures(high: nil, low: nil)
		setPrecipitation(percent: nil)
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
		
		highLowTemperatureLabel.constrainEdgesToSuperview([.leading], inset: inset)
		precipitationLabel.makeConstraintTrailing(view: highLowTemperatureLabel, offset: 0).isActive = true
		precipitationLabel.constrainEdgesToSuperview([.trailing], inset: inset)
		
		for v in [highLowTemperatureLabel, precipitationLabel] {
			v!.makeConstraintAbove(view: humidityMeasurementLabel, offset: 8).isActive = true
		}
	}
	
	func setTemperatures(high: Int?, low: Int?) {
		
		let highString: String? = high.flatMap { String($0) }
		let lowString: String? = low.flatMap { String($0) }
		
		let highLowString = NSMutableAttributedString()
		let bold = UIFont.boldSystemFont(ofSize: measurementLabelSize)
		highLowString.append(NSAttributedString(string: "↑", attributes: [.foregroundColor: UIColor.red, .font: bold]))
		
		highLowString.append(NSAttributedString(string: " \(highString ?? "—")° "))
		
		highLowString.append(NSAttributedString(string: "↓", attributes: [.foregroundColor: UIColor.blue, .font: bold]))
		highLowString.append(NSAttributedString(string: " \(lowString ?? "—")°"))
		
		highLowTemperatureLabel.attributedText = highLowString
	}
	
	func setPrecipitation(percent: Int?) {
		let percentString: String? = percent.flatMap { String($0) }
		
		let attachment = NSTextAttachment()
		attachment.image = UIImage(imageLiteralResourceName: "precip")
		let attachmentString = NSAttributedString(attachment: attachment)
		
		let precipString = NSMutableAttributedString(attributedString: attachmentString)
		precipString.append(NSAttributedString(string: " \(percentString ?? "—")%"))
		
		precipitationLabel.attributedText = precipString
	}
	
	func makeMeasurementLabel() -> UILabel {
		let l = UILabel()
		l.translatesAutoresizingMaskIntoConstraints = false
		l.numberOfLines = 1
		l.font = UIFont.systemFont(ofSize: measurementLabelSize)
		return l
	}
	
	func makeMeasurementLabelPair(_ messageA: String, _ messageB: String) -> (UILabel, UILabel) {
		let a: UILabel = {
			let l = makeMeasurementLabel()
			l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			l.text = messageA
			return l
		}()
		
		let b: UILabel = {
			let l = makeMeasurementLabel()
			l.textAlignment = .right
			l.text = messageB
			return l
		}()
		
		return (a,b)
	}
}
