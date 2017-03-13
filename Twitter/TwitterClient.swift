//
//  TwitterClient.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/4/17.
//
//

import UIKit
import BDBOAuth1Manager

let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "yYqWwISOT6aRCWrQ3TjxeRBXn"
let consumerSecret = "7bqqOfvH7IvH0TNZfSU6LFFM3Y8EaxQMrsjUAjDc6BLiad4f8x"

class TwitterClient: BDBOAuth1SessionManager {
    
    static var sharedInstance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "mytwitterlite://"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            if let response = response {
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            self.loginFailure?(error as! NSError)
        })
    }
    
    func userShow(userId: Int64, success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        _ = get("1.1/users/show.json", parameters: ["user_id": userId], progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            
            if let response = response {
                let dictionary = response as! NSDictionary
                
                let user = User(dictionary: dictionary)
                
                success(user)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        _ = get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            
            if let response = response {
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        _ = get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            
            if let response = response {
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func userTimeline(userId: Int64, success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        _ = get("/1.1/statuses/user_timeline.json", parameters: ["user_id": userId], progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            
            if let response = response {
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        _ = get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            
            if let response = response {
                let userDictionary = response as! NSDictionary
                
                let user = User(dictionary: userDictionary)
                
                success(user)

            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func retweet(tweetId: String, action: String, success: @escaping (Tweet) -> (), failure: @escaping (NSError) -> ()) {
        _ = post("1.1/statuses/\(action)/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            if let response = response {
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func favorite(tweetId: String, action: String, success: @escaping (Tweet) -> (), failure: @escaping (NSError) -> ()) {
        _ = post("1.1/favorites/\(action).json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            if let response = response {
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func tweet(status: String, success: @escaping (Tweet) -> (), failure: @escaping (NSError) -> ()) {
        _ = post("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: { (task: URLSessionDataTask, response:  Any?) in
            if let response = response {
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
}
