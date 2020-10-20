//
//  UIImage+Extension.swift
//  weibo
//
//  Created by 风晓得8023 on 15/10/10.
//  Copyright © 2015年 诠释. All rights reserved.
//
/**
 
 UIViewContentModeScaleToFill 图片以控件大小为准  填满  （以椭圆形为例，变形）
 UIViewContentModeScaleAspectFit  图片以自身宽高比为准填充 ，剩余空间透明（不变形）
 UIViewContentModeScaleAspectFill  图片显示不全，类似于放大并显示一部分
 */


import Foundation
import UIKit
import Accelerate

extension UIImage {
    
    class func imageWithIconFont(fontText:String, fontSize:CGFloat,size:CGSize, color:UIColor) ->UIImage?{
        
        UIGraphicsBeginImageContext(size)
        let label = UILabel(color: color, fontSize: fontSize, customFontType: FontType.IconFont, textAlignment: NSTextAlignment.center)
        label.text = fontText
        
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    
    func creatRoundImage() ->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size,false,UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.addEllipse(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        ctx!.clip()
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     缩放图片
     
     - parameter image:  原始图片
     - parameter resize: 指定的压缩大小
     */
    class func reSizeImage(_ image:UIImage?, resize:CGSize, drawPoint:CGPoint = CGPoint.zero) ->UIImage? {
        
        guard let img = image else {
            return image
        }
        
        UIGraphicsBeginImageContext(resize)
        UIGraphicsBeginImageContextWithOptions(resize, false, 0.0)
        img.draw(in: CGRect(x: drawPoint.x, y: drawPoint.y, width: resize.width, height: resize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage!
    }
    
    /** 返回一个基于中心点的拉伸图片        */
    class func imageWithName(_ name:String) -> UIImage{
    
        let image = UIImage(named: name)!
        return image.stretchableImage(withLeftCapWidth: Int(image.size.width * 0.5), topCapHeight: Int(image.size.height * 0.6))
    }
    
    /**     返回纯色的背景图片        */
    class func imageWithColor(_ color:UIColor,size:CGSize) ->UIImage{
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
     /**    将label转换为image */
    class func imageWithView(_ view:UIView,size:CGSize) ->UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     将图片转成高斯模糊
     */
    func gaussianBlur(_ blurAmount:CGFloat) -> UIImage {
        var blurAmountCopy = blurAmount
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        if (blurAmountCopy < 0.0 || blurAmountCopy > 1.0) {
            blurAmountCopy = 0.5
        }
        
        var boxSize = Int(blurAmountCopy * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = self.cgImage
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        
        let inProvider =  img!.dataProvider
        let inBitmapData =  inProvider!.data
        
        inBuffer.width = vImagePixelCount(img!.width)
        inBuffer.height = vImagePixelCount(img!.height)
        inBuffer.rowBytes = img!.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        //手动申请内存
        let pixelBuffer = malloc(img!.bytesPerRow * img!.height)
        
        outBuffer.width = vImagePixelCount(img!.width)
        outBuffer.height = vImagePixelCount(img!.height)
        outBuffer.rowBytes = img!.bytesPerRow
        outBuffer.data = pixelBuffer
        
        var error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if (kvImageNoError != error)
        {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if (kvImageNoError != error)
            {
                error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                                   &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                                   UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue
        
        let ctx = CGContext(data: outBuffer.data,
                                        width: Int(outBuffer.width),
                                        height: Int(outBuffer.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: outBuffer.rowBytes,
                                        space: colorSpace,
                                        bitmapInfo: bitmapInfo)
        
        let imageRef = ctx!.makeImage()
        
        //手动申请内存
        free(pixelBuffer)
        
        return UIImage(cgImage:imageRef!)
    }
    
    /// 返回图片主题颜色
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGContext(data: &bitmap, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)!
            let inputImage = cgImage ?? CIContext().createCGImage(ciImage!, from: ciImage!.extent)
            
            // Render to bitmap.
            context.draw(inputImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
 
    /// 给图片更换主题颜色
    func imageWithTinkColor(tinkColor:UIColor, blendMode:CGBlendMode) ->UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        tinkColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: blendMode, alpha: 1)
        if blendMode != CGBlendMode.destinationIn {
            self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 屏幕截屏
    class func shotScreenImage() ->UIImage {
        
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!
        UIGraphicsBeginImageContext(window.frame.size)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
//    /// 返回图片尺寸
//    var bytesSize: Int {
//        return jpegData(compressionQuality: 1)?.count ?? 0
//    }
//
//    /// 返回图片尺寸 单位是千字节
//    var kilobytesSize: Int {
//        return bytesSize / 1024
//    }
    
    /// 原图
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// 通过指定高度 缩放图片
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: 不透明度
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 通过指定宽度 缩放图片
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: 不透明度
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 返回指定旋转角度的图片副本
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(iOS 10.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)
        
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 返回指定旋转弧度的图片副本
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 将图片切成圆角
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 文本转图片
    class func image(_ text:String,size:(CGFloat,CGFloat),backColor:UIColor=UIColor.orange,textColor:UIColor=UIColor.white, font:UIFont, isCircle:Bool=true) -> UIImage?{
        // 过滤空""
        if text.isEmpty { return nil }
        
        var letter:String = ""
        // 截取文本
        if text.count >= 2 {
            letter = (text as NSString).substring(to: 2)
        }else {
            letter = (text as NSString).substring(to: 1)
        }
        
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide*0.5).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(backColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        let attr = [NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : font]
        let letterSize = letter.size(font, maxSize: sise)
        // 写入文字
        (letter as NSString).draw(at: CGPoint(x: (sise.width * 0.5) - (letterSize.width * 0.5), y: (sise.height * 0.5) - (letterSize.height * 0.5)), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }

    
    
}
