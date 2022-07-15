//
//  DateManager.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/18.
//

import Foundation

class DateManager: NSObject {
    
    class func getDateBytimeStamp(_ timeStamp: Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm:ss"
        let dateStr = dformatter.string(from: date as Date)
        return dateStr
    }
    class func getDateByMdStamp(_ timeStamp: Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM-dd HH:mm"
        let dateStr = dformatter.string(from: date as Date)
        return dateStr
    }
    class func getDateByyMMdStamp(_ timeStamp: Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dformatter.string(from: date as Date)
        return dateStr
    }
    class func getDateByYYMdStamp(_ timeStamp: Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dformatter.string(from: date as Date)
        return dateStr
    }
    class func getDateStringStamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

}
