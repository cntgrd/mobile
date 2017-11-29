//
//  UIView+Edges.swift
//  Centigrade
//
//  Created by Paul Herz on 2017-11-02.
//  Copyright © 2017 Centigrade. All rights reserved.
//

import UIKit

enum Edge {
	case top, bottom, leading, trailing
}

extension UIView {
	
	func centerIn(_ container: UIView) {
		self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
		self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
	}
	
	func centerInSuperview() {
		centerIn(self.superview!)
	}
	
	func constrainEdges(
		_ edges: [Edge] = [.top, .bottom, .leading, .trailing],
		to other: UIView,
		inset: CGFloat = 0.0,
		usingMargins: Bool = false
	) {
		let margins = other.layoutMarginsGuide
		
		if edges.contains(.top) && !usingMargins {
			self.topAnchor.constraint(equalTo: other.topAnchor, constant: inset).isActive = true
		} else if edges.contains(.top) && usingMargins {
			self.topAnchor.constraint(equalTo: margins.topAnchor, constant: inset).isActive = true
		}
		
		if edges.contains(.bottom) && !usingMargins {
			self.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -1.0*inset).isActive = true
		} else if edges.contains(.bottom) && usingMargins {
			self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -1.0*inset).isActive = true
		}
		
		if edges.contains(.leading) && !usingMargins {
			self.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: inset).isActive = true
		} else if edges.contains(.leading) && usingMargins {
			self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: inset).isActive = true
		}
		
		if edges.contains(.trailing) && !usingMargins {
			self.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -1.0*inset).isActive = true
		} else if edges.contains(.trailing) && usingMargins {
			self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -1.0*inset).isActive = true
		}
	}
	
	func constrainEdgesToSuperview(
		_ edges: [Edge] = [.top, .bottom, .leading, .trailing],
		inset: CGFloat = 0.0,
		usingMargins: Bool = false
	) {
		constrainEdges(edges, to: superview!, inset: inset, usingMargins: usingMargins)
	}
	
	func constrainToSize(_ size: CGSize) {
		self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
		self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
	}
	
	func makeConstraintBelow(view other: UIView, offset: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.topAnchor.constraint(equalTo: other.bottomAnchor, constant: offset)
	}
	
	func makeConstraintAbove(view other: UIView, offset: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.bottomAnchor.constraint(equalTo: other.topAnchor, constant: -1.0*offset)
	}
	
	func makeConstraintLeading(view other: UIView, offset: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.trailingAnchor.constraint(equalTo: other.leadingAnchor, constant: -1.0*offset)
	}
	
	func makeConstraintTrailing(view other: UIView, offset: CGFloat = 0.0) -> NSLayoutConstraint {
		return self.leadingAnchor.constraint(equalTo: other.trailingAnchor, constant: -1.0*offset)
	}
}

class LayoutChain {
	enum LayoutChainAxis {
		case horizontal, vertical
	}
	
	let axis: LayoutChainAxis
	let spacing: CGFloat
	let isReversed: Bool
	private(set) var views: [UIView] = []
	private var constraints: [NSLayoutConstraint] = []
	
	init(_ views: [UIView] = [], onAxis axis: LayoutChainAxis = .vertical, withSpacing spacing: CGFloat = 0.0, reversed: Bool = false) {
		self.axis = axis
		self.spacing = spacing
		self.isReversed = reversed
		
		for view in views {
			addView(view)
		}
	}
	
	func addView(_ view: UIView) {
		if !views.isEmpty {
			constrain(view, following: views.last!)
		}
		views.append(view)
	}
	
	private func constrain(_ view: UIView, following previousView: UIView) {
		var constraint: NSLayoutConstraint
		if axis == .horizontal && isReversed {
			constraint = view.makeConstraintLeading(view: previousView, offset: spacing)
		} else if axis == .horizontal {
			constraint = view.makeConstraintTrailing(view: previousView, offset: spacing)
		} else if axis == .vertical && isReversed {
			constraint = view.makeConstraintAbove(view: previousView, offset: spacing)
		} else { // vertical, normal
			constraint = view.makeConstraintBelow(view: previousView, offset: spacing)
		}
		
		constraint.isActive = true
		constraints.append(constraint)
	}
	
	func deactivate() {
		for constraint in constraints {
			constraint.isActive = false
		}
		views = []
		constraints = []
	}
}
