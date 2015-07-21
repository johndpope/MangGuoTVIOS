//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

enum AppTutorialsType: String {
    
    // 长按缩略图移除选中图片
    case AssetsProcessLongPressRemoveAsset = "AssetsProcessLongPressRemoveAsset"
    // 长按标签提示
    case AssetsProcessLongPressTag = "AssetsProcessLongPressTag"
    
}

// 新手提示
class AppTutorials: NSObject {
   
    class func shouldShowTutorials(type: AppTutorialsType) -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let hasShown = userDefaults.objectForKey(type.rawValue) as? Bool {
            if hasShown {
                return false
            }
        }
        return true
    }
    
    class func hasShown(type: AppTutorialsType) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(true, forKey: type.rawValue)
        userDefaults.synchronize()
    }
}




