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
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onButtonClickedDelegate: TweetCellDelegate!
   
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            userNameLabel.text = tweet.user?.screenName
            timeStampLabel.text = tweet.timeStamp
            tweetLabel.text = tweet.text
            
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
        print("Retweet!")
        onButtonClickedDelegate.onRetweetButtonClicked(tweetCell: self)
    }
    
    @IBAction func onFavoriteButtonClicked(_ sender: Any) {
        print("favoirte!")
        onButtonClickedDelegate.onFavoriteButtonClicked(tweetCell: self)
    }
   
}

protocol TweetCellDelegate: class {
    func onRetweetButtonClicked(tweetCell: TweetCell!)
    func onFavoriteButtonClicked(tweetCell: TweetCell!)
}
