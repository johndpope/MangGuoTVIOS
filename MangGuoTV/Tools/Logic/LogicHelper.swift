//
//  LogicHelper.swift
//  AppClient
//
//  Created by 陆广庆 on 15/3/17.
//  Copyright (c) 2015年 陆广庆. All rights reserved.
//

import AssetsLibrary
import UIKit

class LogicHelper: NSObject {
   
    // 生成适应屏幕尺寸的全屏图片
    class func makeAssetsImageFillToAssetsProcessController(asset: ALAsset) -> UIImage {
        let image = makeImageFillToAssetsProcessController(asset.fullScreenImage)
        return image
    }
    
    class func makeImageFillToAssetsProcessController(image: UIImage) -> UIImage {
        let imageW = image.size.width
        let imageH = image.size.height
        
        var w: CGFloat = 0
        var h: CGFloat = 0
        
        // 缩放至屏幕宽度
        var scale = dWidth / imageW
        w = dWidth
        h = imageH * scale
        
        // 高度检查
        let maxH = dHeight - AssetsProcessController.kAssetsProcessTopViewHeight - AssetsProcessController.kAssetsProcessBottomViewHeight
        if h > maxH {
            scale = maxH / h
            w = w * scale
            h = maxH
        }
        let img = image.scaleToSize(CGSizeMake(w, h))
        println("\(img.size.width) ,\(img.size.height)")
        return img
    }
    
    class func createWaterFilterImage(image: UIImage) -> UIImage {
        let waterImage = UIImage(named: "logo_text_s")!.imageWithTintColor(UIColor.whiteColor())
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let transparentRect = CGRectMake(8, image.size.height - waterImage.size.height - 8, waterImage.size.width, waterImage.size.height)
        
        waterImage.drawInRect(transparentRect, blendMode: kCGBlendModeOverlay, alpha: 0.7)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    class func shouldAdjustImageRatio(width: CGFloat, height: CGFloat) -> Bool {
//        let scale = dWidth > width ? dWidth / width : width / dWidth
//        let h = height * scale
//        if width > height {
//            return h <= 100
//        } else {
//            return h > dHeight
//        }
        if width > height {
            return height / width < 0.5
        } else {
            return height / width > 1.8
        }
    }
    
    class func uploadImageSize(image: UIImage) -> CGFloat {
        return calSize(image, maxSize: dWidth)
    }
    
    class func uploadThumbnailSize(thumbnail: UIImage) -> CGFloat {
        return calSize(thumbnail, maxSize: kThumbnailMaxSize)
    }
    
    class func uploadAvatarSize(avatar: UIImage) -> CGFloat {
        return calSize(avatar, maxSize: kAvatarMaxSize)
    }
    
    class func uploadAvatarThumbnailSize(avatar: UIImage) -> CGFloat {
        return calSize(avatar, maxSize: kAvatarThumbnailMaxSize)
    }
    
    class func uploadCoverSize(cover: UIImage) -> CGFloat {
        return calSize(cover, maxSize: dWidth)
    }
    
    class func uploadTopicCoverSize(cover: UIImage) -> CGFloat {
        return calSize(cover, maxSize: dWidth)
    }
    
    class func uploadTopicCoverThumbnailSize(thumbnail: UIImage) -> CGFloat {
        return calSize(thumbnail, maxSize: kCoverThumbnailMaxSize)
    }
    
    class func calSize(image: UIImage, maxSize: CGFloat) -> CGFloat {
        let w = image.size.width
        let h = image.size.height
        var size: CGFloat = 0
        if w > h {
            size = (maxSize * h / w) * 2
        } else {
            size = (maxSize * w / h) * 2
        }
        // 处理retina
        if dWidth == 414 {
            size = size / 3
        } else {
            size = size / 2
        }
        return size
    }
    
    
    class func dateConvertToPlanText(date: NSDate) -> String {
        let now = NSDate()
        let nowSec = now.secondSince1970
        let sec = date.secondSince1970
        
        let year = date.year
        let month = date.month
        let day = date.days
        let hour = date.hours
        let min = date.minutes
        
        let yearNow = now.year
        let monthNow = now.month
        let dayNow = now.days
        let hourNow = now.hours
        let minNow = now.minutes
        
        let minute: Double = 60.0
        let interval = nowSec - sec
        if interval <= 10 * minute {
            // 刚刚
            return ApplicationUtils.i18n("date.format.just.now")
        }
        
        if year == yearNow && month == monthNow {
            if dayNow - day == 1 {
                // 昨天
                return ApplicationUtils.i18n("date.format.yesterday")
            }
            if dayNow - day == 2 {
                // 前天
                return ApplicationUtils.i18n("date.format.before.yesterday")
            }
        }
        
        
        if interval <= 60 * minute {
            // x分钟前
            let m = (interval / 60).intValue
            return "\(m)" + ApplicationUtils.i18n("date.format.minute.ago")
        } else if interval <= 24 * 60 * minute {
            // x小时前
            let h = (interval / 60 / 60).intValue
            return "\(h)" + ApplicationUtils.i18n("date.format.hour.ago")
        } else if interval <= 3 * 24 * 60 * minute {
            // x天前
            let d = (interval / 60 / 60 / 24).intValue
            return "\(d)" + ApplicationUtils.i18n("date.format.day.ago")
        } else {
            // 日期
            return date.format("MM-dd")
        }
    }
    
    class func isReleaseVersion() -> Bool {
        return DeviceUtils.appBuildVersion().hasSuffix("1")
    }
    
    
}
