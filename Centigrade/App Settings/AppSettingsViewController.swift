//
//  AppSettingsViewController.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-29.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit
import Eureka

class AppSettingsViewController: FormViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let unitsSection = Section(
			header: "Units",
			footer: "This will affect measurements in this app from the National Weather Service or your Centigrade station."
		)
		
		
		
		form +++ unitsSection
		<<< makeOptionRow(fromOptionSetting: SettingsManager.shared.units.temperature, withTitle: "Temperature")
//		<<< makeOptionRow(withTitle: "Temperature", options: ["Fahrenheit","Celsius"], value: "Fahrenheit")
//		<<< makeOptionRow(withTitle: "Pressure", options: ["inHg","mmHg","Millibar","Atmospheres"], value: "inHg")
	}
	
	private func makeOptionRow<T>(fromOptionSetting setting: OptionSetting<T>, withTitle title: String) -> PushRow<T> {
		return PushRow<T> { row in
			row.title = title
			row.options = setting.options
			row.value = setting.value
		}.onPresent { form, selectorController in
			selectorController.enableDeselection = false
			selectorController.selectableRowCellUpdate = { cell, row in
				if
					let option = row.selectableValue,
					let label = cell.textLabel,
					let name = setting.nameForOption(option)
				{
					label.text = name
				}
			}
		}.onChange { row in
			if let newValue = row.value {
				setting.value = newValue
			}
			row.updateCell()
		}
	}
	
	private func makeOptionRow(withTitle title: String, options: [String], value: String) -> PushRow<String> {
		return PushRow<String> { row in
			row.title = title
			row.options = options
			row.value = value
		}.onPresent { form, selectorController in
			selectorController.enableDeselection = false
		}.onChange { row in
			row.updateCell()
		}
	}
}
