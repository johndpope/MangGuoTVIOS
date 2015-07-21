//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit
import Accelerate

class ImageUtils: NSObject {
    
//    class func loadRemoteImage(url: String, completion: (image: UIImage?) -> ()) {
//        
//        var fileName: String?
//        var finalPath: NSURL?
//        //let destination = Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
//        download(.GET, url) { (temporaryURL, response) -> (NSURL) in
//            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
//                
//                fileName = response.suggestedFilename!
//                finalPath = directoryURL.URLByAppendingPathComponent(fileName!)
//                return finalPath!
//            }
//            
//            return temporaryURL
//            }.response { (request, response, data, error) -> Void in
//                if error != nil {
//                    println("error: \(error?.description)")
//                }
//                
//                if finalPath != nil {
//                    if let data = NSData(contentsOfFile: finalPath!.path!) {
//                        if let image = UIImage(data: data) {
//                            completion(image: image)
//                        }
//                    }
//                }
//        }
//    }
    
}

extension UIImage {
    
    var data: NSData {
        let data = UIImageJPEGRepresentation(self, 1.0)
        return data
    }
    
    
    
    func compressToQuality(quality: CGFloat) -> UIImage {
        let q = min(max(quality, 0), 1)
        let data = UIImageJPEGRepresentation(self, q)
        return UIImage(data: data)!
    }
    
    func imageWithTintColor(tintColor: UIColor) -> UIImage {
        return imageWithTintColor(tintColor, blendMode: kCGBlendModeDestinationIn)
    }
    
    func imageWithGradientTintColor(tintColor: UIColor) -> UIImage {
        return imageWithTintColor(tintColor, blendMode: kCGBlendModeOverlay)
    }
    
    
    func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRectMake(0, 0, size.width, size.height)
        UIRectFill(bounds)
        
        drawInRect(bounds, blendMode: blendMode, alpha: 1.0)
        
        if blendMode.value != kCGBlendModeDestinationIn.value {
            drawInRect(bounds, blendMode: kCGBlendModeDestinationIn, alpha: 1.0)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    /*!
    保持图片比例裁剪
    */
    func clipToSize(size: CGSize) -> UIImage {
        let clippedImage = Toucan(image: self).resize(size, fitMode: Toucan.Resize.FitMode.Clip).image
        return clippedImage
    }
    
    /*!
    不限比例裁剪至相应尺寸
    */
    func cropToSize(size: CGSize) -> UIImage {
        let croppedImage = Toucan(image: self).resize(size, fitMode: Toucan.Resize.FitMode.Crop).image
        return croppedImage
    }
    
    /*!
    缩放至相应尺寸
    */
    func scaleToSize(size: CGSize) -> UIImage {
        let scaledImage = Toucan(image: self).resize(size, fitMode: Toucan.Resize.FitMode.Scale).image
        return scaledImage
    }
    
    /*!
    裁剪某个区域
    */
    func cropWithRect(rect: CGRect) -> UIImage {
        let scale = max(self.scale, 1.0)
        let scaledBounds = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale)
        let imageRef = CGImageCreateWithImageInRect(CGImage, scaledBounds)
        let croppedImage = UIImage(CGImage: imageRef, scale: scale, orientation: imageOrientation)
        //CGImageRelease(imageRef)
        return croppedImage!
    }
    
    /*!
    椭圆
    */
    func maskWithEllipse() -> UIImage {
        let image = Toucan(image: self).maskWithEllipse().image
        return image
    }
    
    /*!
    椭圆带边框
    */
    func maskWithEllipse(borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let image = Toucan(image: self).maskWithEllipse(borderWidth: borderWidth, borderColor: borderColor).image
        return image
    }
    
    /*!
    圆角
    */
    func maskWithRoundCorner(cornerRadius: CGFloat) -> UIImage {
        let image = Toucan(image: self).maskWithRoundedRect(cornerRadius: cornerRadius).image
        return image
    }
    
    /*!
    圆角带边框
    */
    func maskWithRoundCorner(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let image = Toucan(image: self).maskWithRoundedRect(cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor).image
        return image
    }
    
    /*!
    圆形
    */
    func maskWithRound() -> UIImage {
        let cropTo = min(self.size.width, self.size.height)
        let image = cropToSize(CGSizeMake(cropTo, cropTo))
        return image.maskWithRoundCorner(cropTo / 2)
    }
    
    /*!
    圆形带边框
    */
    func maskWithRound(borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let cropTo = min(self.size.width, self.size.height)
        let image = cropToSize(CGSizeMake(cropTo, cropTo))
        return image.maskWithRoundCorner(cropTo / 2, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    /*!
    图形遮罩
    */
    func maskWithImage(mask: UIImage) -> UIImage {
        let image = Toucan(image: self).maskWithImage(maskImage: mask).image
        return image
    }
   
    
    func fixImageOrientation() -> UIImage {
        
        if imageOrientation == UIImageOrientation.Up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransformIdentity
        
        switch imageOrientation {
        case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
        case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
        case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
        case UIImageOrientation.Up, UIImageOrientation.UpMirrored:
            break
        default:
            break
        }
        
        switch imageOrientation {
        case UIImageOrientation.UpMirrored, UIImageOrientation.DownMirrored:
            CGAffineTransformTranslate(transform, size.width, 0)
            CGAffineTransformScale(transform, -1, 1)
            break
        case UIImageOrientation.LeftMirrored, UIImageOrientation.RightMirrored:
            CGAffineTransformTranslate(transform, size.height, 0)
            CGAffineTransformScale(transform, -1, 1)
        case UIImageOrientation.Up, UIImageOrientation.Down, UIImageOrientation.Left, UIImageOrientation.Right:
            break
        default:
            break
        }
        
        
        var ctx:CGContextRef = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), CGImageGetBitsPerComponent(CGImage), 0, CGImageGetColorSpace(CGImage), CGImageGetBitmapInfo(CGImage))
        
        CGContextConcatCTM(ctx, transform)
        
        switch imageOrientation {
        case UIImageOrientation.Left, UIImageOrientation.LeftMirrored, UIImageOrientation.Right, UIImageOrientation.RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, size.height, size.width), CGImage)
            break
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, size.width, size.height), CGImage)
            break
        }
        
        let cgimg:CGImageRef = CGBitmapContextCreateImage(ctx)
        var img:UIImage = UIImage(CGImage: cgimg)!
        
        return img
    }
    
    func blurredImage(radius: CGFloat, iterations: Int) -> UIImage! {
        if floorf(Float(size.width)) * floorf(Float(size.height)) <= 0.0 {
            return self
        }
        
        let imageRef = CGImage
        var boxSize = UInt32(radius * scale)
        if boxSize % 2 == 0 {
            boxSize++
        }
        
        let height = CGImageGetHeight(imageRef)
        let width = CGImageGetWidth(imageRef)
        let rowBytes = CGImageGetBytesPerRow(imageRef)
        let bytes = rowBytes * height
        
        let inData = malloc(bytes)
        var inBuffer = vImage_Buffer(data: inData, height: UInt(height), width: UInt(width), rowBytes: rowBytes)
        
        let outData = malloc(bytes)
        var outBuffer = vImage_Buffer(data: outData, height: UInt(height), width: UInt(width), rowBytes: rowBytes)
        
        let tempFlags = vImage_Flags(kvImageEdgeExtend + kvImageGetTempBufferSize)
        let tempSize = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, boxSize, boxSize, nil, tempFlags)
        let tempBuffer = malloc(tempSize)
        
        let provider = CGImageGetDataProvider(imageRef)
        let copy = CGDataProviderCopyData(provider)
        let source = CFDataGetBytePtr(copy)
        memcpy(inBuffer.data, source, bytes)
        
        let flags = vImage_Flags(kvImageEdgeExtend)
        for index in 0 ..< iterations {
            vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, tempBuffer, 0, 0, boxSize, boxSize, nil, flags)
            
            let temp = inBuffer.data
            inBuffer.data = outBuffer.data
            outBuffer.data = temp
        }
        
        free(outBuffer.data)
        free(tempBuffer)
        
        let space = CGImageGetColorSpace(imageRef)
        let bitmapInfo = CGImageGetBitmapInfo(imageRef)
        let ctx = CGBitmapContextCreate(inBuffer.data, Int(inBuffer.width), Int(inBuffer.height), 8, inBuffer.rowBytes, space, bitmapInfo)
        
        let bitmap = CGBitmapContextCreateImage(ctx);
        let image = UIImage(CGImage: bitmap, scale: scale, orientation: imageOrientation)
        free(inBuffer.data)
        
        return image
    }
}
