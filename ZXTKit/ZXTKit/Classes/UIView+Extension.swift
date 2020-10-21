//
//  UIView+Extension.swift
//  chinaFocusBIBF
//
//  Created by  jiangxiaopeng on 2020/5/30.
//  Copyright © 2020 manman. All rights reserved.
//

import UIKit


extension UIView {
    @objc class func cf_cellIdentifier() -> String {
        return "\(NSStringFromClass(self))"
    }
    
    func move(to destination: CGPoint, duration: TimeInterval,
              options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: nil)
    }
    
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func favoriteAnimation() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIView.KeyframeAnimationOptions.layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3.0, relativeDuration: 1/3.0) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/2.0, relativeDuration: 1/2.0) { [weak self] in
                self?.transform = .identity
            }
        }, completion: nil)
    }
    
   @objc func addTargetEventAction(target:Any,action:Selector) {
        self.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer.init(target:target, action: action)
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
    }
    
    func didAnimate(scale:CGFloat = 0.75) {
        UIView.animate(withDuration: 0.1, animations: {[weak self] in
            self?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { (isOK) in
            UIView.animate(withDuration: 0.1, animations: {[weak self] in
                self?.transform = CGAffineTransform.identity
            })
        }
    }
   func setShadow(sColor:UIColor,offset:CGSize,
                  opacity:Float,radius:CGFloat) {
        //设置阴影颜色
        self.layer.shadowColor = sColor.cgColor
        //设置透明度
        self.layer.shadowOpacity = opacity
        //设置阴影半径
        self.layer.shadowRadius = radius
        //设置阴影偏移量
        self.layer.shadowOffset = offset
   }
}
