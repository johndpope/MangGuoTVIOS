//
//  TitleCollectionViewCell.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/16.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    static let cellId = "TitleCollectionViewCell"
    

  
    @IBOutlet weak var moreLabel: UILabel!
    
    private var titileChannel = ChannelTemplateModel()
    @IBOutlet weak var titleName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
            }
    func configure(channel:ChannelTemplateModel)
    {
        self.titileChannel = channel
        if titileChannel.jumpType != "subjectPage"
        {
            self.moreLabel.hidden = true
        }
        self.titleName.text = titileChannel.name

    }

}
