//
//  BannerCollectionViewCell.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/18.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {

    var imageW:CGFloat = AppDelegate.screenWidth - 16
    var imageH:CGFloat = AppDelegate.screenWidth 
    static let bannerCellID = "BannerCollectionViewCell"
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var currentVideoName: UILabel!
    private var currentIndex:Int = 0
    var channels = [ChannelTemplateModel]()
    var timer : NSTimer!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initImages(channelList:[ChannelTemplateModel])
    {
        self.channels = channelList
        // 0.一些固定的尺寸参数
//        var imageW : CGFloat = self.scrollView.frame.size.width;
//        var imageH : CGFloat = self.scrollView.frame.size.height;
        var imageY : CGFloat = 0;
        
        // 1.添加5张图片到scrollView中
        for (i , channel) in enumerate(channels){
            var imageView = UIImageView()
            
            // 设置frame
            var imageX : CGFloat =  imageW * CGFloat(i);
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            let url = NSURL(string: channel.picUrl)
            
            //图片数据
            var data = NSData(contentsOfURL:url!)
            //通过得到图片数据来加载
            let image = UIImage(data: data!)
            imageView.image = image
            self.scrollView.addSubview(imageView)
            
        }
        
        var videoTap = UITapGestureRecognizer()
        videoTap.addTarget(self, action: "VideoTap")
        self.contentView.addGestureRecognizer(videoTap)
        
        // 2.设置内容尺寸
        var contentW : CGFloat = CGFloat(channels.count) * imageW;
        self.scrollView.contentSize = CGSizeMake(contentW, 0);
        
        // 3.隐藏水平滚动条
        self.scrollView.showsHorizontalScrollIndicator = false;
        
        // 4.分页
        self.scrollView.pagingEnabled = true;
        self.scrollView.delegate = self;
        
        // 5.设置pageControl的总页数
        self.pageControl.numberOfPages = channels.count;
        
        // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
        self.addTimer();
        
        self.currentVideoName.text = self.channels[self.currentIndex].name
    }
    func VideoTap()
    {
        var video = self.channels[self.currentIndex]
        
//        if let playView = self.storyboard?.instantiateViewControllerWithIdentifier(PlayViewController.playViewID)  as? PlayViewController {
//            var nvc = UINavigationController(rootViewController: playView)
//            self.presentViewController(nvc, animated: true, completion: nil)
//        }
    }
    
    /**
    *  添加定时器
    */
    func addTimer()
    {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector:"nextImage", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
    }
    
    /**
    *  移除定时器
    */
    func removeTimer()
    {
        self.timer.invalidate();
    }
    
    func nextImage()
    {
        // 1.增加pageControl的页码
        var page :Int = 0;
        if (self.pageControl.currentPage == channels.count - 1) {
            page = 0;
        } else {
            page = self.pageControl.currentPage + 1;
        }
        // 2.计算scrollView滚动的位置
        var offsetX :CGFloat = CGFloat(page) * self.scrollView.frame.size.width;
        var offset : CGPoint = CGPointMake(offsetX, 0);
        self.scrollView.setContentOffset(offset, animated: true)
        self.currentVideoName.text = channels[page].name
    }
    
    // #pragma mark - 代理方法

    //当scrollView正在滚动就会调用
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //     根据scrollView的滚动位置决定pageControl显示第几页
        var scrollW :CGFloat = scrollView.frame.size.width;
        var page : Int = Int((scrollView.contentOffset.x + scrollW * 0.5) / scrollW);
        self.pageControl.currentPage = page;
        currentIndex = page
    }
    //开始拖拽的时候调用
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    //停止拖拽的时候调用
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
}
