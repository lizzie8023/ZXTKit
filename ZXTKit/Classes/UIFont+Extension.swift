//
//  UIFont+Extension.swift
//  guanbaIOS_v2
//
//  Created by 诠释 on 2017/4/30.
//  Copyright © 2017年 Lizzie. All rights reserved.
//

import UIKit

enum FontType:String {
    case Default = ""
    case Regular = "PingFangSC-Regular"
    /// 超细
    case Ultralight = "PingFangSC-Ultralight"
    /// 中粗体
    case Semibold = "PingFangSC-Semibold"
    /// 细
    case Thin = "PingFangSC-Thin"
    /// 
    case Light = "PingFangSC-Light"
    case Medium = "PingFangSC-Medium"
    case IconFont = "iconfont"
    /// 粗体
    case Bold = "Helvetica-Bold"
    /// 斜体
    case Oblique = "Helvetica-Oblique"
    /// 又粗又斜
    case BoldOblique = "Helvetica-BoldOblique"
    
    /// 自定义字体
    case MontserratRegular = "Montserrat-Regular"
    case MontserratMedium = "Montserrat-Medium"
    case MontserratBold = "Montserrat-Bold"
}

extension UIFont {
    /**
     * 便捷设置字体
     * type:字体名枚举
     * size:字体尺寸
     */
    class func fontWithType(type:FontType, size:CGFloat) ->UIFont {
        
        let font:UIFont!
        
        if #available(iOS 9.0, *) {
            font = UIFont(name: type.rawValue, size: size)
        }else {
            font = UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    
    ///  返回一个粗体的Font对象
    var bold: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }
    
    /// 返回一个斜体的Font对象
    var italic: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }
    
    /// 返回一个等宽字体
    ///
    ///     UIFont.preferredFont(forTextStyle: .body).monospaced
    ///
    var monospaced: UIFont {
        let settings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType, UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        
        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        let newDescriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }

    
}
