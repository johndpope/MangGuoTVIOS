//
//  VideoCollectionViewCell.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/15.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    static var videoCellId = "VideoCollectionViewCell"
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    private var channel = ChannelTemplateModel()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(channel:ChannelTemplateModel)
    {
        self.channel = channel
        videoName.text = channel.name
        tagLabel.text = channel.tag
        ImageLoader().loadImage(url: channel.picUrl) { (image, remote) -> () in
            if image != nil {
                self.image.image = image!
            }else{
                self.image.image = UIImage(named: "main_tab_recommend_normal")
            }
        }
    }
}
