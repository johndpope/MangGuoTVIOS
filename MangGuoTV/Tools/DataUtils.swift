//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class DataUtils: NSObject {
   
}


extension NSData {
    
    func lengthStr() -> String {
        let kb: Int = 1024
        let mb: Int = kb * 1024
        let gb: Int = mb * 1024
        let len = self.length
        if (len >= gb) {
            let g = len / gb
            return "\(g)GB"
        } else if (len >= mb) {
            let m = len / mb
            return "\(m)M"
        } else if (len >= kb) {
            let k = len / kb
            return "\(k)KB"
        } else {
            return "\(len)B"
        }
    }

}