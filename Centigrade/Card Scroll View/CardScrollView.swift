//
//  CardScrollView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-03-01.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

// as the dataSource for a CardScrollView, you are responsible for telling it
// the number of cards there will be, as well as generating the UIViews for each
// card on-demand. Those views manage their own appearance (background, shadows)
// and CardScrollView manages spacing.
protocol CardScrollViewDataSource {
	// returns the number of cards there will be in the list.
	func numberOfCards(in cardScrollView: CardScrollView) -> Int
	
	// on-demand generates the views for cards from scratch (no recycling/reuse).
	// indices are just integers, unlike IndexPaths in UITableViews, because
	// there are no sections.
	func contentView(in cardScrollView: CardScrollView, atIndex index: Int) -> UIView
}

// a horizontal, scrollable collection of cards, like a horizontal UITableView
// or a single-row UICollectionView. I tried implementing this through the latter
// but it was painful. Don't use for a large number of cards, as unlike the two
// aforementioned classes, this scrolling view does not magically remove and
// recycle cells (cards) as they go off screen, meaning very poor performance
// for long lists.
//
// It does, however, mimic the DataSource pattern from both of those classes,
// where we delegate the role of generating content on-demand to an outside
// entity (usually the parent view controller), i.e. an inversion of responsibility.
// dataSource?.numberOfCards(in:) determines list size, and
// dataSource?.contentView(in:atIndex:) is called to populate the list with views.
// reloadData() actually calls these methods and populates the list, and
// reloadData() is automatically called when dataSource changes (including from
// nil the first time it is set). Nothing happens if you call reloadData() without
// a dataSource.
//
// reloadData() is not intelligent, does not recycle cells (there are no reuse
// identifiers), and does not keep views that are still in the list: it just
// deletes everything then adds the new views, regenerated. These optimizations
// would be welcome, but I am only using this mechanism for short lists of cards
// for now.
//
// Generated views (cards) are responsible for their own backgrounds and shadows,
// but CardScrollView spaces them consistently.
//
// You can change the `direction` property to make it a vertical list of cards.
// You'll probably want to change the CardScrollView's constraints relative to
// its parent when this happens, like aligning it to a different corner of the
// screen (this is the responsibility of the parent UIViewController)
//
// TL;DR: it's like UITableView for cards. It has a dataSource responsible for
// telling it the number of cards and generating the UIViews for those cards.
// You can call reloadData() to have the view reload all the cards. But this is
// not efficient like UITableView. Don't make long lists with it or use
// expensive-to-create UIViews. This does not have reuse identifiers, recycling,
// or off-screen culling.

final class CardScrollView: UIView, LoadingState {
	
	// MARK - LoadingState
	var isLoading: Bool = false {
		didSet {
			if isLoading {
				scrollView.isHidden = true
				activityIndicator.startAnimating()
			} else {
				scrollView.isHidden = false
				activityIndicator.stopAnimating()
			}
		}
	}
	
	// The direction the CardScrollView is flowing.
	// Horizontal cards layout left-to-right, with only horizontal scrolling.
	// The height of the CardScrollView will be the height of the content.
	// Vertical cards layout top-to-bottom, with only vertical scrolling.
	// The width of the CardScrollView will be the width of the content.
	enum Direction {
		case horizontal, vertical
	}
	
	var direction: CardScrollView.Direction = .horizontal {
		didSet {
			updateDirection()
		}
	}
	
	// we can make this mutable in the future, but we need a didSet
	// callback to actually change the underlying UIStackView's spacing
	// (and wherever else this is used)
	private let spacing: CGFloat = 15
	
	// if there is no datasource (nil), nothing happens on reloadData()
	open var dataSource: CardScrollViewDataSource? = nil {
		didSet {
			reloadData()
		}
	}
	
	// the constraints to be disabled and cleared, and replaced with new ones,
	// when the `direction` property, affecting the flow axis of content, changes.
	private var directionConstraints = [NSLayoutConstraint]()
	
	// underneath it all, CardScrollView is driven by a UIStackView of cards
	// within a UIScrollView.
	private var scrollView: UIScrollView!
	private var stack: UIStackView!
	private var activityIndicator: UIActivityIndicatorView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		
		// set up the scroll view and stack view that will
		// contain the cards.
		setupSubviews()
		
		// set up any invariant constraints (layout constraints that
		// will NOT change if `direction`/other properties change)
		setupConstraints()
		
		// we DON'T call this here because updateDirections() calls it
		// after it sets up the stackView properties.
//		setNeedsUpdateConstraints()
		
		// based on the initial value of the `direction` property,
		// modify the traits of the UIStackView (axis, distribution, spacing)
		// and then trigger updateConstraints to setup variant constraints
		// that DO change when `direction` changes.
		updateDirection()
		
		// we DON'T call this here because CardScrollView will never have a
		// dataSource before its initializer finishes, so the function is
		// useless here. Developers have to set the dataSource after initialization,
		// and setting the dataSource automatically calls reloadData. Someone
		// can explicitly call this method if the data then changes further.
//		reloadData()
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
		
		activityIndicator = {
			let a = UIActivityIndicatorView()
			a.translatesAutoresizingMaskIntoConstraints = false
			a.activityIndicatorViewStyle = .gray
			return a
		}()
		addSubview(activityIndicator)
	}
	
	private func setupConstraints() {
		stack.constrainEdgesToSuperview(inset: spacing)
		scrollView.constrainEdgesToSuperview()
		activityIndicator.centerInSuperview()
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
	
	open func reloadData() {
		// [CITE] Apple Documentation: UIStackView.removeArrangedSubview(_:)
		//
		// [removeArrangedSubview] does not remove the provided view from
		// the stack’s subviews array; therefore, the view is still displayed as
		// part of the view hierarchy. To prevent the view from appearing on
		// screen after calling the stack’s removeArrangedSubview: method,
		// explicitly remove the view from the subviews array by calling the
		// view’s removeFromSuperview() method.
		
		for view in stack.arrangedSubviews {
			stack.removeArrangedSubview(view)
			view.removeFromSuperview()
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
