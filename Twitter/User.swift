//
//  User.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/4/17.
//
//

import UIKit

class User: NSObject {
    var id: Int64?
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var profileBannerUrl: URL?
    var tagline: String?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as? Int64
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tweetsCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let profileBannerUrlString = dictionary["profile_banner_url"] as? String
        if let profileBannerUrlString = profileBannerUrlString {
            profileBannerUrl = URL(string: "\(profileBannerUrlString)/mobile")
        }
        
        tagline = dictionary["descrition"] as? String
    }
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
                defaults.synchronize()
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
        }
    }
}
