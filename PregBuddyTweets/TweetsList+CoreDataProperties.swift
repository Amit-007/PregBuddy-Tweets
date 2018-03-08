//
//  TweetsList+CoreDataProperties.swift
//  
//
//  Created by Amit Majumdar on 08/03/18.
//
//

import Foundation
import CoreData


extension TweetsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetsList> {
        return NSFetchRequest<TweetsList>(entityName: "TweetsList")
    }

    @NSManaged public var created_at: String?
    @NSManaged public var retweet_count: String?
    @NSManaged public var text: String?
    @NSManaged public var hashTag: String?
    @NSManaged public var name: String?
    @NSManaged public var profile_image_url: String?
    @NSManaged public var media_url: String?
    @NSManaged public var screen_name: String?

}
