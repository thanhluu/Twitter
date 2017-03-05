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
    
    @IBOutlet weak var subHeading: UILabel!
    
    @IBOutlet weak var subHeadingImage: UIImageView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var replyImage: UIImageView!
    
    @IBOutlet weak var retweetCount: UILabel!
    
    @IBOutlet weak var retweetImage: UIImageView!
    
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            
            // Display Retweet Info
            if true == tweet.retweetedStatus {
                subHeading.isHidden = false
                subHeadingImage.isHidden = false
                subHeading.text = "\((tweet.user?.name)!) Retweeted"
            } else {
                subHeading.isHidden = true
                subHeadingImage.isHidden = true
            }
            
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
                retweetImage.image = UIImage(named: "retweet_on")
                retweetCount.textColor = UIColor(red: 25/255, green: 207/255, blue: 134/255, alpha: 1.0)
            } else {
                retweetImage.image = UIImage(named: "retweet_off")
                retweetCount.textColor = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1.0)
            }
            // Set Retweet Count Text
            if ( tweet.retweetCount == 0 ) {
                retweetCount.text = ""
            } else {
                retweetCount.text = String(tweet.retweetCount)
            }
            // Did I Favorited?
            if tweet.isFavorited {
                favoriteImage.image = UIImage(named: "like_on")
                favoriteCount.textColor = UIColor(red: 232/255, green: 28/255, blue: 79/255, alpha: 1.0)
            } else {
                favoriteImage.image = UIImage(named: "like_off")
                favoriteCount.textColor = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1.0)
            }
            // Set Favorite Count Text
            if ( tweet.favoritesCount == 0 ) {
                favoriteCount.text = ""
            } else {
                favoriteCount.text = String(tweet.favoritesCount)
            }
            
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
