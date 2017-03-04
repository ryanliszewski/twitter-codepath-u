//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 3/3/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    
    var delegate: ComposeTweetDelegate!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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


