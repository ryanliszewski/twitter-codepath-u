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

}
