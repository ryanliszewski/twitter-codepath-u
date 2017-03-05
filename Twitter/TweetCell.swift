//
//  TweetCell.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/20/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
   
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetIconImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetedUserNameLabel: UILabel!
    
    @IBOutlet weak var retweetView: UIView!
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var retweetedNameLabel: UILabel!
    
    @IBOutlet weak var retweetViewHeightConstraint: NSLayoutConstraint!
    
    var onButtonClickedDelegate: TweetCellDelegate!
   
    var tweet: Tweet! {
        didSet {
            
            tweetLabel.adjustsFontSizeToFitWidth = true
            tweetLabel.minimumScaleFactor = 0.5
            nameLabel.text = tweet.user?.name
            userNameLabel.text =  "@" + (tweet.user?.screenName)! + "･ " + tweet.timeStamp!
            //timeStampLabel.text = tweet.timeStamp
            tweetLabel.text = tweet.text
            
            if(tweet.isRetweeted){
                retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
            }else {
                retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon")
            }
            
            if(tweet.isFavorited){
                favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon-red")
            } else {
                favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon")
            }
            
            if(tweet.isRetweet){
                
                self.retweetViewHeightConstraint.constant = 22
                
                retweetView.isHidden = false
                retweetedNameLabel.text = tweet.retweetUsername! + " Retweeted"
            } else {
                retweetView.isHidden = true
                self.retweetViewHeightConstraint.constant = 0
            }
            
            if(tweet.favoritesCount == 0) {
                favoritesCountLabel.isHidden = true
            } else {
                favoritesCountLabel.isHidden = false
                favoritesCountLabel.text = String(tweet.favoritesCount)
            }
            
            if(tweet.retweetCount == 0){
                retweetCountLabel.isHidden = true
            } else {
                retweetCountLabel.isHidden = false
                retweetCountLabel.text = String(tweet.retweetCount)
            }
            
            profileImageView.setImageWith((tweet.user?.profileUrl)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onRetweetButtonClicked(_ sender: Any) {
        onButtonClickedDelegate.onRetweetButtonClicked(tweetCell: self)
    }
    
    @IBAction func onFavoriteButtonClicked(_ sender: Any) {
        onButtonClickedDelegate.onFavoriteButtonClicked(tweetCell: self)
    }
    @IBAction func onProfileImageClicked(_ sender: Any) {
        onButtonClickedDelegate.onProfileImageClicked(tweetCell: self)
    }
    
    
   
}

protocol TweetCellDelegate: class {
    func onRetweetButtonClicked(tweetCell: TweetCell!)
    func onFavoriteButtonClicked(tweetCell: TweetCell!)
    func onProfileImageClicked(tweetCell: TweetCell!)
    func onReplyButtonClicked(tweetCell: TweetCell!)
}
