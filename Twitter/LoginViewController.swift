//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 2/19/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    var window: UIWindow?
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        window = UIWindow(frame: UIScreen.main.bounds)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onLoginButton(_ sender: Any) {

        let client = TwitterClient.sharedInstance
        
        client?.login(success: { 
            print("i've logged in")
            //self.loadTabBarController()
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("Error:\(error.localizedDescription)")
        })
    }
    
    func loadTabBarController(){
        let homeTimeLineNavigationController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        
        let profileTimeLineNavigationController = storyBoard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        
        
        homeTimeLineNavigationController.tabBarItem.image = #imageLiteral(resourceName: "home-icon")
        homeTimeLineNavigationController.tabBarItem.title = "Home"
        
        profileTimeLineNavigationController.tabBarItem.image = #imageLiteral(resourceName: "account-icon")
        profileTimeLineNavigationController.tabBarItem.title = "Me"
        
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeTimeLineNavigationController, profileTimeLineNavigationController]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
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
