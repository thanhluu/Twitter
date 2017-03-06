//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/6/17.
//
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set Avatar
        avatarImage.setImageWith((tweet?.user?.profileUrl)!)
        avatarImage.layer.cornerRadius = 5
        avatarImage.clipsToBounds = true
        
        // Set Name
        nameLabel.text = tweet?.user?.name
        
        // Set Screen Name
        usernameLabel.text = "@\((tweet?.user?.screenname)!)"
        
        // Set Timestamp
        timestampLabel.text = tweet?.timestamp?.shortTimeAgoSinceNow
        
        // Set Tweet Text
        contentLabel.text = tweet?.text
        
        // Did I Retweeted?
        if (tweet?.isRetweeted)! {
            retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet_off"), for: .normal)
        }
        // Set Retweet Count Text
        retweetCount.text = String(describing: (tweet?.retweetCount)!)
        
        // Did I Favorited?
        if (tweet?.isFavorited)! {
            favoriteButton.setImage(UIImage(named: "like_on"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like_off"), for: .normal)
        }
        // Set Favorite Count Text
        favoriteCount.text = String(describing: (tweet?.favoritesCount)!)
    }

    @IBAction func onRetweetButton(_ sender: UIButton) {
        if (self.tweet?.isRetweeted)! {
            TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.id)!, action: "unretweet", success: {_ in
                self.retweetButton.setImage(UIImage(named: "retweet_off"), for: .normal)
                self.tweet?.retweetCount = (self.tweet?.retweetCount)! - 1
                self.retweetCount.text = "\( (self.tweet?.retweetCount)! )"
                self.tweet?.isRetweeted = !(self.tweet?.isRetweeted)!
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: (tweet?.id!)!, action: "retweet", success: {_ in
                self.retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
                self.tweet?.retweetCount = (self.tweet?.retweetCount)! + 1
                self.retweetCount.text = "\( (self.tweet?.retweetCount)! )"
                self.tweet?.isRetweeted = !(self.tweet?.isRetweeted)!
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: UIButton) {
        if (tweet?.isFavorited)! {
            TwitterClient.sharedInstance?.favorite(tweetId: (tweet?.id!)!, action: "destroy", success: {_ in
                self.favoriteButton.setImage(UIImage(named: "like_off"), for: .normal)
                self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! - 1
                self.favoriteCount.text = "\( (self.tweet?.favoritesCount)! )"
                self.tweet?.isFavorited = !(self.tweet?.isFavorited)!
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: (tweet?.id!)!, action: "create", success: {_ in
                self.favoriteButton.setImage(UIImage(named: "like_on"), for: .normal)
                self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! + 1
                self.favoriteCount.text = "\( (self.tweet?.favoritesCount)! )"
                self.tweet?.isFavorited = !(self.tweet?.isFavorited)!
            }, failure: { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
