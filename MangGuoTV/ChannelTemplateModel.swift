//
//  ChannelTemplateModel.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/15.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import Foundation
class ChannelListModel{
    var type:String = ""
    var template:[ChannelTemplateModel] = []
}
class ChannelTemplateModel{
    var name:String = ""
    /// <summary>
    /// 跳转类型
    /// </summary>
    var jumpType:String = ""
    /// <summary>
    ///
    /// </summary>
    var subjectId:String = ""
    /// <summary>
    /// 图片地址
    /// </summary>
    var picUrl:String = ""
    /// <summary>
    /// 播放地址
    /// </summary>
    var playUrl:String = ""
    var icon:String = ""
    var tag:String = ""
    var desc:String = ""
    /// <summary>
    /// 视频id
    /// </summary>
    var videoId:String = ""
    var hotDegree:String = ""
    var hotType:String = ""
    var playTimeIconUrl:String = ""
    var webUrl:String = ""
    var ext:String = ""
    var rank:String = ""
}