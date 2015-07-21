//
//  AllChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class AllChannelViewController: UICollectionViewController {
   var pageIndex : Int = 0
    var parent: MainViewController!
    var channels = [ChannelModel]()
    override func loadView() {
        super.loadView()
        //loadChannelData();
        channels =  AppDelegate.channels
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if parent != nil {
            parent.currentIndex = pageIndex
        }
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return channels.count
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: ChannelCollectionViewCell  = (collectionView.dequeueReusableCellWithReuseIdentifier("channelCell", forIndexPath: indexPath) as? ChannelCollectionViewCell)!
        
        var channelImageUrl = channels[indexPath.row].iconUrl
        let url = NSURL(string: channelImageUrl)
        
        //图片数据
        
        var data = NSData(contentsOfURL:url!)
        
        //通过得到图片数据来加载
        
        let image = UIImage(data: data!)
        
        //把加载到的图片丢给imageView的image现实
        cell.channelImage.image = image
        cell.channelName.text = channels[indexPath.row].channelName
        return cell;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width:CGFloat = AppDelegate.screenWidth/3 - 20
        var height:CGFloat = width + 10
        
        return CGSizeMake(width, height)
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if var channelView = self.storyboard?.instantiateViewControllerWithIdentifier("channel") as? ChannelViewController {
            var channelInfo = AppDelegate.channels[indexPath.row]
            if channelInfo.channelName  == "精选" || channelInfo.channelName == "热榜"{
                
            }else {
                channelView.channelId = "\(channelInfo.channelId)"
                channelView.type = channelInfo.type
                var nvc = UINavigationController(rootViewController: channelView)
                nvc.navigationBarHidden = true
                self.presentViewController(nvc, animated: true, completion: nil)
            }
        }
    }
}
