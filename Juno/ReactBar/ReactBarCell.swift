//
//  ReactBarCell.swift
//  Juno
//
//  Created by Hunain Ali on 5/18/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit

class ReactBarCell: UICollectionViewCell {
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pluto")
        imageView.contentMode = ContentMode.scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell() {
        self.contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//        imageView.layer.cornerRadius = self.frame.width/2
        imageView.clipsToBounds = false
    }
    
    func updateUserImage(image img : UIImage) {
        
//        let imageRef = self.storageRef.reference(withPath: "User-Profile-Images/\(userID).jpg")
//
//        let placeHolder = UIImage(color: Constant.myGrayColor)
//        self.userImageView.sd_setImage(with: imageRef, placeholderImage: placeHolder)
        
        self.imageView.image = img
        
    }
    
    
    
    
}
