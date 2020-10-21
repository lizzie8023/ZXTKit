//
//  UILabel+Extension.swift
//  New
//
//  Created by 风晓得8023 on 15/10/24.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {

    /**
     便捷的构造方法
     - parameter color:    字体颜色
     - parameter fontSize: 字体大小
     */
    convenience init(color: UIColor, fontSize: CGFloat, customFontType:FontType, textAlignment:NSTextAlignment) {
        self.init()
        self.textColor = color
        self.textAlignment = textAlignment
        
        if #available(iOS 9.0, *) {
            
            if customFontType == .Default {
                self.font = UIFont.systemFont(ofSize: fontSize)
            }else {
                self.font = UIFont(name: customFontType.rawValue, size: fontSize)
            }
        }else {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
        
    }
    
    func setLineHeight(lineSpacing:CGFloat, lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        
        
        let attrString = NSMutableAttributedString(string: self.text ?? "")
        attrString.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: self.font ?? UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    /// 获取行数
    func getNumberOfLines() ->Int{
        let lines = self.value(forKey: "measuredNumberOfLines") as? Int ?? 0
        return lines
    }
    
}




