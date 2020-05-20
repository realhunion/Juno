//
//  TweetManager.swift
//  VerticalPagingScroll
//
//  Created by Hunain Ali on 5/16/20.
//  Copyright © 2020 秋本大介. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Tweet {
    var tweetID : String
    var numRetweets : Int
    var numLikes : Int
    var createdAt : Date
}

class TweetManager {
    
    static let shared : TweetManager = TweetManager()
    
    func getUserTweets(userhandle : String, count : Int, completion: @escaping (_ tweetArray : [Tweet]) -> Void) {
        
        let excludeReplies = "true"
        
        let headers = [
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGZ3EQEAAAAAuNAJIah6%2BCYO91Si7r%2FnyP4MHUA%3DGhaZtY5f1xrDkVTHTGHuY4EtxksDGTbJMIXQXwj4QI4PuVICKU",
            "Accept": "application/json"
        ]
        
        let hHeaders = HTTPHeaders(headers)
        AF.request("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(userhandle)&count=\(count)&include_rts=false&exclude_replies=\(excludeReplies)&trim_user=true", headers: hHeaders)
            .responseJSON { response in
                guard let data = response.data else { completion([]); return }
                
                print("----------------\n-----------------")
                
                var tweetArray : [Tweet] = []
                
                for j in JSON(data).arrayValue {
                    
                    if let tweetID = j["id_str"].string, let numLikes = j["favorite_count"].int, let numRetweets = j["retweet_count"].int, let createdAtString = j["created_at"].string, let createdAt = self.formatDate(string: createdAtString) {
                        
                        let t = Tweet(tweetID: tweetID, numRetweets: numRetweets, numLikes: numLikes, createdAt: createdAt)
                        tweetArray.append(t)
                        
                    }
                }
                
                
                completion(tweetArray)
                return
        }
    }
    
    func formatDate(string : String) -> Date? {
        let tdf = DateFormatter()
        tdf.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        tdf.locale = Locale(identifier: "en_US_POSIX")
        if let date = tdf.date(from: string) {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .medium
            return date
        } else {
            return nil
        }
    }
    
    func getTopTweets(keyword : String, count : Int, completion: @escaping (_ tweetArray : [Tweet]) -> Void) {
        
        let headers = [
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGZ3EQEAAAAAuNAJIah6%2BCYO91Si7r%2FnyP4MHUA%3DGhaZtY5f1xrDkVTHTGHuY4EtxksDGTbJMIXQXwj4QI4PuVICKU",
            "Accept": "application/json"
        ]
        
        let hHeaders = HTTPHeaders(headers)
        AF.request("https://api.twitter.com/1.1/search/tweets.json?q=\(keyword)&lang=en&result_type=popular&count=\(count)&include_entities=false", headers: hHeaders)
            .responseJSON { response in
                guard let data = response.data else { completion([]); return }
                
                print("----------------\n-----------------")
                
                var tweetArray : [Tweet] = []
                
                for j in JSON(data)["statuses"].arrayValue {
                    
                    if let tweetID = j["id_str"].string, let numLikes = j["favorite_count"].int, let numRetweets = j["retweet_count"].int, let createdAtString = j["created_at"].string, let createdAt = self.formatDate(string: createdAtString) {
                        
                        let t = Tweet(tweetID: tweetID, numRetweets: numRetweets, numLikes: numLikes, createdAt: createdAt)
                        tweetArray.append(t)
                        
                    }
                }
                
                
                completion(tweetArray)
                return
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getTwitterTrends(completion: @escaping (_ tweetIDArray : [String]) -> Void) {
        
        let place = "23424977"
        let headers = [
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGZ3EQEAAAAAuNAJIah6%2BCYO91Si7r%2FnyP4MHUA%3DGhaZtY5f1xrDkVTHTGHuY4EtxksDGTbJMIXQXwj4QI4PuVICKU",
            "Accept": "application/json"
        ]
        
        let hHeaders = HTTPHeaders(headers)
        AF.request("https://api.twitter.com/1.1/trends/place.json?id=\(place)", headers: hHeaders)
            .responseJSON { response in
                guard let data = response.data else { completion([]); return }
                
                print("----------------\n-----------------")
                
                let theJSON = JSON(data)
//                let jsonIDArray = theJSON["trends"].array?.map({$0["name"]}) ?? []
                
//                let intIDArray = jsonIDArray.map({$0.string!})
                
                var trendArray = theJSON[0]["trends"].array!
                trendArray = trendArray.map({$0["name"]})
                let c = trendArray.map({$0.string!})
//                trend
                print(c)
                
                completion(c)
                return
        }
    }
    
    
    func getTweetIDArray3(completion: @escaping (_ tweetIDArray : [String]) -> Void) {
        
        self.getTwitterTrends { (trendNameArray) in
            
            var totalIDArray : [String] = []
            let dGroup = DispatchGroup()
            
            for trend in trendNameArray {
                
                let headers = [
                    "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAAGZ3EQEAAAAAuNAJIah6%2BCYO91Si7r%2FnyP4MHUA%3DGhaZtY5f1xrDkVTHTGHuY4EtxksDGTbJMIXQXwj4QI4PuVICKU",
                    "Accept": "application/json"
                ]
                let count = 5
                let hHeaders = HTTPHeaders(headers)
                
                let resultType = "result_type=popular"
                
                dGroup.enter()
                AF.request("https://api.twitter.com/1.1/search/tweets.json?q=\(trend)&lang=en&result_type=popular&count=\(count)&include_entities=false", headers: hHeaders)
                    .responseJSON { response in
                        guard let data = response.data else { dGroup.leave(); return }
                        
                        print("----------------\n-----------------")
                        
                        let theJSON = JSON(data)
                        let jsonIDArray = theJSON["statuses"].array?.map({$0["id"]}) ?? []
                        
                        let intIDArray = jsonIDArray.map({$0.intValue})
                        let stringIDArray = intIDArray.map({String($0)})
                        
                        totalIDArray.append(contentsOf: stringIDArray)
                        dGroup.leave()
                        
                        
                }
            }
            
            
            dGroup.notify(queue: DispatchQueue.main) {
                
                completion(totalIDArray)
                return
            }
            
        }
        
    }
    
}
