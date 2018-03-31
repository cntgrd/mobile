//
//  WeatherConditionPlaceholderView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-31.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

// we only have this because we need these placeholders in places
// where viewModels are required, but these placeholders are not customizable
// so their viewModels are empty, and just always create the same view.
struct WeatherConditionPlaceholderViewModel: ViewModel {
	func makeView(from view: UIView?) -> UIView {
		return WeatherConditionPlaceholderView()
	}
}

// a transparent placeholder card for when the weather cards are loading.
class WeatherConditionPlaceholderView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		setupConstraints()
		
		backgroundColor = UIColor(white: 1.0, alpha: 0.8)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints() {
		constrainToHeight(WeatherConditionView.defaultSize.height)
		constrainToWidth(WeatherConditionView.defaultSize.width)
	}
}
