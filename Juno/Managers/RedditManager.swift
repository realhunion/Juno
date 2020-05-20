//
//  RedditManager.swift
//  Juno
//
//  Created by Hunain Ali on 5/19/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RedditManager {
    
    static let shared : RedditManager = RedditManager()
    
    func getSubredditPosts(subreddit : String, completion: @escaping (_ tweetIDArray : [String]) -> Void) {
        
        
//        let headers = []
//        let hHeaders = HTTPHeaders(headers)
        
        let requestURL = "https://www.reddit.com/r/earthporn/.json?limit=5"
        
        AF.request(requestURL, headers: nil)
            .responseJSON { response in
                guard let data = response.data else { completion([]); return }
                
                print("----------------\n-----------------")
                
                let theJSON = JSON(data)
//                let jsonIDArray = theJSON.array?.map({$0["id"]}) ?? []
//
//                let intIDArray = jsonIDArray.map({$0.intValue})
//
//                let stringIDArray = intIDArray.map({String($0)})
                
                var urlArray = theJSON["data"]["children"].array?.map({$0["data"]["permalink"]}) ?? []
                let x = urlArray.map({$0.string})
                let xx = x.map({$0!})
                
                
                
                print(xx)
                
                completion(xx)
                return
        }
        
        
    }
}
