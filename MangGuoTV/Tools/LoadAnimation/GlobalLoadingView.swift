//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

enum GlobalLoadingViewState {
    case Normal
    case Loading
    case LoadingMore
    case LoadNone
    case LoadAll
    case LoadError
    case LoadMoreError
}

class GlobalLoadingView: UIView {

    static let defaultH: CGFloat = 58.0
    static let viewTag = -505
    
    @IBOutlet weak var iLoadingImage: UIImageView!
    @IBOutlet weak var iLoadingImage2: UIImageView!
    @IBOutlet weak var iBackgroundView: UIView!
    @IBOutlet weak var iLoadingLabel: UILabel!
    @IBOutlet weak var iLoadingProgress: UIActivityIndicatorView!
    
    var loadErrorBlock: (() -> ())?
    var loadMoreErrorBlock: (() -> ())?
    
    var state = GlobalLoadingViewState.Normal
    
    deinit {
        iLoadingImage.stopAnimating()
        iLoadingImage2.stopAnimating()
    }
    
    class func create() -> GlobalLoadingView {
        let view = ApplicationUtils.loadNibForView("GlobalLoadingView") as! GlobalLoadingView
        view.frame = CGRectMake(0, 0, dWidth, defaultH)
        view.tag = GlobalLoadingView.viewTag
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        iBackgroundView.backgroundColor = UIColor.clearColor()
        iLoadingLabel.textColor = AppStyle.appLightTextColor()
        iLoadingProgress.color = AppStyleColor
        
        var animationImages: [UIImage] = []
        for i in 2...19 {
            animationImages.append(UIImage(named: "refresh\(i)")!)
        }
        var animation2Images: [UIImage] = []
        for i in 1...15 {
            animation2Images.append(UIImage(named: "refresh2_\(i)")!)
        }
        var duration: Double = Double(animationImages.count) * 0.1
        iLoadingImage.animationDuration = duration
        iLoadingImage.animationRepeatCount = 0
        iLoadingImage.animationImages = animationImages
        iLoadingImage2.animationDuration = duration
        iLoadingImage2.animationRepeatCount = 0
        iLoadingImage2.animationImages = animation2Images
        iBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapped"))
    }
    
    func tapped() {
        if state == .LoadError && loadErrorBlock != nil {
            startLoading()
            loadErrorBlock!()
        } else if state == .LoadMoreError &&  loadMoreErrorBlock != nil {
            startLoadingMore()
            loadMoreErrorBlock!()
        }
    }
    
    func addLoadErrorBlock(block: () -> ()) {
        loadErrorBlock = block
    }
    
    func addLoadMoreErrorBlock(block: () -> ()) {
        loadMoreErrorBlock = block
    }
    
    func startLoading() {
        state = .Loading
        iLoadingImage.hidden = false
        iLoadingImage2.hidden = true
        iLoadingImage.startAnimating()
        iLoadingProgress.startAnimating()
        iLoadingLabel.hidden = true
    }
    
    func stopLoading() {
        state = .Normal
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = true
        iLoadingImage.stopAnimating()
        iLoadingProgress.stopAnimating()
        iLoadingLabel.hidden = true
    }
    
    func loadError(error: String) {
        state = .LoadError
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = true
        iLoadingImage.stopAnimating()
        iLoadingProgress.stopAnimating()
        iLoadingLabel.hidden = false
        iLoadingLabel.text = error + " " + ApplicationUtils.i18n("app.loading.view.retry")
    }
    
    func startLoadingMore() {
        state = .LoadingMore
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = false
        iLoadingImage2.startAnimating()
        iLoadingProgress.startAnimating()
        iLoadingLabel.hidden = true
    }
    
    func stopLoadingMore() {
        state = .Normal
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = true
        iLoadingImage2.stopAnimating()
        iLoadingProgress.stopAnimating()
        iLoadingLabel.hidden = true
    }
    
    func loadMoreError(error: String) {
        state = .LoadMoreError
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = true
        iLoadingImage2.stopAnimating()
        iLoadingProgress.stopAnimating()
        iLoadingLabel.hidden = false
        iLoadingLabel.text = error + " " + ApplicationUtils.i18n("app.loading.view.retry")
    }
    
    func loadAll(msg: String?) {
        state = .LoadAll
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = true
        iLoadingImage2.stopAnimating()
        iLoadingProgress.stopAnimating()
        iLoadingLabel.hidden = false
        iLoadingLabel.text = msg == nil ? ApplicationUtils.i18n("app.load.all") : msg
    }
    
    func loadNone(msg: String?) {
        state = .LoadNone
        iLoadingImage.hidden = true
        iLoadingImage2.hidden = true
        iLoadingImage.stopAnimating()
        iLoadingProgress.stopAnimating()
        iLoadingLabel.hidden = false
        iLoadingLabel.text = msg == nil ? ApplicationUtils.i18n("app.load.all") : msg
    }

}





