//
//  HorizontallyFlushCollectionViewFlowLayout.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/17/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class HorizontallyFlushCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // Don't forget to use this class in your storyboard (or code, .xib etc)
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        guard let collectionView = collectionView else { return attributes }
        attributes?.bounds.size.width = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let allAttributes = super.layoutAttributesForElements(in: rect)
        return allAttributes?.flatMap { attributes in
            switch attributes.representedElementCategory {
            case .cell: return layoutAttributesForItem(at: attributes.indexPath)
            default: return attributes
            }
        }
    }
}
