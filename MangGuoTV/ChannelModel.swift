//
//  ChannelModel.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/15.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import Foundation

class ChannelModel {
    /// 频道ID
    var channelId:Int = 0
    /// 频道名称
    var channelName : String = ""
    /// 频道icon
    var iconUrl : String = ""
    /// 更多
    var hasMore : String = ""
    ///目录Id
    var libId : Int = 0
    /// 频道播放类型  normal为正常  live为直播
    var type : String = ""
}
