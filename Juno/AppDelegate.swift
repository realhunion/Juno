//
//  AppDelegate.swift
//  Juno
//
//  Created by Hunain Ali on 5/18/20.
//  Copyright © 2020 BUMP. All rights reserved.
//
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    var pluto : Pluto?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configureMyFirebase()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
//        self.pluto = Pluto()
        self.feedVC = FeedVC(collectionViewLayout: UICollectionViewFlowLayout())
        let myGroupsVC = MyGroupsVC(style: .plain)
        let myGroupsNC = UINavigationController(rootViewController: myGroupsVC)
        let tvc2 = TestVCTableViewController(style: .insetGrouped)
        let snapContainer = SnapContainerViewController.containerViewWith(myGroupsNC, middleVC: feedVC!, rightVC: tvc2, topVC: nil, bottomVC: nil, directionLockDisabled: nil)
        self.window?.rootViewController = snapContainer
        //        self.window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    var feedVC : FeedVC?
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        self.feedVC?.setupFetcher()
    }
    
    
    
    
    // MARK: - Configure Firebase
    
    func configureMyFirebase() {
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        Firestore.firestore().settings = settings
    }
    
    
    
    
    
    
    
    
}
