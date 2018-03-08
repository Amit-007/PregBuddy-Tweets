//
//  TwitterWrapper.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import Foundation
import TwitterKit
import TwitterCore

enum type {
    case mixed
    case retweeted
    case liked
}

class TwitterWrapper: NSObject {
    
    private static let sharedInstance: TwitterWrapper = {
        let sharedInstance = TwitterWrapper()
        return sharedInstance
    }()
    
    class func shared() -> TwitterWrapper{
        return sharedInstance
    }
    
    func instantiateTwitter()  {
        TWTRTwitter.sharedInstance().start(withConsumerKey:"hvZFqA5NhkDY8DqhlyUlocqmS",
            consumerSecret:"arn7xAveO1lzDfSBJ7AoeZ1nOWC2AxgjfPZHkbMx3S2JXBgCYe")
    }
    
    func loadTweets(_ completion: @escaping(([Tweet]?,Error?) ->())){
        
        let session = TWTRTwitter.sharedInstance().sessionStore.session()
        guard let userID = session?.userID else {
            return }
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": "pregnancy",
                      "count": "20",
                      "result_type": "recent"]
        var clientError : NSError?
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (urlresponse, data, error) in
            if error == nil{
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("json: \(json)")
                    let tweets = Tweets.parseTweets(json as! [String : Any])
                    print(tweets)
                    completion(tweets,error)
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    completion(nil,error)
                }
            }else{
                print(error?.localizedDescription ?? "")
                completion(nil,error)
            }
        }
    }
    
    
    func fetchTweets(_ type: type, completion: @escaping(([Tweet]?,Error?)->()))  {
        
        var resultType: String = ""
        
        switch type {
        case .liked:
            resultType = "recent"
            break
        case .mixed:
            resultType = "mixed"
            break
        case .retweeted:
            resultType = "popular"
            break
        }
        let session = TWTRTwitter.sharedInstance().sessionStore.session()
        guard let userID = session?.userID else {
            return }
        let client = TWTRAPIClient(userID: userID)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": "pregnancy",
                      "count": "10",
                      "result_type": resultType]
        
        var clientError : NSError?
        let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (urlresponse, data, error) in
            if error == nil{
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("json: \(json)")
                    let tweets = Tweets.parseTweets(json as! [String : Any])
                    print(tweets)
                    completion(tweets,error)
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    completion(nil,error)
                }
            }else{
                print(error?.localizedDescription ?? "")
                completion(nil,error)
            }
        }
    }
}
