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
    let user = User.currentUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser!
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
        let bannerImage = UIImageView(frame: bannerView.bounds)
        bannerImage.setImageWith(user.profileBannerUrl!)
        bannerView.insertSubview(bannerImage, at: 0)
        
        // Style for Navigation Bar
        navigationController?.navigationBar.barTintColor = .white
        
        refreshControl.addTarget(self, action: #selector(ProfileViewController.loadUserTimeline), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadUserTimeline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserTimeline()
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
    
    func loadUserTimeline() {
        TwitterClient.sharedInstance?.userTimeline(userId: user.id!,success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        self.refreshControl.endRefreshing()
        
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
