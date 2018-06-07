//
//  TopicsViewController+CategoryCV.swift
//  PeriodTracker
//
//  Created by Mostafa Oraei on 3/16/1397 AP.
//  Copyright © 1397 Mahdiar . All rights reserved.
//

import UIKit

extension TopicsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorycell", for: indexPath) as! CategoryCVCell
        cell.indexPath = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 50
        return CGSize(width: width/4, height: width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCVCell
        cell.selectedItem = indexPath.row
        filterCategory.append(category[indexPath.row])
        filterCat()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCVCell
        cell.deselectedItem = indexPath.row
        let str = category[indexPath.row]
        filterCategory = filterCategory.filter {$0 != str}
        filterCat()
    }
    
    func filterCat() {
        sectionItems.removeAll()
        models.removeAll()
        
        for topic in self.trashModel {
            for cat in filterCategory {
                if topic.category == cat {
                    self.models.append(topic)
                }
                
            }
        }
    }
    
    func setupCV() {
        let width = view.frame.width
        view.addSubview(collectionView)
        collectionView.widthAnchor.constraint(equalToConstant: width-20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: width/4).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 66).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
