//
//  DownloadViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet weak var downTabbarItem: UITabBarItem!{
        didSet {
            //downTabbarItem.image = reSizeImage(downTabbarItem.image!, reSize: CGSizeMake(64, 64))        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reSizeImage(image :UIImage ,reSize :CGSize)->UIImage
    {
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    image.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
    
    var reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
