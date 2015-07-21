//
//  ChannelViewController.swift
//  MangGuoTV
//
//  Created by xyl on 15/6/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//
import UIKit
import ImageIO

let kImageFilterNameAuto = "auto"
let kImageFilterNameOldFilm = "oldFilm"

class ImageFilter: NSObject {
    
    init(originalImage: UIImage) {
        super.init()
        self.originalImage = originalImage
    }
    
    var originalImage: UIImage!
    
    lazy var context = CIContext(options: nil)
    
    var filter: CIFilter?
    
    func showFiltersInConsole() -> [String : UIImage] {
        let filterNames = CIFilter.filterNamesInCategory(kCICategoryColorEffect)
        println(filterNames.count)
        println(filterNames)
        var filterImages: [String : UIImage] = [:]
        for filterName in filterNames {
            let name = filterName as! String
            filter = CIFilter(name: name)
            //let attributes = filter.attributes()
            //println(attributes)
            if let image = applyFilter() {
                filterImages[name] = image
            }
            
        }
        return filterImages
    }
    
    func imagesWithFilters(filterNames: [String]) -> [UIImage] {
        var filterImages: [UIImage] = []
        for filterName in filterNames {
            filterImages.append(imageWithFilter(filterName))
        }
        return filterImages
    }
    
    func imageWithFilter(filterName: String) -> UIImage {
        if filterName.isBlankByTrimming() {
            return originalImage
        }
        if filterName == kImageFilterNameAuto {
            let image = autoAdjust()
            return image
        }
        if filterName == kImageFilterNameOldFilm {
            let image = oldFilmEffect()
            return image
        }
        filter = CIFilter(name: filterName)
        if let image = applyFilter() {
            return image
        } else {
            return originalImage
        }
    }
    
    /*!
    自动调整
    系统自动使用以下滤镜：
    CIRedEyeCorrection：修复因相机的闪光灯导致的各种红眼
    CIFaceBalance：调整肤色
    CIVibrance：在不影响肤色的情况下，改善图像的饱和度
    CIToneCurve：改善图像的对比度
    CIHighlightShadowAdjust：改善阴影细节
    */
    func autoAdjust() -> UIImage {
        var inputImage = CIImage(image: originalImage!)
        let filters = inputImage.autoAdjustmentFilters() as! [CIFilter]
        for filter: CIFilter in filters {
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            inputImage = filter.outputImage
        }
        return UIImage(CIImage: inputImage)!
    }
    
    // MARK: - 怀旧
    func effectInstant() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectInstant")
        return applyFilter()
    }
    
    // MARK: - 黑白
    func effectNoir() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectNoir")
        return applyFilter()
    }
    
    // MARK: - 色调
    func effectTonal() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectTonal")
        return applyFilter()
    }
    
    // MARK: - 岁月
    func effectTransfer() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectTransfer")
        return applyFilter()
    }
    
    // MARK: - 单色
    func effectMono() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectMono")
        return applyFilter()
    }
    
    // MARK: - 褪色
    func effectFade() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectFade")
        return applyFilter()
    }
    
    // MARK: - 冲印
    func effectProcess() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectProcess")
        return applyFilter()
    }
    
    // MARK: - 铬黄
    func effectChrome() -> UIImage? {
        filter = CIFilter(name: "CIPhotoEffectChrome")
        return applyFilter()
    }
    
    func oldFilmEffect() -> UIImage {
        let inputImage = CIImage(image: originalImage)
        // 1.创建CISepiaTone滤镜
        let sepiaToneFilter = CIFilter(name: "CISepiaTone")
        sepiaToneFilter.setValue(inputImage, forKey: kCIInputImageKey)
        sepiaToneFilter.setValue(1, forKey: kCIInputIntensityKey)
        // 2.创建白班图滤镜
        let whiteSpecksFilter = CIFilter(name: "CIColorMatrix")
        whiteSpecksFilter.setValue(CIFilter(name: "CIRandomGenerator").outputImage.imageByCroppingToRect(inputImage.extent()), forKey: kCIInputImageKey)
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputRVector")
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputGVector")
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputBVector")
        whiteSpecksFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")
        // 3.把CISepiaTone滤镜和白班图滤镜以源覆盖(source over)的方式先组合起来
        let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing")
        sourceOverCompositingFilter.setValue(whiteSpecksFilter.outputImage, forKey: kCIInputBackgroundImageKey)
        sourceOverCompositingFilter.setValue(sepiaToneFilter.outputImage, forKey: kCIInputImageKey)
        // ---------上面算是完成了一半
        // 4.用CIAffineTransform滤镜先对随机噪点图进行处理
        let affineTransformFilter = CIFilter(name: "CIAffineTransform")
        affineTransformFilter.setValue(CIFilter(name: "CIRandomGenerator").outputImage.imageByCroppingToRect(inputImage.extent()), forKey: kCIInputImageKey)
        affineTransformFilter.setValue(NSValue(CGAffineTransform: CGAffineTransformMakeScale(1.5, 25)), forKey: kCIInputTransformKey)
        // 5.创建蓝绿色磨砂图滤镜
        let darkScratchesFilter = CIFilter(name: "CIColorMatrix")
        darkScratchesFilter.setValue(affineTransformFilter.outputImage, forKey: kCIInputImageKey)
        darkScratchesFilter.setValue(CIVector(x: 4, y: 0, z: 0, w: 0), forKey: "inputRVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputGVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputAVector")
        darkScratchesFilter.setValue(CIVector(x: 0, y: 1, z: 1, w: 1), forKey: "inputBiasVector")
        // 6.用CIMinimumComponent滤镜把蓝绿色磨砂图滤镜处理成黑色磨砂图滤镜
        let minimumComponentFilter = CIFilter(name: "CIMinimumComponent")
        minimumComponentFilter.setValue(darkScratchesFilter.outputImage, forKey: kCIInputImageKey)
        // ---------上面算是基本完成了
        // 7.最终组合在一起
        let multiplyCompositingFilter = CIFilter(name: "CIMultiplyCompositing")
        multiplyCompositingFilter.setValue(minimumComponentFilter.outputImage, forKey: kCIInputBackgroundImageKey)
        multiplyCompositingFilter.setValue(sourceOverCompositingFilter.outputImage, forKey: kCIInputImageKey)
        // 8.最后输出
        let outputImage = multiplyCompositingFilter.outputImage
        let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent())
        return UIImage(CGImage: cgImage)!
    }
    
    func faceDetecing(imageView: UIImageView) {
        let inputImage = CIImage(image: originalImage)
        let detector = CIDetector(ofType: CIDetectorTypeFace,
            context: context,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        if let orientation: AnyObject = inputImage.properties()?[kCGImagePropertyOrientation] {
            faceFeatures = detector.featuresInImage(inputImage, options: [CIDetectorImageOrientation: orientation]) as! [CIFaceFeature]
        } else {
            faceFeatures = detector.featuresInImage(inputImage) as! [CIFaceFeature]
        }
        let inputImageSize = inputImage.extent().size
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformScale(transform, 1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height)
        
        for faceFeature in faceFeatures {
            var faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform)
            //加框标记
            var scale = min(imageView.bounds.size.width / inputImageSize.width,
                imageView.bounds.size.height / inputImageSize.height)
            var offsetX = (imageView.bounds.size.width - inputImageSize.width * scale) / 2
            var offsetY = (imageView.bounds.size.height - inputImageSize.height * scale) / 2
            
            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceView = UIView(frame: faceViewBounds)
            faceView.layer.borderColor = UIColor.orangeColor().CGColor
            faceView.layer.borderWidth = 2
            
            imageView.addSubview(faceView)
        }
    }
    
    // 马赛克
    func pixellated(contentSize: CGSize) -> UIImage {
        // 1.
        var filter = CIFilter(name: "CIPixellate")
        //println(filter.attributes())
        let inputImage = CIImage(image: originalImage)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        // filter.setValue(max(inputImage.extent().size.width, inputImage.extent().size.height) / 60, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter.outputImage
        // let cgImage = context.createCGImage(fullPixellatedImage, fromRect: fullPixellatedImage.extent())
        // imageView.image = UIImage(CGImage: cgImage)
        // 2.
        let detector = CIDetector(ofType: CIDetectorTypeFace,
            context: context,
            options: nil)
        let faceFeatures = detector.featuresInImage(inputImage)
        // 3.
        var maskImage: CIImage!
        var scale = min(contentSize.width / inputImage.extent().size.width,
            contentSize.height / inputImage.extent().size.height)
        for faceFeature in faceFeatures {
            println(faceFeature.bounds)
            // 4.
            let centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2
            let centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2
            let radius = min(faceFeature.bounds.size.width*CGFloat(2.0), faceFeature.bounds.size.height*CGFloat(2.0)) * scale
            let radialGradient = CIFilter(name: "CIRadialGradient",
                withInputParameters: [
                    "inputRadius0" : radius,
                    "inputRadius1" : radius + 1,
                    "inputColor0" : CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                    "inputColor1" : CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                    kCIInputCenterKey : CIVector(x: centerX, y: centerY)
                ])
            println(radialGradient.attributes())
            // 5.
            let radialGradientOutputImage = radialGradient.outputImage.imageByCroppingToRect(inputImage.extent())
            if maskImage == nil {
                maskImage = radialGradientOutputImage
            } else {
                println(radialGradientOutputImage)
                maskImage = CIFilter(name: "CISourceOverCompositing",
                    withInputParameters: [
                        kCIInputImageKey : radialGradientOutputImage,
                        kCIInputBackgroundImageKey : maskImage
                    ]).outputImage
            }
            println(maskImage.extent())
        }
        // 6.
        let blendFilter = CIFilter(name: "CIBlendWithMask")
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        // 7.
        let blendOutputImage = blendFilter.outputImage
        let blendCGImage = context.createCGImage(blendOutputImage, fromRect: blendOutputImage.extent())
        return UIImage(CGImage: blendCGImage)!
    }
    
    private func applyFilter() -> UIImage? {
        let inputImage = CIImage(image: originalImage!)
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        if let outputImage = filter!.outputImage {
            let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent())
            return UIImage(CGImage: cgImage)
            
        }
        return nil
    }
    
    func effectNameCN(filterName: String) -> String {
        if let cn = effectMap[filterName] {
            return cn
        }
        return filterName
    }
    
    lazy var effectMap: [String : String] =
    [   "CIColorClamp" : "" ,
        "CIColorCrossPolynomial" : "" ,
        "CIColorCube" : "" ,
        "CIColorCubeWithColorSpace" : "" ,
        "CIColorInvert" : "反转" ,
        "CIColorMap" : "矩阵" ,
        "CIColorMonochrome" : "古铜" ,
        "CIColorPolynomial" : "杂色" ,
        "CIColorPosterize" : "" ,
        "CIFalseColor" : "假彩色" ,
        "CIMaskToAlpha" : "混合" ,
        "CIMaximumComponent" : "沧桑" ,
        "CIPhotoEffectChrome" : "铬黄" ,
        "CIPhotoEffectFade" : "褪色" ,
        "CIPhotoEffectInstant" : "怀旧" ,
        "CIPhotoEffectMono" : "单色" ,
        "CIPhotoEffectNoir" : "黑白" ,
        "CIPhotoEffectProcess" : "胶片" ,
        "CIPhotoEffectTonal" : "色调" ,
        "CIPhotoEffectTransfer" : "岁月" ,
        "CISepiaTone" : "怀旧" ,
        "CIVignette" : "虚光" ,
        "CIVignetteEffect" : "秋日"
    ]
}
