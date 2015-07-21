//
//  MoreVideoViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/18.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class MoreVideoViewController: UIViewController {
    static var moreId = "MoreVideoViewController"
    var pageViewController : UIPageViewController?
    var channelInfo = ChannelModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //create pageview
        if let pageViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageVIewController") as? UIPageViewController
        {
            self.pageViewController =  pageViewController
            //self.pageViewController?.dataSource = self
            if var channelView = self.storyboard?.instantiateViewControllerWithIdentifier("channel") as? ChannelViewController {
                channelView.channelId = "\(channelInfo.channelId)"
                channelView.type = channelInfo.type
                self.pageViewController?.setViewControllers([channelView], direction:UIPageViewControllerNavigationDirection.Forward, animated: false, completion: { (finished) -> Void in
                    
                })
                
                self.pageViewController?.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)
                self.addChildViewController(self.pageViewController!)
                self.view.addSubview(self.pageViewController!.view!)
                
                self.pageViewController!.didMoveToParentViewController(self);
            }
        }
    }
    @IBAction func navBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
