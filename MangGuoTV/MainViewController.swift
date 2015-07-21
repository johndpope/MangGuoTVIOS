//
//  MainViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate{//UIScrollViewDelegate
    
    var naviLine: UIView!
    var naviButtons: [UIButton]! = []
    var naviButtonsX: [CGFloat]! = []
    var initialized = false
    var lateIndex = 0
    var contentControllers: [UIViewController] = []
    @IBOutlet weak var headerScroll: UIScrollView!
    var flagView = UIView()
    var pageViewControll : UIPageViewController?
    var currentIndex = 0
    let headerTitle = ["精选","综艺","电视剧","热榜","所有频道"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initContentControllers()
        
        initHeaderView()
        initLineStyle()
        initButtonStyle()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !initialized {
            initView()
            initialized = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    func initContentControllers(){
        var contentControllers: [UIViewController] = []
        for i in 0...(headerTitle.count - 1) {
            let ctl = viewControllerAtIndex(i)
            contentControllers.append(ctl)
        }
        
        self.contentControllers = contentControllers
    }
    func initView(){
        //create pageview
        if let pageViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageVIewController") as? UIPageViewController
        {
            self.pageViewControll =  pageViewController
            self.pageViewControll?.dataSource = self
            self.pageViewControll?.delegate = self
            
            var firstPageView = setupContentController(0)
            self.pageViewControll?.setViewControllers([firstPageView], direction:UIPageViewControllerNavigationDirection.Forward, animated: false, completion: { (finished) -> Void in
                
            })
            
            self.pageViewControll?.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)
            self.addChildViewController(self.pageViewControll!)
            self.view.addSubview(self.pageViewControll!.view!)
            
            self.pageViewControll!.didMoveToParentViewController(self);
            initButtonStyle()
            changeSelectedButton(currentIndex)
            naviButtons[currentIndex].selected = true
        }

    }
    func initHeaderView(){
        // 2.设置内容尺寸
        var contentW:CGFloat  = 0;
        let oneWith:CGFloat = 13
        var btnWidth = headerScroll.frame.size.width/CGFloat(headerTitle.count)
        for i in 0...(headerTitle.count - 1) {
            var btn = UIButton()
            // 设置frame
            //var btnLenth = String.lengthOfBytesUsingEncoding(headerTitle[i])
            var btnLenth =  headerTitle[i].lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
            //var btnWidth = CGFloat(btnLenth) * oneWith
            //var btnX = CGFloat(i) * oneWith
            btn.frame = CGRectMake(contentW, 0, btnWidth, headerScroll.frame.size.height)
            btn.setTitle(headerTitle[i], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            btn.tag = i
            btn.addTarget(self, action: "headBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            naviButtonsX.append(contentW)
            contentW = contentW + btnWidth
            headerScroll.addSubview(btn)
            naviButtons.append(btn)
            
        }
        contentW = oneWith * CGFloat(headerTitle.count)
        self.headerScroll.contentSize = CGSizeMake(contentW, headerScroll.frame.size.height + 10);
        // 3.隐藏水平滚动条
        self.headerScroll.showsHorizontalScrollIndicator = false;
    }
    func headBtnClick(btn:UIButton)
    {
        let index = btn.tag
        initButtonStyle()
        changeSelectedButton(index)
        btn.selected = true
        //var clickPageView = viewControllerAtIndex(index)!

        self.view.userInteractionEnabled = false
        Async.main(after: 0.25) { () -> Void in
            self.view.userInteractionEnabled = true
        }
        self.pageViewControll?.setViewControllers([self.contentControllers[index]], direction: lateIndex > index ? .Reverse : .Forward, animated: true, completion: { (finished) -> Void in
            self.lateIndex = index
        })
    }
    private func initButtonStyle() {
        for btn in naviButtons {
            btn.setTitleColor(AppStyleColor, forState: .Selected)
            btn.setTitleColor(AppStyle.appLightTextColor(), forState: .Normal)
            btn.titleLabel?.font = UIFont(name: AppStyle.appFont(), size: 14.0)
            btn.backgroundColor = UIColor.clearColor()
            btn.selected = false
        }
    }
    private func initLineStyle() {
        naviLine = UIView(frame: CGRectMake(8,naviButtons[currentIndex].frame.size.height-8, naviButtons[currentIndex].frame.size.width, 2))
        naviLine.backgroundColor = AppStyleColor
        headerScroll.addSubview(naviLine)
    }

    private func changeSelectedButton(index: Int) {
      
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: { () -> Void in
            self.naviLine.changeX(self.naviButtonsX[index])
            }) { (finished) -> Void in
                
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
        if index == 0 || index == NSNotFound {
            return nil
        }
        index--
        return setupContentController(index);
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = currentIndex
        if let view = viewController as? ChannelViewController{
            index = view.pageIndex
        }
        if let view = viewController as? AllChannelViewController{
            index = view.pageIndex
        }
        if index == NSNotFound {
            return nil
        }
        index++
        if index == contentControllers.count {
            return nil
        }
        return setupContentController(index);
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if completed {
            initButtonStyle()
            changeSelectedButton(currentIndex)
            naviButtons[currentIndex].selected = true
        }
        
    }
    private func viewControllerAtIndex(index : Int)->UIViewController!
    {
        
        var tempViewController : UIViewController?
        if headerTitle.count <= index || index < 0
        {
            return nil
        }
        switch index
        {
        case 0,1,2,3:
            if var channelView = self.storyboard?.instantiateViewControllerWithIdentifier("channel") as? ChannelViewController {
                channelView.pageIndex = index
                var channelInfo = ChannelModel()
                channelInfo = loadChannelInfo(self.headerTitle[index])
                channelView.channelId = "\(channelInfo.channelId)"
                channelView.type = channelInfo.type
                channelView.parent = self
                tempViewController = channelView
            }
        case 4:
            if var allChannelView = self.storyboard?.instantiateViewControllerWithIdentifier("allChannel") as? AllChannelViewController {
                allChannelView.pageIndex = index
                allChannelView.parent = self
                tempViewController = allChannelView
            }
            //tempViewController = AllChannelViewController()
        default:
            break
            
        }
        //currentIndex = index
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
    private func setupContentController(index: Int) -> UIViewController {
        let contentCtl = contentControllers[index]
        return contentCtl
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
