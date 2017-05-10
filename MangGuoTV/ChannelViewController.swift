//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class ChannelViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    var loadingView = GlobalLoadingView.create()
    var pageIndex : Int = 0
    var channelId = ""
    var type = "normal"
    var parent: MainViewController!
    var channelList = [ChannelListModel]()
    override func loadView() {
        super.loadView()
        initCollectionView()
        loadingView.addLoadErrorBlock { () -> () in
            self.loadChannelDatas()
        }
        loadingView.addLoadMoreErrorBlock { () -> () in
            self.loadChannelDatas()
        }
        collectionView!.addRefreshAction { () -> Void in
            self.loadChannelDatas()
        }
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if parent != nil {
            parent.currentIndex = pageIndex
        }
        self.collectionView!.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.reloadData()
        if shouldRequestData() {
            self.collectionView!.startRefresh()
        }
    }
    /**************************************** 初始化方法 ****************************************/
    func initCollectionView() {
        // 属性
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        //永远有“边缘弹性“
        self.collectionView!.alwaysBounceHorizontal = false
        self.collectionView!.alwaysBounceVertical = true
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = true
        
        collectionView?.registerNib(UINib(nibName: TitleCollectionViewCell.cellId, bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: TitleCollectionViewCell.cellId)
        collectionView?.registerNib(UINib(nibName: BannerCollectionViewCell.bannerCellID, bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: BannerCollectionViewCell.bannerCellID)
        collectionView!.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelList.count
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        let channel = self.channelList[indexPath.row]
        switch channel.type {
        case "title":
            let videoCell:TitleCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(TitleCollectionViewCell.cellId, forIndexPath: indexPath) as? TitleCollectionViewCell)!
        
            videoCell.configure(channel.template[0])
            return videoCell
        case "banner":
            let videoCell:BannerCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(BannerCollectionViewCell.bannerCellID, forIndexPath: indexPath) as? BannerCollectionViewCell)!
            
            videoCell.initImages(channel.template)
            return videoCell
        
        case "normalAvatorText",
        "largeLandScapeNodesc",
        "largeLandScape",
        "normalLandScapeNodesc",
        "aceSeason",
        "normalLandScape",
        "roundAvatorText",
        "tvPortrait",
        "moviePortrait":
            let videoCell:
                = (collectionView.dequeueReusableCellWithReuseIdentifier(VideoCollectionViewCell.videoCellId, forIndexPath: indexPath) as? VideoCollectionViewCell)!
            videoCell.configure(channel.template[0])
            return videoCell
       
        case "rankList":
            let videoCell:VideoCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(VideoCollectionViewCell.videoCellId, forIndexPath: indexPath) as? VideoCollectionViewCell)!
            videoCell.configure(channel.template[0])
            return videoCell
        case "live":
            let videoCell:VideoCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(VideoCollectionViewCell.videoCellId, forIndexPath: indexPath) as? VideoCollectionViewCell)!
            videoCell.configure(channel.template[0])
            return videoCell
        default:
            let videoCell:VideoCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(VideoCollectionViewCell.videoCellId, forIndexPath: indexPath) as? VideoCollectionViewCell)!
            cell = videoCell
            print("未能找到该类型=\(channel.type)")
            
            break;
            
        }
        return cell;
    }
    
    func loadChannelDatas(){
        let body = commondUrl +  "&channelId=\(channelId)&type=\(type)"
        let data = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)

        BaseRequest.requestWithHttp(channelDetailUrl + body, body: data!){
        (json) -> () in
            //println("restule data : \(json.rawString()!)")
             var isSucc = false
             var errorMsg = ""
             let code = json["err_code"].intValue

                switch code {
                case 200:
                    if let datas = json["data"].array{
                        self.channelList.removeAll(keepCapacity: true)
                        for dataInfo in datas {
                            if  let type = dataInfo["type"].string{
                                if type == "banner"{
                                    var channel = ChannelListModel()
                                    channel.type = type
                                    var channelTemplates = [ChannelTemplateModel]()
                                    
                                    if let templateDatas = dataInfo["templateData"].array{
                                        for templateData in templateDatas {
                                            var channelTemplate = ChannelTemplateModel()
                                            for (k, v) in templateData {
                                                var vStr = "\(v)"
                                                if vStr == "null" {
                                                    continue
                                                }
                                                channelTemplate.setValue(v.object, forKey: k)
                                            }
                                            channelTemplates.append(channelTemplate)
                                        }
                                    }
                                    channel.template = channelTemplates
                                    self.channelList.append(channel)
                                    
                                }else if type != "unknowModType1" && type != "unknowModType2"{
                                    if let templateDatas = dataInfo["templateData"].array{
                                        for templateData in templateDatas {
                                            var channel = ChannelListModel()
                                            channel.type = type
                                            var channelTemplates = [ChannelTemplateModel]()
                                            var channelTemplate = ChannelTemplateModel()
                                            for (k, v) in templateData {
                                                var vStr = "\(v)"
                                                if vStr == "null" {
                                                    continue
                                                }
                                                channelTemplate.setValue(v.object, forKey: k)
                                            }
                                            channelTemplates.append(channelTemplate)
                                            channel.template = channelTemplates
                                            self.channelList.append(channel)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                  
                    isSucc = true
                default :
                    if let err = json["err_msg"].string{
                       errorMsg = "获取频道列表失败。\(err)"
                    }
                }
            dispatch_async(dispatch_get_main_queue(),{
                self.loadDataCompleted(isSucc,errorMsg: errorMsg)
            })
        }
    }
    private func loadDataCompleted(isSucc:Bool, errorMsg:String){
        self.collectionView!.stopRefresh()
        if isSucc{
            self.collectionView!.enableRefresh()
            self.loadingView.stopLoading()
            self.collectionView!.reloadData()
        }else{
            self.collectionView!.disableRefresh()
            self.loadingView.loadError(errorMsg)
        }
       
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let channel = self.channelList[indexPath.row]
        var width:CGFloat = 0
        var height:CGFloat = 0
        switch channel.type {
        case "banner":
            width = AppDelegate.screenWidth
            height = width * 2/5
        case "normalAvatorText":
            width = AppDelegate.screenWidth/4 - 10
            height = width
        case "largeLandScapeNodesc","largeLandScape","normalLandScapeNodesc","aceSeason":
            width = AppDelegate.screenWidth
            height = width * 2/5
        case "normalLandScape","roundAvatorText","tvPortrait":
            width = AppDelegate.screenWidth/2 - 5
            height = width * 3/5
        case "title":
            width = AppDelegate.screenWidth
            height = 30
        case "rankList":
            width = AppDelegate.screenWidth
            height = width * 2/5
        case "live":
            width = AppDelegate.screenWidth/2 - 5
            height = width * 3/5
        default:
            break;
        }

        return CGSizeMake(width, height)
    }
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let channel = self.channelList[indexPath.row]
        if channel.type == "title"
        {
            if channel.template[0].jumpType == "subjectPage"
            {
                if let moreView = self.storyboard?.instantiateViewControllerWithIdentifier(MoreVideoViewController.moreId)  as? MoreVideoViewController {
                    let nvc = UINavigationController(rootViewController: moreView)
                    nvc.navigationBarHidden = true
                    // nvc.view.layer.addAnimation(CABasicAnimation(), forKey: nil)
                    self.presentViewController(nvc, animated: true, completion: nil)
                }
            }
        }
        else if channel.type != "banner"
        {
            loadPlayView()
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(AppDelegate.screenWidth, 30)
    }
    func loadPlayView()
    {
        if let playView = self.storyboard?.instantiateViewControllerWithIdentifier(PlayViewController.playViewID)  as? PlayViewController {
            let nvc = UINavigationController(rootViewController: playView)
            nvc.navigationBarHidden = true
            // nvc.view.layer.addAnimation(CABasicAnimation(), forKey: nil)
            self.presentViewController(nvc, animated: true, completion: nil)
            //nvc.pushViewController(playView, animated: true)
            
            print("----self.navigationController= \(self.navigationController)")
            
        }

    }
    // MARK: - Helper
    var lastUpdate: Double = 0
    func shouldRequestData() -> Bool {
        let now = NSDate().secondSince1970
        if now - lastUpdate > 60 * 60 { // 更新频率
            lastUpdate = now
            return true
        }
        return false
    }
}








