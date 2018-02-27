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
		
		form +++ Section(header: "Units", footer: "This will affect measurements in this app from the National Weather Service or your Centigrade station.")
		<<< PushRow<String> { row in
			row.title = "Temperature"
			row.options = ["Fahrenheit","Celsius"]
			row.value = "Fahrenheit"
		}
	}
}
