//
//  BaseModel.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/30.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        println("setValue \(value)失败, key:\(key) 不存在")
    }
    
}
