//
//  Constants.swift
//  AppClient
//
//  Created by 陆广庆 on 15/3/10.
//  Copyright (c) 2015年 陆广庆. All rights reserved.
//


import AssetsLibrary
import UIKit


let assetsLibrary = ALAssetsLibrary()
let kImageCompressionQuality: CGFloat = 0.6
let kThumbnailMaxSize: CGFloat = 150
let kAvatarMaxSize: CGFloat = 200
let kAvatarThumbnailMaxSize: CGFloat = 50
let kCoverThumbnailMaxSize: CGFloat = 100
let kLocalPostSidPrefix = "LOCAL_POST_"
let kVideoSuffix = ".mp4"
let kThumbnailSuffix = ".thub"
let kImageSuffix = ".ognl"
let kGroupTableSpacing: CGFloat = 8.0
let kTagCustomImage = UIImage(named: "ic_tag")
let kTagTopicImage = UIImage(named: "tag_point")
let kTagImage = UIImage(named: "tag_bg")
let kTagLocationImage = UIImage(named: "ic_loc")


struct AppEffect {
    var filterName: String!
    var filterNameDesc: String!
}

struct AppCrop {
    var demoImage: UIImage!
    var desc: String!
}

let AppBaseTagTheme  =
[
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
    ApplicationUtils.i18n("tag.nature.01"),
]

let AppVideoEffects =
[
    AppEffect(filterName: "", filterNameDesc: "无效果"),
    AppEffect(filterName: "CIPhotoEffectTransfer", filterNameDesc: "岁月"),
    AppEffect(filterName: "CIPhotoEffectChrome", filterNameDesc: "铬黄"),
    AppEffect(filterName: "CIPhotoEffectInstant", filterNameDesc: "怀旧"),
    AppEffect(filterName: "CIPhotoEffectProcess", filterNameDesc: "胶片"),
    AppEffect(filterName: "CIColorMonochrome", filterNameDesc: "古铜"),
    AppEffect(filterName: "CISepiaTone", filterNameDesc: "复古"),
    AppEffect(filterName: "CIMaximumComponent", filterNameDesc: "沧桑")
]

let AppPhotoEffects =
[
    AppEffect(filterName: "", filterNameDesc: "原图"),
    //AppEffect(filterName: kImageFilterNameAuto, filterNameDesc: "自动"),
    AppEffect(filterName: kImageFilterNameOldFilm, filterNameDesc: "胶片"),
    AppEffect(filterName: "CIPhotoEffectTransfer", filterNameDesc: "岁月"),
    AppEffect(filterName: "CIPhotoEffectChrome", filterNameDesc: "铬黄"),
    AppEffect(filterName: "CIPhotoEffectInstant", filterNameDesc: "怀旧"),
    AppEffect(filterName: "CIPhotoEffectProcess", filterNameDesc: "电影"),
    AppEffect(filterName: "CIColorMonochrome", filterNameDesc: "古铜"),
    AppEffect(filterName: "CISepiaTone", filterNameDesc: "复古"),
    AppEffect(filterName: "CIMaximumComponent", filterNameDesc: "沧桑")
]

let AppPhotoCrops =
[
    AppCrop(demoImage: UIImage(named:"ic_crop_original")!, desc: "原始比例"),
    AppCrop(demoImage: UIImage(named:"ic_crop_1:1")!, desc: "正方形")
]








