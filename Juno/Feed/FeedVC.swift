//
//  FeedVC.swift
//  Juno
//
//  Created by Hunain Ali on 5/18/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit
import WebKit
import SafariServices


class FeedVC: UICollectionViewController {
    
    var tweetArray : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                self.setupCollectionView()
        
        self.setupReactBar()
        
        WidgetsJsManager.shared.load()
        
        self.setupFetcher()
        
    }
    
    func setupFetcher() {
        FeedManager.shared.getFeed { (array) in
            print("dodo \(array.count)")
            self.tweetArray = array.sorted(by: { (t1, t2) -> Bool in
                return t1.createdAt.compare(t2.createdAt) == .orderedDescending
            })
            self.tweetArray = self.tweetArray.filter({-$0.createdAt.timeIntervalSinceNow < TimeInterval(floatLiteral: 150000)}) //~86400 is one day so approx 2 days
            self.collectionView.reloadData()
            
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func setupReactBar() {
        let bar = ReactBar.shared
        self.view.addSubview(bar)
        bar.reactDelegate = self
        //        bar.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        bar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bar.heightAnchor.constraint(equalToConstant: ReactBar.heightX).isActive = true
    }
    
    
    func setupCollectionView() {
        
        collectionView.removeConstraints(collectionView.constraints)
        collectionView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.bounds.width, height: self.view.bounds.height-UIApplication.shared.statusBarFrame.height)
        
        self.collectionView.decelerationRate = .fast
        
        self.collectionView.isPagingEnabled = true
        
        self.collectionView.backgroundColor = .black
        
        self.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "feedCell")
    }
    
    // UITableViewController
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        let tweet = self.tweetArray[indexPath.row]
        
        cell.tweetID = tweet.tweetID
        print("tweetID : \(tweet.tweetID)")
        cell.loadWebview()
        
        var array : [User] = []
        let img1 = UIImage(named: "soha")
        let soha = User(image: img1, name: "Soha")
        let img2 = UIImage(named: "mama")
        let mama = User(image: img2, name: "Mama")
        let img3 = UIImage(named: "hunain")
        let hunain = User(image: img3, name: "Hunain")
        let img4 = UIImage(named: "baba")
        let baba = User(image: img4, name: "Baba")
        
        let random1 = Int.random(in: 0...1)
        if random1 == 1 {
            array.append(soha)
        }
        let random2 = Int.random(in: 0...1)
        if random2 == 1 {
            array.append(hunain)
        }
        let random3 = Int.random(in: 0...1)
        if random3 == 1 {
            array.append(baba)
        }
        let random4 = Int.random(in: 0...1)
        if random4 == 1 {
            array.append(mama)
        }
        cell.memberStackView.userArray = array
        cell.memberStackView.reloadData()
        
        
        
        return cell
    }
    
    
//    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("yoyo \(collectionView.visibleCells.map({$0.}))")
//    }
    
    
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class WidgetsJsManager {
    static let shared = WidgetsJsManager()
    
    // The contents of https://platform.twitter.com/widgets.js
    var content: String?
    
    func load() {
        do {
            content = try String(contentsOf: URL(string: "https://platform.twitter.com/widgets.js")!)
            
        } catch {
            print("Could not load widgets.js script")
        }
    }
    
    func getScriptContent() -> String? {
        return content
    }
}



extension FeedVC : ReactBarDelegate {
    
    func reactionTapped() {
        let indexPaths = self.collectionView.indexPathsForVisibleItems
        let rows = indexPaths.map({$0.row})
        print("rows \(rows)")
        let theRow = rows.min() ?? 0 + 1
        
        self.collectionView.scrollToItem(at: IndexPath(item: theRow, section: 0), at: .top, animated: true)
    }
    
}
