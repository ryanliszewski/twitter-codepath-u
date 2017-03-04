//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 3/3/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = tweet.user?.screenName
        tweetTextLabel.adjustsFontSizeToFitWidth = true
        tweetTextLabel.minimumScaleFactor = 0.5
        tweetTextLabel.text = tweet.text
        profileImageView.setImageWith((tweet.user?.profileUrl)!)
        dateLabel.text = tweet.dateTimeStamp
        nameLabel.text = tweet.user?.name
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
