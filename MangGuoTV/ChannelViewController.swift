//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class ChannelViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var pageIndex : Int = 0
    var channelId = ""
    var type = ""
    var channelList = [ChannelListModel]()
    var channelUrl = "channel/getDetail?userId=&osVersion=4.4&device=sdk&appVersion=4.3.4&ticket=&channel=360dev&mac=i000000000000000&osType=android"
    override func loadView() {
        super.loadView()
        collectionView?.registerNib(UINib(nibName: TitleCollectionViewCell.cellId, bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: TitleCollectionViewCell.cellId)
         self.channelUrl = AppDelegate.urlHost + self.channelUrl + "&channelId=\(channelId)&type=\(type)"
        if self.channelList.count == 0{
             self.loadChannelData();
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelList.count
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        var channel = self.channelList[indexPath.row]
        switch channel.type {
        case "title":
            var videoCell:TitleCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(TitleCollectionViewCell.cellId, forIndexPath: indexPath) as? TitleCollectionViewCell)!
            
            videoCell.titleName.text = channel.template[0].name
            return videoCell
        case "banner",
        "normalAvatorText",
        "largeLandScapeNodesc",
        "largeLandScape",
        "normalLandScapeNodesc",
        "aceSeason",
        "normalLandScape",
        "roundAvatorText",
        "tvPortrait",
        "moviePortrait":
            var videoCell:VideoCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as? VideoCollectionViewCell)!
            var channelImageUrl = channel.template[0].picUrl
            let url = NSURL(string: channelImageUrl)
            //图片数据
            var data = NSData(contentsOfURL:url!)
            //通过得到图片数据来加载
            let image = UIImage(data: data!)
            //把加载到的图片丢给imageView的image现实
            videoCell.image.image = image
            videoCell.videoName.text = channel.template[0].name
            return videoCell
       
        case "rankList":
            var videoCell:VideoCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as? VideoCollectionViewCell)!
            var channelImageUrl = channel.template[0].picUrl
            let url = NSURL(string: channelImageUrl)
            //图片数据
            var data = NSData(contentsOfURL:url!)
            //通过得到图片数据来加载
            let image = UIImage(data: data!)
            //把加载到的图片丢给imageView的image现实
            videoCell.image.image = image
            videoCell.videoName.text = channel.template[0].name
            return videoCell
        case "live":
            var videoCell:VideoCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as? VideoCollectionViewCell)!
            var channelImageUrl = channel.template[0].picUrl
            let url = NSURL(string: channelImageUrl)            
            //图片数据
            var data = NSData(contentsOfURL:url!)
            //通过得到图片数据来加载
            let image = UIImage(data: data!)
            //把加载到的图片丢给imageView的image现实
            videoCell.image.image = image
            videoCell.videoName.text = channel.template[0].name
            return videoCell
//        case "unknowModType1":
//            //CreateNorLandscapeImages(channeldetail.templateData);
//            break;
//        case "unknowModType2":
//            //CreateNorLandscapeImages(channeldetail.templateData);
//            break;
        default:
            
            break;
            
        }
        return cell;
    }
    
    func loadChannelData() -> (Bool,String) {
        var strErr = ""
        var result = false
     
        var req = NSMutableURLRequest(URL:  NSURL(string: channelUrl)!)
        req.timeoutInterval = 5.0
        req.HTTPMethod = "GET"
        req.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        //req.setValue("ios", forHTTPHeaderField: "User-Agent")
        var err:NSError?
        let data = NSURLConnection.sendSynchronousRequest(req, returningResponse: nil, error: &err)
        
        if err != nil {
            if let s = err?.localizedDescription {
                strErr = s
            }
            return  ( result , strErr )
        }

                let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                println("data = \(str)")
        if let d = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil)  as?  NSDictionary
        {
            if let code: AnyObject = d.valueForKey("err_code"){
                
                switch code as! Int {
                case 200:
                    if let info = d.valueForKey("data") as? [NSDictionary]{
                        for (key,obj) in enumerate(info) {
                            if  let type = obj.valueForKey("type") as? String {
                                if type == "banner"{
                                    var channel = ChannelListModel()
                                    channel.type = type
                                    var channelTemplates = [ChannelTemplateModel]()
                                    
                                    if let templateData = obj.valueForKey("templateData")  as? [NSDictionary]{
                                        for (key,dict) in enumerate(templateData) {
                                            var channelTemplate = ChannelTemplateModel()
                                            dictConvertTemplate(dict, channelTemplate: channelTemplate)
                                            channelTemplates.append(channelTemplate)
                                        }
                                    }
                                    channel.template = channelTemplates
                                    self.channelList.append(channel)
                                    
                                }else if type != "unknowModType1" && type != "unknowModType2"{
                                    if let templateData = obj.valueForKey("templateData")  as? [NSDictionary]{
                                        for (key,dict) in enumerate(templateData) {
                                            var channel = ChannelListModel()
                                            channel.type = type
                                            var channelTemplates = [ChannelTemplateModel]()
                                            var channelTemplate = ChannelTemplateModel()
                                            dictConvertTemplate(dict, channelTemplate: channelTemplate)
                                            channelTemplates.append(channelTemplate)
                                            channel.template = channelTemplates
                                            self.channelList.append(channel)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    strErr = ""
                    result = true
                    
                default :
                    if let err = d.valueForKey("err_msg") as? String{
                        strErr = "获取频道列表失败。\(err)"
                    }
                    result = false
                }
            }
            
        }
        else
        {
            strErr = "获取视频列表失败"
        }
        return  (result,strErr)
        
    }
    func dictConvertTemplate(dict:NSDictionary, channelTemplate:ChannelTemplateModel)->ChannelTemplateModel
    {
        if  let name = dict.valueForKey("name") as? String {
            channelTemplate.name = name
        }
        if  let jumpType = dict.valueForKey("jumpType") as? String {
            channelTemplate.jumpType = jumpType
        }
        if  let subjectId = dict.valueForKey("subjectId") as? String {
            channelTemplate.subjectId = subjectId
        }
        if  let picUrl = dict.valueForKey("picUrl") as? String {
            channelTemplate.picUrl = picUrl
        }
        if  let playUrl = dict.valueForKey("playUrl") as? String {
            channelTemplate.playUrl = playUrl
        }
        if  let tag = dict.valueForKey("tag") as? String {
            channelTemplate.tag = tag
        }
        if  let icon = dict.valueForKey("icon") as? String {
            channelTemplate.icon = icon
        }
        if  let desc = dict.valueForKey("desc") as? String {
            channelTemplate.desc = desc
        }
        if  let videoId = dict.valueForKey("videoId") as? String {
            channelTemplate.videoId = videoId
        }
        if  let hotDegree = dict.valueForKey("hotDegree") as? String {
            channelTemplate.hotDegree = hotDegree
        }
        if  let hotType = dict.valueForKey("hotType") as? String {
            channelTemplate.hotType = hotType
        }
        if  let webUrl = dict.valueForKey("webUrl") as? String {
            channelTemplate.webUrl = webUrl
        }
        if  let playTimeIconUrl = dict.valueForKey("playTimeIconUrl") as? String {
            channelTemplate.playTimeIconUrl = playTimeIconUrl
        }
        if  let ext = dict.valueForKey("ext") as? String {
            channelTemplate.ext = ext
        }
        if  let rank = dict.valueForKey("rank") as? String {
            channelTemplate.rank = rank
        }
        
        return channelTemplate;
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var channel = self.channelList[indexPath.row]
        var width:CGFloat = AppDelegate.screenWidth/2 - 5
        var height:CGFloat = 180
        switch channel.type {
        case "banner":
           width = AppDelegate.screenWidth
        case "normalAvatorText":
            width = AppDelegate.screenWidth/4 - 10
            height = width
        case "largeLandScapeNodesc","largeLandScape","normalLandScapeNodesc","aceSeason":
           width = AppDelegate.screenWidth
        case "normalLandScape","roundAvatorText","tvPortrait":
           height = 120
        case "title":
            width = AppDelegate.screenWidth
            height = 30
        case "rankList":
            width = AppDelegate.screenWidth
        case "live":
            height = 120
        default:
            break;
        }

        return CGSizeMake(width, height)
    }
    
}








