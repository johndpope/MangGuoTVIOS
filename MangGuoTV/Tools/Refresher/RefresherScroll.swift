//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit


enum RefresherAnimationStatus {
    case PullAnimation, LoadingAnimation
}

extension UIScrollView: UIScrollViewDelegate {
    
    var refresher: Refresher? {
        get {
            var refresher = viewWithTag(kRefresherTag)
            return refresher as? Refresher
        }
    }

    func addRefreshAction(action :(() -> Void)) {
        
        self.alwaysBounceVertical = true
        if self.refresher == nil {
            var refresher = Refresher(action: action,frame: CGRectMake(0, -kRefresherHeight, frame.size.width, kRefresherHeight))
            refresher.scrollView = self
            refresher.originOffsetTop = contentInset.top
            refresher.tag = kRefresherTag
            //refresher.backgroundColor = UIColor.redColor()
            self.insertSubview(refresher, atIndex: 0)
        }
    }
    
    func sendRefreshToBack() {
        if let r = refresher {
            r.scrollView.sendSubviewToBack(r)
        }
    }
    
    func startRefresh() {
        self.scrollRectToVisible(CGRectMake(0, -kRefresherHeight, refresher!.frame.width, refresher!.frame.height), animated: true)
    }
    
    func stopRefresh() {
        if var refresher = self.viewWithTag(kRefresherTag) as? Refresher {
            refresher.stopAnimation()
        }
    }
    
    func disableRefresh() {
        if let r  = refresher {
            r.hidden = true
            r.enable = false
        }
        
    }
    
    func enableRefresh() {
        if let r  = refresher {
            r.hidden = false
            r.enable = true
        }
    }
    
}
