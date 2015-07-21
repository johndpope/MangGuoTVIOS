//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

let kImageCachePrefix = "CacheImage_"
let ImageLoaderCache = NSCache()

class ImageLoader: NSObject {
    
    var round = false
    var borderColor: UIColor?
    var borderWidth: CGFloat?
    
    
    init(round: Bool = false, borderColor: UIColor? = AppStyle.appLightBgColor(), borderWidth: CGFloat? = 2.0) {
        super.init()
        self.round = round
        if borderColor != nil {
            self.borderColor = borderColor
        }
        if borderWidth != nil {
            self.borderWidth = borderWidth
        }
    }
    
    func loadImage(#url: String, completion: (image: UIImage?, remote: Bool) -> ()) {
        if url.isBlankByTrimming() {
            completion(image: nil, remote: false)
            return
        }
        if let image = ImageLoaderCache.objectForKey(self.cacheKey(url)) as? UIImage {
            completion(image: image, remote: false)
            return
        }
        Async.background { () -> Void in
            let fileManager = NSFileManager.defaultManager()
            // 本地上传照片
            if url.hasPrefix(PathManager.uploadImageFolder()) || url.hasPrefix(PathManager.uploadVideoFolder()) {
                if fileManager.fileExistsAtPath(url) {
                    let image = self.processImage(UIImage(contentsOfFile: url)!)
                    ImageLoaderCache.setObject(image, forKey: self.cacheKey(url))
                    Async.main({ () -> Void in
                        completion(image: image, remote: false)
                    })
                    return
                }
            }
            // 已下载
            let filePath = PathManager.downloadTmpPath(url)
            if fileManager.fileExistsAtPath(filePath) {
                let image = self.processImage(UIImage(contentsOfFile: filePath)!)
                ImageLoaderCache.setObject(image, forKey: self.cacheKey(url))
                Async.main({ () -> Void in
                    completion(image: image, remote: false)
                })
                return
            }
            
            
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "GET"
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            var session = NSURLSession(configuration: sessionConfig)
            var task = session.downloadTaskWithRequest(request, completionHandler: { data, response, error in
                if error != nil {
                    Async.main({ () -> Void in
                        completion(image: nil, remote: false)
                    })
                    return
                }
                if let imageData = NSData(contentsOfURL: data) {
                    var image = UIImage(data: imageData)
                    if image != nil {
                        imageData.writeToFile(filePath, atomically: true)
                        let img = self.processImage(image!)
                        ImageLoaderCache.setObject(img, forKey: self.cacheKey(url))
                        Async.main({ () -> Void in
                            completion(image: img, remote: true)
                        })
                    } else {
                        completion(image: nil, remote: true)
                    }
                    
                } else {
                    completion(image: nil, remote: true)
                }
            })
            task.resume()
            
        }
    }
    
    private func cacheKey(url: String) -> String {
        let r = round ? "Y" : "N"
        return kImageCachePrefix + url + r
    }
    
    private func processImage(image: UIImage) -> UIImage {
        var img = image
        if round {
            if borderColor != nil && borderWidth != nil {
                img = image.maskWithRound(borderWidth!, borderColor: borderColor!)
            } else {
                img = image.maskWithRound()
            }
        }
        return img
    }
    
}
