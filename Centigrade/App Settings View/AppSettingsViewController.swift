//
//  AppSettingsViewController.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-29.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController {
	
	var testLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		testLabel = {
			let l = UILabel()
			l.text = "Hello World"
			l.translatesAutoresizingMaskIntoConstraints = false
			return l
		}()
	}
	
	override func updateViewConstraints() {
		super.updateViewConstraints()
		
		testLabel.centerInSuperview()
	}
}
