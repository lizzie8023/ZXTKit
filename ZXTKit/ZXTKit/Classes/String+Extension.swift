//
//  String+Extension.swift
//  New
//
//  Created by 诠释 on 15/10/24.
//  Copyright © 2015年 Tuofeng. All rights reserved.


import Foundation
import UIKit


extension NSString {
    
    func stringWidthFont(_ font: UIFont) -> CGFloat {
        if self.length < 1 {
            return 0.0
        }
        
        let size = self.boundingRect(with: CGSize(width: 200, height: 1000), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        
        return size.width
    }
}

extension String {
    
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
    
    func json2Any() ->Any? {

        do {
            if let decode = try? JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8) ?? Data(), options: []) {
                return decode
            }else {
                return nil
            }
        }
    }
    
    var int: Int? {
        return Int(self)
    }
 
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    
    var urlParameters: [String: Any]? {
        // 判断是否有参数
        let arr = self.components(separatedBy: "?")
        if arr.count <= 1 {
            return nil
        }
        
        var params = [String: Any]()
        let paramsString = arr[1]
        
        // 判断参数是单个参数还是多个参数
        if paramsString.contain(subStr: "&") {
            
            // 多个参数，分割参数
            let urlComponents = paramsString.components(separatedBy: "&")
            
            // 遍历参数
            for keyValuePair in urlComponents {
                // 生成Key/Value
                let pairComponents = keyValuePair.components(separatedBy: "=")
                let key = pairComponents.first?.removingPercentEncoding
                let value = pairComponents.last?.removingPercentEncoding
                // 判断参数是否是数组
                if let key = key, let value = value {
                    // 已存在的值，生成数组
                    if let existValue = params[key] {
                        if var existValue = existValue as? [Any] {
                            
                            existValue.append(value)
                        } else {
                            params[key] = [existValue, value]
                        }
                        
                    } else {
                        
                        params[key] = value
                    }
                    
                }
            }
            
        } else {
            
            // 单个参数
            let pairComponents = paramsString.components(separatedBy: "=")
            
            // 判断是否有值
            if pairComponents.count == 1 {
                return nil
            }
            
            let key = pairComponents.first?.removingPercentEncoding
            let value = pairComponents.last?.removingPercentEncoding
            if let key = key, let value = value {
                params[key] = value
            }
            
        }
        
        return params
    }
    
    
    func addUrlValue(urlKey:String, urlValue:String) ->String {
        
        if self.contain(subStr: "?") {
            // 直接在后面拼接
            return self + "&\(urlKey)=\(urlValue)"
        }else if self.contain(subStr: "&") {
            // 需要补充?
            let urlComponents:[String] = self.components(separatedBy: "&")
            var dict:[String:Any] = [:]
            for i in urlComponents {
                if i.contain(subStr: "=") {
                    let pairComponents = i.components(separatedBy: "=")
                    let key = pairComponents.first?.removingPercentEncoding
                    let value = pairComponents.last?.removingPercentEncoding
                    if let key = key, let value = value {
                        if dict[key] == nil {
                            dict[key] = value
                        }
                    }
                }
            }
            
            var url = urlComponents.first ?? ""
            url = url + "?\(urlKey)=\(urlValue)"
            for i in dict {
                
                url = url + "&\(i.key)=\(i.value)"
            }
            return url
        }
        
        return self + "?\(urlKey)=\(urlValue)"
    }
    
    
    /// 从字符串中移除给定的前缀。
    ///
    ///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
    
    /// 从字符串中删除给定的后缀。
    ///
    ///   "Hello, World!".removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
    
    /// base64解码
    var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    
    /// base64编码
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// 字符串转数组
    var charactersArray: [Character] {
        return Array(self)
    }
    
    /// 判断是否包含emoji
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 判断第一个字符是否是String 返回第一个字符
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }
    
    /// 判断是否包含字母
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// 判断是否包含数字
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    
    /**
     根据文本获得大小
     */
    func size(_ font: UIFont, maxSize size:CGSize) -> CGSize {
        return (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes:[NSAttributedString.Key.font: font], context: nil).size
    }
    
    /// 去除HTML格式
    func deleHTML() ->String {
        
        var strCopy = self
        let scanner:Scanner = Scanner(string: strCopy)
        var text:NSString?
        while scanner.isAtEnd == false {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: &text)
            strCopy = strCopy.replacingOccurrences(of: NSString(format: "<p>",text ?? "") as String, with: "")
            strCopy = strCopy.replacingOccurrences(of: NSString(format: "</p>",text ?? "") as String, with: "")
        }
        strCopy = strCopy.replacingOccurrences(of: NSString(format: "&nbsp;",text ?? "") as String, with: "")
        strCopy = strCopy.replacingOccurrences(of: NSString(format: "&amp;",text ?? "") as String, with: "")
        return strCopy
    }
    
     /// 进一法
    func formatterViewCount() ->String {
        
        let num = self.doubleValue ?? 0
        
        if num < 10000 {
            return self
        }
        return "\(ceil(floor(num / 100) / 10) / 10)万"
    }
    
    func content2title() -> String {
        
        if self.count > 30 {
            return String((self as NSString).substring(with: NSMakeRange(0, 30)))
        }else {
            return self
        }
    }
    
    func fotmatterJson2Array() ->[String] {
        
        if let data = self.data(using: String.Encoding.utf8) {
            var json:Any?
            do {
                json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            }
            
            if let arr =  json as? NSArray {
                return arr as? [String] ?? []
            }
        }
        return []
    }

    func setLineSpacing(_ height:CGFloat = 0) ->NSMutableAttributedString {
        
        let attributeString = NSMutableAttributedString(string: self)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = height
        attributeString.addAttributes([kCTParagraphStyleAttributeName as NSAttributedString.Key:style], range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    /// 判断是否是url
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    /// 是否是有效的URL
    ///
    ///        "https://google.com".isValidSchemedUrl -> true
    ///        "google.com".isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 是否是https的URL
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    
    /// 是否是http的URL
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    
    func formatterStr2Html() ->String {
        
        var content = self.replacingOccurrences(of: "&", with: "&amp;")
        content = content.replacingOccurrences(of: "<", with: "&lt;")
        content = content.replacingOccurrences(of: ">", with: "&gt;")
        content = content.replacingOccurrences(of: "\"", with: "&quot;")
        content = content.replacingOccurrences(of: "\'", with: "&apos;")
        content = content.replacingOccurrences(of: " ", with: "&nbsp;")
        content = content.replacingOccurrences(of: "\n", with: "<br/>")
        
        return content
    }
    
    /// 是否是本地路径URL
    ///
    ///        "file://Documents/file.txt".isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    
    /// 判断bool
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    /// Date object from "yyyy-MM-dd" formatted string.
    ///
    ///        "2007-06-29".date -> Optional(Date)
    ///
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    /// URL from string (if applicable).
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    var url: URL? {
        return URL(string: self)
    }
    
    /// 将编码后的url转换回原始的url
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return encodeUrlString ?? ""
    }
    
    /// 判断是否是email
    ///
    /// - Note: Note that this property does not validate the email address against an email server. It merely attempts to determine whether its format is suitable for an email address.
    ///
    ///        "john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 判断是否是英文大小写、数字、符号
    /// 未限制长度
    var isValidEn:Bool {
//        let regex = "/(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\\W_])/"
        let regex = "^[A-Za-z0-9\\W_]+$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 判断固话 非0开头
    var isValidChTel:Bool {
        let regex = "\\d{2,4}-[0-9]\\d{6,7}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    var isValidOtherTel:Bool {
        let regex = "[0-9]\\d{3,12}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    /// 去除首尾空格 以及中间换行
    func formattingWithString(isReplaceNewline:Bool = true) ->String {
        
        var strCopy = self
        // 去除首尾空格
        strCopy = strCopy.trimmingCharacters(in: CharacterSet.whitespaces)
        if isReplaceNewline == true {
            // 去除换行
            strCopy = strCopy.replacingOccurrences(of: "\n", with: "")
        }
        return strCopy
    }
    
    /// 去除全部空格和换行
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    /**
     隐藏手机号中间4位
     */
    func hiddenPhone() ->String{
        if self == "" {
            return self
        }
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****")
    }
    
    func contain(subStr: String) -> Bool {return (self as NSString).range(of: subStr).length > 0}
    
    func explode (_ separator: Character) -> [String] {
        return self.split(whereSeparator: { (element: Character) -> Bool in
            return element == separator
        }).map { String($0) }
    }
    
    func replacingOccurrencesOfString(_ target: String, withString: String) -> String{
        return (self as NSString).replacingOccurrences(of: target, with: withString)
    }
    
    var floatValue: Float? {return NumberFormatter().number(from: self)?.floatValue}
    var doubleValue: Double?{return NumberFormatter().number(from: self)?.doubleValue}
//    var doubleValue: Double? {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = NumberFormatter.Style.decimal
//        let finalNumber = numberFormatter.number(from: self)
//        if let doubleValueTemp = (finalNumber?.doubleValue) {
//            return doubleValueTemp
//        }
//        return 0.0
//    }
    
    func repeatTimes(_ times: Int) -> String{
        
        var strM = ""
        
        for _ in 0..<times {
            strM += self
        }
        return strM
    }
    
    func isLetterWithDigital() -> Bool {
        let numberRegex:NSPredicate=NSPredicate(format:"SELF MATCHES %@","^.*[0-9]+.*$")
        let letterRegex:NSPredicate=NSPredicate(format:"SELF MATCHES %@","^.*[A-Za-z]+.*$")
        if numberRegex.evaluate(with: self) && letterRegex.evaluate(with: self){
            return true
        }else{
            return false
        }
    }
    
    /// 中文转拼音
    func transformToPinYin() -> String {
        
        
        
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)

        let string = String(mutableString)
        //去掉空格
        let str = string.replacingOccurrences(of: " ", with: "")
        if str.first?.description.hasLetters == false {
            return "#"
        }
        return str
   }
}
