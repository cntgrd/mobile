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
	
	override func viewDidAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		testLabel = {
			let l = UILabel(frame: .zero)
			l.text = "Hello World"
			l.translatesAutoresizingMaskIntoConstraints = false
			return l
		}()
		view.addSubview(testLabel)
	}
	
	override func updateViewConstraints() {
		super.updateViewConstraints()
		testLabel.centerInSuperview()
		testLabel.constrainToSize(CGSize(width: 100, height: 100))
	}
}
