//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class PathManager: NSObject {

    // 生成上传视频本地文件夹
    class func uploadVideoFolder() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
        let folder = path.stringByAppendingPathComponent("video")
        var fileManager = NSFileManager.defaultManager()
        var isDir = ObjCBool(false)
        var exist = fileManager.fileExistsAtPath(folder, isDirectory: &isDir)
        if !isDir || !exist {
            fileManager.createDirectoryAtPath(folder, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        return folder
    }
    
    // 生成上传图片本地文件夹
    class func uploadImageFolder() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
        let folder = path.stringByAppendingPathComponent("image")
        var fileManager = NSFileManager.defaultManager()
        var isDir = ObjCBool(false)
        var exist = fileManager.fileExistsAtPath(folder, isDirectory: &isDir)
        if !isDir || !exist {
            fileManager.createDirectoryAtPath(folder, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        return folder
    }
    
    // 生成下载文件地址
    class func downloadTmpPath(url: String) -> String {
        let folder = NSTemporaryDirectory()
        let path = folder.stringByAppendingPathComponent(url.md5)
        return path
    }
    
    static var size: Double = 0
    
    class func tmpFileSize() -> Double {
        size = 0
        let path = NSTemporaryDirectory()
        let cacheSize = sizeAtFolder(path)
        return cacheSize
    }
    
    
    class func sizeAtFolder(folderPath: String) -> Double {
        var manager = NSFileManager.defaultManager()
        var array = manager.contentsOfDirectoryAtPath(folderPath, error: nil)!
        for filePath in array{
            var fullPath:String = folderPath.stringByAppendingPathComponent(filePath as! String)
            var isDir = ObjCBool(true)
            if  manager.fileExistsAtPath(fullPath, isDirectory:&isDir) {
                if isDir.boolValue {
                    //println("folderPath is dict:\(fullPath)")
                    sizeAtFolder(fullPath)
                }else{
                    var fileAttributeDic = manager.attributesOfItemAtPath(fullPath, error: nil)
                    var newfileAttributeDic:NSDictionary = fileAttributeDic! as NSDictionary
                    size += Double(newfileAttributeDic.fileSize())
                }
            }else{
                var fileAttributeDic = manager.attributesOfItemAtPath(fullPath, error: nil)
                var newfileAttributeDic:NSDictionary = fileAttributeDic! as NSDictionary
                size += Double(newfileAttributeDic.fileSize())
            }
        }
        return size
    }
    
    class func clearTmpFiles() {
        let path = NSTemporaryDirectory()
        let fileManager = NSFileManager.defaultManager()
        if let contents = fileManager.contentsOfDirectoryAtPath(NSTemporaryDirectory(), error: nil) {
            for item in contents {
                let fullPath = path.stringByAppendingPathComponent(item as! String)
                fileManager.removeItemAtPath(fullPath, error: nil)
            }
        }
        
        
    }
    

}




 