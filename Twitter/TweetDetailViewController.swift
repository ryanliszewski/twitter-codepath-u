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
    var delegate: TweetCellDelegate!
    var tweetCell: TweetCell!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = tweet.user?.screenName
        tweetTextLabel.adjustsFontSizeToFitWidth = true
        tweetTextLabel.minimumScaleFactor = 0.5
        tweetTextLabel.text = tweet.text
        profileImageView.setImageWith((tweet.user?.profileUrl)!)
        dateLabel.text = tweet.dateTimeStamp
        nameLabel.text = tweet.user?.name
        
        setUpRetweetButton()
        setUpFavoriteButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {

        self.delegate.onFavoriteButtonClicked(tweetCell: tweetCell)
    }

    @IBAction func retweetButtonTapped(_ sender: Any) {
        
        self.delegate.onRetweetButtonClicked(tweetCell: tweetCell)

    }
    
    func setUpRetweetButton(){
        
       if(tweet.isRetweeted){
            retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon")
        }
        
    }
    
    func setUpFavoriteButton(){
        if(tweet.isFavorited){
            favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon")
        }
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
