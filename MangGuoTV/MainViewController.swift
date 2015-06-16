//
//  MainViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIPageViewControllerDataSource{

    @IBOutlet weak var titleName: UILabel!
    var pageViewControll : UIPageViewController?
    var currentIndex = 0
    let headerTitle = ["精选","综艺","电视剧","热榜","所有频道"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //create pageview 
        if let pageViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageVIewController") as? UIPageViewController
        {
            self.pageViewControll =  pageViewController
            self.pageViewControll?.dataSource = self
            
            var firstPageView = viewControllerAtIndex(0)!
            titleName.text = headerTitle[0]
            self.pageViewControll?.setViewControllers([firstPageView], direction:UIPageViewControllerNavigationDirection.Forward, animated: false, completion: { (finished) -> Void in
                
            })
    
            self.pageViewControll?.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)
            self.addChildViewController(pageViewControll!)
            self.view.addSubview(pageViewControll!.view!)
            
            self.pageViewControll!.didMoveToParentViewController(self);
        }
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.headerTitle.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = currentIndex
        if let view = viewController as? ChannelViewController{
            index = view.pageIndex
        }
        if let view = viewController as? AllChannelViewController{
            index = view.pageIndex
        }
        self.titleName.text = headerTitle[index]
        return viewControllerAtIndex(index - 1);
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = currentIndex
        if let view = viewController as? ChannelViewController{
            index = view.pageIndex
        }
        if let view = viewController as? AllChannelViewController{
            index = view.pageIndex
        }
        self.titleName.text = headerTitle[index]
        return viewControllerAtIndex(index + 1);    }
    private func viewControllerAtIndex(index : Int)->UIViewController?
    {
       
        var tempViewController : UIViewController?
        if headerTitle.count <= index || index < 0
        {
           return tempViewController
        }
    switch index
        {
        case 0,1,2,3:
            if var channelView = self.storyboard?.instantiateViewControllerWithIdentifier("channel") as? ChannelViewController {
                channelView.pageIndex = index
                //todo
                var channelInfo = ChannelModel()
                channelInfo = loadChannelInfo(self.headerTitle[index])
                channelView.channelId = "\(channelInfo.channelId)"
                channelView.type = channelInfo.type
                tempViewController = channelView
            }
        case 4:
            if var allChannelView = self.storyboard?.instantiateViewControllerWithIdentifier("allChannel") as? AllChannelViewController {
                allChannelView.pageIndex = index
                tempViewController = allChannelView
            }
            //tempViewController = AllChannelViewController()
        default:
            break
            
        }
        currentIndex = index
        return tempViewController!
    }
    func reSizeImage(image :UIImage ,reSize :CGSize)->UIImage
    {
        
        UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
        
        image.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
        
        var reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return reSizeImage;
        
    }
    func loadChannelInfo(name:String)->ChannelModel
    {
        var channelInfo = ChannelModel()
        for channel in AppDelegate.channels
        {
            if channel.channelName == name
            {
                channelInfo = channel
                break
            }
        }
        return channelInfo
    }
    /*5
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
