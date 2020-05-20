//
//  FeedManager.swift
//  Juno
//
//  Created by Hunain Ali on 5/20/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import Foundation
import Firebase

class FeedManager {
    
    var db = Firestore.firestore()
    
    static let shared : FeedManager = FeedManager()
    
    
    //MARK: - Get Feed
    
    func getFeed(completion: @escaping (_ tweetArray : [Tweet]) -> Void) {

        let newsHandles = ["cnnbrk", "nytimes", "chicagotribune", "NewsweekPak", "nytimestech", "markets", "CNNBusiness", "ABCWorldNews", "AP"]
//        let newsHandles = ["wonderofscience","worldandscience"]

        let dGroup = DispatchGroup()

        var allTweetArray : [Tweet] = []

        for handle in newsHandles {
            dGroup.enter()
            TweetManager.shared.getUserTweets(userhandle: handle, count: 20) { (tweetArray) in
                allTweetArray.append(contentsOf: tweetArray)
                dGroup.leave()
            }
        }

        dGroup.notify(queue: DispatchQueue.main) {

            completion(allTweetArray)
            return
        }
    }
    
//    func getFeed(completion: @escaping (_ tweetArray : [Tweet]) -> Void) {
//
//        let newsHandles = ["nba", "nfl", "space", "corona", "stocks", "elon musk"]
//
//        let dGroup = DispatchGroup()
//
//        var allTweetArray : [Tweet] = []
//
//        for handle in newsHandles {
//            dGroup.enter()
//            TweetManager.shared.getTopTweets(keyword: handle, count: 20) { (tweetArray) in
//                allTweetArray.append(contentsOf: tweetArray)
//                dGroup.leave()
//            }
//        }
//
//        dGroup.notify(queue: DispatchQueue.main) {
//
//            completion(allTweetArray)
//            return
//        }
//    }
    
    
    //MARK: - Feed Helpers
    
    func getMyUnseenReactions(groupID : String, completion: @escaping (_ reactionArray : [Reaction]) -> Void) {
        
        self.getMyLastReaction(groupID: groupID) { (myLastReaction) in
            guard let lastReaction = myLastReaction else { completion([]); return }
            
            let ref = self.db.collection("Groups").document(groupID).collection("Reactions")
            ref.whereField("tweetID", isGreaterThan: lastReaction.reaction).getDocuments { (snap, err) in
                guard let docs = snap?.documents else {completion([]); return }
                
                var reactionArray : [Reaction] = []
                
                for doc in docs {
                    if let tweetID = doc.data()["tweetID"] as? String, let userID = doc.data()["userID"] as? String, let userName = doc.data()["userName"] as? String, let reactionString = doc.data()["reaction"] as? String {
                        
                        let reaction = Reaction(tweetID: tweetID, userID: userID, userName: userName, reaction: Reaction.getReactionType(reactionString: reactionString))
                        reactionArray.append(reaction)
                    }
                }
                
                completion(reactionArray)
                return
                
            }
            
            
        }
        
    }
    
    func getMyLastReaction(groupID : String, completion: @escaping (_ reaction : Reaction?) -> Void) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("Groups").document(groupID).collection("Reactions")
        ref.whereField("userID", isEqualTo: myUID).order(by: "tweetID", descending: true).limit(to: 1).getDocuments { (snap, err) in
            guard let doc = snap?.documents.first else { completion(nil); return }
            
            if let tweetID = doc.data()["tweetID"] as? String, let userID = doc.data()["userID"] as? String, let userName = doc.data()["userName"] as? String, let reactionString = doc.data()["reaction"] as? String {
                
                let reaction = Reaction(tweetID: tweetID, userID: userID, userName: userName, reaction: Reaction.getReactionType(reactionString: reactionString))
                completion(reaction)
                return
            }
        }
        
        
    }
    
    
    
    //MARK: - Tweet Reactions
    
    
    func reactTo(groupID : String, tweetID : String, reactionType : ReactionType) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        let displayName = Auth.auth().currentUser?.displayName ?? "Hunion"
        
        let payload : [String:Any] = ["tweetID": tweetID ,"userID":myUID, "userName":displayName, "reaction":reactionType.rawValue]
        
        db.collection("Groups").document(groupID).collection("Reactions").addDocument(data: payload)
        
    }
    
    func getReactions(groupID : String, tweetID : String, completion: @escaping (_ reactionArray : [Reaction]) -> Void) {
        
        let ref = db.collection("Groups").document(groupID).collection("Reactions")
        ref.whereField("tweetID", isEqualTo: tweetID).getDocuments { (snap, err) in
            guard let docs = snap?.documents else { completion([]); return}
            
            var reactionArray : [Reaction] = []
            
            for doc in docs {
                if let tweetID = doc.data()["tweetID"] as? String, let userID = doc.data()["userID"] as? String, let userName = doc.data()["userName"] as? String, let reactionString = doc.data()["reaction"] as? String {
                    
                    let reaction = Reaction(tweetID: tweetID, userID: userID, userName: userName, reaction: Reaction.getReactionType(reactionString: reactionString))
                    reactionArray.append(reaction)
                }
            }
            
            completion(reactionArray)
            return
            
        }
        
    }
    
    
}

enum ReactionType : String {
    case heart = "heart"
    case laugh = "laugh"
    case angry = "angry"
    case sad = "sad"
    case wow = "wow"
    case seen = "seen"
}

struct Reaction {
    var tweetID : String
    var userID : String
    var userName : String
    var reaction : ReactionType
    
    static func getReactionType(reactionString : String) -> ReactionType {
        if reactionString == "heart" {
            return .heart
        }
        else if reactionString == "wow" {
            return .wow
        }
        else if reactionString == "laugh" {
            return .laugh
        }
        else if reactionString == "angry" {
            return .angry
        }
        else if reactionString == "sad" {
            return .sad
        }
        else {
            return .seen
        }
    }
}
