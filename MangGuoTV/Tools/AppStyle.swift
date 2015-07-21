//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//
import UIKit

var AppStyleColor = UIColor.blueColor()

class AppStyle: NSObject {
    
    class func configureGlobalStyle(window: UIWindow?) {
        window?.backgroundColor = UIColor.whiteColor()
        AppStyleColor = appTintColor()
        //let trans = UIImage(named: "trans")
        let white = UIImage(named: "white")
        let defaultFont = appFont()
        let largeSize = fontSizeLarge()
        let normalSize = fontSizeNormal()
        let smallSize = fontSizeSmall()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        //UINavigationBar.appearance().setBackgroundImage(white?.imageWithTintColor(AppStyleColor), forBarMetrics: UIBarMetrics.Default)
        //UINavigationBar.appearance().shadowImage = UIImage()
        
        // 标题颜色
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: defaultFont, size: largeSize + 1)!, NSForegroundColorAttributeName : AppStyleColor]
        // 按钮颜色
        UINavigationBar.appearance().tintColor = AppStyleColor
        
        // 背景颜色
        //UINavigationBar.appearance().barTintColor = appNaviTintColor()
        //UINavigationBar.appearance().backgroundColor = AppStyleColor
        
        //UINavigationBar.appearance().translucent = false
        
        
        //UITabBar.appearance().backgroundColor = UIColor(white: 0.95, alpha: 0.98)
        //UITabBar.appearance().backgroundImage = trans
        //UITabBar.appearance().shadowImage = trans
        
        //let attrNormal: [String : AnyObject] = [NSForegroundColorAttributeName : appLayerContentColor(), NSFontAttributeName : UIFont(name: blodFont, size: normalSize)!]
        //let attrSel: [String : AnyObject] = [NSForegroundColorAttributeName : AppStyleColor, NSFontAttributeName : UIFont(name: blodFont, size: normalSize)!]
        //UITabBarItem.appearance().setTitleTextAttributes(attrNormal, forState: .Normal)
        //UITabBarItem.appearance().setTitleTextAttributes(attrSel, forState: .Selected)
        UITabBar.appearance().tintColor = AppStyleColor
        //UILabel.appearance().font = UIFont(name: defaultFont, size: normalSize)
        UIButton.appearance().titleLabel?.font = UIFont(name: defaultFont, size: largeSize)
        UIButton.appearance().tintColor = AppStyleColor
        //UITextField.appearance().font = UIFont(name: defaultFont, size: normalSize)
        //UITextView.appearance().font = UIFont(name: defaultFont, size: normalSize)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont(name: defaultFont, size: largeSize)!], forState: .Normal)
        
        
    }
    
    class func appFont() -> String {
        //return "HiraKakuProN-W3"
        return "Verdana"
    }
    
    class func appFontBold() -> String {
        //return "HiraKakuProN-W3"
        return "Verdana-Bold"
    }
    
    // 淡色字体颜色
    class func appLightTextColor() -> UIColor {
        let c: CGFloat = 151
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    // 深色字体颜色
    class func appDarkTextColor() -> UIColor {
        let c: CGFloat = 31
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    // 名字颜色
    class func appNameTextColor() -> UIColor {
        let c: CGFloat = 31
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    // Tint颜色
    class func appTintColor() -> UIColor {
        //return UIColor.color(255, g: 93, b: 163, a: 1.0) // 粉色
        //return UIColor.color(67, g: 215, b: 179, a: 1.0) // 糖果绿
        return UIColor.color(175, g: 50, b: 150, a: 1.0) // 紫色
    }
    
    class func appNaviTintColor() -> UIColor {
        //return UIColor.color(255, g: 93, b: 163, a: 1.0) // 粉色
        //return UIColor.color(67, g: 215, b: 179, a: 1.0) // 糖果绿
        return UIColor.color(211, g: 25, b: 161, a: 1.0) // 紫色
    }
    
    // 分割线颜色
    class func appDarkSpliterColor() -> UIColor {
        return UIColor.color(213, g: 213, b: 213, a: 1.0)
    }
    
    // 分割线颜色
    class func appLightSpliterColor() -> UIColor {
        let c: CGFloat = 239
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    class func appLayerColor() -> UIColor {
        let c: CGFloat = 247
        return UIColor.color(c, g: c, b: c, a: 0.95)
    }
    
    class func appLayerContentColor() -> UIColor {
        let c: CGFloat = 171
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    
    class func appBgColor() -> UIColor {
        let c: CGFloat = 231
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    
    class func appLightBgColor() -> UIColor {
        let c: CGFloat = 255
        return UIColor.color(c, g: c, b: c, a: 1.0)
    }
    
    class func appTagWordColor() -> UIColor {
        return UIColor.color(0, g: 200, b: 255, a: 1.0)
        //return UIColor.color(255, g: 200, b: 50, a: 1.0)
    }
    
    class func appTagLocationColor() -> UIColor {
        return UIColor.color(255, g: 150, b: 0, a: 1.0)
    }
    
    class func appTagTopicColor() -> UIColor {
        return UIColor.color(255, g: 150, b: 0, a: 1.0)
    }
    
    class func appTagCustomColor() -> UIColor {
        return UIColor(white: 1, alpha: 1)
    }
    
    
    class func fontSizeLarge() -> CGFloat {
        return 16.0
    }
    
    class func fontSizeNormal() -> CGFloat {
        return 14.0
    }
    
    class func fontSizeSmall() -> CGFloat {
        return 12.0
    }
    
    
    
    class func attributedText(text: String, font: UIFont, color: UIColor = AppStyle.appDarkTextColor()) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, text.length)
        attributedString.addAttribute(NSFontAttributeName, value: font, range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        return attributedString
    }
    
    class func attributedLineSpacingText(text: String, font: UIFont, color: UIColor = AppStyle.appDarkTextColor()) -> NSMutableAttributedString {
        let attributedString = attributedText(text, font: font, color: color)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let range = NSMakeRange(0, text.length)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        return attributedString
    }
    
    class func attributedBlodText(text: String, fontSize: CGFloat, color: UIColor = AppStyle.appDarkTextColor()) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, text.length)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: appFont(), size: fontSize)!, range: range)
        attributedString.addAttribute(NSStrokeWidthAttributeName, value: 3.0, range: range)
        attributedString.addAttribute(NSStrokeColorAttributeName, value: color, range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        return attributedString
    }
    
    
    
    
}

