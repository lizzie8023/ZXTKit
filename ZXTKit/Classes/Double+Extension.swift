//
//  Double+Extension.swift
//  chinaFocusBIBF
//
//  Created by 张泉 on 2020/8/24.
//  Copyright © 2020 manman. All rights reserved.
//

import UIKit

extension Double {
    
    /// 取出位数0
    var cleanZero : String {
        
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        
    }
    
    /// 小数点保留几位
    func ceiling(toDecimal decimal: Int) -> Double {
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        if self.sign == .minus {
            return Double(Int(self * numberOfDigits)) / numberOfDigits
        } else {
            return Double(ceil(self * numberOfDigits)) / numberOfDigits
        }
    }
    
    
}
