//
//  Int+Extension.swift
//  guanba_iOS_v3
//
//  Created by zq on 2017/8/10.
//  Copyright © 2017年 Lizzie. All rights reserved.
//

import UIKit


public enum CFTimeFormatType {
    case normal
    case yyyy_mm_dd
    case yyyy_mm_dd_hh_ss
}


extension Int {
    
    var boolValue: Bool { return self != 0 }
    
    func formatterCount() ->String {
        
        var unit = ""
        var divisor:Int = 1
        if self >= 100000000 {
            divisor = 100000000
            unit = "亿"
        }else if self >= 1000000 {
            divisor = 1000000
            unit = "百万"
        }else if self >= 10000 {
            divisor = 10000
            unit = "万"
        }
        
        if divisor == 1 {
            return "\(self)"
        }
        
        let a = Double(self) / Double(divisor)
        return "\(String(format: "%.1f", a))\(unit)"
    }
    
    func downTwoDigits() -> String{
        
        //原始值
        let number = NSNumber(value: self)
        //创建一个NumberFormatter对象
        let numberFormatter = NumberFormatter()
        numberFormatter.formatWidth = 2 //补齐10位
        numberFormatter.paddingCharacter = "0" //不足位数用0补
        numberFormatter.paddingPosition = .beforePrefix  //补在前面
        return numberFormatter.string(from: number) ?? ""
        
    }
    
    func formatterDuration() ->String {
        
        guard self > 0 else {
            return "0'00\""
        }
        
        var m = self / 60
        let s = self - m * 60
        var sStr:String!
        
        if s < 10 {
            sStr = "0\(s)"
        }else {
            sStr = "\(s)"
        }
        
        if m < 60 {
            return "\(m)'\(sStr!)\""
        }else {
            
            let h = m / 60
            m = m - h * 60
            return "\(h)'\(m)'\(sStr!)\""
        }
        
    }
    
    
    var uInt: UInt {
        return UInt(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }

    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /**
     * 格式化为大于±1000的值的字符串(例如:1k、-2k、100k、1kk、-5kk.)
     */
    var kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = Swift.abs(self)
        if abs == 0 {
            return "0k"
        } else if abs >= 0 && abs < 1000 {
            return "0k"
        } else if abs >= 1000 && abs < 1000000 {
            return String(format: "\(sign)%ik", abs / 1000)
        }
        return String(format: "\(sign)%ikk", abs / 100000)
    }
}

extension Int64 {
    func toHoursMinSeconds() -> String {
        let hour = self/3600
        let minute = (self%3600)/60
        let second = self%60
        if hour < 1 {
            return String(format: "%02d:%02d", minute ,second)
        }
        return String(format: "%02d:%02d:%02d", hour, minute ,second)
    }
    
    func cf_int2Date(type: CFTimeFormatType) -> String {
        let date:Date = Date(timeIntervalSince1970: TimeInterval(self)/1000)
        let dateformat:DateFormatter = DateFormatter()
        dateformat.timeZone = NSTimeZone.local
        var format: String = "yyyy-MM-dd HH:mm:ss.SSS"
        switch type {
        case .yyyy_mm_dd:
            format = "yyyy-MM-dd"
        case .yyyy_mm_dd_hh_ss:
            format = "yyyy-MM-dd HH:ss"
        default:
            format = "yyyy-MM-dd HH:mm:ss.SSS"
        }
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}
