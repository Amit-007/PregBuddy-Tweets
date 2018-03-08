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


/*


objc[2605]: Class TWTRScribeService is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9148) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108560f70). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRUserAuthRequestSigner is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e91c0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108560fe8). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRSecItemWrapper is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9210) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561038). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRMultipartFormElement is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9238) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561060). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRMultipartFormDocument is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9288) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085610b0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAPINetworkErrorsShim is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e92d8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561100). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAPIResponseValidator is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9350) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561178). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRDateFormatters is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e93a0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085611c8). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGuestAuthRequestSigner is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e93f0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561218). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRKeychainWrapper is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9418) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561240). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRScribeClientEventNamespace is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9468) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561290). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRUserAPIClient is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e94b8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085612e0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRNetworking is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9508) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561330). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRRequestSigningOperation is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9558) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561380). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGuestRequestSigningOperation is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e95a8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085613d0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRUserRequestSigningOperation is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e95f8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561420). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRColorUtil is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9648) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561470). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRFileManager is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e96c0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085614e8). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGuestSessionRefreshStrategy is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e96e8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561510). One of the two will be used. Which one is undefined.
objc[2605]: Class TFSScribe is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9738) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561560). One of the two will be used. Which one is undefined.
objc[2605]: Class TFSScribeEvent is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e97b0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085615d8). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRResourcesUtil is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e97d8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561600). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAuthenticationProvider is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9850) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561678). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAuthConfig is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9878) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085616a0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRDateUtil is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e98f0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561718). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRUserSessionVerifier is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9918) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561740). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGuestAuthProvider is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9968) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561790). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRScribeMediaDetails is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e99b8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085617e0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRIdentifier is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9a30) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561858). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRScribeEvent is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9a58) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561880). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRErrorScribeEvent is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9aa8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085618d0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGenericKeychainQuery is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9af8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561920). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGenericKeychainItem is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9b48) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561970). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRNetworkingPipeline is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9b98) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085619c0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRCore is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9c10) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561a38). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAppAPIClient is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9c38) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561a60). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAPIServiceConfigRegistry is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9c88) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561ab0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAuthConfigSessionsValidator is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9cd8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561b00). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRScribeItem is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9d28) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561b50). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRScribeCardEvent is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9d78) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561ba0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRTokenOnlyAuthSession is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9dc8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561bf0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRURLSessionDelegate is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9e18) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561c40). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRScribeFilterDetails is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9e68) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561c90). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRNetworkingUtil is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9eb8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561ce0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTROAuth1aAuthRequestSigner is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9f30) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561d58). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGCOAuth is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9f58) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561d80). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAppInstallationUUID is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9fd0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561df8). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRNetworkSessionProvider is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086e9ff8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561e20). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRSessionStore is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea048) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561e70). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRNetworkingPipelineQueue is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea098) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561ec0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAuthConfigStore is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea0e8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561f10). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRCoreLanguage is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea160) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561f88). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRSession is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea188) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108561fb0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRX509Certificate is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea1d8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562000). One of the two will be used. Which one is undefined.
objc[2605]: Class TFSScribeImpression is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea250) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562078). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAppleSocialAuthenticaticationProvider is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea278) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085620a0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAPIDateSync is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea2c8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085620f0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRDictUtil is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea318) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562140). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRMultiThreadUtil is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea368) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562190). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAuthenticator is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea3e0) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562208). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRGuestSession is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea408) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562230). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRUtils is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea458) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562280). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRNetworkingPipelinePackage is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea4a8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x1085622d0). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRServerTrustEvaluator is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea4f8) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562320). One of the two will be used. Which one is undefined.
objc[2605]: Class TWTRAppAuthProvider is implemented in both /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterKit.framework/TwitterKit (0x1086ea548) and /Users/amitmajumdar/Library/Developer/CoreSimulator/Devices/BAAAADDB-C2C0-4E1A-B64E-6CC961564404/data/Containers/Bundle/Application/AB8334B9-8E43-4A62-94CD-DC06649F8707/PregBuddyTweets.app/Frameworks/TwitterCore.framework/TwitterCore (0x108562370). One of the two will be used. Which one is undefined.
json: {
    "search_metadata" =     {
        "completed_in" = "0.052";
        count = 20;
        "max_id" = 971632466430779393;
        "max_id_str" = 971632466430779393;
        "next_results" = "?max_id=971632144828239871&q=pregnancy&count=20&include_entities=1&result_type=recent";
        query = pregnancy;
        "refresh_url" = "?since_id=971632466430779393&q=pregnancy&result_type=recent&include_entities=1";
        "since_id" = 0;
        "since_id_str" = 0;
    };
    statuses =     (
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:26 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 268719816;
                        "id_str" = 268719816;
                        indices =                         (
                            3,
                            16
                        );
                        name = "Ruby Mungai";
                        "screen_name" = "Shiru_Mungai";
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632466430779393;
            "id_str" = 971632466430779393;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 5;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:01:00 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971611719918264321";
                            indices =                             (
                            116,
                            139
                            );
                            url = "https://t.co/eBsSVrVVIa";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 9;
                favorited = 0;
                geo = "<null>";
                id = 971611719918264321;
                "id_str" = 971611719918264321;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 5;
                retweeted = 0;
                source = "<a href=\"https://about.twitter.com/products/tweetdeck\" rel=\"nofollow\">TweetDeck</a>";
                text = "Adolescent pregnancy robs girls of their potential and reinforces the vicious cycle of poverty. It is also a major\U2026 https://t.co/eBsSVrVVIa";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Sat Mar 19 09:56:00 +0000 2011";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Writer, photographer and optimist.\nAlways stay gracious, best revenge is your success.";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                    };
                    "favourites_count" = 10;
                    "follow_request_sent" = 0;
                    "followers_count" = 931;
                    following = 0;
                    "friends_count" = 450;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 1;
                    id = 268719816;
                    "id_str" = 268719816;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 22;
                    location = "Nairobi,Kenya.";
                    name = "Ruby Mungai";
                    notifications = 0;
                    "profile_background_color" = 131516;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme14/bg.gif";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme14/bg.gif";
                    "profile_background_tile" = 1;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/268719816/1449162925";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/700710064428965888/LqrEn_Tu_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/700710064428965888/LqrEn_Tu_normal.jpg";
                    "profile_link_color" = 5F3861;
                    "profile_sidebar_border_color" = EEEEEE;
                    "profile_sidebar_fill_color" = EFEFEF;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = "Shiru_Mungai";
                    "statuses_count" = 1977;
                    "time_zone" = Nairobi;
                    "translator_type" = none;
                    url = "<null>";
                    "utc_offset" = 10800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Shiru_Mungai: Adolescent pregnancy robs girls of their potential and reinforces the vicious cycle of poverty. It is also a major cause\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sat Nov 11 11:41:44 +0000 2017";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Medical student\nJomo kenyatta University of agriculture and technology//\nTeamchelsea//\nA patriot//advocate for good governance";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 4486;
                "follow_request_sent" = 0;
                "followers_count" = 215;
                following = 0;
                "friends_count" = 142;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 929313188121849857;
                "id_str" = 929313188121849857;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = Kenya;
                name = "Lilian Obaga";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/929313188121849857/1516695951";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/947704829836775424/VCkiOsW-_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/947704829836775424/VCkiOsW-_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = LilianObaga;
                "statuses_count" = 423;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:26 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 814450819;
                        "id_str" = 814450819;
                        indices =                         (
                            3,
                            16
                        );
                        name = "Women's Aid Org";
                        "screen_name" = womensaidorg;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632465935704064;
            "id_str" = 971632465935704064;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 12;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 14:03:06 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971385755556655104";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/BU37G2eVYg";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 4;
                favorited = 0;
                geo = "<null>";
                id = 971385755556655104;
                "id_str" = 971385755556655104;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 12;
                retweeted = 0;
                source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
                text = "In conjunction with International Women's Day, WAO is launching our 'Invisible Women' art exhibition, which highlig\U2026 https://t.co/BU37G2eVYg";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Mon Sep 10 04:19:35 +0000 2012";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "WAO is an NGO that provides shelter & counseling for abused women, & advocates for women\U2019s human rights. Counseling line:+603-7956 3488; SMS +6018-988 8058";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "wao.org.my";
                                    "expanded_url" = "http://www.wao.org.my/";
                                    indices =                                     (
                                        0,
                                        22
                                    );
                                    url = "http://t.co/B975VUP32j";
                                }
                            );
                        };
                    };
                    "favourites_count" = 523;
                    "follow_request_sent" = 0;
                    "followers_count" = 4430;
                    following = 0;
                    "friends_count" = 261;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 0;
                    id = 814450819;
                    "id_str" = 814450819;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 72;
                    location = "Selangor, Malaysia";
                    name = "Women's Aid Org";
                    notifications = 0;
                    "profile_background_color" = A32121;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme6/bg.gif";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme6/bg.gif";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/814450819/1404284197";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/894454092793225216/RStdO_XJ_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/894454092793225216/RStdO_XJ_normal.jpg";
                    "profile_link_color" = 8E3BDB;
                    "profile_sidebar_border_color" = FFFFFF;
                    "profile_sidebar_fill_color" = A0C5C7;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 0;
                    protected = 0;
                    "screen_name" = womensaidorg;
                    "statuses_count" = 7013;
                    "time_zone" = "Kuala Lumpur";
                    "translator_type" = none;
                    url = "http://t.co/B975VUP32j";
                    "utc_offset" = 28800;
                    verified = 1;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @womensaidorg: In conjunction with International Women's Day, WAO is launching our 'Invisible Women' art exhibition, which highlights wo\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Mon Aug 07 06:56:13 +0000 2017";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\U2728\U2601\Ufe0fArt and lifestyle collective based in the clouds \U2601\Ufe0f\U2728";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "kekabumi.tumblr.com";
                                "expanded_url" = "http://kekabumi.tumblr.com";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/yOasvo8Pqt";
                            }
                        );
                    };
                };
                "favourites_count" = 16;
                "follow_request_sent" = 0;
                "followers_count" = 97;
                following = 0;
                "friends_count" = 33;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 894452100049936385;
                "id_str" = 894452100049936385;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = Malaysia;
                name = Kekabumi;
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/894452100049936385/1504258921";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/903553250833588224/yVXosx05_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/903553250833588224/yVXosx05_normal.jpg";
                "profile_link_color" = F58EA8;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = kekabumi;
                "statuses_count" = 124;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/yOasvo8Pqt";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:26 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 265902729;
                        "id_str" = 265902729;
                        indices =                         (
                            3,
                            12
                        );
                        name = "BBC Sport";
                        "screen_name" = BBCSport;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632465566748672;
            "id_str" = 971632465566748672;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 161;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Tue Mar 06 12:47:43 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971004396598329344";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/mhrkniSfnG";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 293;
                favorited = 0;
                geo = "<null>";
                id = 971004396598329344;
                "id_str" = 971004396598329344;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 0;
                "retweet_count" = 161;
                retweeted = 0;
                source = "<a href=\"http://www.socialflow.com\" rel=\"nofollow\">SocialFlow</a>";
                text = "\"We're dying. Three-times more likely.\"\n\nSerena Williams has spoken candidly about the ''heartbreaking'' complicati\U2026 https://t.co/mhrkniSfnG";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Mon Mar 14 09:44:40 +0000 2011";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Official https://t.co/XsBH2P4slh account. Also from @bbc - @bbcmotd @bbcf1 @bbctms @bbctennis @bbcrugbyunion @bbcsnooker & @bbcgetinspired";
                    entities =                     {
                        description =                         {
                            urls =                             (
                                {
                                    "display_url" = "bbc.co.uk/sport";
                                    "expanded_url" = "http://www.bbc.co.uk/sport";
                                    indices =                                     (
                                        9,
                                        32
                                    );
                                    url = "https://t.co/XsBH2P4slh";
                                }
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "bbc.co.uk/sport/0/";
                                    "expanded_url" = "http://www.bbc.co.uk/sport/0/";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/nGZXuvg6cY";
                                }
                            );
                        };
                    };
                    "favourites_count" = 377;
                    "follow_request_sent" = 0;
                    "followers_count" = 7255947;
                    following = 0;
                    "friends_count" = 280;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 0;
                    id = 265902729;
                    "id_str" = 265902729;
                    "is_translation_enabled" = 1;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 19106;
                    location = "MediaCityUK, Salford";
                    name = "BBC Sport";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/240463705/BBCSportTwitter_backing11.jpg";
                    "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/240463705/BBCSportTwitter_backing11.jpg";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/265902729/1519644660";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/968086146180886528/P_nvzGw__normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968086146180886528/P_nvzGw__normal.jpg";
                    "profile_link_color" = FFD230;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = BBCSport;
                    "statuses_count" = 328056;
                    "time_zone" = London;
                    "translator_type" = none;
                    url = "https://t.co/nGZXuvg6cY";
                    "utc_offset" = 0;
                    verified = 1;
                };
            };
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "RT @BBCSport: \"We're dying. Three-times more likely.\"\n\nSerena Williams has spoken candidly about the ''heartbreaking'' complications for bl\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Nov 22 10:49:43 +0000 2013";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "We inform & empower mothers in rural African communities to adopt healthy behaviors & to access maternal & child health services #MaternalHealth #DigitalHealth";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "babymed.jabotech.co.ke";
                                "expanded_url" = "http://babymed.jabotech.co.ke/";
                                indices =                                 (
                                    0,
                                    22
                                );
                                url = "http://t.co/qfb8QiHn1a";
                            }
                        );
                    };
                };
                "favourites_count" = 65;
                "follow_request_sent" = 0;
                "followers_count" = 1060;
                following = 0;
                "friends_count" = 2789;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 2208776912;
                "id_str" = 2208776912;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 63;
                location = "Nairobi, Kenya";
                name = BabyMed;
                notifications = 0;
                "profile_background_color" = DBF70A;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/378800000172559448/JU3wXOp-.png";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/378800000172559448/JU3wXOp-.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2208776912/1479286510";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/425963747589365760/dm5Xv5-5_normal.png";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/425963747589365760/dm5Xv5-5_normal.png";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = FFFFFF;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "babymed_Ke";
                "statuses_count" = 8224;
                "time_zone" = "Pacific Time (US & Canada)";
                "translator_type" = none;
                url = "http://t.co/qfb8QiHn1a";
                "utc_offset" = "-28800";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:26 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                media =                 (
                    {
                        "display_url" = "pic.twitter.com/CWMAcbbx6i";
                        "expanded_url" = "https://twitter.com/kriskrystal/status/971632464182566912/photo/1";
                        id = 971632442682552321;
                        "id_str" = 971632442682552321;
                        indices =                         (
                            108,
                            131
                        );
                        "media_url" = "http://pbs.twimg.com/tweet_video_thumb/DXvujwZWsAEoLew.jpg";
                        "media_url_https" = "https://pbs.twimg.com/tweet_video_thumb/DXvujwZWsAEoLew.jpg";
                        sizes =                         {
                            large =                             {
                                h = 300;
                                resize = fit;
                                w = 300;
                            };
                            medium =                             {
                                h = 300;
                                resize = fit;
                                w = 300;
                            };
                            small =                             {
                                h = 300;
                                resize = fit;
                                w = 300;
                            };
                            thumb =                             {
                                h = 150;
                                resize = crop;
                                w = 150;
                            };
                        };
                        type = photo;
                        url = "https://t.co/CWMAcbbx6i";
                    }
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                );
            };
            "extended_entities" =             {
                media =                 (
                    {
                        "display_url" = "pic.twitter.com/CWMAcbbx6i";
                        "expanded_url" = "https://twitter.com/kriskrystal/status/971632464182566912/photo/1";
                        id = 971632442682552321;
                        "id_str" = 971632442682552321;
                        indices =                         (
                            108,
                            131
                        );
                        "media_url" = "http://pbs.twimg.com/tweet_video_thumb/DXvujwZWsAEoLew.jpg";
                        "media_url_https" = "https://pbs.twimg.com/tweet_video_thumb/DXvujwZWsAEoLew.jpg";
                        sizes =                         {
                            large =                             {
                                h = 300;
                                resize = fit;
                                w = 300;
                            };
                            medium =                             {
                                h = 300;
                                resize = fit;
                                w = 300;
                            };
                            small =                             {
                                h = 300;
                                resize = fit;
                                w = 300;
                            };
                            thumb =                             {
                                h = 150;
                                resize = crop;
                                w = 150;
                            };
                        };
                        type = "animated_gif";
                        url = "https://t.co/CWMAcbbx6i";
                        "video_info" =                         {
                            "aspect_ratio" =                             (
                                1,
                                1
                            );
                            variants =                             (
                                {
                                    bitrate = 0;
                                    "content_type" = "video/mp4";
                                    url = "https://video.twimg.com/tweet_video/DXvujwZWsAEoLew.mp4";
                                }
                            );
                        };
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632464182566912;
            "id_str" = 971632464182566912;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
            text = "why the FUCK is everybody pregnant... this year was supposed to be about ME AND MY PREGNANCY. i'm so mad rn https://t.co/CWMAcbbx6i";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Feb 24 02:42:16 +0000 2012";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "\Ud83c\Udf6d";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 6456;
                "follow_request_sent" = 0;
                "followers_count" = 241;
                following = 0;
                "friends_count" = 162;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 501379922;
                "id_str" = 501379922;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "Trinidad and Tobago";
                name = "babyK & babyD";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/501379922/1513632915";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/949168988524875776/gtc8WDe5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/949168988524875776/gtc8WDe5_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = kriskrystal;
                "statuses_count" = 184;
                "time_zone" = "Pacific Time (US & Canada)";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "-28800";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:25 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 2318870107;
                        "id_str" = 2318870107;
                        indices =                         (
                            3,
                            11
                        );
                        name = Jotham;
                        "screen_name" = Etoo254;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632460877434880;
            "id_str" = 971632460877434880;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 6;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:22:29 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971617128284647424";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/4PVR5OLKOQ";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 1;
                favorited = 0;
                geo = "<null>";
                id = 971617128284647424;
                "id_str" = 971617128284647424;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 6;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Religious Leaders: Sensitize community members about the dangers of underage pregnancy and \Ufb01ght negative cultural b\U2026 https://t.co/4PVR5OLKOQ";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Thu Jan 30 13:04:50 +0000 2014";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Marketer \Ud83d\Udd4e |  Growth Hacker \Ud83c\Udf3f | Award Winning Blogger \Ud83c\Udfc5\Ud83c\Udfc6| Download  @MOMBO_App  \Ud83c\Udfe7 | Music \Ud83c\Udfbc ,  Events  & Dining \Ud83c\Udf79 | 0703269969 |  jmumina13@gmail.com |";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "kenyanmusik.co.ke";
                                    "expanded_url" = "http://kenyanmusik.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/YuDKHUoz6e";
                                }
                            );
                        };
                    };
                    "favourites_count" = 21223;
                    "follow_request_sent" = 0;
                    "followers_count" = 135567;
                    following = 0;
                    "friends_count" = 89977;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 2318870107;
                    "id_str" = 2318870107;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 351;
                    location = "Kerugoya Kutus, Kenya";
                    name = Jotham;
                    notifications = 0;
                    "profile_background_color" = 352726;
                    "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_tile" = 1;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2318870107/1518520626";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_link_color" = FF691F;
                    "profile_sidebar_border_color" = 829D5E;
                    "profile_sidebar_fill_color" = 99CC33;
                    "profile_text_color" = 3E4415;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Etoo254;
                    "statuses_count" = 223354;
                    "time_zone" = "Africa/Nairobi";
                    "translator_type" = regular;
                    url = "https://t.co/YuDKHUoz6e";
                    "utc_offset" = 10800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Etoo254: Religious Leaders: Sensitize community members about the dangers of underage pregnancy and \Ufb01ght negative cultural beliefs and\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Jun 02 09:13:56 +0000 2016";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\Ud83d\Udc49The Digital Nomad\Ud83c\Uddf0\Ud83c\Uddea |\U2022| Content Marketing |\U2022| Informaticist |\U2022| Gamer/Tech Enthusiast |\U2022| Ardent Reader |\U2022| Otaku |\U2022|\U260e\Ufe0f0716348259 |\U2022| \Ud83d\Udce9ianphysika@gmail.com";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/100001427364796";
                                "expanded_url" = "https://www.facebook.com/100001427364796";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/kFQzb1qjyj";
                            }
                        );
                    };
                };
                "favourites_count" = 13975;
                "follow_request_sent" = 0;
                "followers_count" = 47692;
                following = 0;
                "friends_count" = 29751;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 738297586109583360;
                "id_str" = 738297586109583360;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 98;
                location = Kenya;
                name = "S\U03b1\U0274c\U0442\U03b9o\U0274ed I\U03b1\U0274 M\U03b1r\U0138";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/738297586109583360/1493474673";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = IanmarkKimani;
                "statuses_count" = 67542;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/kFQzb1qjyj";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:23 +0000 2018";
            entities =             {
                hashtags =                 (
                    {
                        indices =                         (
                            5,
                            28
                        );
                        text = InternationalWomensDay;
                    }
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971632451574489088";
                        indices =                         (
                        114,
                        137
                        );
                        url = "https://t.co/PoMq9LjBSC";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632451574489088;
            "id_str" = 971632451574489088;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "This #InternationalWomensDay , let us pledge to work towards providing quality care for women during 9 months of\U2026 https://t.co/PoMq9LjBSC";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Mon Jun 10 10:15:22 +0000 2013";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Ministry of Health and Family Welfare, Government of India has set up the National Health Portal for single point access of Health Information";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "nhp.gov.in";
                                "expanded_url" = "http://www.nhp.gov.in";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/vmmgLYoGDi";
                            }
                        );
                    };
                };
                "favourites_count" = 7268;
                "follow_request_sent" = 0;
                "followers_count" = 23802;
                following = 0;
                "friends_count" = 232;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 1497890814;
                "id_str" = 1497890814;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 170;
                location = "New Delhi";
                name = "National Health Portal";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/1497890814/1518418457";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/876679325285662721/bhGcfaXx_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/876679325285662721/bhGcfaXx_normal.jpg";
                "profile_link_color" = 83B300;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = NHPINDIA;
                "statuses_count" = 20550;
                "time_zone" = "New Delhi";
                "translator_type" = none;
                url = "https://t.co/vmmgLYoGDi";
                "utc_offset" = 19800;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:03 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 867947619661881344;
                        "id_str" = 867947619661881344;
                        indices =                         (
                            3,
                            14
                        );
                        name = "Dan Siddons";
                        "screen_name" = SiddonsDan;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632370322358276;
            "id_str" = 971632370322358276;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 1983;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 13:06:09 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971371423569760256";
                            indices =                             (
                            116,
                            139
                            );
                            url = "https://t.co/qZPuLAQTai";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 1414;
                favorited = 0;
                geo = "<null>";
                id = 971371423569760256;
                "id_str" = 971371423569760256;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 1;
                "retweet_count" = 1983;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/#!/download/ipad\" rel=\"nofollow\">Twitter for iPad</a>";
                text = "\U201cIn America, children can be legally killed through all nine months of pregnancy, at any time, and for any reason.\U2026 https://t.co/qZPuLAQTai";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Fri May 26 03:36:53 +0000 2017";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "I Support President Donald J. Trump @Trish_Regan @lauraloomer @cvpayne @michellemalkin @katrinapierson @ericbolling @deneenborelli @RealJamesWoods @kelliwardaz";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "kelliward.com";
                                    "expanded_url" = "http://kelliward.com";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/q7wZtK6fua";
                                }
                            );
                        };
                    };
                    "favourites_count" = 156297;
                    "follow_request_sent" = 0;
                    "followers_count" = 67743;
                    following = 0;
                    "friends_count" = 67275;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 0;
                    id = 867947619661881344;
                    "id_str" = 867947619661881344;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 158;
                    location = "Miami FL ";
                    name = "Dan Siddons";
                    notifications = 0;
                    "profile_background_color" = F5F8FA;
                    "profile_background_image_url" = "<null>";
                    "profile_background_image_url_https" = "<null>";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/867947619661881344/1520464459";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/932133290194165760/gKVRr-xH_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/932133290194165760/gKVRr-xH_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = SiddonsDan;
                    "statuses_count" = 176003;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "https://t.co/q7wZtK6fua";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @SiddonsDan: \U201cIn America, children can be legally killed through all nine months of pregnancy, at any time, and for any reason. This vid\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Wed Dec 07 03:27:55 +0000 2016";
                "default_profile" = 1;
                "default_profile_image" = 1;
                description = "";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 12342;
                "follow_request_sent" = 0;
                "followers_count" = 146;
                following = 0;
                "friends_count" = 80;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 806339426288861184;
                "id_str" = 806339426288861184;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 7;
                location = "";
                name = "Susan Simon";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_image_url" = "http://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png";
                "profile_image_url_https" = "https://abs.twimg.com/sticky/default_profile_images/default_profile_normal.png";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = SusanSi23428588;
                "statuses_count" = 16932;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:23:00 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971632355743068160";
                        indices =                         (
                        116,
                        139
                        );
                        url = "https://t.co/CxX5rGliSB";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 1;
            favorited = 0;
            geo = "<null>";
            id = 971632355743068160;
            "id_str" = 971632355743068160;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"https://about.twitter.com/products/tweetdeck\" rel=\"nofollow\">TweetDeck</a>";
            text = "Media: Highlight the impact of teenage pregnancy and amplify voices of stakeholders demanding an end to adolescent\U2026 https://t.co/CxX5rGliSB";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sat Mar 19 09:56:00 +0000 2011";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Writer, photographer and optimist.\nAlways stay gracious, best revenge is your success.";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 10;
                "follow_request_sent" = 0;
                "followers_count" = 931;
                following = 0;
                "friends_count" = 450;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 268719816;
                "id_str" = 268719816;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 22;
                location = "Nairobi,Kenya.";
                name = "Ruby Mungai";
                notifications = 0;
                "profile_background_color" = 131516;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme14/bg.gif";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme14/bg.gif";
                "profile_background_tile" = 1;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/268719816/1449162925";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/700710064428965888/LqrEn_Tu_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/700710064428965888/LqrEn_Tu_normal.jpg";
                "profile_link_color" = 5F3861;
                "profile_sidebar_border_color" = EEEEEE;
                "profile_sidebar_fill_color" = EFEFEF;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "Shiru_Mungai";
                "statuses_count" = 1977;
                "time_zone" = Nairobi;
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = 10800;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:56 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 354203444;
                        "id_str" = 354203444;
                        indices =                         (
                            3,
                            12
                        );
                        name = "CAPT MACHUKA";
                        "screen_name" = Machukah;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632340245065729;
            "id_str" = 971632340245065729;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 4;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:28:20 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971618598560108545";
                            indices =                             (
                            116,
                            139
                            );
                            url = "https://t.co/p2n33P8eDm";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 5;
                favorited = 0;
                geo = "<null>";
                id = 971618598560108545;
                "id_str" = 971618598560108545;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 4;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Create time to talk to your children or get someone to talk to them about sex issues and the consequences of early\U2026 https://t.co/p2n33P8eDm";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Sat Aug 13 09:23:57 +0000 2011";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "A Social Journalist |:| Entrepreneur |:| Activist Of Truth And Democracy |:| An Influencer |:| GOD FIRST |:|";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "machuka.co.ke";
                                    "expanded_url" = "http://machuka.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/PmZIwPWWXh";
                                }
                            );
                        };
                    };
                    "favourites_count" = 94443;
                    "follow_request_sent" = 0;
                    "followers_count" = 142720;
                    following = 0;
                    "friends_count" = 49695;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 354203444;
                    "id_str" = 354203444;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 200;
                    location = "Mombasa, Kenya";
                    name = "CAPT MACHUKA";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/354203444/1518777237";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/964448027363733505/f5W7xSjX_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/964448027363733505/f5W7xSjX_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Machukah;
                    "statuses_count" = 167457;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "https://t.co/PmZIwPWWXh";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Machukah: Create time to talk to your children or get someone to talk to them about sex issues and the consequences of early sex and pr\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Jun 02 09:13:56 +0000 2016";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\Ud83d\Udc49The Digital Nomad\Ud83c\Uddf0\Ud83c\Uddea |\U2022| Content Marketing |\U2022| Informaticist |\U2022| Gamer/Tech Enthusiast |\U2022| Ardent Reader |\U2022| Otaku |\U2022|\U260e\Ufe0f0716348259 |\U2022| \Ud83d\Udce9ianphysika@gmail.com";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/100001427364796";
                                "expanded_url" = "https://www.facebook.com/100001427364796";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/kFQzb1qjyj";
                            }
                        );
                    };
                };
                "favourites_count" = 13975;
                "follow_request_sent" = 0;
                "followers_count" = 47692;
                following = 0;
                "friends_count" = 29751;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 738297586109583360;
                "id_str" = 738297586109583360;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 98;
                location = Kenya;
                name = "S\U03b1\U0274c\U0442\U03b9o\U0274ed I\U03b1\U0274 M\U03b1r\U0138";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/738297586109583360/1493474673";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = IanmarkKimani;
                "statuses_count" = 67542;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/kFQzb1qjyj";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:49 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 354203444;
                        "id_str" = 354203444;
                        indices =                         (
                            3,
                            12
                        );
                        name = "CAPT MACHUKA";
                        "screen_name" = Machukah;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632309203099649;
            "id_str" = 971632309203099649;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 6;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:29:09 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971618806358560769";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/rohkgBq5oW";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 8;
                favorited = 0;
                geo = "<null>";
                id = 971618806358560769;
                "id_str" = 971618806358560769;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 6;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Remember, unprotected sex puts you at risk of STIs/HIVs and pregnancy, resulting in childbirth or unsafe abortions,\U2026 https://t.co/rohkgBq5oW";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Sat Aug 13 09:23:57 +0000 2011";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "A Social Journalist |:| Entrepreneur |:| Activist Of Truth And Democracy |:| An Influencer |:| GOD FIRST |:|";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "machuka.co.ke";
                                    "expanded_url" = "http://machuka.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/PmZIwPWWXh";
                                }
                            );
                        };
                    };
                    "favourites_count" = 94443;
                    "follow_request_sent" = 0;
                    "followers_count" = 142720;
                    following = 0;
                    "friends_count" = 49695;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 354203444;
                    "id_str" = 354203444;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 200;
                    location = "Mombasa, Kenya";
                    name = "CAPT MACHUKA";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/354203444/1518777237";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/964448027363733505/f5W7xSjX_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/964448027363733505/f5W7xSjX_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Machukah;
                    "statuses_count" = 167457;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "https://t.co/PmZIwPWWXh";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Machukah: Remember, unprotected sex puts you at risk of STIs/HIVs and pregnancy, resulting in childbirth or unsafe abortions, which can\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Jun 02 09:13:56 +0000 2016";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\Ud83d\Udc49The Digital Nomad\Ud83c\Uddf0\Ud83c\Uddea |\U2022| Content Marketing |\U2022| Informaticist |\U2022| Gamer/Tech Enthusiast |\U2022| Ardent Reader |\U2022| Otaku |\U2022|\U260e\Ufe0f0716348259 |\U2022| \Ud83d\Udce9ianphysika@gmail.com";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/100001427364796";
                                "expanded_url" = "https://www.facebook.com/100001427364796";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/kFQzb1qjyj";
                            }
                        );
                    };
                };
                "favourites_count" = 13975;
                "follow_request_sent" = 0;
                "followers_count" = 47692;
                following = 0;
                "friends_count" = 29751;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 738297586109583360;
                "id_str" = 738297586109583360;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 98;
                location = Kenya;
                name = "S\U03b1\U0274c\U0442\U03b9o\U0274ed I\U03b1\U0274 M\U03b1r\U0138";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/738297586109583360/1493474673";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = IanmarkKimani;
                "statuses_count" = 67542;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/kFQzb1qjyj";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:44 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 2318870107;
                        "id_str" = 2318870107;
                        indices =                         (
                            3,
                            11
                        );
                        name = Jotham;
                        "screen_name" = Etoo254;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632287631671296;
            "id_str" = 971632287631671296;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 2;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:14:36 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971615145075138560";
                            indices =                             (
                            116,
                            139
                            );
                            url = "https://t.co/h3G0hMVebm";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 1;
                favorited = 0;
                geo = "<null>";
                id = 971615145075138560;
                "id_str" = 971615145075138560;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 2;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Create time to talk to your children or get someone to talk to them about sex issues and the consequences of early\U2026 https://t.co/h3G0hMVebm";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Thu Jan 30 13:04:50 +0000 2014";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Marketer \Ud83d\Udd4e |  Growth Hacker \Ud83c\Udf3f | Award Winning Blogger \Ud83c\Udfc5\Ud83c\Udfc6| Download  @MOMBO_App  \Ud83c\Udfe7 | Music \Ud83c\Udfbc ,  Events  & Dining \Ud83c\Udf79 | 0703269969 |  jmumina13@gmail.com |";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "kenyanmusik.co.ke";
                                    "expanded_url" = "http://kenyanmusik.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/YuDKHUoz6e";
                                }
                            );
                        };
                    };
                    "favourites_count" = 21223;
                    "follow_request_sent" = 0;
                    "followers_count" = 135567;
                    following = 0;
                    "friends_count" = 89977;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 2318870107;
                    "id_str" = 2318870107;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 351;
                    location = "Kerugoya Kutus, Kenya";
                    name = Jotham;
                    notifications = 0;
                    "profile_background_color" = 352726;
                    "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_tile" = 1;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2318870107/1518520626";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_link_color" = FF691F;
                    "profile_sidebar_border_color" = 829D5E;
                    "profile_sidebar_fill_color" = 99CC33;
                    "profile_text_color" = 3E4415;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Etoo254;
                    "statuses_count" = 223354;
                    "time_zone" = "Africa/Nairobi";
                    "translator_type" = regular;
                    url = "https://t.co/YuDKHUoz6e";
                    "utc_offset" = 10800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Etoo254: Create time to talk to your children or get someone to talk to them about sex issues and the consequences of early sex and pre\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sat Feb 25 16:05:37 +0000 2017";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "#TMP_Video Editor/Badguy/Chelsea Fc Freak/Medikal #1 Fan/Rap and Music Lover/#1 Worlds Problem/the whole lot!";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 1118;
                "follow_request_sent" = 0;
                "followers_count" = 132;
                following = 0;
                "friends_count" = 366;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 835521137610272768;
                "id_str" = 835521137610272768;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "Tamale, Ghana";
                name = "Son Of Tamale \Ud83d\Udcaa\Ud83d\Udd25";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/835521137610272768/1488198862";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/961182667466313728/X4ROlWiY_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/961182667466313728/X4ROlWiY_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = OJjnr12;
                "statuses_count" = 626;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:43 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 939674116700934144;
                        "id_str" = 939674116700934144;
                        indices =                         (
                            3,
                            19
                        );
                        name = "\Ud835\Udceb\Ud835\Udcf8\Ud835\Udcfc\Ud835\Udcfc-\Ud835\Udcf6\U2741\Ud835\Udcf6\Ud835\Udcf6\Ud835\Udcea";
                        "screen_name" = "mothering_a_boy";
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632284662157313;
            "id_str" = 971632284662157313;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 348;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 10:16:40 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971328771952398336";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/0WTedckLFC";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 477;
                favorited = 0;
                geo = "<null>";
                id = 971328771952398336;
                "id_str" = 971328771952398336;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 348;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
                text = "with April fools right around the corner- PREGNANCY IS NOT AN APRIL FOOLS JOKE PREGNANCY IS NOT AN APRIL FOOLS JOKE\U2026 https://t.co/0WTedckLFC";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Sun Dec 10 01:52:22 +0000 2017";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "\Ud835\Udfda\Ud835\Udfd8 \Ud835\Udd6a\Ud835\Udd63 \Ud835\Udd60\Ud835\Udd5d\Ud835\Udd55 \Ud835\Udd2a\Ud835\Udd2c\Ud835\Udd2a\Ud835\Udd1f\Ud835\Udd26\Ud835\Udd22\Ud83e\Udddf\U200d\U2640\Ufe0f \Ud835\Udd5e\Ud835\Udd60\Ud835\Udd5e\Ud835\Udd5e\Ud835\Udd5a\Ud835\Udd5f\U2019 \Ud835\Udd5d\Ud835\Udd5a\Ud835\Udd5c\Ud835\Udd56 \Ud835\Udd52 \Ud835\Udd53\Ud835\Udd60\Ud835\Udd64\Ud835\Udd64\Ud83e\Udd31\Ud83c\Udffb \Ud835\Udd5a\Ud835\Udd5f \Ud835\Udd5d\Ud835\Udd60\Ud835\Udd67\Ud835\Udd56 \Ud835\Udd68\Ud835\Udd5a\Ud835\Udd65\Ud835\Udd59 \Ud835\Udd59\Ud835\Udd5a\Ud835\Udd64 \Ud835\Udd55\Ud835\Udd52\Ud835\Udd55\Ud835\Udd55\Ud835\Udd6a\Ud83d\Udc8d";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                    };
                    "favourites_count" = 4028;
                    "follow_request_sent" = 0;
                    "followers_count" = 978;
                    following = 0;
                    "friends_count" = 1281;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 0;
                    id = 939674116700934144;
                    "id_str" = 939674116700934144;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 2;
                    location = "United States";
                    name = "\Ud835\Udceb\Ud835\Udcf8\Ud835\Udcfc\Ud835\Udcfc-\Ud835\Udcf6\U2741\Ud835\Udcf6\Ud835\Udcf6\Ud835\Udcea";
                    notifications = 0;
                    "profile_background_color" = F5F8FA;
                    "profile_background_image_url" = "<null>";
                    "profile_background_image_url_https" = "<null>";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/939674116700934144/1519690803";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/968568308508307457/cnkwLzbf_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968568308508307457/cnkwLzbf_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = "mothering_a_boy";
                    "statuses_count" = 2541;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "<null>";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @mothering_a_boy: with April fools right around the corner- PREGNANCY IS NOT AN APRIL FOOLS JOKE PREGNANCY IS NOT AN APRIL FOOLS JOKE PR\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sun Jun 12 20:16:34 +0000 2016";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "redeemed\U271d\Ufe0f| mom\Ud83d\Udc18| wifey\Ud83d\Udc8d| wine\Ud83c\Udf77| auntie\Ud83e\Udd84| daughter && sister\Ud83d\Udc51| dog mom\Ud83d\Udc3e| FEARLESS\Ud83e\Udd8b |";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "instagram.com/_mrseakin_";
                                "expanded_url" = "http://instagram.com/_mrseakin_";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/igCFE7LXpK";
                            }
                        );
                    };
                };
                "favourites_count" = 14397;
                "follow_request_sent" = 0;
                "followers_count" = 535;
                following = 0;
                "friends_count" = 462;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 742088222818193409;
                "id_str" = 742088222818193409;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 8;
                location = "Texas, USA";
                name = "Mama Mae\Ud83c\Udf35";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/742088222818193409/1519711469";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968365362248110082/RwoZfwc7_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968365362248110082/RwoZfwc7_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "_mrseakin_";
                "statuses_count" = 9824;
                "time_zone" = "Pacific Time (US & Canada)";
                "translator_type" = none;
                url = "https://t.co/igCFE7LXpK";
                "utc_offset" = "-28800";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:42 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 354203444;
                        "id_str" = 354203444;
                        indices =                         (
                            3,
                            12
                        );
                        name = "CAPT MACHUKA";
                        "screen_name" = Machukah;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632281935925248;
            "id_str" = 971632281935925248;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 4;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:29:58 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971619010872737792";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/FYuhdvAPy4";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 1;
                favorited = 0;
                geo = "<null>";
                id = 971619010872737792;
                "id_str" = 971619010872737792;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 4;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "CSOs and Donors: Support and implement projects aimed at advocating for an end to adolescent pregnancy and accounta\U2026 https://t.co/FYuhdvAPy4";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Sat Aug 13 09:23:57 +0000 2011";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "A Social Journalist |:| Entrepreneur |:| Activist Of Truth And Democracy |:| An Influencer |:| GOD FIRST |:|";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "machuka.co.ke";
                                    "expanded_url" = "http://machuka.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/PmZIwPWWXh";
                                }
                            );
                        };
                    };
                    "favourites_count" = 94443;
                    "follow_request_sent" = 0;
                    "followers_count" = 142720;
                    following = 0;
                    "friends_count" = 49695;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 354203444;
                    "id_str" = 354203444;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 200;
                    location = "Mombasa, Kenya";
                    name = "CAPT MACHUKA";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/354203444/1518777237";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/964448027363733505/f5W7xSjX_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/964448027363733505/f5W7xSjX_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Machukah;
                    "statuses_count" = 167457;
                    "time_zone" = "<null>";
                    "translator_type" = none;
                    url = "https://t.co/PmZIwPWWXh";
                    "utc_offset" = "<null>";
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Machukah: CSOs and Donors: Support and implement projects aimed at advocating for an end to adolescent pregnancy and accountability for\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Jun 02 09:13:56 +0000 2016";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\Ud83d\Udc49The Digital Nomad\Ud83c\Uddf0\Ud83c\Uddea |\U2022| Content Marketing |\U2022| Informaticist |\U2022| Gamer/Tech Enthusiast |\U2022| Ardent Reader |\U2022| Otaku |\U2022|\U260e\Ufe0f0716348259 |\U2022| \Ud83d\Udce9ianphysika@gmail.com";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/100001427364796";
                                "expanded_url" = "https://www.facebook.com/100001427364796";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/kFQzb1qjyj";
                            }
                        );
                    };
                };
                "favourites_count" = 13975;
                "follow_request_sent" = 0;
                "followers_count" = 47692;
                following = 0;
                "friends_count" = 29751;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 738297586109583360;
                "id_str" = 738297586109583360;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 98;
                location = Kenya;
                name = "S\U03b1\U0274c\U0442\U03b9o\U0274ed I\U03b1\U0274 M\U03b1r\U0138";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/738297586109583360/1493474673";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = IanmarkKimani;
                "statuses_count" = 67542;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/kFQzb1qjyj";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:35 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971632253129383936";
                        indices =                         (
                        116,
                        139
                        );
                        url = "https://t.co/nCdlrIUaYn";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632253129383936;
            "id_str" = 971632253129383936;
            "in_reply_to_screen_name" = praveenbpatil5;
            "in_reply_to_status_id" = 971632250637910016;
            "in_reply_to_status_id_str" = 971632250637910016;
            "in_reply_to_user_id" = 898464658666905600;
            "in_reply_to_user_id_str" = 898464658666905600;
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
            text = "Here is my gift to Women on Women's day.\nYour weight gain post delivery or complications during pregnancy or other\U2026 https://t.co/nCdlrIUaYn";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Fri Aug 18 08:40:42 +0000 2017";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Sometimes Solutions are too simple just try it";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "medium.com/@praveenbpatil5";
                                "expanded_url" = "https://medium.com/@praveenbpatil5";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/u2sFD5Br56";
                            }
                        );
                    };
                };
                "favourites_count" = 0;
                "follow_request_sent" = 0;
                "followers_count" = 10;
                following = 0;
                "friends_count" = 256;
                "geo_enabled" = 0;
                "has_extended_profile" = 0;
                id = 898464658666905600;
                "id_str" = 898464658666905600;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "Bengaluru, India";
                name = "Praveen Patil";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_image_url" = "http://pbs.twimg.com/profile_images/904318056645648385/L8XG3DXE_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/904318056645648385/L8XG3DXE_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = praveenbpatil5;
                "statuses_count" = 126;
                "time_zone" = "New Delhi";
                "translator_type" = none;
                url = "https://t.co/u2sFD5Br56";
                "utc_offset" = 19800;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:26 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 2318870107;
                        "id_str" = 2318870107;
                        indices =                         (
                            3,
                            11
                        );
                        name = Jotham;
                        "screen_name" = Etoo254;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632213287727104;
            "id_str" = 971632213287727104;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 3;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:32:50 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971619730112073729";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/r97w6gPCRr";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 1;
                favorited = 0;
                geo = "<null>";
                id = 971619730112073729;
                "id_str" = 971619730112073729;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 3;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "This IWD 2018, we are calling on Parents/Management to create time to talk to their children or get someone to talk\U2026 https://t.co/r97w6gPCRr";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Thu Jan 30 13:04:50 +0000 2014";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Marketer \Ud83d\Udd4e |  Growth Hacker \Ud83c\Udf3f | Award Winning Blogger \Ud83c\Udfc5\Ud83c\Udfc6| Download  @MOMBO_App  \Ud83c\Udfe7 | Music \Ud83c\Udfbc ,  Events  & Dining \Ud83c\Udf79 | 0703269969 |  jmumina13@gmail.com |";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "kenyanmusik.co.ke";
                                    "expanded_url" = "http://kenyanmusik.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/YuDKHUoz6e";
                                }
                            );
                        };
                    };
                    "favourites_count" = 21223;
                    "follow_request_sent" = 0;
                    "followers_count" = 135567;
                    following = 0;
                    "friends_count" = 89977;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 2318870107;
                    "id_str" = 2318870107;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 351;
                    location = "Kerugoya Kutus, Kenya";
                    name = Jotham;
                    notifications = 0;
                    "profile_background_color" = 352726;
                    "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_tile" = 1;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2318870107/1518520626";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_link_color" = FF691F;
                    "profile_sidebar_border_color" = 829D5E;
                    "profile_sidebar_fill_color" = 99CC33;
                    "profile_text_color" = 3E4415;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Etoo254;
                    "statuses_count" = 223354;
                    "time_zone" = "Africa/Nairobi";
                    "translator_type" = regular;
                    url = "https://t.co/YuDKHUoz6e";
                    "utc_offset" = 10800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Etoo254: This IWD 2018, we are calling on Parents/Management to create time to talk to their children or get someone to talk to them ab\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Jun 02 09:13:56 +0000 2016";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\Ud83d\Udc49The Digital Nomad\Ud83c\Uddf0\Ud83c\Uddea |\U2022| Content Marketing |\U2022| Informaticist |\U2022| Gamer/Tech Enthusiast |\U2022| Ardent Reader |\U2022| Otaku |\U2022|\U260e\Ufe0f0716348259 |\U2022| \Ud83d\Udce9ianphysika@gmail.com";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/100001427364796";
                                "expanded_url" = "https://www.facebook.com/100001427364796";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/kFQzb1qjyj";
                            }
                        );
                    };
                };
                "favourites_count" = 13975;
                "follow_request_sent" = 0;
                "followers_count" = 47692;
                following = 0;
                "friends_count" = 29751;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 738297586109583360;
                "id_str" = 738297586109583360;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 98;
                location = Kenya;
                name = "S\U03b1\U0274c\U0442\U03b9o\U0274ed I\U03b1\U0274 M\U03b1r\U0138";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/738297586109583360/1493474673";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = IanmarkKimani;
                "statuses_count" = 67542;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/kFQzb1qjyj";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:23 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "fb.me/1Qe88wRGV";
                        "expanded_url" = "https://fb.me/1Qe88wRGV";
                        indices =                         (
                            69,
                            92
                        );
                        url = "https://t.co/hUuP9NviaR";
                    }
                );
                "user_mentions" =                 (
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632201405263872;
            "id_str" = 971632201405263872;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"http://www.facebook.com/twitter\" rel=\"nofollow\">Facebook</a>";
            text = "A local reader gives her view about the high teenage pregnancy rates https://t.co/hUuP9NviaR";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Tue Mar 27 12:18:30 +0000 2012";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "Looklocal Tzaneen and Surrounds is your daily online community newspaper. BBM 29C63BFB. 0153075050.";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "bit.ly/looklocaltzane\U2026";
                                "expanded_url" = "http://bit.ly/looklocaltzaneen";
                                indices =                                 (
                                0,
                                22
                                );
                                url = "http://t.co/GnslJ5sH3w";
                            }
                        );
                    };
                };
                "favourites_count" = 0;
                "follow_request_sent" = 0;
                "followers_count" = 1305;
                following = 0;
                "friends_count" = 989;
                "geo_enabled" = 1;
                "has_extended_profile" = 0;
                id = 538198290;
                "id_str" = 538198290;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 6;
                location = Tzaneen;
                name = looktzaneen;
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/581976319/xd8ed76889b90b79be980a345baa0c26.jpg";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/581976319/xd8ed76889b90b79be980a345baa0c26.jpg";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/538198290/1369125745";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/2881092398/10641856af816d343389e5cfcd2b1541_normal.jpeg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/2881092398/10641856af816d343389e5cfcd2b1541_normal.jpeg";
                "profile_link_color" = 485C3A;
                "profile_sidebar_border_color" = 204207;
                "profile_sidebar_fill_color" = 060A00;
                "profile_text_color" = 618238;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = looktzaneen;
                "statuses_count" = 13431;
                "time_zone" = Athens;
                "translator_type" = none;
                url = "http://t.co/GnslJ5sH3w";
                "utc_offset" = 7200;
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:23 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                media =                 (
                    {
                        "display_url" = "pic.twitter.com/PxsbTOYUhP";
                        "expanded_url" = "https://twitter.com/TheMedicalVids/status/971582011684065280/video/1";
                        id = 971580972587249669;
                        "id_str" = 971580972587249669;
                        indices =                         (
                            60,
                            83
                        );
                        "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                        "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                        sizes =                         {
                            large =                             {
                                h = 360;
                                resize = fit;
                                w = 640;
                            };
                            medium =                             {
                                h = 360;
                                resize = fit;
                                w = 640;
                            };
                            small =                             {
                                h = 360;
                                resize = fit;
                                w = 640;
                            };
                            thumb =                             {
                                h = 150;
                                resize = crop;
                                w = 150;
                            };
                        };
                        "source_status_id" = 971582011684065280;
                        "source_status_id_str" = 971582011684065280;
                        "source_user_id" = 3239969270;
                        "source_user_id_str" = 3239969270;
                        type = photo;
                        url = "https://t.co/PxsbTOYUhP";
                    }
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 3239969270;
                        "id_str" = 3239969270;
                        indices =                         (
                            3,
                            18
                        );
                        name = "Medical Vids\U2695\Ufe0f";
                        "screen_name" = TheMedicalVids;
                    }
                );
            };
            "extended_entities" =             {
                media =                 (
                    {
                        "additional_media_info" =                         {
                            monetizable = 0;
                            "source_user" =                             {
                                "contributors_enabled" = 0;
                                "created_at" = "Mon Jun 08 14:33:21 +0000 2015";
                                "default_profile" = 1;
                                "default_profile_image" = 0;
                                description = "Posting Medical & Health Videos(18+).(parody)";
                                entities =                                 {
                                    description =                                     {
                                        urls =                                         (
                                        );
                                    };
                                };
                                "favourites_count" = 847;
                                "follow_request_sent" = 0;
                                "followers_count" = 508896;
                                following = 0;
                                "friends_count" = 182;
                                "geo_enabled" = 0;
                                "has_extended_profile" = 0;
                                id = 3239969270;
                                "id_str" = 3239969270;
                                "is_translation_enabled" = 0;
                                "is_translator" = 0;
                                lang = en;
                                "listed_count" = 502;
                                location = "turn my post notification on.";
                                name = "Medical Vids\U2695\Ufe0f";
                                notifications = 0;
                                "profile_background_color" = C0DEED;
                                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                                "profile_background_tile" = 0;
                                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3239969270/1499021033";
                                "profile_image_url" = "http://pbs.twimg.com/profile_images/881584217653616640/ljRx-zm5_normal.jpg";
                                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/881584217653616640/ljRx-zm5_normal.jpg";
                                "profile_link_color" = 1DA1F2;
                                "profile_sidebar_border_color" = C0DEED;
                                "profile_sidebar_fill_color" = DDEEF6;
                                "profile_text_color" = 333333;
                                "profile_use_background_image" = 1;
                                protected = 0;
                                "screen_name" = TheMedicalVids;
                                "statuses_count" = 2089;
                                "time_zone" = "Asia/Kolkata";
                                "translator_type" = none;
                                url = "<null>";
                                "utc_offset" = 19800;
                                verified = 0;
                            };
                        };
                        "display_url" = "pic.twitter.com/PxsbTOYUhP";
                        "expanded_url" = "https://twitter.com/TheMedicalVids/status/971582011684065280/video/1";
                        id = 971580972587249669;
                        "id_str" = 971580972587249669;
                        indices =                         (
                            60,
                            83
                        );
                        "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                        "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                        sizes =                         {
                            large =                             {
                                h = 360;
                                resize = fit;
                                w = 640;
                            };
                            medium =                             {
                                h = 360;
                                resize = fit;
                                w = 640;
                            };
                            small =                             {
                                h = 360;
                                resize = fit;
                                w = 640;
                            };
                            thumb =                             {
                                h = 150;
                                resize = crop;
                                w = 150;
                            };
                        };
                        "source_status_id" = 971582011684065280;
                        "source_status_id_str" = 971582011684065280;
                        "source_user_id" = 3239969270;
                        "source_user_id_str" = 3239969270;
                        type = video;
                        url = "https://t.co/PxsbTOYUhP";
                        "video_info" =                         {
                            "aspect_ratio" =                             (
                                16,
                                9
                            );
                            "duration_millis" = 53687;
                            variants =                             (
                                {
                                    bitrate = 256000;
                                    "content_type" = "video/mp4";
                                    url = "https://video.twimg.com/ext_tw_video/971580972587249669/pu/vid/320x180/KIp1gzqxhEbTg4nx.mp4";
                            },
                                {
                                    bitrate = 832000;
                                    "content_type" = "video/mp4";
                                    url = "https://video.twimg.com/ext_tw_video/971580972587249669/pu/vid/640x360/a71xKwgWpCOqUqv9.mp4";
                            },
                                {
                                    "content_type" = "application/x-mpegURL";
                                    url = "https://video.twimg.com/ext_tw_video/971580972587249669/pu/pl/5oXH54Z-K7KFM42A.m3u8";
                            }
                            );
                        };
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632199664578561;
            "id_str" = 971632199664578561;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "possibly_sensitive" = 0;
            "retweet_count" = 312;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 03:02:57 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    media =                     (
                        {
                            "display_url" = "pic.twitter.com/PxsbTOYUhP";
                            "expanded_url" = "https://twitter.com/TheMedicalVids/status/971582011684065280/video/1";
                            id = 971580972587249669;
                            "id_str" = 971580972587249669;
                            indices =                             (
                                40,
                                63
                            );
                            "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                            "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                            sizes =                             {
                                large =                                 {
                                    h = 360;
                                    resize = fit;
                                    w = 640;
                                };
                                medium =                                 {
                                    h = 360;
                                    resize = fit;
                                    w = 640;
                                };
                                small =                                 {
                                    h = 360;
                                    resize = fit;
                                    w = 640;
                                };
                                thumb =                                 {
                                    h = 150;
                                    resize = crop;
                                    w = 150;
                                };
                            };
                            type = photo;
                            url = "https://t.co/PxsbTOYUhP";
                        }
                    );
                    symbols =                     (
                    );
                    urls =                     (
                    );
                    "user_mentions" =                     (
                    );
                };
                "extended_entities" =                 {
                    media =                     (
                        {
                            "additional_media_info" =                             {
                                monetizable = 0;
                            };
                            "display_url" = "pic.twitter.com/PxsbTOYUhP";
                            "expanded_url" = "https://twitter.com/TheMedicalVids/status/971582011684065280/video/1";
                            id = 971580972587249669;
                            "id_str" = 971580972587249669;
                            indices =                             (
                                40,
                                63
                            );
                            "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                            "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
                            sizes =                             {
                                large =                                 {
                                    h = 360;
                                    resize = fit;
                                    w = 640;
                                };
                                medium =                                 {
                                    h = 360;
                                    resize = fit;
                                    w = 640;
                                };
                                small =                                 {
                                    h = 360;
                                    resize = fit;
                                    w = 640;
                                };
                                thumb =                                 {
                                    h = 150;
                                    resize = crop;
                                    w = 150;
                                };
                            };
                            type = video;
                            url = "https://t.co/PxsbTOYUhP";
                            "video_info" =                             {
                                "aspect_ratio" =                                 (
                                    16,
                                    9
                                );
                                "duration_millis" = 53687;
                                variants =                                 (
                                    {
                                        bitrate = 256000;
                                        "content_type" = "video/mp4";
                                        url = "https://video.twimg.com/ext_tw_video/971580972587249669/pu/vid/320x180/KIp1gzqxhEbTg4nx.mp4";
                                },
                                    {
                                        bitrate = 832000;
                                        "content_type" = "video/mp4";
                                        url = "https://video.twimg.com/ext_tw_video/971580972587249669/pu/vid/640x360/a71xKwgWpCOqUqv9.mp4";
                                },
                                    {
                                        "content_type" = "application/x-mpegURL";
                                        url = "https://video.twimg.com/ext_tw_video/971580972587249669/pu/pl/5oXH54Z-K7KFM42A.m3u8";
                                }
                                );
                            };
                        }
                    );
                };
                "favorite_count" = 594;
                favorited = 0;
                geo = "<null>";
                id = 971582011684065280;
                "id_str" = 971582011684065280;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 1;
                "retweet_count" = 312;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Ectopic Pregnancy Baby Abortion Surgery https://t.co/PxsbTOYUhP";
                truncated = 0;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Mon Jun 08 14:33:21 +0000 2015";
                    "default_profile" = 1;
                    "default_profile_image" = 0;
                    description = "Posting Medical & Health Videos(18+).(parody)";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                    };
                    "favourites_count" = 847;
                    "follow_request_sent" = 0;
                    "followers_count" = 508896;
                    following = 0;
                    "friends_count" = 182;
                    "geo_enabled" = 0;
                    "has_extended_profile" = 0;
                    id = 3239969270;
                    "id_str" = 3239969270;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 502;
                    location = "turn my post notification on.";
                    name = "Medical Vids\U2695\Ufe0f";
                    notifications = 0;
                    "profile_background_color" = C0DEED;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3239969270/1499021033";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/881584217653616640/ljRx-zm5_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/881584217653616640/ljRx-zm5_normal.jpg";
                    "profile_link_color" = 1DA1F2;
                    "profile_sidebar_border_color" = C0DEED;
                    "profile_sidebar_fill_color" = DDEEF6;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = TheMedicalVids;
                    "statuses_count" = 2089;
                    "time_zone" = "Asia/Kolkata";
                    "translator_type" = none;
                    url = "<null>";
                    "utc_offset" = 19800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @TheMedicalVids: Ectopic Pregnancy Baby Abortion Surgery https://t.co/PxsbTOYUhP";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Sat Jun 08 03:36:56 +0000 2013";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "negra mi alma, negro mi coraz\U00f3n. ||snap: Camibulfar0";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/camii.bulfaro";
                                "expanded_url" = "http://www.facebook.com/camii.bulfaro";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/azYm9VZVgj";
                            }
                        );
                    };
                };
                "favourites_count" = 10699;
                "follow_request_sent" = 0;
                "followers_count" = 763;
                following = 0;
                "friends_count" = 1636;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 1491914851;
                "id_str" = 1491914851;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = es;
                "listed_count" = 2;
                location = ARG;
                name = "feminasty\Ud83c\Udf39";
                notifications = 0;
                "profile_background_color" = 022330;
                "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/596436418550870016/mR2DdFuB.png";
                "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/596436418550870016/mR2DdFuB.png";
                "profile_background_tile" = 1;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/1491914851/1501643819";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/971446802808533002/RY1mfsj-_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/971446802808533002/RY1mfsj-_normal.jpg";
                "profile_link_color" = FA743E;
                "profile_sidebar_border_color" = FFFFFF;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = "_Bulfar0";
                "statuses_count" = 24305;
                "time_zone" = "Mexico City";
                "translator_type" = regular;
                url = "https://t.co/azYm9VZVgj";
                "utc_offset" = "-21600";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:20 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 2318870107;
                        "id_str" = 2318870107;
                        indices =                         (
                            3,
                            11
                        );
                        name = Jotham;
                        "screen_name" = Etoo254;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632190084845568;
            "id_str" = 971632190084845568;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 4;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Thu Mar 08 05:33:42 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971619950971510784";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/LadtAz3EMT";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 2;
                favorited = 0;
                geo = "<null>";
                id = 971619950971510784;
                "id_str" = 971619950971510784;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "retweet_count" = 4;
                retweeted = 0;
                source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
                text = "Remember, unprotected sex puts you at risk of STIs/HIVs and pregnancy, resulting in childbirth or unsafe abortions,\U2026 https://t.co/LadtAz3EMT";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Thu Jan 30 13:04:50 +0000 2014";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "Marketer \Ud83d\Udd4e |  Growth Hacker \Ud83c\Udf3f | Award Winning Blogger \Ud83c\Udfc5\Ud83c\Udfc6| Download  @MOMBO_App  \Ud83c\Udfe7 | Music \Ud83c\Udfbc ,  Events  & Dining \Ud83c\Udf79 | 0703269969 |  jmumina13@gmail.com |";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "kenyanmusik.co.ke";
                                    "expanded_url" = "http://kenyanmusik.co.ke";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/YuDKHUoz6e";
                                }
                            );
                        };
                    };
                    "favourites_count" = 21223;
                    "follow_request_sent" = 0;
                    "followers_count" = 135567;
                    following = 0;
                    "friends_count" = 89977;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 1;
                    id = 2318870107;
                    "id_str" = 2318870107;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 351;
                    location = "Kerugoya Kutus, Kenya";
                    name = Jotham;
                    notifications = 0;
                    "profile_background_color" = 352726;
                    "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/578935788194258944/m918NuYB.jpeg";
                    "profile_background_tile" = 1;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2318870107/1518520626";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/967280694283132928/qFEkuQHI_normal.jpg";
                    "profile_link_color" = FF691F;
                    "profile_sidebar_border_color" = 829D5E;
                    "profile_sidebar_fill_color" = 99CC33;
                    "profile_text_color" = 3E4415;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = Etoo254;
                    "statuses_count" = 223354;
                    "time_zone" = "Africa/Nairobi";
                    "translator_type" = regular;
                    url = "https://t.co/YuDKHUoz6e";
                    "utc_offset" = 10800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @Etoo254: Remember, unprotected sex puts you at risk of STIs/HIVs and pregnancy, resulting in childbirth or unsafe abortions, which can\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Thu Jun 02 09:13:56 +0000 2016";
                "default_profile" = 0;
                "default_profile_image" = 0;
                description = "\Ud83d\Udc49The Digital Nomad\Ud83c\Uddf0\Ud83c\Uddea |\U2022| Content Marketing |\U2022| Informaticist |\U2022| Gamer/Tech Enthusiast |\U2022| Ardent Reader |\U2022| Otaku |\U2022|\U260e\Ufe0f0716348259 |\U2022| \Ud83d\Udce9ianphysika@gmail.com";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                    url =                     {
                        urls =                         (
                            {
                                "display_url" = "facebook.com/100001427364796";
                                "expanded_url" = "https://www.facebook.com/100001427364796";
                                indices =                                 (
                                    0,
                                    23
                                );
                                url = "https://t.co/kFQzb1qjyj";
                            }
                        );
                    };
                };
                "favourites_count" = 13975;
                "follow_request_sent" = 0;
                "followers_count" = 47692;
                following = 0;
                "friends_count" = 29751;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 738297586109583360;
                "id_str" = 738297586109583360;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 98;
                location = Kenya;
                name = "S\U03b1\U0274c\U0442\U03b9o\U0274ed I\U03b1\U0274 M\U03b1r\U0138";
                notifications = 0;
                "profile_background_color" = 000000;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/738297586109583360/1493474673";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/968738860804005889/5eBYPrv5_normal.jpg";
                "profile_link_color" = 19CF86;
                "profile_sidebar_border_color" = 000000;
                "profile_sidebar_fill_color" = 000000;
                "profile_text_color" = 000000;
                "profile_use_background_image" = 0;
                protected = 0;
                "screen_name" = IanmarkKimani;
                "statuses_count" = 67542;
                "time_zone" = "<null>";
                "translator_type" = none;
                url = "https://t.co/kFQzb1qjyj";
                "utc_offset" = "<null>";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:13 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                    {
                        "display_url" = "twitter.com/i/web/status/9\U2026";
                        "expanded_url" = "https://twitter.com/i/web/status/971632158908604417";
                        indices =                         (
                        117,
                        140
                        );
                        url = "https://t.co/oSZg3alKiE";
                    }
                );
                "user_mentions" =                 (
                    {
                        id = 32959253;
                        "id_str" = 32959253;
                        indices =                         (
                            0,
                            16
                        );
                        name = "Khlo\U00e9";
                        "screen_name" = khloekardashian;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632158908604417;
            "id_str" = 971632158908604417;
            "in_reply_to_screen_name" = khloekardashian;
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = 32959253;
            "in_reply_to_user_id_str" = 32959253;
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 0;
            retweeted = 0;
            source = "<a href=\"https://mobile.twitter.com\" rel=\"nofollow\">Twitter Lite</a>";
            text = "@khloekardashian Hello I am a big fan of yours and I would love to tell you a story. If you ever accept it would me\U2026 https://t.co/oSZg3alKiE";
            truncated = 1;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Wed Jul 26 20:38:22 +0000 2017";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "BTS trash since '14\Ud83d\Udeae.. will forever and always be an ARMY\U2764\Ufe0f Mic Drop is for them haters.. \Ud83d\Ude33 Supporting Bangtan 'til I die.. I may be smol but I can fight chu!";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 2638;
                "follow_request_sent" = 0;
                "followers_count" = 75;
                following = 0;
                "friends_count" = 146;
                "geo_enabled" = 0;
                "has_extended_profile" = 1;
                id = 890310348053544969;
                "id_str" = 890310348053544969;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 0;
                location = "San Antonio, TX";
                name = "Hope World is my World\Ud83d\Udc9a\Ud83c\Udf1e\Ud83d\Udc96";
                notifications = 0;
                "profile_background_color" = F5F8FA;
                "profile_background_image_url" = "<null>";
                "profile_background_image_url_https" = "<null>";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/890310348053544969/1511849332";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/953925002117738496/FuhABhvR_normal.jpg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/953925002117738496/FuhABhvR_normal.jpg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = jackiearwen;
                "statuses_count" = 2877;
                "time_zone" = "Pacific Time (US & Canada)";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "-28800";
                verified = 0;
            };
    },
        {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Thu Mar 08 06:22:10 +0000 2018";
            entities =             {
                hashtags =                 (
                );
                symbols =                 (
                );
                urls =                 (
                );
                "user_mentions" =                 (
                    {
                        id = 360470255;
                        "id_str" = 360470255;
                        indices =                         (
                            3,
                            16
                        );
                        name = "CEHURD Uganda";
                        "screen_name" = cehurduganda;
                    }
                );
            };
            "favorite_count" = 0;
            favorited = 0;
            geo = "<null>";
            id = 971632144828239872;
            "id_str" = 971632144828239872;
            "in_reply_to_screen_name" = "<null>";
            "in_reply_to_status_id" = "<null>";
            "in_reply_to_status_id_str" = "<null>";
            "in_reply_to_user_id" = "<null>";
            "in_reply_to_user_id_str" = "<null>";
            "is_quote_status" = 0;
            lang = en;
            metadata =             {
                "iso_language_code" = en;
                "result_type" = recent;
            };
            place = "<null>";
            "retweet_count" = 9;
            retweeted = 0;
            "retweeted_status" =             {
                contributors = "<null>";
                coordinates = "<null>";
                "created_at" = "Wed Mar 07 22:58:49 +0000 2018";
                entities =                 {
                    hashtags =                     (
                    );
                    symbols =                     (
                    );
                    urls =                     (
                        {
                            "display_url" = "twitter.com/i/web/status/9\U2026";
                            "expanded_url" = "https://twitter.com/i/web/status/971520572848070656";
                            indices =                             (
                            117,
                            140
                            );
                            url = "https://t.co/gnNRUkhZwt";
                        }
                    );
                    "user_mentions" =                     (
                    );
                };
                "favorite_count" = 11;
                favorited = 0;
                geo = "<null>";
                id = 971520572848070656;
                "id_str" = 971520572848070656;
                "in_reply_to_screen_name" = "<null>";
                "in_reply_to_status_id" = "<null>";
                "in_reply_to_status_id_str" = "<null>";
                "in_reply_to_user_id" = "<null>";
                "in_reply_to_user_id_str" = "<null>";
                "is_quote_status" = 0;
                lang = en;
                metadata =                 {
                    "iso_language_code" = en;
                    "result_type" = recent;
                };
                place = "<null>";
                "possibly_sensitive" = 0;
                "retweet_count" = 9;
                retweeted = 0;
                source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
                text = "Uganda still registers a high maternal mortality ratio, which is at 360 deaths per 100,000 births \U2013 At CEHURD we ha\U2026 https://t.co/gnNRUkhZwt";
                truncated = 1;
                user =                 {
                    "contributors_enabled" = 0;
                    "created_at" = "Tue Aug 23 07:57:04 +0000 2011";
                    "default_profile" = 0;
                    "default_profile_image" = 0;
                    description = "We work towards an effective,equitable,people-centered health system,ensure full realization of right to health&promote respect for #HumanRights in East Africa.";
                    entities =                     {
                        description =                         {
                            urls =                             (
                            );
                        };
                        url =                         {
                            urls =                             (
                                {
                                    "display_url" = "cehurd.org";
                                    "expanded_url" = "http://www.cehurd.org";
                                    indices =                                     (
                                        0,
                                        23
                                    );
                                    url = "https://t.co/rM4TOxni8R";
                                }
                            );
                        };
                    };
                    "favourites_count" = 760;
                    "follow_request_sent" = 0;
                    "followers_count" = 2098;
                    following = 0;
                    "friends_count" = 764;
                    "geo_enabled" = 1;
                    "has_extended_profile" = 0;
                    id = 360470255;
                    "id_str" = 360470255;
                    "is_translation_enabled" = 0;
                    "is_translator" = 0;
                    lang = en;
                    "listed_count" = 30;
                    location = "Kampala, Uganda";
                    name = "CEHURD Uganda";
                    notifications = 0;
                    "profile_background_color" = EBEBEB;
                    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme7/bg.gif";
                    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme7/bg.gif";
                    "profile_background_tile" = 0;
                    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/360470255/1508838128";
                    "profile_image_url" = "http://pbs.twimg.com/profile_images/504903630101561344/m09yeVAJ_normal.png";
                    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/504903630101561344/m09yeVAJ_normal.png";
                    "profile_link_color" = 990000;
                    "profile_sidebar_border_color" = DFDFDF;
                    "profile_sidebar_fill_color" = F3F3F3;
                    "profile_text_color" = 333333;
                    "profile_use_background_image" = 1;
                    protected = 0;
                    "screen_name" = cehurduganda;
                    "statuses_count" = 3481;
                    "time_zone" = Nairobi;
                    "translator_type" = none;
                    url = "https://t.co/rM4TOxni8R";
                    "utc_offset" = 10800;
                    verified = 0;
                };
            };
            source = "<a href=\"http://twitter.com/download/android\" rel=\"nofollow\">Twitter for Android</a>";
            text = "RT @cehurduganda: Uganda still registers a high maternal mortality ratio, which is at 360 deaths per 100,000 births \U2013 At CEHURD we have con\U2026";
            truncated = 0;
            user =             {
                "contributors_enabled" = 0;
                "created_at" = "Wed Apr 30 11:53:01 +0000 2014";
                "default_profile" = 1;
                "default_profile_image" = 0;
                description = "Christian medical doctor and leader .";
                entities =                 {
                    description =                     {
                        urls =                         (
                        );
                    };
                };
                "favourites_count" = 1360;
                "follow_request_sent" = 0;
                "followers_count" = 97;
                following = 0;
                "friends_count" = 254;
                "geo_enabled" = 1;
                "has_extended_profile" = 1;
                id = 2518893801;
                "id_str" = 2518893801;
                "is_translation_enabled" = 0;
                "is_translator" = 0;
                lang = en;
                "listed_count" = 4;
                location = "MUST ";
                name = "Rogers Kajabwangu ";
                notifications = 0;
                "profile_background_color" = C0DEED;
                "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
                "profile_background_tile" = 0;
                "profile_banner_url" = "https://pbs.twimg.com/profile_banners/2518893801/1413468739";
                "profile_image_url" = "http://pbs.twimg.com/profile_images/466679009246314496/k018aIJe_normal.jpeg";
                "profile_image_url_https" = "https://pbs.twimg.com/profile_images/466679009246314496/k018aIJe_normal.jpeg";
                "profile_link_color" = 1DA1F2;
                "profile_sidebar_border_color" = C0DEED;
                "profile_sidebar_fill_color" = DDEEF6;
                "profile_text_color" = 333333;
                "profile_use_background_image" = 1;
                protected = 0;
                "screen_name" = kajabwanguR;
                "statuses_count" = 1141;
                "time_zone" = "Pacific/Midway";
                "translator_type" = none;
                url = "<null>";
                "utc_offset" = "-39600";
                verified = 0;
            };
    }
    );
}
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000d860>(
    {
    id = 268719816;
    "id_str" = 268719816;
    indices =     (
    3,
    16
    );
    name = "Ruby Mungai";
    "screen_name" = "Shiru_Mungai";
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000dd50>(
    {
    id = 814450819;
    "id_str" = 814450819;
    indices =     (
    3,
    16
    );
    name = "Women's Aid Org";
    "screen_name" = womensaidorg;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000dd90>(
    {
    id = 265902729;
    "id_str" = 265902729;
    indices =     (
    3,
    12
    );
    name = "BBC Sport";
    "screen_name" = BBCSport;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSArray0 0x60400000d0e0>(
    
    )
    , "media": <__NSSingleObjectArrayI 0x60000000ddf0>(
    {
    "display_url" = "pic.twitter.com/CWMAcbbx6i";
    "expanded_url" = "https://twitter.com/kriskrystal/status/971632464182566912/photo/1";
    id = 971632442682552321;
    "id_str" = 971632442682552321;
    indices =     (
    108,
    131
    );
    "media_url" = "http://pbs.twimg.com/tweet_video_thumb/DXvujwZWsAEoLew.jpg";
    "media_url_https" = "https://pbs.twimg.com/tweet_video_thumb/DXvujwZWsAEoLew.jpg";
    sizes =     {
    large =         {
    h = 300;
    resize = fit;
    w = 300;
    };
    medium =         {
    h = 300;
    resize = fit;
    w = 300;
    };
    small =         {
    h = 300;
    resize = fit;
    w = 300;
    };
    thumb =         {
    h = 150;
    resize = crop;
    w = 150;
    };
    };
    type = photo;
    url = "https://t.co/CWMAcbbx6i";
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000de20>(
    {
    id = 2318870107;
    "id_str" = 2318870107;
    indices =     (
    3,
    11
    );
    name = Jotham;
    "screen_name" = Etoo254;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSSingleObjectArrayI 0x60000000de70>(
    {
    indices =     (
    5,
    28
    );
    text = InternationalWomensDay;
    }
    )
    , "user_mentions": <__NSArray0 0x60400000d0e0>(
    
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSSingleObjectArrayI 0x60000000de80>(
    {
    "display_url" = "twitter.com/i/web/status/9\U2026";
    "expanded_url" = "https://twitter.com/i/web/status/971632451574489088";
    indices =     (
    114,
    137
    );
    url = "https://t.co/PoMq9LjBSC";
    }
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000dea0>(
    {
    id = 867947619661881344;
    "id_str" = 867947619661881344;
    indices =     (
    3,
    14
    );
    name = "Dan Siddons";
    "screen_name" = SiddonsDan;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSArray0 0x60400000d0e0>(
    
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSSingleObjectArrayI 0x60000000ded0>(
    {
    "display_url" = "twitter.com/i/web/status/9\U2026";
    "expanded_url" = "https://twitter.com/i/web/status/971632355743068160";
    indices =     (
    116,
    139
    );
    url = "https://t.co/CxX5rGliSB";
    }
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000dee0>(
    {
    id = 354203444;
    "id_str" = 354203444;
    indices =     (
    3,
    12
    );
    name = "CAPT MACHUKA";
    "screen_name" = Machukah;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000df20>(
    {
    id = 354203444;
    "id_str" = 354203444;
    indices =     (
    3,
    12
    );
    name = "CAPT MACHUKA";
    "screen_name" = Machukah;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000df60>(
    {
    id = 2318870107;
    "id_str" = 2318870107;
    indices =     (
    3,
    11
    );
    name = Jotham;
    "screen_name" = Etoo254;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000dfa0>(
    {
    id = 939674116700934144;
    "id_str" = 939674116700934144;
    indices =     (
    3,
    19
    );
    name = "\Ud835\Udceb\Ud835\Udcf8\Ud835\Udcfc\Ud835\Udcfc-\Ud835\Udcf6\U2741\Ud835\Udcf6\Ud835\Udcf6\Ud835\Udcea";
    "screen_name" = "mothering_a_boy";
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000dfd0>(
    {
    id = 354203444;
    "id_str" = 354203444;
    indices =     (
    3,
    12
    );
    name = "CAPT MACHUKA";
    "screen_name" = Machukah;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSArray0 0x60400000d0e0>(
    
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSSingleObjectArrayI 0x60000000e010>(
    {
    "display_url" = "twitter.com/i/web/status/9\U2026";
    "expanded_url" = "https://twitter.com/i/web/status/971632253129383936";
    indices =     (
    116,
    139
    );
    url = "https://t.co/nCdlrIUaYn";
    }
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000e030>(
    {
    id = 2318870107;
    "id_str" = 2318870107;
    indices =     (
    3,
    11
    );
    name = Jotham;
    "screen_name" = Etoo254;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSArray0 0x60400000d0e0>(
    
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSSingleObjectArrayI 0x60000000e080>(
    {
    "display_url" = "fb.me/1Qe88wRGV";
    "expanded_url" = "https://fb.me/1Qe88wRGV";
    indices =     (
    69,
    92
    );
    url = "https://t.co/hUuP9NviaR";
    }
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000e0a0>(
    {
    id = 3239969270;
    "id_str" = 3239969270;
    indices =     (
    3,
    18
    );
    name = "Medical Vids\U2695\Ufe0f";
    "screen_name" = TheMedicalVids;
    }
    )
    , "media": <__NSSingleObjectArrayI 0x60000000e0b0>(
    {
    "display_url" = "pic.twitter.com/PxsbTOYUhP";
    "expanded_url" = "https://twitter.com/TheMedicalVids/status/971582011684065280/video/1";
    id = 971580972587249669;
    "id_str" = 971580972587249669;
    indices =     (
    60,
    83
    );
    "media_url" = "http://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
    "media_url_https" = "https://pbs.twimg.com/ext_tw_video_thumb/971580972587249669/pu/img/RzbZe0DH83EKBCJ3.jpg";
    sizes =     {
    large =         {
    h = 360;
    resize = fit;
    w = 640;
    };
    medium =         {
    h = 360;
    resize = fit;
    w = 640;
    };
    small =         {
    h = 360;
    resize = fit;
    w = 640;
    };
    thumb =         {
    h = 150;
    resize = crop;
    w = 150;
    };
    };
    "source_status_id" = 971582011684065280;
    "source_status_id_str" = 971582011684065280;
    "source_user_id" = 3239969270;
    "source_user_id_str" = 3239969270;
    type = photo;
    url = "https://t.co/PxsbTOYUhP";
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000e120>(
    {
    id = 2318870107;
    "id_str" = 2318870107;
    indices =     (
    3,
    11
    );
    name = Jotham;
    "screen_name" = Etoo254;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000e170>(
    {
    id = 32959253;
    "id_str" = 32959253;
    indices =     (
    0,
    16
    );
    name = "Khlo\U00e9";
    "screen_name" = khloekardashian;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSSingleObjectArrayI 0x60000000e180>(
    {
    "display_url" = "twitter.com/i/web/status/9\U2026";
    "expanded_url" = "https://twitter.com/i/web/status/971632158908604417";
    indices =     (
    117,
    140
    );
    url = "https://t.co/oSZg3alKiE";
    }
    )
    ])
Optional(["hashtags": <__NSArray0 0x60400000d0e0>(
    
    )
    , "user_mentions": <__NSSingleObjectArrayI 0x60000000e190>(
    {
    id = 360470255;
    "id_str" = 360470255;
    indices =     (
    3,
    16
    );
    name = "CEHURD Uganda";
    "screen_name" = cehurduganda;
    }
    )
    , "symbols": <__NSArray0 0x60400000d0e0>(
    
    )
    , "urls": <__NSArray0 0x60400000d0e0>(
    
    )
    ])
[PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:26 +0000 2018"), retweet_count: Optional("5"), text: Optional("RT @Shiru_Mungai: Adolescent pregnancy robs girls of their potential and reinforces the vicious cycle of poverty. It is also a major cause…"), hashTag: Optional(""), name: Optional("Lilian Obaga"), profile_image_url: Optional(""), media_url: Optional(" "), screen_name: Optional("LilianObaga")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:26 +0000 2018"), retweet_count: Optional("12"), text: Optional("RT @womensaidorg: In conjunction with International Women\'s Day, WAO is launching our \'Invisible Women\' art exhibition, which highlights wo…"), hashTag: Optional(""), name: Optional("Kekabumi"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("kekabumi")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:26 +0000 2018"), retweet_count: Optional("161"), text: Optional("RT @BBCSport: \"We\'re dying. Three-times more likely.\"\n\nSerena Williams has spoken candidly about the \'\'heartbreaking\'\' complications for bl…"), hashTag: Optional(""), name: Optional("BabyMed"), profile_image_url: Optional("https://pbs.twimg.com/profile_background_images/378800000172559448/JU3wXOp-.png"), media_url: Optional(" "), screen_name: Optional("babymed_Ke")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:26 +0000 2018"), retweet_count: Optional("0"), text: Optional("why the FUCK is everybody pregnant... this year was supposed to be about ME AND MY PREGNANCY. i\'m so mad rn https://t.co/CWMAcbbx6i"), hashTag: Optional(""), name: Optional("babyK & babyD"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("kriskrystal")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:25 +0000 2018"), retweet_count: Optional("6"), text: Optional("RT @Etoo254: Religious Leaders: Sensitize community members about the dangers of underage pregnancy and ﬁght negative cultural beliefs and…"), hashTag: Optional(""), name: Optional("Sαɴcтιoɴed Iαɴ Mαrĸ"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("IanmarkKimani")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:23 +0000 2018"), retweet_count: Optional("0"), text: Optional("This #InternationalWomensDay , let us pledge to work towards providing quality care for women during 9 months of… https://t.co/PoMq9LjBSC"), hashTag: Optional("#InternationalWomensDay"), name: Optional("National Health Portal"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("NHPINDIA")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:03 +0000 2018"), retweet_count: Optional("1983"), text: Optional("RT @SiddonsDan: “In America, children can be legally killed through all nine months of pregnancy, at any time, and for any reason. This vid…"), hashTag: Optional(""), name: Optional("Susan Simon"), profile_image_url: Optional(""), media_url: Optional(" "), screen_name: Optional("SusanSi23428588")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:23:00 +0000 2018"), retweet_count: Optional("0"), text: Optional("Media: Highlight the impact of teenage pregnancy and amplify voices of stakeholders demanding an end to adolescent… https://t.co/CxX5rGliSB"), hashTag: Optional(""), name: Optional("Ruby Mungai"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme14/bg.gif"), media_url: Optional(" "), screen_name: Optional("Shiru_Mungai")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:56 +0000 2018"), retweet_count: Optional("4"), text: Optional("RT @Machukah: Create time to talk to your children or get someone to talk to them about sex issues and the consequences of early sex and pr…"), hashTag: Optional(""), name: Optional("Sαɴcтιoɴed Iαɴ Mαrĸ"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("IanmarkKimani")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:49 +0000 2018"), retweet_count: Optional("6"), text: Optional("RT @Machukah: Remember, unprotected sex puts you at risk of STIs/HIVs and pregnancy, resulting in childbirth or unsafe abortions, which can…"), hashTag: Optional(""), name: Optional("Sαɴcтιoɴed Iαɴ Mαrĸ"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("IanmarkKimani")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:44 +0000 2018"), retweet_count: Optional("2"), text: Optional("RT @Etoo254: Create time to talk to your children or get someone to talk to them about sex issues and the consequences of early sex and pre…"), hashTag: Optional(""), name: Optional("Son Of Tamale 💪🔥"), profile_image_url: Optional(""), media_url: Optional(" "), screen_name: Optional("OJjnr12")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:43 +0000 2018"), retweet_count: Optional("348"), text: Optional("RT @mothering_a_boy: with April fools right around the corner- PREGNANCY IS NOT AN APRIL FOOLS JOKE PREGNANCY IS NOT AN APRIL FOOLS JOKE PR…"), hashTag: Optional(""), name: Optional("Mama Mae🌵"), profile_image_url: Optional(""), media_url: Optional(" "), screen_name: Optional("_mrseakin_")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:42 +0000 2018"), retweet_count: Optional("4"), text: Optional("RT @Machukah: CSOs and Donors: Support and implement projects aimed at advocating for an end to adolescent pregnancy and accountability for…"), hashTag: Optional(""), name: Optional("Sαɴcтιoɴed Iαɴ Mαrĸ"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("IanmarkKimani")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:35 +0000 2018"), retweet_count: Optional("0"), text: Optional("Here is my gift to Women on Women\'s day.\nYour weight gain post delivery or complications during pregnancy or other… https://t.co/nCdlrIUaYn"), hashTag: Optional(""), name: Optional("Praveen Patil"), profile_image_url: Optional(""), media_url: Optional(" "), screen_name: Optional("praveenbpatil5")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:26 +0000 2018"), retweet_count: Optional("3"), text: Optional("RT @Etoo254: This IWD 2018, we are calling on Parents/Management to create time to talk to their children or get someone to talk to them ab…"), hashTag: Optional(""), name: Optional("Sαɴcтιoɴed Iαɴ Mαrĸ"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("IanmarkKimani")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:23 +0000 2018"), retweet_count: Optional("0"), text: Optional("A local reader gives her view about the high teenage pregnancy rates https://t.co/hUuP9NviaR"), hashTag: Optional(""), name: Optional("looktzaneen"), profile_image_url: Optional("https://pbs.twimg.com/profile_background_images/581976319/xd8ed76889b90b79be980a345baa0c26.jpg"), media_url: Optional(" "), screen_name: Optional("looktzaneen")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:23 +0000 2018"), retweet_count: Optional("312"), text: Optional("RT @TheMedicalVids: Ectopic Pregnancy Baby Abortion Surgery https://t.co/PxsbTOYUhP"), hashTag: Optional(""), name: Optional("feminasty🌹"), profile_image_url: Optional("https://pbs.twimg.com/profile_background_images/596436418550870016/mR2DdFuB.png"), media_url: Optional(" "), screen_name: Optional("_Bulfar0")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:20 +0000 2018"), retweet_count: Optional("4"), text: Optional("RT @Etoo254: Remember, unprotected sex puts you at risk of STIs/HIVs and pregnancy, resulting in childbirth or unsafe abortions, which can…"), hashTag: Optional(""), name: Optional("Sαɴcтιoɴed Iαɴ Mαrĸ"), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("IanmarkKimani")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:13 +0000 2018"), retweet_count: Optional("0"), text: Optional("@khloekardashian Hello I am a big fan of yours and I would love to tell you a story. If you ever accept it would me… https://t.co/oSZg3alKiE"), hashTag: Optional(""), name: Optional("Hope World is my World💚🌞💖"), profile_image_url: Optional(""), media_url: Optional(" "), screen_name: Optional("jackiearwen")), PregBuddyTweets.Tweet(created_at: Optional("Thu Mar 08 06:22:10 +0000 2018"), retweet_count: Optional("9"), text: Optional("RT @cehurduganda: Uganda still registers a high maternal mortality ratio, which is at 360 deaths per 100,000 births – At CEHURD we have con…"), hashTag: Optional(""), name: Optional("Rogers Kajabwangu "), profile_image_url: Optional("https://abs.twimg.com/images/themes/theme1/bg.png"), media_url: Optional(" "), screen_name: Optional("kajabwanguR"))]



*/
