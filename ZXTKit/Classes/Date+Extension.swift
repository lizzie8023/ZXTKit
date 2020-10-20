//
//  NSDate+Extension.swift
//  New
//
//  Created by 风晓得8023 on 15/11/10.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import Foundation

extension Date{
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    var isInCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isInCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    var isInCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    var calendar:Calendar {
        get {
            var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            calendar.firstWeekday = 2
            return calendar
        }
    }
    
    var year:Int {
        get {
            return setComponents(.year).year!
        }
    }
    
    var month:Int {
        get {
            return setComponents(.month).month!
        }
    }
    
    var  day:Int {
        get {
            return setComponents(.day).day!
        }
    }
    
    var week:Int {
        get {
            return setComponents(.weekday).weekday!
        }
    }
    
    var hour:Int {
        get {
            return setComponents(.hour).hour!
        }
    }
    
    var minute:Int {
        get {
            return setComponents(.minute).minute!
        }
    }
    
    var second:Int {
        get {
            return  setComponents(.second).second!
        }
    }
    func countOfDaysInMonth() ->Int {
        return (self.calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self).length
    }
    
    func countOfWeeksInMonth() ->Int {
        return (self.calendar as NSCalendar).range(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.month, for: self).length
    }
    
    func firstWeekDayInMonth() ->Int {
        var compoments = self.setComponents([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day])
        compoments.day = 1
        let newDate = self.calendar.date(from: compoments)
        return (self.calendar as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: newDate!)
    }
    
    func weekInMonth() ->Int {
        return self.setComponents(NSCalendar.Unit.weekOfMonth).weekOfMonth!
    }
    
    func weekInYear() ->Int {
        return self.setComponents(NSCalendar.Unit.weekOfYear).weekOfYear!
    }
    
    func offsetMonth(_ numMonths:Int) ->Date {
        var offsetCompontents = DateComponents()
        offsetCompontents.month = numMonths
        return (self.calendar as NSCalendar).date(byAdding: offsetCompontents, to: self, options: [])!
    }
    
    func offsetDay(_ numDays:Int) ->Date {
        var offsetCompontents = DateComponents()
        offsetCompontents.day = numDays
        return (self.calendar as NSCalendar).date(byAdding: offsetCompontents, to: self, options: [])!
    }
    
    func setComponents(_ unitFlags:NSCalendar.Unit) ->DateComponents{
        return (self.calendar as NSCalendar).components(unitFlags, from: self)
    }
    
    /**
     返回时间差
     
     */
    func timeDifference(endTime:Date) ->DateComponents {
        
        let calendar = Calendar.current
        let unit:Set<Calendar.Component> = [.hour,.minute,.second]
        let commponent:DateComponents = calendar.dateComponents(unit, from: self, to: endTime)
        return commponent
    }
    
    /**
     方法名为了避免重写系统方法加了个With
     */
    func isEqualToWithDate(_ date:Date) ->Bool {
        
        if self.year == date.year && self.month == date.month && self.day == date.day {
            return true
        }else {
            return false
        }
    }
    
    /**
     返回指定格式的当前时间
     */
    func dateWithFormat(_ format:String = "dd/MM/yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /**
     时间转换
     */
    static func specifiedFormat(_ date:Date) ->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    
    /**
     将XXXX-XX-XX的日期格式转成date
     */
    static func convertStringToDate(dateFormat:String, str:String) ->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: str)!
    }
    
    /**
     获得当前时间的下个月时间戳
     */
    static func nextMonthTimeStamp() ->TimeInterval {
        var components = DateComponents()
        components.year = 0
        components.month = 1
        components.day = 0
        let date = (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).date(byAdding: components, to: Date(), options: NSCalendar.Options.wrapComponents)!
        
        return date.timeIntervalSince1970
    }
    
   
    static func date(_ str : String)-> Date{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateformatter.date(from: str) ?? Date()
    }
    
    /// 扩展属性 返回时间
    var dateDesctiption: String {
        
        let cal = Calendar.current
        
        let delta = Int(Date().timeIntervalSince(self))
        
        if delta < 60 {
            return "刚刚"
        }
        
        if delta < 3600 {
            return "\(delta / 60)分钟前"
        }
        
        if delta < (86400) {
            return "\(delta / 3600)小时前"
        }
        
        var fmtString = " HH:mm"
        if delta > (86400) && delta < (86400) * 2 {
            return "2天前"
        }else if (delta > 86400) && (delta < (86400 * 3)) {
            return "3天前"
        }else {
            let a =  cal.component(Calendar.Component.year, from: Date())
            let b = cal.component(Calendar.Component.year, from: self)
            if a != b {
                fmtString = "yyyy-MM-dd \(fmtString)"
            }else {
                fmtString = "MM-dd \(fmtString)"
            }
        }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = fmtString
        
        return df.string(from: self)
    }
    
     func weekDay() ->String {

        let weekDays = [NSNull.init(),"星期日","星期一","星期二","星期三","星期四","星期五","星期六"] as [Any]
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        if let timeZone = NSTimeZone.init(name:"Asia/Shanghai") {
            calendar?.timeZone = timeZone as TimeZone
        }
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar?.components(calendarUnit, from:self)
        return weekDays[(theComponents?.weekday)!] as! String
    }

    
    /// 栏目的时间转换
    var columnDateDesctiption: String {
        
        let cal = Calendar.current
        // 今天以内
        let delta = Int(Date().timeIntervalSince(self))
        
        /// 3分钟以内
        if delta < 180 {
            return "刚刚"
        }
        
        if delta < 3600 {
            return "\(delta / 60)分钟前"
        }
        
        if delta < (86400) {
            return "\(delta / 3600)小时前"
        }
        
        var fmtString = ""
        
        if delta > (86400) && delta < (86400) * 2 {
            return "昨天"
        }
        
        if (delta > 86400) && (delta < (86400 * 3)) {
            return "前天"
        }
        
        if (delta > (86400 * 2)) && (delta < (86400 * 7)) {
            let days = (Double(self.timeIntervalSince1970) + Double(NSTimeZone().secondsFromGMT)) / 86400
            let weakDay = Int(((days + 4).truncatingRemainder(dividingBy: 7.0) + 7).truncatingRemainder(dividingBy: 7.0))
            
            switch weakDay {
            case 0: // 7
                return "星期日"
            case 1:
                return "星期一"
            case 2:
                return "星期二"
            case 3:
                return "星期三"
            case 4:
                return "星期四"
            case 5:
                return "星期五"
            case 6:
                return "星期六"
            case 7:
                return "星期日"
            default:
                fmtString = "yyyy.MM.dd"
                break
            }
        }
        
        let a =  cal.component(Calendar.Component.year, from: Date())
        let b = cal.component(Calendar.Component.year, from: self)
        if a != b {
            fmtString = "yy.M.d"
        }else {
            fmtString = "M.d"
        }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = fmtString
        
        return df.string(from: self)
    }
    
    func hotCommentDateDesctiption() ->String {
        
        let cal = Calendar.current
        
        // 今天以内
        if cal.isDateInYesterday(self) {
            return "1天前"
        }
        
        var fmtString = " HH:mm"
        let a =  cal.component(Calendar.Component.year, from: Date())
        let b = cal.component(Calendar.Component.year, from: self)
        if a != b {
            fmtString = "yyyy-MM-dd" + fmtString
        }else {
            fmtString = "MM-dd" + fmtString
        }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = fmtString
        
        return df.string(from: self)
    }
    
    
    
}

    
