//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ryan Liszewski on 3/5/18.
//  Copyright © 2018 Smiley. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView


class ProfileViewController: UIViewController {
	
	var user: User?
	var stretchyHeader: GSKStretchyHeaderView!
	
	@IBOutlet weak var tableview: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if user == nil {
			user = User._currentUser
		}
		
		self.stretchyHeader = GSKStretchyHeaderView(frame: CGRect(x: 0, y: 0, width: tableview.frame.size.width, height: 200))
		stretchyHeader.backgroundColor = #colorLiteral(red: 0.4763481021, green: 0.4931288958, blue: 0.8382745385, alpha: 1)
		tableview.addSubview(stretchyHeader)
	}
	
}
