//
//  Tweet.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/20/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var timeStamp: String?
    var dateTimeStamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var isRetweeted: Bool
    var isRetweet: Bool
    var isFavorited: Bool
    var id: Int = 0
    var retweetUsername: String?
    
    
    init(dictionary: NSDictionary){
        
        let timeStampString = dictionary["created_at"] as? String
        
        if(dictionary["retweeted_status"] != nil) {
            self.isRetweet = true
            
            let retweetDictionary = dictionary["retweeted_status"] as! NSDictionary
            let retweetUserNameDictionary = dictionary["user"] as! NSDictionary
            
            
            retweetUsername = retweetUserNameDictionary["name"] as? String
            
            
            user = User(dictionary: retweetDictionary["user"] as! NSDictionary)
            
            text = retweetDictionary["text"] as? String 
            
            retweetCount = (retweetDictionary["retweet_count"] as? Int) ?? 0
            favoritesCount = (retweetDictionary["favorite_count"] as? Int) ?? 0
            
            let timeStampString = retweetDictionary["created_at"] as? String
            
            id = retweetDictionary["id"] as! Int
            
        } else {
            self.isRetweet = false
            
            user = User(dictionary: dictionary["user"] as! NSDictionary)
            
            id = dictionary["id"] as! Int
            
            text = dictionary["text"] as? String
            
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
            
            retweetUsername = nil
            }
  
        isFavorited = dictionary["favorited"] as! Bool
        isRetweeted = dictionary["retweeted"] as! Bool
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let formattedDateTimeStamp = formatter.date(from: timeStampString)!
            
            dateTimeStamp = formatter.string(from: formattedDateTimeStamp)
            
            
            timeStamp = Tweet.formatTweetTimeStamp((formattedDateTimeStamp.timeIntervalSinceNow))
        }
        
        
    }
    
    class func formatTweetTimeStamp(_ tweetTimeStamp: TimeInterval) -> String{
        var time = Int(tweetTimeStamp)
        var timeSinceTweet: Int = 0
        var timeLabelCharacter = ""
        
        time = time * -1
        
        
        if(time < 60) {//Seconds ago
            timeSinceTweet = time
           timeLabelCharacter = "s"
        } else if ((time/60) <= 60) { //Minutes ago
            timeSinceTweet = time / 60
            timeLabelCharacter = "m"
        } else if ((time/60/60) <= 24){ //Hours ago
            timeSinceTweet = time/60/60
            timeLabelCharacter = "h"
        } else if((time/60/60/24) <= 365){ //Days ago
            timeSinceTweet = time/60/60/24
            timeLabelCharacter = "d"
        } else if((time/60/60/24/365) <= 1){ //Years ago
            timeSinceTweet = time/60/60/24/365
            timeLabelCharacter = "y"
        }
        
        return("\(timeSinceTweet)\(timeLabelCharacter)")
    }
    
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
    
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
