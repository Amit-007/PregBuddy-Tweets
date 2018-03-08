//
//  Tweets.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import Foundation

struct Tweet {
    
    var created_at : String? = ""
    var retweet_count: String? = ""
    var text: String? = ""
    var hashTag: String? = ""
    var name: String? = ""
    var profile_image_url: String? = ""
    var media_url: String? = ""
    var screen_name: String? = ""
}


class Tweets: NSObject {
    
    class func parseTweets(_ tweetsResponse : [String : Any]) -> [Tweet] {
        
        var tweetsArray = [Tweet]()
        let statuses = tweetsResponse["statuses"] as! [[String: Any]]
        for tweets in statuses {
            
            let created_at = String.checkIfStringIsNull(forItem: tweets, key: "created_at").trimWhiteSpaces()
            let retweet_count = NSNumber.checkIfNumberIsNull(forItem: tweets, forKey: "retweet_count")
            let entitiesPresent = Dictionary<String, Any>.ifExists(forItem: tweets, withKey: "entities")
            var media_url = ""
            var hashTag = ""
            if entitiesPresent == true{
                let entities = tweets["entities"] as? [String : Any]
                if entities != nil{
                    
                    if Dictionary<String, Any>.ifExists(forItem: entities!, withKey: "hashtags") == true{
                        hashTag = getHashtags(entities!["hashtags"] as? [[String : Any]])
                    }
                    let media = entities!["media"] as? [[String: Any]]
                    if media != nil && media?.count != 0{
                        let mediaAtFirstIndex = media![0]
                        media_url = String.checkIfStringIsNull(forItem: mediaAtFirstIndex, key: "media_url_https").trimWhiteSpaces()
                    }
                }
            }
            let text = String.checkIfStringIsNull(forItem: tweets, key: "text").trimWhiteSpaces()
            var name = ""
            var screen_name = ""
            var profile_image_url = ""
            
            if Dictionary<String, Any>.ifExists(forItem: tweets, withKey: "user") == true{
                let user = tweets["user"] as? [String: Any]
                if user != nil{
                    name = String.checkIfStringIsNull(forItem: user!, key: "name").trimWhiteSpaces()
                    screen_name = String.checkIfStringIsNull(forItem: user!, key: "screen_name").trimWhiteSpaces()
                    profile_image_url = String.checkIfStringIsNull(forItem: user!, key: "profile_background_image_url_https").trimWhiteSpaces()
                }
            }
            let tweet = Tweet(created_at: created_at, retweet_count: "\(retweet_count)", text: text, hashTag: hashTag, name: name, profile_image_url: profile_image_url, media_url: media_url,screen_name: screen_name)
            
            tweetsArray.append(tweet)
        }
        return tweetsArray
    }
    
    
    
    class func getHashtags(_ hashtags : [[String : Any]]?) -> String {
        
        let mutableTag = NSMutableString()
        if hashtags != nil {
            for hashTag in hashtags! {
                let str = hashTag["text"] as! String
                mutableTag.append("#\(str) ")
            }
        }
        
        let str = "\(mutableTag)"
        return str.trimWhiteSpaces()
    }
    
}

