//
//  ApplicationUtils.swift
//  AppFramework
//
//  Created by 陆广庆 on 15/3/1.
//  Copyright (c) 2015年 陆广庆. All rights reserved.
//

import UIKit

//        系统自带中文字体
//        Heiti SC
//        STHeitiSC-Light
//        STHeitiSC-Medium
//
//        Heiti TC
//        STHeitiTC-Light
//        STHeitiTC-Medium
//
//        Hiragino Kaku Gothic ProN
//        HiraKakuProN-W3
//        HiraKakuProN-W6
//
//        Hiragino Mincho ProN
//        HiraMinProN-W3
//        HiraMinProN-W6


class ApplicationUtils: NSObject {
   
    class func appVersion() -> String {
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        return nsObject as! String
    }
    
    class func i18n(code: String) -> String {
        return NSLocalizedString(code, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    class func isTopViewController(ctl: UIViewController) -> Bool {
        let top = topViewController()
        return top == ctl
    }
    
    class func topViewController() -> UIViewController {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        return topViewController(app.window!.rootViewController!)
    }
    
    class func loadNib(name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
    
    class func loadNibForView(name: String) -> UIView {
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)[0] as! UIView
    }
    
    class func loadNibForView(name: String, index: Int) -> UIView {
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)[index] as! UIView
    }
    
    class func topViewController(rootViewController: UIViewController) -> UIViewController {
        if let presented = rootViewController.presentedViewController {
            if presented is UINavigationController {
                let navi = presented as! UINavigationController
                let lastViewController = navi.viewControllers.last as! UIViewController
                return topViewController(lastViewController)
            }
            return topViewController(presented)
        } else {
            return rootViewController
        }
    }

    class func showAlert(message: String!) {
        var alert = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: i18n("app.confirm"))
        alert.show()
    }
    
    class func currentViewControllerOnWindow() -> UIViewController? {
        var result: UIViewController?
        var window = UIApplication.sharedApplication().keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.sharedApplication().windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin as? UIWindow
                    break
                }
            }
        }
        
        if let views = window?.subviews {
            if !views.isEmpty {
                let frontView: AnyObject? = window?.subviews[0]
                let nextResponder = frontView?.nextResponder()
                if nextResponder is UIViewController {
                    result = nextResponder as? UIViewController
                } else {
                    result = window?.rootViewController
                }
            }
        }
        return result
    }
    
}

extension UIViewController {

    func setLightStatusBar() {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    func setDefaultStatusBar() {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
   
}











