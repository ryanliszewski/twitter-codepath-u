//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 3/4/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBannerImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        followersLabel.text = String(describing: user.numberOfFollowers)
        followingLabel.text = String(describing: user.numberOfFollowing)
        descriptionLabel.text = user.tagline
        screenNameLabel.text = user.screenName
        nameLabel.text = user.name
        profileImageView.setImageWith(user.profileUrl!)
        profileBannerImageView.setImageWith(user.profileBannerUrl!)
        
        
        // Do any additional setup after loading the view.
    }
    
    func getUser(){
        TwitterClient.sharedInstance?.getUserProfile(screenName: user.screenName!, success: { (user: User) in
            self.user = user
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
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
