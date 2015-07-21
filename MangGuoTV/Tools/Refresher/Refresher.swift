//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

let kRefresherTag = 1000
let kRefresherHeight: CGFloat = 15
let kRefreshImageViewSize: CGFloat = 50
let kStartRefreshImageViewSize: CGFloat = 21
let kContentOffsetKeyPath = "contentOffset"
let kContentSizeKeyPath = "contentSize"

//enum RefresherStyle {
//    case BottomToUp, UpToBottom
//}

class Refresher: UIView {
   
    var scrollView: UIScrollView!
    var refreshing = false
    var shouldRefresh = false
    let refreshImageView = UIImageView(image: UIImage(named: "refresh1"))
    let startRefreshImageView = UIImageView(image: UIImage(named: "ic_alert")?.imageWithTintColor(AppStyleColor))
    let preogress = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var animationImages: [UIImage] = []
    //var style = RefresherStyle.BottomToUp
    var enable = true
    var originOffsetTop: CGFloat = 0
    
    private var action: (() -> ()) = {}
    var nowAction: (() -> ()) = {}
    private var refreshTempAction:(() -> Void) = {}
    
    
    convenience init(action :(() -> ()), frame: CGRect) {
        self.init(frame: frame)
        self.action = action
        self.nowAction = action
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        
    }
    
    deinit {
        var scrollView = superview as? UIScrollView
        scrollView?.removeObserver(self, forKeyPath: kContentOffsetKeyPath, context: &KVOContext)
    }
    
    func setupUI() {
        for i in 2...19 {
            animationImages.append(UIImage(named: "refresh\(i)")!)
        }
        
        refreshImageView.hidden = true
        startRefreshImageView.frame = CGRectMake((dWidth + kRefreshImageViewSize) / 2, (kRefresherHeight - kRefreshImageViewSize) / 2, kStartRefreshImageViewSize, kStartRefreshImageViewSize)
        preogress.frame = CGRectMake((dWidth + kRefreshImageViewSize) / 2, (kRefresherHeight - kRefreshImageViewSize) / 2, kStartRefreshImageViewSize, kStartRefreshImageViewSize)
        preogress.color = AppStyleColor
        preogress.hidesWhenStopped = true
        startRefreshImageView.hidden = true
        insertSubview(refreshImageView, atIndex: 0)
        insertSubview(startRefreshImageView, atIndex: 0)
        insertSubview(preogress, atIndex: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var KVOContext = ""
    override func willMoveToSuperview(newSuperview: UIView!) {
        superview?.removeObserver(self, forKeyPath: kContentOffsetKeyPath, context: &KVOContext)
        if (newSuperview != nil && newSuperview.isKindOfClass(UIScrollView)) {
            self.scrollView = newSuperview as! UIScrollView
            newSuperview.addObserver(self, forKeyPath: kContentOffsetKeyPath, options: .Initial, context: &KVOContext)
        }
    }
    
    //MARK: KVO methods
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if !enable {
            return
        }
        if (self.action == nil) {
            return
        }
        var scrollView = self.scrollView
        var scrollViewContentOffsetY = scrollView.contentOffset.y
        if !refreshing {
            prepareForAnimation(scrollView.contentOffset.y)
        }
        var position: CGFloat = 0
//        if style == .UpToBottom {
//            position = -kRefresherHeight - scrollView.contentInset.top + 10// 触摸结束延迟
//        } else {
//            position = -kRefresherHeight - scrollView.contentInset.top + 30 // 触摸结束延迟
//        }
        position = -kRefresherHeight - scrollView.contentInset.top + 10// 触摸结束延迟
        //println("\(scrollViewContentOffsetY) ---  \(position)")
        if (scrollViewContentOffsetY + self.getNavigationHeight() != 0 && scrollViewContentOffsetY <= position) {
            println("scrollView.dragging=\(scrollView.dragging),refreshing:\(refreshing),shouldRefresh:\(shouldRefresh)")
            if !scrollView.dragging && !refreshing && shouldRefresh {
                if refreshTempAction != nil {
                    self.startAnimation()
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        if scrollView.contentInset.top == 0 {
                            scrollView.contentInset = UIEdgeInsetsMake(self.getNavigationHeight(), 0, scrollView.contentInset.bottom, 0)
                        } else {
                            scrollView.contentInset = UIEdgeInsetsMake(kRefresherHeight + scrollView.contentInset.top, 0, scrollView.contentInset.bottom, 0)
                        }
                        
                    })
                    
                    refreshTempAction()
                    refreshTempAction = {}
                }
            }
            
        } else {
            refreshTempAction = self.action
        }
    }
    
    //MARK: getNavigaition Height -> delete
    func getNavigationHeight() -> CGFloat{
        var vc = UIViewController()
        let ctl: AnyObject = self.getViewControllerWithView(self)
        if ctl is UIViewController {
            vc = ctl as! UIViewController
        }
        
        var top = vc.navigationController?.navigationBar.frame.height
        if top == nil{
            top = 0
        }
        // iOS7
        var offset:CGFloat = 20
        if((UIDevice.currentDevice().systemVersion as NSString).floatValue < 7.0){
            offset = 0
        }
        
        return offset + top!
    }
    
    func getViewControllerWithView(vcView:UIView) -> AnyObject {
        if( (vcView.nextResponder()?.isKindOfClass(UIViewController) ) == true){
            return vcView.nextResponder() as! UIViewController
        }
        
        if(vcView.superview == nil){
            return vcView
        }
        return self.getViewControllerWithView(vcView.superview!)
    }
    
    let refreshPos = (kRefresherHeight - kRefreshImageViewSize) / 2
    func prepareForAnimation(position: CGFloat) {
        startRefreshImageView.hidden = true
        let y = abs(position) - originOffsetTop
        //println("\(position)")
        if y > 0 {
            refreshImageView.hidden = false
            shouldRefresh = y > kRefresherHeight - 10
            refreshImageView.alpha = min(y / kRefresherHeight, 1.0)
            refreshImageView.frame = CGRectMake((dWidth - kRefreshImageViewSize) / 2, (kRefresherHeight - kRefreshImageViewSize) / 2, kRefreshImageViewSize, kRefreshImageViewSize)
            if y > kRefresherHeight {
                startRefreshImageView.hidden = false
                shouldRefresh = true
            }
        } else {
            refreshImageView.hidden = true
            shouldRefresh = false
        }
//        if style == .UpToBottom {
//            if y > 0 {
//                refreshImageView.hidden = false
//                shouldRefresh = y > kRefresherHeight - 10
//                refreshImageView.alpha = min(y / kRefresherHeight, 1.0)
//                refreshImageView.frame = CGRectMake((dWidth - kRefreshImageViewSize) / 2, (kRefresherHeight - kRefreshImageViewSize) / 2, kRefreshImageViewSize, kRefreshImageViewSize)
//                if y > kRefresherHeight {
//                    startRefreshImageView.hidden = false
//                    shouldRefresh = true
//                }
//            } else {
//                refreshImageView.hidden = true
//                shouldRefresh = false
//            }
//        } else {
//            if y > 0 {
//                var imageY = kRefresherHeight + kRefreshImageViewSize - y * 1.7
//                if imageY < refreshPos + kRefresherHeight {
//                    refreshImageView.hidden = false
//                } else {
//                    refreshImageView.hidden = true
//                }
//                if imageY < refreshPos {
//                    imageY = refreshPos
//                    startRefreshImageView.hidden = false
//                    shouldRefresh = true
//                }
//                refreshImageView.frame = CGRectMake((dWidth - kRefreshImageViewSize) / 2, imageY, kRefreshImageViewSize, kRefreshImageViewSize)
//            } else {
//                refreshImageView.hidden = true
//                shouldRefresh = false
//            }
//        }
        
    }
    
    func startAnimation() {
        //Logger.debug("startAnimation")
        preogress.startAnimating()
        refreshImageView.frame = CGRectMake((dWidth - kRefreshImageViewSize) / 2, refreshPos, kRefreshImageViewSize, kRefreshImageViewSize)
        refreshing = true
        shouldRefresh = false
        startRefreshImageView.hidden = true
        var duration: Double = Double(animationImages.count) * 0.1
        refreshImageView.animationDuration = duration
        refreshImageView.animationRepeatCount = 0
        refreshImageView.animationImages = animationImages
        refreshImageView.startAnimating()
    }
    
    func stopAnimation() {
        //Logger.debug("stopAnimation")
        preogress.stopAnimating()
        refreshImageView.stopAnimating()
        //let top = scrollView.contentInset.top - kRefresherHeight
        //println("\(top), \(self.scrollView.contentInset.top)")
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.scrollView.contentInset = UIEdgeInsetsMake(self.originOffsetTop, 0, self.scrollView.contentInset.bottom, 0)
            self.refreshImageView.alpha = 0.0
        }) { (finished) -> Void in
            self.refreshImageView.hidden = true
            self.refreshImageView.alpha = 1.0
        }
        refreshing = false
        startRefreshImageView.hidden = true
        
    }
    
}
