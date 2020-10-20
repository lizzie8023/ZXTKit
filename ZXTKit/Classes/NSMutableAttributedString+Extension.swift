//
//  NSMutableAttributedString + Extension.swift
//  chinaFocusBIBF
//
//  Created by 张泉 on 2020/7/20.
//  Copyright © 2020 manman. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    /// 获取范围
    func cf_allRange() -> NSRange {
        return NSMakeRange(0,length)
    }
    /// 添加中划线
    @discardableResult
    func cf_addMidline(_ lineHeght: Int) -> NSMutableAttributedString {
        addAttributes([.strikethroughStyle:lineHeght], range: cf_allRange())
        return self
    }
    /// 中划线颜色
    @discardableResult
    func cf_midlineColor(_ color: UIColor) -> NSMutableAttributedString{
        addAttributes([.strikethroughColor:color], range: cf_allRange())
        return self
    }
    /// 给文字添加描边
    ///
    /// - Parameter width: 描边宽带
    /// - Returns:
    @discardableResult
    func cf_addStroke(_ width: CGFloat) -> NSMutableAttributedString {
        addAttributes([.strokeWidth:width], range: cf_allRange())
        return self
    }
    /// 描边颜色
    @discardableResult
    func cf_strokeColor(_ color: UIColor) -> NSMutableAttributedString {
        addAttributes([.strokeColor:color], range: cf_allRange())
        return self
    }
    
    /// 添加字间距
    @discardableResult
    func cf_addSpace(_ space: CGFloat) -> NSMutableAttributedString {
        addAttributes([.kern:space], range: cf_allRange())
        return self
    }
    /// 背景色
    @discardableResult
    func cf_backgroundColor(_ color: UIColor) -> NSMutableAttributedString {
        addAttributes([.backgroundColor:color], range: cf_allRange())
        return self
    }
    /// 文字颜色
    @discardableResult
    func cf_color(_ color: UIColor) -> NSMutableAttributedString {
        addAttributes([.foregroundColor:color], range: cf_allRange())
        return self
    }

    /// 添加下划线
    ///
    @discardableResult
    func cf_addUnderLine(_ style: NSUnderlineStyle) -> NSMutableAttributedString{
        addAttributes([.underlineStyle:style.rawValue], range: cf_allRange())
        return self
    }
    /// 下划线颜色
    @discardableResult
    func cf_underLineColor(_ color: UIColor) -> NSMutableAttributedString{
        addAttributes([.underlineColor:color], range: cf_allRange())
        return self
    }
    
    /// 字体
    @discardableResult
    func cf_font(_ font: UIFont) -> NSMutableAttributedString{
        addAttributes([.font:font], range: cf_allRange())
        return self
    }
    /// 系统字体大小
    @discardableResult
    func cf_fontSize(_ size: CGFloat)->NSMutableAttributedString{
        addAttributes([.font:UIFont.systemFont(ofSize: size)], range: cf_allRange())
        return self
    }
    
    /// 添加行间距
    @discardableResult
    func cf_addLineSpace(_ space: CGFloat) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        style.lineBreakMode = .byCharWrapping
        addAttribute(.paragraphStyle, value: style, range: cf_allRange())
        return self
    }
    /// 拼接富文本
    @discardableResult
    func cf_addAttribute(_ attribute: NSMutableAttributedString) -> NSMutableAttributedString {
        append(attribute)
        return self
    }
    
    /// 添加阴影
    @discardableResult
    func cf_addShadow(_ shadowOffset:CGSize? = nil ,_ color: UIColor? = nil) -> NSMutableAttributedString {
        let shadow = NSShadow.init()
        shadow.shadowColor = color == nil ? UIColor.black : color!
        shadow.shadowOffset = shadowOffset == nil ? CGSize.init(width: 2, height: 2) : shadowOffset!
        addAttributes([NSAttributedString.Key.shadow: shadow], range: cf_allRange())
        return self
    }
}


public extension String {
    /// 字符串转富文本
    func cf_toAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}
