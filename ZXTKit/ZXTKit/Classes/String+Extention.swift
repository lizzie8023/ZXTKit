//
//  String+Extention.swift
//  chinaFocusBIBF
//
//  Created by jiangxiaopeng on 2020/6/4.
//  Copyright © 2020 manman. All rights reserved.
//

import UIKit

extension String {
    
    func sizeWithText(font: UIFont, size: CGSize) -> CGSize {
        //        let para = NSMutableParagraphStyle()
        //        para.lineSpacing = 10
        let attributes = [
            NSAttributedString.Key.font : font
            //            NSAttributedString.Key.paragraphStyle :para
        ]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
    func urlHost() -> String {
        return URL(string:self)?.host ?? self
    }
    
    func cf_mutableAttributedString(font: UIFont, color: UIColor, lineSpace:CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
        ])
        return attributedString
    }
    
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    
    func changeAttrString(text:String,detailString:String) -> NSMutableAttributedString {
        let detailString = text + ":" + detailString
        let attr = NSMutableAttributedString.init(string: detailString)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "#333333") as Any, range: NSRange(location: 0, length: text.count))
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "#999999") as Any, range: NSRange(location: text.count, length: attr.length - text.count))
        return attr
    }
    
}

extension NSMutableAttributedString {
    
    func sizeWithText(font: UIFont, size: CGSize, lineSpace:CGFloat? = 0) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace ?? 0
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font : font
        ]
        self.setAttributes(attributes, range: NSMakeRange(0,self.length))
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, context: nil)
        return rect.size;
    }
    
    func getLines(width: CGFloat) -> Int {
        let framesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: CGFloat(INT_MAX)))
        let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        let rows: CFArray = CTFrameGetLines(frame)
        let numberOfLines: Int = CFArrayGetCount(rows)
        return numberOfLines
    }
   
}

