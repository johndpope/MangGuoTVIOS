//
//  AppDelegate.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var screenWidth :CGFloat = 0
//    static var urlHost = "http://mobile.api.hunantv.com/"
//    var channelsUrl = "http://mobile.api.hunantv.com/channel/getList?userId=&osVersion=4.4&device=sdk&appVersion=4.3.4&ticket=&channel=360dev&mac=i000000000000000&osType=android"
//    static var commondUrl = "userId=&osVersion=4.4&device=sdk&appVersion=4.3.4&ticket=&channel=360dev&mac=i000000000000000&osType=android"
    static var channels = [ChannelModel]()
     var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        AppDelegate.screenWidth = UIScreen.mainScreen().bounds.size.width
        loadChannelsData()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func loadChannelsData() -> (Bool,String) {
        var strErr = ""
        var result = false
        
        var req = NSMutableURLRequest(URL:  NSURL(string: urlHost + allChannelUrl + commondUrl)!)
        req.timeoutInterval = 5.0
        req.HTTPMethod = "GET"
        req.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        //req.setValue("ios", forHTTPHeaderField: "User-Agent")
        var err:NSError?
        let data = NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: &err)
        
        if err != nil {
            if let s = err?.localizedDescription {
                strErr = s
            }
            return  ( result , strErr )
        }
        
        let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        println("data = \(str)")
        if let d = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil)  as?  NSDictionary
        {
            if let code: AnyObject = d.valueForKey("err_code"){
                
                switch code as! Int {
                case 200:
                    
                    var info: AnyObject? = d.valueForKey("data")
                    if let lockchannels = info?.valueForKey("lockedChannel")  as? NSArray{
                        
                        
                        for (key,val) in enumerate(lockchannels) {
                            let dict = val as! NSDictionary
                            var channel = ChannelModel()
                            
                            if  let id = dict.valueForKey("channelId") as? Int {
                                channel.channelId = id
                            }
                            
                            if  let name = dict.valueForKey("channelName") as? String {
                                channel.channelName = name
                            }
                            if  let icon = dict.valueForKey("iconUrl") as? String {
                                channel.iconUrl = icon
                            }
                            if  let hasMore = dict.valueForKey("hasMore") as? String {
                                channel.hasMore = hasMore
                            }
                            if  let libId = dict.valueForKey("libId") as? Int {
                                channel.libId = libId
                            }
                            if  let type = dict.valueForKey("type") as? String {
                                channel.type = type
                            }
                            AppDelegate.channels.append(channel)
                            
                        }
                    }
                    if let normalChannel = info?.valueForKey("normalChannel")  as? NSArray{
                        
                        
                        for (key,val) in enumerate(normalChannel) {
                            
                            let dict = val as! NSDictionary
                            var channel = ChannelModel()
                            if  let id = dict.valueForKey("channelId") as? Int {
                                channel.channelId = id
                            }
                            
                            if  let name = dict.valueForKey("channelName") as? String {
                                channel.channelName = name
                            }
                            if  let icon = dict.valueForKey("iconUrl") as? String {
                                channel.iconUrl = icon
                            }
                            if  let hasMore = dict.valueForKey("hasMore") as? String {
                                channel.hasMore = hasMore
                            }
                            if  let libId = dict.valueForKey("libId") as? Int {
                                channel.libId = libId
                            }
                            if  let type = dict.valueForKey("type") as? String {
                                channel.type = type
                            }
                            AppDelegate.channels.append(channel)
                            
                        }
                    }
                    strErr = ""
                    result = true
                    
                default :
                    if let err = d.valueForKey("err_msg") as? String{
                        strErr = "获取频道列表失败。\(err)"
                    }
                    result = false
                }
            }

        }
        else
        {
            strErr = "获取视频列表失败"
        }
        return  (result,strErr)
        
    }

}

