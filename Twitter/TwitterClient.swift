//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/20/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "li3mzZamBXs6MZMQgYRWjiADc", consumerSecret: "Syj9xq4q1xcxsUHn3PLdbMtagalni4PTwZ2ExG3GIsoWeoBs8t")
    
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        
        
        get("1.1/statuses/home_timeline.json", parameters: nil,
            progress: nil, success: { (task: URLSessionDataTask!, response: Any?) -> Void in
                
                let dictionaries = response as! [NSDictionary]
                //print("user: \(user)")
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
        }, failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(){
        
        get("1.1/account/verify_credentials.json", parameters: nil,
                   progress: nil, success: { (task: URLSessionDataTask!, response: Any?) -> Void in
                    
                    let userDictionary = response as! NSDictionary
                    //print("user: \(user)")
                    
                    let user = User(dictionary: userDictionary)
                    
                    
                    //let tweets = Tweet.tweetsWithArray(dictionaries: userDictionary)
                    
                    print("name:\(user.name)")
                    print("screenname:\(user.screenName)")
                    print("name:\(user.profileUrl)")
                    print("name:\(user.tagline)")
                    
                    
                    
        }, failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
            
            
        })
        
    }
    

}
