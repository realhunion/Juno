//
//  ReactBar.swift
//  Juno
//
//  Created by Hunain Ali on 5/18/20.
//  Copyright © 2020 BUMP. All rights reserved.
//


import Foundation
import UIKit

protocol ReactBarDelegate : class {
    func reactionTapped()
}


class ReactBar : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let shared : ReactBar = ReactBar(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    static let heightX : CGFloat = 74.0
    
    weak var reactDelegate : ReactBarDelegate?
    
    let leftRightSpacing : CGFloat = 36.0
    let middleSpacing : CGFloat = 24.0
    let bottomSpacing : CGFloat = 20.0
    let topSpacing : CGFloat = 10.0
    
    var emojiArray : [UIImage] = [UIImage(named: "angryEmoji")!,
                                  UIImage(named: "wowEmoji")!,
                                  UIImage(named: "heartEmoji")!,
                                  UIImage(named: "laughEmoji")!,
                                  UIImage(named: "sadEmoji")!]
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layoutX = UICollectionViewFlowLayout()
        layoutX.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layoutX)
        
        self.setupCollectionView()
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Users Here Bar DE INIT")
    }
    
    func setupCollectionView() {
        
        self.isPagingEnabled = false
        self.allowsSelection = true
        self.allowsMultipleSelection = false
        self.isScrollEnabled = false
        
        
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        
        self.register(ReactBarCell.self, forCellWithReuseIdentifier: "reactBarCell")
        self.dataSource = self
        self.delegate = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojiArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = self.dequeueReusableCell(withReuseIdentifier: "reactBarCell", for: indexPath) as! ReactBarCell
        
        let img = self.emojiArray[indexPath.row]
        myCell.updateUserImage(image: img)
        
        return myCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.setContentOffset(self.contentOffset, animated: false)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.10) {
                            collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform.identity
                        }
        })
        
        self.reactDelegate?.reactionTapped()
    }
    
    
}



extension ReactBar : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.bounds.height - (self.bottomSpacing+self.topSpacing),
                      height: self.bounds.height - (self.bottomSpacing+self.topSpacing))
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return self.middleSpacing
        
        let numItems = emojiArray.count
        let itemsWidth = CGFloat(numItems) * (self.bounds.height - self.bottomSpacing - self.topSpacing)
        let leftRightWidth = self.leftRightSpacing * 2
        
        let totalMiddleSpacing = self.bounds.width - itemsWidth - leftRightWidth
        let middleSpacing = totalMiddleSpacing / CGFloat(numItems - 1)
        
        return middleSpacing
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let numItems = emojiArray.count
        
        let itemsWidth = CGFloat(numItems) * (self.bounds.height - self.bottomSpacing)
        let itemsSpacingWidth = CGFloat(numItems-1) * self.middleSpacing
        let total = itemsWidth + itemsSpacingWidth
        
        var oneSideWidth = (self.frame.width - total) / 2
        
        if oneSideWidth < self.leftRightSpacing {
            oneSideWidth = leftRightSpacing
        }
        
        return UIEdgeInsets(top: self.topSpacing, left: self.leftRightSpacing, bottom: self.bottomSpacing, right: self.leftRightSpacing)
        
    }
    
    
    
    
    
}
