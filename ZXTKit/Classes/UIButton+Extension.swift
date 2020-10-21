//
//  UIButton+Extension.swift
//  chinaFocusBIBF
//
//  Created by 张泉 on 2020/6/28.
//  Copyright © 2020 manman. All rights reserved.
//

import UIKit


struct UIButtonExtensionKeys {
    static var clickAreaRadiousKey: String = "clickAreaRadiousKey"
    static var clickEventTimeKey:String = "clickEventTimeKey"
    static var clickActionTimeKey:String = "clickActionTimeKey"
}


extension UIButton {
    
    public var clickAreaRadious: CGFloat? {
        get {
            return (objc_getAssociatedObject(self, &UIButtonExtensionKeys.clickAreaRadiousKey) as? CGFloat) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &UIButtonExtensionKeys.clickAreaRadiousKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var clickEventTime:Double? {
        get {
                return (objc_getAssociatedObject(self, &UIButtonExtensionKeys.clickEventTimeKey) as? Double) ?? 0
            }
           set {
               objc_setAssociatedObject(self, &UIButtonExtensionKeys.clickEventTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
    }
    
    public var clickActionTime:Double? {
        get {
                return (objc_getAssociatedObject(self, &UIButtonExtensionKeys.clickActionTimeKey) as? Double) ?? 0
            }
           set {
               objc_setAssociatedObject(self, &UIButtonExtensionKeys.clickActionTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
           }
    }
    
    
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if (clickEventTime ?? 0) != 0 {
            
            if Date().timeIntervalSince1970 - (clickActionTime ?? 0) < (clickEventTime ?? 0){
                return
            }
            clickActionTime = Date().timeIntervalSince1970
            super.sendAction(action, to: target, for: event)
        }else {
            super.sendAction(action, to: target, for: event)
        }
        
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let widthDelta = max((clickAreaRadious ?? 0) - self.bounds.width , 0)
        let heightDelta = max((clickAreaRadious ?? 0) - self.bounds.height , 0)
        let bounds = self.bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return bounds.contains(point)
    }
    
    /**
     快捷设置按钮
     
     - parameter titlePosition:     文本所在位置 上方 下方 左方 右方
     - parameter additionalSpacing: 间距
     */
    @objc func set(titlePosition:UIView.ContentMode, additionalSpacing:CGFloat) {
        
        func positionLabelRespectToImage(position:UIView.ContentMode, spacing:CGFloat) {
            
            self.sizeToFit()
            
            let imageSize = self.imageView!.bounds.size
            let titleSize = self.titleLabel!.bounds.size
            
            var titleInsets: UIEdgeInsets
            var imageInsets: UIEdgeInsets
            
            switch (position){
            case .top:
                titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                           left: -(imageSize.width), bottom: 0, right: 0)
                imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            case .bottom:
                titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                           left: -(imageSize.width), bottom: 0, right: 0)
                imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            case .left:
                titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
                imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                           right: -(titleSize.width * 2 + spacing))
            case .right:
                titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
                imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            default:
                titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            self.titleEdgeInsets = titleInsets
            self.imageEdgeInsets = imageInsets
        }
        
        positionLabelRespectToImage(position: titlePosition, spacing: additionalSpacing)
    }
    
    func addAnimation(_ durationTime: Double) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.isRemovedOnCompletion = true
        
        let animationZoomOut = CABasicAnimation(keyPath: "transform.scale")
        animationZoomOut.fromValue = 0
        animationZoomOut.toValue = 1.2
        animationZoomOut.duration = 3/4 * durationTime
        
        let animationZoomIn = CABasicAnimation(keyPath: "transform.scale")
        animationZoomIn.fromValue = 1.2
        animationZoomIn.toValue = 1.0
        animationZoomIn.beginTime = 3/4 * durationTime
        animationZoomIn.duration = 1/4 * durationTime
        
        groupAnimation.animations = [animationZoomOut, animationZoomIn]
        self.layer.add(groupAnimation, forKey: "addAnimation")
    }
  
}
