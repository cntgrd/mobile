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

protocol HasAnchors {
	var centerXAnchor: NSLayoutXAxisAnchor { get }
	var centerYAnchor: NSLayoutYAxisAnchor { get }
	
	var topAnchor: NSLayoutYAxisAnchor { get }
	var rightAnchor: NSLayoutXAxisAnchor { get }
	var bottomAnchor: NSLayoutYAxisAnchor { get }
	var leftAnchor: NSLayoutXAxisAnchor { get }
	
	var leadingAnchor: NSLayoutXAxisAnchor { get }
	var trailingAnchor: NSLayoutXAxisAnchor { get }
	
	var widthAnchor: NSLayoutDimension { get }
	var heightAnchor: NSLayoutDimension { get }
	
	// Not available in UILayoutGuide, so excluded here
//	var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
//	var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: HasAnchors {}
extension UILayoutGuide: HasAnchors {}

extension UIView {
	
	func centerIn(_ container: UIView) {
		self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
		self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
	}
	
	func centerInSuperview() {
		centerIn(self.superview!)
	}
	
	private func _constrainEdges(
		edgesAndInsets: [Edge: CGFloat],
		target: HasAnchors
	) {
		if let topInset = edgesAndInsets[.top] {
			self.topAnchor.constraint(
				equalTo: target.topAnchor,
				constant: topInset
			).isActive = true
		}
		
		if let bottomInset = edgesAndInsets[.bottom] {
			self.bottomAnchor.constraint(
				equalTo: target.bottomAnchor,
				constant: -1.0*bottomInset
			).isActive = true
		}
		
		if let leadingInset = edgesAndInsets[.leading] {
			self.leadingAnchor.constraint(
				equalTo: target.leadingAnchor,
				constant: leadingInset
			).isActive = true
		}
		
		if let trailingInset = edgesAndInsets[.trailing] {
			self.trailingAnchor.constraint(
				equalTo: target.trailingAnchor,
				constant: -1.0*trailingInset
			).isActive = true
		}
	}
	
	func constrainEdges(
		_ edges: [Edge] = [.top, .bottom, .leading, .trailing],
		to other: UIView,
		insets: [CGFloat]? = nil,
		usingMargins: Bool = false
	) {
		// We either target the view itself, or its margins guide,
		// depending on the usingMargins boolean.
		let target: HasAnchors = usingMargins ? other.layoutMarginsGuide : other
		
		// This function takes separate edges and insets,
		// but the _constrainEdges function that underlies
		// it takes a dictionary of edges to insets.
		// Constraints will be made on all edges in the dictionary,
		// so we don't necessarily want to provide all edges.
		var edgesAndInsets: [Edge: CGFloat] = [:]
		for edge in edges {
			edgesAndInsets[edge] = 0.0
		}
		
		// If `insets` is nil (default), keep the zero insets.
		// Otherwise, take corresponding insets and merge them
		// with edges.
		if let insets = insets {
			guard insets.count == edges.count else {
				print("Warning: size mismatch between number of edges and number of insets in call to constrainEdges(_:to:insets:usingMargins:). Constraints not made.")
				return
			}
			for (edge, inset) in zip(edges, insets) {
				edgesAndInsets[edge] = inset
			}
		}
		
		// Call the underlying function that actually constrains
		// the edges.
		_constrainEdges(edgesAndInsets: edgesAndInsets, target: target)
	}
	
	func constrainEdges(
		_ edges: [Edge] = [.top, .bottom, .leading, .trailing],
		to other: UIView,
		inset: CGFloat = 0.0,
		usingMargins: Bool = false
	) {
		// This function allows a single inset value to be provided
		// instead of an array.
		let insets = Array(repeating: inset, count: edges.count)
		constrainEdges(edges, to: other, insets: insets, usingMargins: usingMargins)
	}
	
	func constrainEdgesToSuperview(
		_ edges: [Edge] = [.top, .bottom, .leading, .trailing],
		inset: CGFloat = 0.0,
		usingMargins: Bool = false
	) {
		// This function presupposes that you're constraining to a superview
		// that actually exists.
		constrainEdges(edges, to: superview!, inset: inset, usingMargins: usingMargins)
	}
	
	func constrainToSize(_ size: CGSize) {
		self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
		self.constrainToHeight(size.height)
	}
	
	func constrainToAspectRatio(_ ratio: CGFloat) {
		self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio).isActive = true
	}
	
	func constrainToWidth(_ width: CGFloat) {
		self.widthAnchor.constraint(equalToConstant: width).isActive = true
	}
	
	func constrainToHeight(_ height: CGFloat) {
		self.heightAnchor.constraint(equalToConstant: height).isActive = true
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
