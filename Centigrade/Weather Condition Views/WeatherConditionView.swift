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
	var condition: WeatherCondition
	var conditionDescription: String
	var temperature: Temperature
	var isDaytime: Bool
	
	init(fromNWSPeriod period: NWSForecast.Period) {
		title = period.name
		temperature = period.temperature
		condition = period.condition
		conditionDescription = period.conditionDescription
		isDaytime = period.isDaytime
	}
	
	private func backgroundColorForWeather() -> UIColor {
		if !isDaytime { return Colors.weatherNightBackground }
		switch condition {
		case .unknown:
			return .white
		case .sunny:
			return Colors.weatherSunnyBackground
		case .cloudy:
			return Colors.weatherCloudyBackground
		case .clear:
			return Colors.weatherNightBackground
		case .rain:
			return Colors.weatherRainBackground
		case .snow:
			return Colors.weatherSnowBackground
		case .thunderstorms:
			return Colors.weatherThunderstormsBackground
		case .fog:
			return Colors.weatherFogBackground
		}
	}
	
	private func iconForWeather() -> UIImage {
		var resourceName = ""
		switch condition {
		case .sunny:
			resourceName = "condition-sunny-icon-64"
		case .cloudy:
			resourceName = "condition-cloudy-icon-64"
		case .unknown:
			return UIImage()
		case .clear:
			resourceName = "condition-night-icon-64"
		case .rain:
			resourceName = "condition-rain-icon-64"
		case .snow:
			resourceName = "condition-snow-icon-64"
		case .thunderstorms:
			resourceName = "condition-tstorms-icon-64"
		case .fog:
			resourceName = "condition-fog-icon-64"
		}
		return UIImage(imageLiteralResourceName: resourceName)
	}
	
	func makeView(from view: UIView?) -> UIView {
		let v = (view as? WeatherConditionView) ?? WeatherConditionView()
		v.titleLabel.text = title
		
		// if the condition is listed as unknown, just leave the dash in
		// the label.
		if condition != .unknown {
			v.conditionLabel.text = conditionDescription
		} else {
			v.conditionLabel.text = "—"
		}
		
		// Pick the icon and background color based on the
		// WeatherConditionViewModel.condition property WeatherCondition enum.
		v.backgroundColor = backgroundColorForWeather()
		v.conditionIconView.image = iconForWeather()
		
		// a reusable closure for updating the temperature label based on
		// differing preferences as to Fahrenheit or Celsius
		let updateTemperatureUnit = {
			switch SettingsManager.shared.units.temperature.value {
			case .fahrenheit:
				v.temperatureLabel.text = "\(self.temperature.inFahrenheit)°F"
			case .celsius:
				v.temperatureLabel.text = "\(self.temperature.inCelsius)°C"
			}
		}
		// set the temperature label once:
		updateTemperatureUnit()
		
		// Since the view may not be disposed when somewhere else (i.e. in the settings
		// changing the unit preference), we need to observe for changes to the
		// setting then update the unit in the temperature label.
		NotificationCenter.default.addObserver(
			forName: SettingsManager.shared.units.temperature.didChangeNotification,
			object: nil,
			queue: nil
		) { notification in
			updateTemperatureUnit()
		}
		
		return v
	}
}

final class WeatherConditionView: UIView {
	
	static let defaultSize: CGSize = CGSize(width: 196, height: 221)
	
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
			l.font = UIFont.systemFont(ofSize: 2 * em, weight: .medium)
			return l
		}()
		
		conditionLabel = {
			let l = UILabel()
			l.numberOfLines = 2
			l.lineBreakMode = .byWordWrapping
			l.translatesAutoresizingMaskIntoConstraints = false
			l.text = "—"
			let em = UIFont.systemFontSize
			l.font = UIFont.systemFont(ofSize: 1 * em)
			return l
		}()
		
		temperatureAndConditionStack = {
			let s = UIStackView(arrangedSubviews: [temperatureLabel, conditionLabel])
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
		
		setupShadow()
		setupConstraints()
		
		setTemperatures(high: nil, low: nil)
		setPrecipitation(percent: nil)
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
	
	private func setupConstraints() {
		constrainToHeight(WeatherConditionView.defaultSize.height)
		constrainToWidth(WeatherConditionView.defaultSize.width)
		
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
		attachment.image = UIImage(imageLiteralResourceName: "precipitation")
		attachment.bounds = CGRect(
			x: 0,
			y: precipitationLabel.font.descender,
			width: attachment.image!.size.width,
			height: attachment.image!.size.height
		)
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
