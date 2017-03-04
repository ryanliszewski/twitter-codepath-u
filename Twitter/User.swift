//
//  User.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/20/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var profileBannerUrl: URL?
    var tagline: String?
    var numberOfFollowers: Int = 0
    var numberOfFollowing: Int = 0
    
    var dictionary: NSDictionary
    
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = (dictionary["screen_name"] as? String)!
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let profileBannerUrlString = dictionary["profile_banner_url"] as? String
        
        if let profileBannerUrlString = profileBannerUrlString {
            profileBannerUrl = URL(string: profileBannerUrlString)
        }
        
        print("test")
        
        numberOfFollowers = dictionary["followers_count"] as! Int
        numberOfFollowing = dictionary["friends_count"] as! Int 
        
        tagline = dictionary["description"] as? String
    }
    
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: .allowFragments)
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.removeObject(forKey: "currentUserData")
            }
          
            
        
            defaults.synchronize()

        }
    }

}
