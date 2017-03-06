//
//  TweetCell.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/4/17.
//
//

import UIKit
import DateToolsSwift

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var retweetOnColor = UIColor(red: 25/255, green: 207/255, blue: 134/255, alpha: 1.0)
    var likeOnColor = UIColor(red: 232/255, green: 28/255, blue: 79/255, alpha: 1.0)
    var offColor = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1.0)
    
    //let retweet = Tweet?()
    
    var tweet: Tweet! {
        didSet {
            
            // Set Avatar
            avatarImage.setImageWith((tweet.user?.profileUrl)!)
            avatarImage.layer.cornerRadius = 5
            avatarImage.clipsToBounds = true
            
            // Set Name
            nameLabel.text = tweet.user?.name
            
            // Set Screen Name
            usernameLabel.text = "@\((tweet.user?.screenname)!)"
            
            // Set Timestamp
            timestampLabel.text = tweet.timestamp?.shortTimeAgoSinceNow
            
            // Set Tweet Text
            contentLabel.text = tweet.text
            
            // Did I Retweeted?
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
                retweetCount.textColor = retweetOnColor
            } else {
                retweetButton.setImage(UIImage(named: "retweet_off"), for: .normal)
                retweetCount.textColor = offColor
            }
            // Set Retweet Count Text
            retweetCount.text = String(tweet.retweetCount)
            // Did I Favorited?
            if tweet.isFavorited {
                favoriteButton.setImage(UIImage(named: "like_on"), for: .normal)
                favoriteCount.textColor = likeOnColor
            } else {
                favoriteButton.setImage(UIImage(named: "like_off"), for: .normal)
                favoriteCount.textColor = offColor
            }
            // Set Favorite Count Text
            favoriteCount.text = String(tweet.favoritesCount)
            
        }
    }
    
    @IBAction func onRetweetButton(_ sender: UIButton) {
        if self.tweet.isRetweeted {
            TwitterClient.sharedInstance?.retweet(tweetId: tweet.id!, action: "unretweet", success: {_ in 
                self.retweetButton.setImage(UIImage(named: "retweet_off"), for: .normal)
                self.tweet.retweetCount = self.tweet.retweetCount - 1
                self.retweetCount.text = "\( self.tweet.retweetCount )"
                self.retweetCount.textColor = self.offColor
                self.tweet.isRetweeted = !self.tweet.isRetweeted
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: tweet.id!, action: "retweet", success: {_ in 
                self.retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
                self.tweet.retweetCount = self.tweet.retweetCount + 1
                self.retweetCount.text = "\( self.tweet.retweetCount )"
                self.retweetCount.textColor = self.retweetOnColor
                self.tweet.isRetweeted = !self.tweet.isRetweeted
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: UIButton) {
        if tweet.isFavorited {
            TwitterClient.sharedInstance?.favorite(tweetId: tweet.id!, action: "destroy", success: {_ in
                self.favoriteButton.setImage(UIImage(named: "like_off"), for: .normal)
                self.tweet.favoritesCount = self.tweet.favoritesCount - 1
                self.favoriteCount.text = "\( self.tweet.favoritesCount )"
                self.favoriteCount.textColor = self.offColor
                self.tweet.isFavorited = !self.tweet.isFavorited
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: tweet.id!, action: "create", success: {_ in
                self.favoriteButton.setImage(UIImage(named: "like_on"), for: .normal)
                self.tweet.favoritesCount = self.tweet.favoritesCount + 1
                self.favoriteCount.text = "\( self.tweet.favoritesCount )"
                self.favoriteCount.textColor = self.likeOnColor
                self.tweet.isFavorited = !self.tweet.isFavorited
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
