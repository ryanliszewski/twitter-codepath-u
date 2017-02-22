//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/20/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]? = nil
    
    //var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        getTweets()
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getTweets(){
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            

            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text!)
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)

            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

    }
    
    
    /*
        TABLEVIEW FUNCTIONS
    */
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets?.count) ?? 0
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.onButtonClickedDelegate = self
        
        
        if tweets != nil {
            cell.tweet = tweets?[indexPath.row]
            cell.selectionStyle = .none
        }
        
        return cell 
    }
    
    
    func onRetweetButtonClicked(tweetCell: TweetCell!) {
        print("Retweet Delegate working!")
        
        
        if(tweetCell.tweet.isRetweeted) {
            TwitterClient.sharedInstance?.unRetweet(tweetID: tweetCell.tweet.id, success: { 
                print("The tweet was successfully retweeted")
                
                tweetCell.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon")
                tweetCell.tweet.retweetCount = tweetCell.tweet.retweetCount - 1
                tweetCell.retweetCountLabel.text = String(tweetCell.tweet.retweetCount)
                tweetCell.tweet.isRetweeted = false
                
            }, failure: { (error: Error) in
                print("There was an error unretweeting")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetID: tweetCell.tweet.id , success: {
                print("The tweet was successfully tweeted")
                
                tweetCell.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
                tweetCell.tweet.retweetCount = tweetCell.tweet.retweetCount + 1
                tweetCell.retweetCountLabel.text = String(tweetCell.tweet.retweetCount)
                tweetCell.tweet.isRetweeted = true
                
            }, failure: { (error: Error) in
                
            })
        }
    }
    
    func onFavoriteButtonClicked(tweetCell: TweetCell!) {
        print("favorite button working")
    }
    
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
        
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
