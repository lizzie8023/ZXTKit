//
//  GBKit.swift
//  New
//
//  Created by 张泉 on 16/6/29.
//  Copyright © 2016年 Tuofeng. All rights reserved.
//

import UIKit
import Foundation
import Photos
import AVFoundation


enum AuthorizeType {
    case Photo
    case Camera
    case Microphone
}

class CFKit: NSObject {
    
    static let sharedInstance = CFKit()
 
    var appName:String = ""
    
    var defaultNavBarH:CGFloat {
        if SCREENH >= 812.0 {
            return 88
        }else {
            return 64
        }
    }
    var defaultStatBarH:CGFloat {
        if SCREENH >= 812.0 {
            return 44
        }else {
            return 20
        }
    }
    
    var defaultNavBarViewCenterY:CGFloat {
        if SCREENH >= 812.0 {
            return 62
        }else {
            return 42
        }
    }
    
    var defaultTabBarSafeAreaH:CGFloat{
        if SCREENH >= 812 {
            return 34
        }else{
            return 0
        }
    }
    
    var dev:UIDevice = UIDevice.current
    var appVersion:String?
    var resignActiveTime:Date = Date()
    // 是否是加密传输
    var isRSA:Bool = true
    
    // 获取到图片的baseURL是否需要刷新
//    var needRefresh:Bool = false
    // 是否正在展示用户协议，如果正在展示用户协议，就不刷新，由用户协议触发刷新
    var didShowPrivacyPolicyTip:Bool = false
    
    override init() {
        super.init()
        self.appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    /**
     调试使用,打印方法调用时长
     - parameter f: 调用的方法
     */
    class func measure(_ f: ()->()) {
        let start = CACurrentMediaTime()
        f()
        let end = CACurrentMediaTime()
        ZQLog(message: "所用时间：\(end - start)")
    }
    
    
    /// 调试打印 文件所在位置/方法名/代码行号
    class func ZQLog<T>(message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line)
    {
        #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
    
    /// 拨打电话
    class func callPhone(phone:String) {
        
        if phone.isEmpty {
            return
        }
        let url = URL(string: "telprompt://" + phone)
        openURL(url: url!)
        
    }
    
    class func getNowtimeInterval() -> TimeInterval {
        
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        return timeInterval
    }
    
    // 手机运行时长
    class func uptime() -> time_t {
        
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN,KERN_BOOTTIME]
        var size = MemoryLayout.size(ofValue: boottime)
        var now = time_t()
        var uptime: time_t = -1
        time(&now)
        if sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0 {
            uptime = now - boottime.tv_sec;
        }
        return uptime
        
    }
    
    func saveScreenCapture(view: UIView) {
        if CFKit.isPhotoAlbumAuthorized() {
            //截屏
            let screenRect = view.bounds
            UIGraphicsBeginImageContext(screenRect.size)
            let ctx:CGContext = UIGraphicsGetCurrentContext()!
            view.layer.render(in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? nil
            UIGraphicsEndImageContext();
            
            //保存相册
            if (image != nil) {
                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(saveImage(image: didFinishSavingWithError: contextInfo:)), nil)
            }
        }
    }
    
    @objc func saveImage(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
        } else {
            
        }
    }
    
    class func openURL(url:URL) {
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else{
            UIApplication.shared.openURL(url)
        }
    }
    
    
    class func dict2Json(dict:[String:Any]) ->String {
        
        do {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                return String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            }else {
                return ""
            }
        }
    }
    
    class func json2Dict(jsonStr:String) ->[String:Any] {
        
        do {
            if let decode = try? JSONSerialization.jsonObject(with: jsonStr.data(using: String.Encoding.utf8) ?? Data(), options: []) as? [String:Any] {
                return decode ?? [:]
            }else {
                return [:]
            }
        }
    }
    
    /**
     设置一个文本中所有指定文本高亮,通过正则查找
     */
    class func setSpecifiedText(allStr:String, specifiedStr:String, textColor:UIColor) ->NSMutableAttributedString {
        
        if specifiedStr == "" {
            return NSMutableAttributedString(string: allStr)
        }
        
        let mutableStr = NSMutableAttributedString(string: allStr)
        let regular = try! NSRegularExpression(pattern: specifiedStr, options:.caseInsensitive)
        let results = regular.matches(in: allStr, options: .reportProgress , range: NSMakeRange(0, allStr.count))
        
        for result in results {
            mutableStr.addAttributes([NSAttributedString.Key.foregroundColor:textColor], range: result.range)
            
        }
        return mutableStr
    }
    
    class func currentVersion() ->String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /**
     打印系统的字体名称
     */
    class func logFontName() {
        for familyName in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    /// 获取Document目录
    class func loadDocument(documentName:String) ->String{
        
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                          .userDomainMask, true)[0]
        let filePath = docPath + "/\(documentName)/"
        let fileManager = FileManager.default
        try! fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        return filePath
    }
    
    /**
     正则校验身份证
     */
    class func checkUserIdCard(_ idCard:String) ->Bool {
        //        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: idCard)
    }
    /**
     正则校验手机号码
     */
    class func checkTelNumber(_ telNumber:String) ->Bool {
        let pattern = "(^(13\\d|15[^4,\\D]|17[13678]|18\\d)\\d{8}|170[^346,\\D]\\d{7})$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: telNumber)
    }
    
    /**
     相册授权确认
     //        Restricted    //这个应用程序未被授权访问照片数据。
     //        Denied        //用户已经明确否认了这个应用程序访问图片数据。
     //        Authorized    //用户授权此应用程序访问图片数据。
     */
    class func isPhotoAlbumAuthorized() ->Bool {
        
        let authorization = PHPhotoLibrary.authorizationStatus()
        CFKit.ZQLog(message: authorization.rawValue)
        if authorization == .denied {
            return false
        }
        
        return true
    }
    
    /**
     相册未授权(未提示用户授权)
     //        NotDetermined //用户尚未选择关于这个应用程序
     */
    class func isPhotoAlbumNotDetermined() ->Bool {
        let authorization = PHPhotoLibrary.authorizationStatus()
        if authorization == .denied {
            return false
        }
        return true
    }
    
    /**
     相机授权确认
     */
    class func isCameraAuthorized() ->Bool {
        
        let authorization = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        CFKit.ZQLog(message: authorization.rawValue)
        if authorization == .denied {
            return false
        }
        return true
    }
    
    class func isCameraNotDetermined() ->Bool {
        let authorization = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authorization == AVAuthorizationStatus.restricted {
            return false
        }
        
        return true
    }
    
    /// 是否验证过相机权限
    class func didCameraAuthorized() ->Bool {
        let authorization = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authorization == .notDetermined {
            return false
        }else {
            return true
        }
        
    }
    
    class func uploadKey() ->String{
        
        return NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
    }
    
    /**
     *  GCD 延时调用封装
     */
    typealias Task = ((_ cancel : Bool) ->())
    class func dispatch_delay(_ time:TimeInterval,task:@escaping (()->())) -> Task? {
        
        func dispatch_later(_ block:@escaping ()->()) {
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                execute: block)
        }
        
        var closure: (()->())? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    class func dispatch_delay_cancel(_ task:Task?) {
        task?(true)
    }
    
    
}

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matches = regex.matches(in: input,
                                    options: [],
                                    range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}
