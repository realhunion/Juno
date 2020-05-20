
//  ContainerViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 8/9/15.
//  Copyright (c) 2015 Jake Spracher. All rights reserved.
//
import UIKit


class SubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.imageView?.sd_cancelCurrentImageLoad()
    }
}

class AccessoryTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.imageView?.sd_cancelCurrentImageLoad()
    }
}



protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate {
    
    var topVc: UIViewController?
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var bottomVc: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    class func containerViewWith(_ leftVC: UIViewController,
                                 middleVC: UIViewController,
                                 rightVC: UIViewController,
                                 topVC: UIViewController?=nil,
                                 bottomVC: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(middleVc: middleVc,
                                                                               topVc: topVc,
                                                                               bottomVc: bottomVc)
        delegate = middleVertScrollVc
    }
    
    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height
        )
        
        self.view.addSubview(scrollView)
        
        let scrollWidth  = 3 * view.width
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )
        
        middleVertScrollVc.view.frame = CGRect(x: view.width,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        rightVc.view.frame = CGRect(x: 2 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChild(leftVc)
        addChild(middleVertScrollVc)
        addChild(rightVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        
        leftVc.didMove(toParent: self)
        middleVertScrollVc.didMove(toParent: self)
        rightVc.didMove(toParent: self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
            
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated:  false)
        }
    }
    
}


//
//  MiddleScrollViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 12/14/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//
import UIKit

class VerticalScrollViewController: UIViewController, SnapContainerViewControllerDelegate {
    var topVc: UIViewController!
    var middleVc: UIViewController!
    var bottomVc: UIViewController!
    var scrollView: UIScrollView!
    
    class func verticalScrollVcWith(middleVc: UIViewController,
                                    topVc: UIViewController?=nil,
                                    bottomVc: UIViewController?=nil) -> VerticalScrollViewController {
        let middleScrollVc = VerticalScrollViewController()
        
        middleScrollVc.topVc = topVc
        middleScrollVc.middleVc = middleVc
        middleScrollVc.bottomVc = bottomVc
        
        return middleScrollVc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view:
        setupScrollView()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        scrollView.frame = CGRect(x: view.x, y: view.y, width: view.width, height: view.height)
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = view.width
        var scrollHeight: CGFloat
        
        switch (topVc, bottomVc) {
        case (nil, nil):
            scrollHeight  = view.height
            middleVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            
            addChild(middleVc)
            scrollView.addSubview(middleVc.view)
            middleVc.didMove(toParent: self)
        case (_?, nil):
            scrollHeight  = 2 * view.height
            topVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            middleVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            
            addChild(topVc)
            addChild(middleVc)
            
            scrollView.addSubview(topVc.view)
            scrollView.addSubview(middleVc.view)
            
            topVc.didMove(toParent: self)
            middleVc.didMove(toParent: self)
            
            scrollView.contentOffset.y = middleVc.view.frame.origin.y
        case (nil, _?):
            scrollHeight  = 2 * view.height
            middleVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            bottomVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            
            addChild(middleVc)
            addChild(bottomVc)
            
            scrollView.addSubview(middleVc.view)
            scrollView.addSubview(bottomVc.view)
            
            middleVc.didMove(toParent: self)
            bottomVc.didMove(toParent: self)
            
            scrollView.contentOffset.y = 0
        default:
            scrollHeight  = 3 * view.height
            topVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            middleVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            bottomVc.view.frame = CGRect(x: 0, y: 2 * view.height, width: view.width, height: view.height)
            
            addChild(topVc)
            addChild(middleVc)
            addChild(bottomVc)
            
            scrollView.addSubview(topVc.view)
            scrollView.addSubview(middleVc.view)
            scrollView.addSubview(bottomVc.view)
            
            topVc.didMove(toParent: self)
            middleVc.didMove(toParent: self)
            bottomVc.didMove(toParent: self)
            
            scrollView.contentOffset.y = middleVc.view.frame.origin.y
        }
        
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
    }
    
    // MARK: - SnapContainerViewControllerDelegate Methods
    
    func outerScrollViewShouldScroll() -> Bool {
        if scrollView.contentOffset.y < middleVc.view.frame.origin.y || scrollView.contentOffset.y > 2*middleVc.view.frame.origin.y {
            return false
        } else {
            return true
        }
    }
    
}
