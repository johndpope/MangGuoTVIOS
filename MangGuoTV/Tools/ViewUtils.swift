//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class ViewUtils: UIView {
    
    
    
}

extension UIView {
    
    func converToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size);
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func addShadow(color: UIColor, shadowPath: CGRect?) {
        var layer = self.layer
        layer.shadowColor = color.CGColor
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        if let path = shadowPath {
            layer.shadowPath = UIBezierPath(rect: path).CGPath
        } else {
            layer.shadowPath = UIBezierPath(rect: self.layer.bounds).CGPath
        }
    }
    func changeWidth(width: CGFloat) {
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func changeHeight(height: CGFloat) {
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func changeX(x: CGFloat) {
        var frame = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    func changeY(y: CGFloat) {
        var frame = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func incrX(x: CGFloat) {
        var frame = self.frame
        frame.origin.x += x
        self.frame = frame
    }
    
    func incrY(y: CGFloat) {
        var frame = self.frame
        frame.origin.y += y
        self.frame = frame
    }
    
    func incrWidth(w: CGFloat) {
        var frame = self.frame
        frame.size.width += w
        self.frame = frame
    }
    
    func incrHeight(h: CGFloat) {
        var frame = self.frame
        frame.size.height += h
        self.frame = frame
    }
}

extension UILabel {
    
    public override func awakeFromNib() {
        if let f = UILabel.appearance().font {
            let size = font.pointSize
            font = UIFont(name: f.fontName, size: size)
        }
        
    }
}

extension UIButton {
    
    public override func awakeFromNib() {
        if let label = titleLabel {
            let size = label.font.pointSize
            if let font = UILabel.appearance().font {
                label.font = UIFont(name: font.fontName, size: size)
            }
        }
    }
    
    // 图片在上 文字在下
    func verticalStyle() {
        let spacing = 4.0
        let imageSize = imageView!.frame.size
        titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + CGFloat(spacing)), 0.0)
        let titleSize = titleLabel!.frame.size
        imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + CGFloat(spacing)), 0.0, 0.0, -titleSize.width)
    }
    
    func setBackgroundImageWithGrow(image: UIImage, state: UIControlState) {
        self.alpha = 0
        self.setBackgroundImage(image, forState: state)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 1
            }) { (finished) -> Void in
                self.alpha = 1
        }
    }
    
    func setImageWithGrow(image: UIImage, state: UIControlState) {
        self.alpha = 0
        self.setImage(image, forState: state)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 1
            }) { (finished) -> Void in
                self.alpha = 1
        }
    }
}


extension UIImageView {
    
    func setImageWithGrow(image: UIImage) {
        self.alpha = 0
        self.image = image
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.alpha = 1
            }) { (finished) -> Void in
                self.alpha = 1
        }
    }
    
}

















