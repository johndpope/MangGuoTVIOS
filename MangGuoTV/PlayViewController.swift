//
//  PlayViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/18.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController ,UINavigationControllerDelegate{

    static var playViewID = "PlayViewController"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(animated: Bool) {
//        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("navBack"))
//    }

    @IBAction func navBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
