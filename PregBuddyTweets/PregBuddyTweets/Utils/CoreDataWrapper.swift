//
//  CoreDataWrapper.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import UIKit
import CoreData


class CoreDataWrapper: NSObject {

    
    private static let sharedInstance: CoreDataWrapper = {
        let sharedInstance = CoreDataWrapper()
        return sharedInstance
    }()
    
    class func shared() -> CoreDataWrapper{
        return sharedInstance
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PregBuddyTweets")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Instance Methods

    
    func bookmarkTweet(_ tweet: Tweet) {
        
        let created_at = tweet.created_at
        let retweet_count = tweet.retweet_count
        let text = tweet.text
        let hashTag = tweet.hashTag
        let name = tweet.name
        let profile_image_url = tweet.profile_image_url
        let media_url = tweet.media_url
        let screen_name = tweet.screen_name
       
        let tweetList = NSEntityDescription.insertNewObject(forEntityName: CORE_DATA_ENTITY_TWEETS_LIST, into: managedObjectContext())

        tweetList.setValue(created_at, forKey: "created_at")
        tweetList.setValue(retweet_count, forKey: "retweet_count")
        tweetList.setValue(text, forKey: "text")
        tweetList.setValue(hashTag, forKey: "hashTag")
        tweetList.setValue(name, forKey: "name")
        tweetList.setValue(profile_image_url, forKey: "profile_image_url")
        tweetList.setValue(media_url, forKey: "media_url")
        tweetList.setValue(screen_name, forKey: "screen_name")
        self.saveContext()
    }
    
    func fetchTweets() -> [TweetsList] {
        
        var tweets = [TweetsList]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CORE_DATA_ENTITY_TWEETS_LIST)
        do {
            tweets = try managedObjectContext().fetch(fetchRequest) as! [TweetsList]
          //  print("Tweets Count \(tweets.count)")
        } catch let err as NSError {
            print(err.debugDescription)
        }
        return tweets
    }
    
}
