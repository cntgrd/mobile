//
//  ShowViewControllerRow.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-31.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import Eureka

// Eureka (xmartlabs/Eureka) is a UITableView-based form generation library.
//
// this is a subclass of Eureka.LabelRow that just shows a ViewController,
// no input collection. Eureka.PushRow requires you to push a view controller
// that eventually returns some data collected from user input, I just want
// to show a simple view (like an About page in the settings form).
//
// This subclass accomplishes that by taking the LabelRow, which just shows
// text and is unselectable, and enabling selection (highlighting as gray)
// as well as pushing a ViewController to the NavigationController when selected.
//
// You pass the NC and VC (can be preexisting or constructed on demand) by registering
// two closures with the viewControllerSetup(_:) and usingNavigationController(_:)
// methods.
//
// Additionally, we add a chevron accessory to the row as per iOS
// standards for UITableViewCells that open new views. This is called a
// "disclosure indicator"

public final class ShowViewControllerRow: Eureka._LabelRow, Eureka.RowType {
	
	var makeViewControllerMethod: (() -> UIViewController?)?
	var makeNavigationControllerMethod: (() -> UINavigationController?)?
	
	required public init(tag: String?) {
		super.init(tag: tag)
		cell.selectionStyle = .default
		cell.accessoryType = .disclosureIndicator
		
		// we use `unowned` because closure will become deallocated at same time
		// as the Row, whereas `weak` would lead to an optional that would become
		// `nil` upon deallocation.
		onCellSelection { [unowned self] cell, row in
			guard
				let navigationControllerFactory = self.makeNavigationControllerMethod,
				let viewControllerFactory = self.makeViewControllerMethod,
				let navigationController = navigationControllerFactory(),
				let viewController = viewControllerFactory()
			else { return }
			navigationController.pushViewController(viewController, animated: true)
		}
	}
	
	// we use these chainable callback registration methods as per the Eureka
	// "fluent" standard already in use throughout the library for Row setup.
	@discardableResult open func viewControllerSetup(_ factory: @escaping () -> UIViewController?) -> Self {
		makeViewControllerMethod = factory
		return self
	}
	
	@discardableResult open func usingNavigationController(_ factory: @escaping () -> UINavigationController?) -> Self {
		makeNavigationControllerMethod = factory
		return self
	}
}
