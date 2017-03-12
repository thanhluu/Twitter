//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/11/17.
//
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()
    var user_id: Int64?
    var user = User.currentUser!
    
    //var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style for Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255, green: 161/255, blue: 243/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = nil
        
        refreshControl.addTarget(self, action: #selector(ProfileViewController.loadUserTimeline), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let user_id = user_id {
            TwitterClient.sharedInstance?.userShow(userId: user_id, success: { (user: User) in
                
                let close = UIBarButtonItem(barButtonSystemItem: .stop , target: self, action: #selector(ProfileViewController.dismissThisView))
                
                self.navigationItem.rightBarButtonItems = [close]
                
                //self.navigationItem.leftBarButtonItem = nil
                
                self.user = user
                
                // Set Avatar
                self.avatarImageView.setImageWith(user.profileUrl!)
                self.avatarImageView.layer.cornerRadius = 5
                self.avatarImageView.clipsToBounds = true
                
                // Set Name
                self.displayNameLabel.text = user.name
                
                // Set Screen Name
                self.usernameLabel.text = "@\((user.screenname)!)"
                
                // Set Tweets Count
                self.tweetsCount.text = "\((user.tweetsCount)!)"
                
                // Set Following Count
                self.followingCount.text = "\((user.followingCount)!)"
                
                // Set Followers Count
                self.followersCount.text = "\((user.followersCount)!)"
                
                // Set Avatar
                if let userProfileBannerUrl = user.profileBannerUrl {
                    let bannerImage = UIImageView(frame: self.bannerView.bounds)
                    bannerImage.setImageWith(userProfileBannerUrl)
                    self.bannerView.insertSubview(bannerImage, at: 0)
                }
                
                self.loadUserTimeline( user_id: user.id! )
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        } else {
            // Set Avatar
            avatarImageView.setImageWith(user.profileUrl!)
            avatarImageView.layer.cornerRadius = 5
            avatarImageView.clipsToBounds = true
            
            // Set Name
            displayNameLabel.text = user.name
            
            // Set Screen Name
            usernameLabel.text = "@\((user.screenname)!)"
            
            // Set Tweets Count
            tweetsCount.text = "\((user.tweetsCount)!)"
            
            // Set Following Count
            followingCount.text = "\((user.followingCount)!)"
            
            // Set Followers Count
            followersCount.text = "\((user.followersCount)!)"
            
            // Set Avatar
            if let userProfileBannerUrl = user.profileBannerUrl {
                let bannerImage = UIImageView(frame: bannerView.bounds)
                bannerImage.setImageWith(userProfileBannerUrl)
                bannerView.insertSubview(bannerImage, at: 0)
            }
            
            loadUserTimeline( user_id: user.id! )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserTimeline( user_id: user.id! )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets == nil {
            return 0
        } else {
            return tweets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func loadUserTimeline( user_id: Int64 ) {
        TwitterClient.sharedInstance?.userTimeline(userId: user_id, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        self.refreshControl.endRefreshing()
    }
    
    func dismissThisView() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender is UITableViewCell) {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweetDetailViewController = segue.destination as! TweetDetailViewController
            tweetDetailViewController.tweet = tweets[indexPath!.row]
            tableView.deselectRow(at: indexPath!, animated: true)
        }
    }
}
