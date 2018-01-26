//
//  CardScrollLayout.swift
//  Centigrade
//
//  Created by Paul Herz on 2018-01-25.
//  Copyright © 2018 Centigrade. All rights reserved.
//

import UIKit

class CardScrollLayout: UICollectionViewFlowLayout {
	override init() {
		super.init()
		scrollDirection = .horizontal
		estimatedItemSize = CGSize(width: 1, height: 1)
		sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15+20)
		minimumLineSpacing = 15
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
