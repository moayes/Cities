//
//  AttributionsTableViewController.swift
//  Cities
//
//  Created by Soheil M. Azarpour on 3/26/15.
//  Copyright (c) 2015 Soheil Moayedi Azarpour. All rights reserved.
//

import UIKit

class AttributionsTableViewController: UITableViewController {
  
  @IBAction func linkTapped() {
    let URL: NSURL = NSURL(string: "http://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?src=bkmk")!
    UIApplication.sharedApplication().openURL(URL)
  }
}