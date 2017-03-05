//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/20/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetCellDelegate, ComposeTweetDelegate {

    
    var isMoreDataLoading: Bool = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]! = nil
    
    var nextTweetID: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    //var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Image-1"))
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

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
            self.refreshControl.endRefreshing()

            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func getMoreTweets(){
        
        TwitterClient.sharedInstance?.getMoreTweetsFromHomeTimeLine(sinceID: nextTweetID, success: { (newTweets: [Tweet]) in
            
            self.tweets.append(contentsOf: newTweets)
            self.loadingMoreView?.stopAnimating()
            self.isMoreDataLoading = false 
            
            self.tableView.reloadData()
            
        }, failure: { (error:Error) in
            print("Error getting new tweets")
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getTweets()
        //refreshControl.endRefreshing()
        
    }
        
        
    /*
        TABLEVIEW FUNCTIONS
    */
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tweets != nil){
            return self.tweets.count
        }else {
            return 0
        }
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
    
    /*
        
        SCROLLVIEW FUNCTIONS
 
    */
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                isMoreDataLoading = true
                
                nextTweetID = self.tweets[self.tweets.count - 1].id
                
                getMoreTweets()
                
                
                
                
                // ... Code to load more results ...
            }
        }
    }
    
    
    /*
 
        RETWEET AND FAVORITE BUTTON FUNCTION HANDLERS
 
    */
    
    func onRetweetButtonClicked(tweetCell: TweetCell!) {

        if(tweetCell.tweet.isRetweeted) {
            TwitterClient.sharedInstance?.unRetweet(tweetID: tweetCell.tweet.id, success: { 
                
                tweetCell.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon")
                tweetCell.tweet.retweetCount = tweetCell.tweet.retweetCount - 1
                tweetCell.retweetCountLabel.text = String(tweetCell.tweet.retweetCount)
                tweetCell.tweet.isRetweeted = false
                self.tableView.reloadData()
            }, failure: { (error: Error) in
                print("There was an error unretweeting")
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetID: tweetCell.tweet.id , success: {
        
                tweetCell.retweetButton.imageView?.image = #imageLiteral(resourceName: "retweet-icon-green")
                tweetCell.tweet.retweetCount = tweetCell.tweet.retweetCount + 1
                tweetCell.retweetCountLabel.text = String(tweetCell.tweet.retweetCount)
                tweetCell.tweet.isRetweeted = true
                self.tableView.reloadData()
            }, failure: { (error: Error) in
                print("The was an error retweeting")
            })
        }
    }
    
    func onFavoriteButtonClicked(tweetCell: TweetCell!) {
        
        if(tweetCell.tweet.isFavorited){
            TwitterClient.sharedInstance?.unFavorite(tweetID: tweetCell.tweet.id, success: { 
                
                tweetCell.favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon")
                tweetCell.tweet.favoritesCount = tweetCell.tweet.favoritesCount - 1
                tweetCell.favoritesCountLabel.text = String(tweetCell.tweet.favoritesCount)
                tweetCell.tweet.isFavorited = false
                self.tableView.reloadData()
            }, failure: { (error: Error) in
                print("There was an error unfavoriting")
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetID: tweetCell.tweet.id, success: { 
                tweetCell.favoriteButton.imageView?.image = #imageLiteral(resourceName: "favor-icon-red")
                tweetCell.tweet.favoritesCount = tweetCell.tweet.favoritesCount + 1
                tweetCell.favoritesCountLabel.text = String(tweetCell.tweet.favoritesCount)
                tweetCell.tweet.isFavorited = true
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print("There was an error favoriting ")
            })
        }
    }
    
    func onProfileImageClicked(tweetCell: TweetCell!) {
//        
//        TwitterClient.sharedInstance?.getUserProfile(screenName: (tweetCell.tweet.user?.screenName)!, success: { (user: User) in
//            self.shouldPerformSegue(withIdentifier: "ProfileViewSegue", sender: user)
//         
//        }, failure: { (error: Error) in
//            print(error.localizedDescription)
//        })
    
    }
    
    func onReplyButtonClicked(tweetCell: TweetCell!){
        
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
        print("test")
    }
    
    func composeButtonTapped(tweet: String!){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let escapedTweet = tweet.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        TwitterClient.sharedInstance?.composeTweet(tweet: escapedTweet!, success: { (tweet: Tweet) in
            self.tweets.insert(tweet, at: 0)
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }, failure: { (error: Error) in
            
            print(error.localizedDescription)
            
        })
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ComposeTweetSegue"){
            let navigationController = segue.destination as! UINavigationController
            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
            composeTweetViewController.delegate = self
        } else if(segue.identifier == "TweetDetailSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let viewController = segue.destination as! TweetDetailViewController
            viewController.tweet = tweet
            viewController.delegate = self
            viewController.tweetCell = cell as! TweetCell
        } else if(segue.identifier == "ProfileViewSegue"){
            
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let viewController = segue.destination as! ProfileViewController
            viewController.user = tweet.user
            
        } else if(segue.identifier == "ReplyComposeSegue"){
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let navigationController = segue.destination as! UINavigationController
            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
            
            composeTweetViewController.isReply = true
            composeTweetViewController.screenName = tweet.user?.screenName
            

        }
    }
}
