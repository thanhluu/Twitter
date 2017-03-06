//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Luu Tien Thanh on 3/6/17.
//
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var tweetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.layer.cornerRadius = 5
        tweetText.delegate = self
        placeholderLabel.isHidden = !tweetText.text.isEmpty
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tweetText.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !tweetText.text.isEmpty
        let characterRemaining = 140 - tweetText.text.characters.count
        tweetCount.text = "\(characterRemaining)"
        if ( characterRemaining < 0 ) {
            tweetCount.textColor = .red
            tweetButton.isEnabled = false
            tweetButton.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        } else {
            tweetCount.textColor = UIColor(red: 101/255, green: 119/255, blue: 134/255, alpha: 1.0)
            tweetButton.isEnabled = true
            tweetButton.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            //print(keyboardHeight)
            
            if #available(iOS 9.0, *) {
                NSLayoutConstraint.activate([
                    toolbarView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -keyboardHeight)
                ])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButton(_ sender: UIButton) {
        TwitterClient.sharedInstance?.tweet(status: tweetText.text, success: {_ in
            self.tweetText.endEditing(true)
            self.performSegue(withIdentifier: "unwindToTweetsViewController", sender: self)
        }, failure: { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        })
    }
    @IBAction func onCloseButton(_ sender: UIBarButtonItem) {
        tweetText.endEditing(true)
        performSegue(withIdentifier: "unwindToTweetsViewController", sender: self)
    }
}
