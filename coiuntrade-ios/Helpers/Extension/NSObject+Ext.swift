//
//  NSObject+Ext.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/7.
//

import Foundation
import Localize_Swift

extension NSObject{
    ///未登录获取验证器验证类型
    func getSecurityVerificationType(model : LoginModel) -> SecurityType{
        
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 0{
            return .email
        }
        if model.is_email_auth == 0, model.is_google_auth == 0, model.is_phone_auth == 1{
            return .phone
        }
        if model.is_email_auth == 1, model.is_google_auth == 1, model.is_phone_auth == 0{
            return .emailAndGoogle
        }
        if model.is_email_auth == 0, model.is_google_auth == 1, model.is_phone_auth == 1{
            return .phoneAndGoogle
        }
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 1{
            return .phoneAndEmail
        }
        return .all
    }
    
    ///已登录获取验证器验证类型
    func getSecurityVerificationInfoType(model : InfoModel) -> SecurityType{
        
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 0{
            return .email
        }
        if model.is_email_auth == 0, model.is_google_auth == 0, model.is_phone_auth == 1{
            return .phone
        }
        if model.is_email_auth == 1, model.is_google_auth == 1, model.is_phone_auth == 0{
            return .emailAndGoogle
        }
        if model.is_email_auth == 0, model.is_google_auth == 1, model.is_phone_auth == 1{
            return .phoneAndGoogle
        }
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 1{
            return .phoneAndEmail
        }
        return .all
    }
    func getSafetylevel(model : InfoModel) -> String{
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 0{
            return "safety_level_1"
        }
        if model.is_email_auth == 0, model.is_google_auth == 0, model.is_phone_auth == 1{
            return "safety_level_1"
        }
        if model.is_email_auth == 1, model.is_google_auth == 1, model.is_phone_auth == 0{
            return "safety_level_2"
        }
        if model.is_email_auth == 0, model.is_google_auth == 1, model.is_phone_auth == 1{
            return "safety_level_2"
        }
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 1{
            return "safety_level_2"
        }
        if model.is_email_auth == 1, model.is_google_auth == 1, model.is_phone_auth == 1{
            return "safety_level_4"
        }
        return "safety_level_1"
    }
    ///获取验证器类型：1-手机，2-邮箱，3-GoogleAuthenticator
    func getValidator_type(fromeVCType : FromeVCType) -> Int{
        switch fromeVCType {
        case .openPhone,.resetPhone,.closePhone:
            return 1
        case .openEmail,.resetEmail,.closeEmail:
            return 2
        case .openGoogle,.resetGoogle,.closeGoogle:
            return 3
        default:
            return 0
        }
    }
    ///操作类型：1-开启，2-更改，3-关闭
    func getOperation_type(fromeVCType : FromeVCType) -> Int{
        switch fromeVCType {
        case .openPhone,.openEmail,.openGoogle:
            return 1
        case .resetPhone,.resetEmail,.resetGoogle:
            return 2
        case .closePhone,.closeEmail,.closeGoogle:
            return 3
        default:
            return 0
        }
    }
    ///将百分数字符串转Double
    func getDoubleWithString(str : String) -> Double{
        let tmp = str.replacingOccurrences(of: "%", with: "")
        
        let double = (tmp as NSString).doubleValue / 100.0
        
        return double
    }
    
    
    //获取拼音首字母（大写字母）
    func findFirstLetterFromString(aString: String) -> String {
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: aString)

        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)

        //去掉声调
        let pinyinString = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)

        //将拼音首字母换成大写
        let strPinYin = polyphoneStringHandle(nameString: aString,    pinyinString: pinyinString).uppercased()

        //截取大写首字母
        let firstString = strPinYin.substring(to:     strPinYin.index(strPinYin.startIndex, offsetBy: 1))

        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }

    //多音字处理，根据需要添自行加
    func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        return pinyinString
    }
    //MARK: 获取国家地区
    func getDefaultCountryicon() -> String{
        guard let path = Bundle.main.path(forResource: "ad_country", ofType: "json") else { return ""}
        let localData = NSData.init(contentsOfFile: path)! as Data
        do {
            let jsonData = try JSON(data: localData)
            let model =  Country.deserialize(from: jsonData.dictionaryObject)
            let dataArr:Array<CountryModel> = model?.RECORDS ?? []
            for model in dataArr {
                if model.countryphonecode == "86" {
                    return model.countryicon
                }
            }
        } catch {
            print("解析失败")
        }
        return ""
    }
    //MARK:  计算字符串长度
    func sizeWithText(text: String, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect
    }
    
    //MARK: 汇率计算
    func addRateSymbol(value : String) -> String{
        let tmp : Double = (Double(value) ?? 0) * Double(userManager.rate)
        let str = self.addMicrometerLevel(valueSwift: "\(tmp)")
        return "\(userManager.rateSymbol)\(str)"
    }
    //MARK: 保留2位小数，向下取整
    func addTwoDecimalsDownValue(value : String) -> String{
        let tmp : Double = (Double(value) ?? 0)
        let str = String(format: "%.2f", Double(Int(tmp*100))/100)
        return str
    }
    
    //MARK: 保留2位小数汇率计算
    func addRateTwoDecimalsSymbol(value : String) -> String{
        let tmp : Double = (Double(value) ?? 0) * Double(userManager.rate)
        let str = self.addMicrometerLevel(valueSwift: String(format: "%.2f", Double(Int(tmp*100))/100))//向下取值
        return "\(userManager.rateSymbol)\(str)"
    }
    //MARK: 价格保留小数 digit小数点精度
    func addPriceDecimals(value : String,digit : String) -> String{
        let tmp : Double = Double(value) ?? 0
        let format = "%.\(digit)f"
        let str = String(format: format, tmp)
        return str
    }
    //MARK: 添加千分位的函数实现
    func addMicrometerLevel(valueSwift:String) -> String {
        // 判断传入参数是否有值
        if valueSwift.count != 0 {
            /**
             创建两个变量
             integerPart : 传入参数的整数部分
             decimalPart : 传入参数的小数部分
             */
            var integerPart:String?
            var decimalPart = String.init()
            
            // 先将传入的参数整体赋值给整数部分
            integerPart =  valueSwift
            // 然后再判断是否含有小数点(分割出整数和小数部分)
            if valueSwift.contains(".") {
                let segmentationArray = valueSwift.components(separatedBy: ".")
                integerPart = segmentationArray.first
                decimalPart = segmentationArray.last!
            }
            /**
             创建临时存放余数的可变数组
             */
            let remainderMutableArray = NSMutableArray.init(capacity: 0)
            // 创建一个临时存储商的变量
            var discussValue:Int32 = 0
            
            /**
             对传入参数的整数部分进行千分拆分
             */
            repeat {
                let tempValue = integerPart! as NSString
                var remainderValue = 0
                //解决余数不足三位要补0的BUG
                if tempValue.intValue >= 1000{
                    // 获取商
                    discussValue = tempValue.intValue / 1000
                    // 获取余数
                    remainderValue = Int(tempValue.intValue % 1000)
                    // 将余数一字符串的形式添加到可变数组里面
                    var remainderStr = String.init(format:"%d", remainderValue)
                    if remainderStr.count==1{
                        remainderStr = "00" + remainderStr
                    }else if remainderStr.count==2{
                        remainderStr = "0" + remainderStr
                    }
                    remainderMutableArray.insert(remainderStr, at:0)
                    // 将商重新复制
                    integerPart = String.init(format:"%d", discussValue)
                }else{
                    // 获取余数
                    remainderValue = Int(tempValue.intValue%1000)
                    // 将余数一字符串的形式添加到可变数组里面
                    let remainderStr = String.init(format:"%d", remainderValue)
                    remainderMutableArray.insert(remainderStr, at:0)
                    // 将商重新复制
                    integerPart = String.init(format:"%d", discussValue)
                    break
                }
            } while discussValue>0
            
            // 创建一个临时存储余数数组里的对象拼接起来的对象
            var tempString = String.init()

            // 根据传入参数的小数部分是否存在，是拼接“.” 还是不拼接""
            let lastKey = (decimalPart.count == 0 ? "":".")
            /**
             获取余数组里的余数
             */
            for i in 0..<remainderMutableArray.count {
                // 判断余数数组是否遍历到最后一位
                let  param = (i != remainderMutableArray.count-1 ?",":lastKey)
               tempString = tempString + String.init(format: "%@%@", remainderMutableArray[i] as! String,param)
            }
            //  清楚一些数据
            integerPart = nil
            remainderMutableArray.removeAllObjects()
            // 最后返回整数和小数的合并
            return tempString as String + decimalPart
        }
        return valueSwift
    }
}
extension String{
    //时间戳转成字符串
    static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    //MARK:- 字符串转时间戳
    func timeStrChangeTotimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        if self.isEmpty {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        return date?.milliStamp ?? ""
    }
}
//MARK:千位分割
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}


extension NSObject {
    
    func preciseDecimal(x : String, p : Int) -> String {
   //        为了安全要判空
       if (Double(x) != nil) {
//         四舍五入
           let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down , scale: Int16(p), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
           let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: Double(x)!)
           let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
//          生成需要精确的小数点格式，
//          比如精确到小数点第3位，格式为“0.000”；精确到小数点第4位，格式为“0.0000”；
//          也就是说精确到第几位，小数点后面就有几个“0”
           var formatterString : String = "0."
          
           if p == 0 {
               formatterString = "0"
           }
           let count : Int = (p < 0 ? 0 : p)
           for _ in 0 ..< count {
               formatterString.append("0")
           }
           let formatter : NumberFormatter = NumberFormatter()
           //      设置生成好的格式，NSNumberFormatter 对象会按精确度自动四舍五入
           formatter.positiveFormat = formatterString
//          然后把这个number 对象格式化成我们需要的格式，
//          最后以string 类型返回结果。
           return formatter.string(from: resultNumber)!
       }
       return "0"
   }

}
