//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 3/3/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: ComposeTweetDelegate!
    var isReply: Bool = false
    var screenName: String!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.becomeFirstResponder()
        
        profileImageView.setImageWith((User.currentUser?.profileUrl)!)
        
        if(isReply){
            textView.text = "@" + screenName
            textCountLabel.text = String(140 - textView.text.characters.count)
        } else {
            textCountLabel.text = "140"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func composeTweetButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate.composeButtonTapped(tweet: self.tweetTextView.text)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textViewDidChange(_ textView: UITextView){
        let length = 140 - textView.text.characters.count
        textCountLabel.text = String(length)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        if(text.characters.count == 0){
            if(textView.text.characters.count != 0){
                return true
            }
        } else if(textView.text.characters.count > 139){
            return false
        }
        return true
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

protocol ComposeTweetDelegate: class {
    func composeButtonTapped(tweet: String!)
}


