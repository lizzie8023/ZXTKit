//
//  Dictionary+Extension.swift
//  chinaFocusBIBF
//
//  Created by 张泉 on 2020/6/30.
//  Copyright © 2020 manman. All rights reserved.
//

import UIKit

extension Dictionary {
    
    func dict2Json() ->String {

        do {
            if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
                return String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            }else {
                return ""
            }
        }
//        return ""
    }
    
    
}
