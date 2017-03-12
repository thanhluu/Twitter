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
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style for Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255, green: 161/255, blue: 243/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = nil
        
        refreshControl.addTarget(self, action: #selector(TweetsViewController.loadHomeTimeline), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadHomeTimeline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHomeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHamburgerButton(_ sender: UIBarButtonItem) {
    }
    

    @IBAction func unwindToTweetsViewController(segue: UIStoryboardSegue) {}
    
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
    
    func loadHomeTimeline() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
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
        } else if (sender is UIButton) {
            let navVC = segue.destination as! UINavigationController
            let profileViewController = navVC.viewControllers.first as! ProfileViewController
            let button = sender as! UIButton
            if let superview = button.superview {
                if let cell = superview.superview as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    if let user = tweets[indexPath!.row].user {
                        profileViewController.user_id = user.id
                    }
                    
                }
            }
        }
    }
}
