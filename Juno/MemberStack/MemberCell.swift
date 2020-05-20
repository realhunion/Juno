//
//  MemberCellCollectionViewCell.swift
//  Pluto
//
//  Created by Hunain Ali on 5/10/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit

class MemberCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let reactionView : UIImageView = {
        let reactionView = UIImageView()
        return reactionView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font  = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame.integral)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        self.addSubview(containerView)
        containerView.clipsToBounds = false
        
        
        containerView.addSubview(imageView)
        imageView.frame = containerView.frame
        imageView.layer.cornerRadius = containerView.frame.width/2
        
        containerView.addSubview(reactionView)
        reactionView.frame.size = CGSize(width: imageView.bounds.width*0.5, height: imageView.bounds.height*0.5)
        reactionView.center = CGPoint(x: imageView.bounds.width*(1.0),
                                      y: imageView.bounds.height*(0))
        
        
        self.addSubview(nameLabel)
//        nameLabel.backgroundColor = UIColor.yellow
        nameLabel.frame = CGRect(x: 0, y: self.bounds.width+4.0, width: self.bounds.width, height: 16.0)
    }
    
}
