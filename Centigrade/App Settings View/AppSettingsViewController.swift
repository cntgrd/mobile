//
//  AppSettingsViewController.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-29.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit
import Static

class AppSettingsViewController: Static.TableViewController {
	
	init() {
		super.init(style: .grouped)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource.sections = [
			Static.Section(
				header: "Temperature",
				rows: [Static.Row.init(text: "Blah")],
				footer: "This will affect all temperature readings listed in this app from the National Weather Service or your Centigrade station."
			),
		]
	}
	
	override func updateViewConstraints() {
		super.updateViewConstraints()
	}
}
