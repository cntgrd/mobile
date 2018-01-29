//
//  CardView.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-25.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundView = {
			let v = UIView()
			v.backgroundColor = .white
			v.layer.masksToBounds = false
			v.layer.shadowOffset = CGSize(width: 0, height: 5)
			v.layer.shadowRadius = 8
			v.layer.shadowOpacity = 0.5
			return v
		}()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class CardView: UICollectionView {
	
	private var flowLayout: UICollectionViewFlowLayout {
		return collectionViewLayout as! UICollectionViewFlowLayout
	}
	
	var cardMargin: CGFloat {
		get {
			return flowLayout.minimumLineSpacing
		}
		set {
			flowLayout.sectionInset = UIEdgeInsets(top: 0, left: newValue, bottom: 0, right: newValue)
			flowLayout.minimumLineSpacing = newValue
		}
	}
	
	override var intrinsicContentSize: CGSize {
		get {
			return CGSize(width: UIViewNoIntrinsicMetric, height: cardSize.height)
		}
	}
	
	var cardSize: CGSize {
		didSet {
			self.invalidateIntrinsicContentSize()
		}
	}
	
	init(size: CGSize) {
		cardSize = size
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		
		super.init(frame: .zero, collectionViewLayout: layout)
		
		delegate = self
		translatesAutoresizingMaskIntoConstraints = false
		layer.masksToBounds = false
		backgroundColor = .clear
		bounces = true
		showsHorizontalScrollIndicator = false
		showsVerticalScrollIndicator = false
		cardMargin = 15
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension CardView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return cardSize
	}
}
