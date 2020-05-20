//
//  MembersStackView.swift
//  BUMP
//
//  Created by Hunain Ali on 4/13/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import UIKit
//import SDWebImage
//import Firebase

struct User {
    var image : UIImage!
    var name : String!
}

class MembersStackView : UICollectionView, UICollectionViewDelegate {
    
    var userArray : [User] = [] {
        didSet{
            if self.userArray.isEmpty {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let cLayout = UICollectionViewFlowLayout()
        
        cLayout.scrollDirection = .horizontal
        cLayout.minimumLineSpacing = 24
        cLayout.sectionInset = UIEdgeInsets(top: 20, left: cLayout.minimumLineSpacing, bottom: 10, right: 0)
        cLayout.itemSize = CGSize(width: frame.height-20-cLayout.sectionInset.top-cLayout.sectionInset.bottom,
                                  height: frame.height-cLayout.sectionInset.top-cLayout.sectionInset.bottom)
        cLayout.minimumInteritemSpacing = 0
        
        
//        cLayout.scrollDirection = .horizontal
//        cLayout.minimumLineSpacing = 24
//        cLayout.sectionInset = UIEdgeInsets(top: 20, left: cLayout.minimumLineSpacing, bottom: 16, right: 0)
//        cLayout.itemSize = CGSize(width: 60,
//                                  height: 84)
//        cLayout.minimumInteritemSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: cLayout)
        
        self.register(MemberCell.self, forCellWithReuseIdentifier: "memberCell")
        self.dataSource = self
        self.delegate = self
        
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
        
        self.clipsToBounds = false
        
        self.userArray = []
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MembersStackView: UICollectionViewDataSource {
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textColor = UIColor.systemPink
        
        nameLabel.font = UIFont.systemFont(ofSize: 112.0, weight: .heavy)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("self.userArray \(self.userArray.count)")
        guard !self.userArray.isEmpty else { return 0 }
        return self.userArray.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCell
        
//        cell.backgroundColor = .yellow

        cell.imageView.alpha = 1.0
        cell.nameLabel.alpha = 1.0
        
        if indexPath.row == 0 {
            cell.imageView.image = self.imageWith(name: "\(userArray.count)")
            cell.nameLabel.text = "Seen By"
            cell.reactionView.isHidden = true
            
        } else {
            
            let u = self.userArray[indexPath.row-1]
            cell.imageView.image = u.image
            cell.nameLabel.text = u.name
            
            cell.reactionView.isHidden = false
            
            let random = Int.random(in: 0...22)
            print(random)
            if random == 1 {
                cell.reactionView.image = UIImage(named: "heartEmoji")
            }
            else if random == 2 {
                cell.reactionView.image = UIImage(named: "sadEmoji")
            }
            else if random == 3 {
                cell.reactionView.image = UIImage(named: "wowEmoji")
            }
            else if random == 4 {
                cell.reactionView.image = UIImage(named: "angryEmoji")
            }
            else if random == 5 {
                cell.reactionView.image = UIImage(named: "laughEmoji")
            }
            else {
                cell.reactionView.image = nil
//                cell.reactionView.isHidden = true
//                cell.imageView.alpha = 0.4
//                cell.nameLabel.alpha = 0.4
            }
        }
        
        
        return cell
    }
    
    
    
    
    
}
