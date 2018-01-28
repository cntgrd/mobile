//
//  ConditionCardView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-27.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class ConditionCardCell: CardCell {
	
	var testLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		testLabel = {
			let l = UILabel()
			l.backgroundColor = .yellow
//			l.translatesAutoresizingMaskIntoConstraints = false
			l.text = "Hello"
			return l
		}()
		contentView.addSubview(testLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		testLabel.centerInSuperview()
	}
}
