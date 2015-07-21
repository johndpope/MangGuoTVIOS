//
//  DeviceUtils.swift
//  AppFramework
//
//  Created by 陆广庆 on 15/3/1.
//  Copyright (c) 2015年 陆广庆. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import CoreLocation


let dWidth = UIScreen.mainScreen().bounds.size.width
let dHeight = UIScreen.mainScreen().bounds.size.height
let dNavigationHeight: CGFloat = 44

class DeviceUtils: NSObject {
    
    class func appVersion() -> String {
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        return version
    }
    
    class func appBuildVersion() -> String {
        let buildVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        return buildVersion
    }
    
    class func osVersion() -> Float {
        return UIDevice.currentDevice().systemVersion.toNSString().floatValue
    }
    
    class func saveDeviceToken(deviceToken: NSData) -> Bool {
        let kDeviceTokenKey = "AppDeviceToken"
        let opt = NSStringCompareOptions.LiteralSearch
        let blank = ""
        let token = deviceToken.description
            .stringByReplacingOccurrencesOfString("<", withString: blank, options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString(">", withString: blank, options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString(" ", withString: blank, options: NSStringCompareOptions.LiteralSearch, range: nil)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(token, forKey: kDeviceTokenKey)
        userDefault.synchronize()
        return true
    }
    
    class func loadDeviceToken() -> String? {
        let kDeviceTokenKey = "AppDeviceToken"
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let deviceToken = userDefault.objectForKey(kDeviceTokenKey) as? String {
            return deviceToken
        }
        return nil
    }
    
    /*!
    是否有硬件摄像头
    
    :returns:
    */
    class func hardwareCameraAvailable() -> Bool {
        let available = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
        return available
    }
    
    class func hardwareCameraCount() -> Int {
        let deviceCount = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count
        return deviceCount
    }
    
    /*!
    是否有闪光灯
    
    :returns:
    */
    class func hardwareFlashAvailable() -> Bool {
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            return device.hasFlash
        }
        return false
    }
    
    // 获取前置摄像头
    class func frontFacingCamera() -> AVCaptureDevice? {
        return cameraWithPosition(AVCaptureDevicePosition.Front)
    }
    
    // 获取后置摄像头
    class func backFacingCamera() -> AVCaptureDevice? {
        return cameraWithPosition(AVCaptureDevicePosition.Back)
    }
    
    // 获取摄像头
    class func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        if devices == nil || devices.isEmpty {
            return nil
        }
        for device in devices {
            if device.position == position {
                return device as? AVCaptureDevice
            }
        }
        return devices[0] as? AVCaptureDevice
    }
    
    
    
    // 相机权限
    class func permissionCaptureEnable() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
        case AVAuthorizationStatus.Authorized://已经获得了许可
            return true;
        case AVAuthorizationStatus.Denied://被拒绝了，不能打开
            return false;
        case AVAuthorizationStatus.NotDetermined://不确定是否获得了许可
            return true;
        case AVAuthorizationStatus.Restricted://受限制：已经询问过是否获得许可但被拒绝
            return false;
        default:
            return false;
            
        }
    }
    
    // 相册权限
    class func permissionAlbumEnable() -> Bool {
        let authStatus = ALAssetsLibrary.authorizationStatus()
        switch authStatus {
        case ALAuthorizationStatus.Authorized://已经获得了许可
            return true;
        case ALAuthorizationStatus.Denied://被拒绝了，不能打开
            return false;
        case ALAuthorizationStatus.NotDetermined://不确定是否获得了许可
            return true;
        case ALAuthorizationStatus.Restricted://受限制：已经询问过是否获得许可但被拒绝
            return false;
        default:
            return false;
            
        }
    }
    
    // 麦克风权限
    class func permissionMicophoneEnable() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio)
        switch authStatus {
        case AVAuthorizationStatus.Authorized://已经获得了许可
            return true;
        case AVAuthorizationStatus.Denied://被拒绝了，不能打开
            return false;
        case AVAuthorizationStatus.NotDetermined://不确定是否获得了许可
            return true;
        case AVAuthorizationStatus.Restricted://受限制：已经询问过是否获得许可但被拒绝
            return false;
        default:
            return false;
            
        }

    }
    
    // 麦克风权限
    class func permissionLBSEnable() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .NotDetermined://不确定
            return true;
        case .Restricted://已经获得了许可
            return false;
        case .Denied://被拒绝了，不能打开
            return false;
        case .AuthorizedAlways://不确定是否获得了许可
            return true;
        case .AuthorizedWhenInUse://受限制：已经询问过是否获得许可但被拒绝
            return true;
        default:
            return false;
            
            
        }
        
    }
}
