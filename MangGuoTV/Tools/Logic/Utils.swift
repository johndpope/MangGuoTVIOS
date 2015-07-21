//
//  Utils.swift
//  AppClient
//
//  Created by 陆广庆 on 15/4/14.
//  Copyright (c) 2015年 陆广庆. All rights reserved.
//

import UIKit


extension String {
    
    func includeSpecialCharacter() -> Bool {
        let sc = AppConfig.instance.specialCharacter
        for s in sc {
            if self.toNSString().rangeOfString(s).location != NSNotFound {
                return true
            }
        }
        return false
    }
    
}