//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/4/17.
//
//

import UIKit

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "twitter-dark-blue"))

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweetDetailViewController = segue.destination as! TweetDetailViewController
        tweetDetailViewController.tweet = tweets[indexPath!.row]
        tableView.deselectRow(at: indexPath!, animated: true)
    }
}
