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
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "li3mzZamBXs6MZMQgYRWjiADc", consumerSecret: "Syj9xq4q1xcxsUHn3PLdbMtagalni4PTwZ2ExG3GIsoWeoBs8t")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () ->(), failure: @escaping (Error) ->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclone://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
        
    }
    
    func logout(){
        
        User.currentUser = nil 
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (accesstoken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user 
                
                self.loginSuccess?()
                
            }, failure: { (error: Error) in
                
                self.loginFailure?(error)
            })
            
            
            
            self.loginSuccess?()
            
            print("I got an access to  token")
        }) { (error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
            
        }

    }
    
    
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
    
    func retweet(tweetID: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        post("1.1/statuses/retweet/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            print("retweeted the tweet")
            success()
        }) { (operation: URLSessionDataTask?, error: Error) in
            print("error retweeting")
        }
    }
    
    func unRetweet(tweetID: Int, success: @escaping() -> (), failure: @escaping (Error) -> ()) {
    
        post("1.1/statuses/unretweet/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("unretweeted the tweet")
            success()
        }) { (operation: URLSessionDataTask?, error: Error) in
            print("error un retweeting")
        }
    }
    
    func favorite(tweetId: Int, success: @escaping() -> (), failure: @escaping (Error) -> ()) {
        
        
        
        
    }
                 
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        
        get("1.1/account/verify_credentials.json", parameters: nil,
                   progress: nil, success: { (task: URLSessionDataTask!, response: Any?) -> Void in
                    
                    let userDictionary = response as! NSDictionary
                    //print("user: \(user)")
                    
                    let user = User(dictionary: userDictionary)
                    
                    success(user)
                    
                    
                    
        }, failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
            
        })
        
    }
    

}
