//
//  Date+Category.swift
//  doctor
//
//  Created by apple on 2017/3/30.
//  Copyright © 2017年 digital. All rights reserved.
//

import Foundation

extension Date {
    
    /// 时间格式化
    /// - Parameter date: date
    static func string(y date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: date)
    }
    
    /// 时间格式化
    /// - Parameter date: date
    static func string(ymdhms date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: date)
    }
    
    /// 时间格式化
    /// - Parameter date: date
    static func string(ymd date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    /// 获取时间
    /// - Parameter dateStr: 时间字符串
    static func date(ymd dateStr: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.date(from: dateStr)
    }
    
}

extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
