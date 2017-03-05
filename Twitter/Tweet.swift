//
//  Tweet.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/4/17.
//
//

import UIKit

class Tweet: NSObject {
    var retweetedStatus: Bool = false
    var retweetedStatusId: String?
    var user: User?
    var timestamp: Date?
    var text: String?
    var replyCount: Int = 0
    var retweetCount: Int = 0
    var isRetweeted: Bool = false
    var favoritesCount: Int = 0
    var isFavorited: Bool = false
    
    init(dictionary: NSDictionary) {
        if let retweetedStatusDict = dictionary["retweeted_status"] as? NSDictionary {
            retweetedStatus = true
            retweetedStatusId = retweetedStatusDict["id_str"] as? String
        }
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        isRetweeted = (dictionary["retweeted"] as? Bool) ?? false
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        isFavorited = (dictionary["favorited"] as? Bool) ?? false
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
