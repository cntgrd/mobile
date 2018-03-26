//
//  CardScrollView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-01.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

protocol CardScrollViewDataSource {
	func numberOfCards(in cardScrollView: CardScrollView) -> Int
	func contentView(in cardScrollView: CardScrollView, atIndex index: Int) -> UIView
}

class CardScrollView: UIView {
	
	enum Direction {
		case horizontal, vertical
	}
	
	var direction: CardScrollView.Direction = .horizontal {
		didSet {
			updateDirection()
		}
	}
	
	let spacing: CGFloat = 15
	var dataSource: CardScrollViewDataSource? = nil {
		didSet {
			reloadData()
		}
	}
	
	var directionConstraints = [NSLayoutConstraint]()
	
	private var scrollView: UIScrollView!
	private var stack: UIStackView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		setupSubviews()
		setupConstraints()
		setNeedsUpdateConstraints()
		updateDirection()
		reloadData()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupSubviews() {
		scrollView = {
			let v = UIScrollView()
			v.translatesAutoresizingMaskIntoConstraints = false
			v.layer.masksToBounds = false
			v.showsVerticalScrollIndicator = false
			v.showsHorizontalScrollIndicator = false
			v.bounces = true
			return v
		}()
		addSubview(scrollView)
		
		stack = {
			let s = UIStackView()
			s.translatesAutoresizingMaskIntoConstraints = false
			s.layer.masksToBounds = false
			s.axis = .horizontal
			s.spacing = spacing
			s.alignment = .fill
			s.distribution = .fill
			return s
		}()
		scrollView.addSubview(stack)
	}
	
	private func setupConstraints() {
		stack.constrainEdgesToSuperview(inset: spacing)
		scrollView.constrainEdgesToSuperview()
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		
		for constraint in directionConstraints {
			constraint.isActive = false
		}
		directionConstraints.removeAll()
		
		switch direction {
		case .horizontal:
			directionConstraints = stack.constrainEdges([.top, .bottom], to: self, inset: spacing)
		case .vertical:
			directionConstraints = stack.constrainEdges([.leading, .trailing], to: self, inset: spacing)
		}
	}
	
	private func updateDirection() {
		switch direction {
		case .horizontal:
			stack.axis = .horizontal
			scrollView.alwaysBounceHorizontal = true
			scrollView.alwaysBounceVertical = false
		case .vertical:
			stack.axis = .vertical
			scrollView.alwaysBounceHorizontal = false
			scrollView.alwaysBounceVertical = true
		}
		setNeedsUpdateConstraints()
	}
	
	func reloadData() {
		// clear
		for view in stack.arrangedSubviews {
			stack.removeArrangedSubview(view)
		}
		
		// query the datasource for new cards
		guard let dataSource = dataSource else { return }
		let nCards = dataSource.numberOfCards(in: self)
		
		// create empty cards and set their content views
		// to the corresponding content view for index `i`
		// and then insert into the stackview
		for i in 0..<nCards {
			let cardView = CardView()
			cardView.contentView = dataSource.contentView(in: self, atIndex: i)
			stack.addArrangedSubview(cardView)
		}
	}
}
