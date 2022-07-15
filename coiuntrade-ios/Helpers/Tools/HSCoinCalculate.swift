//
//  HSCoinCalculate.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/10.
//

import UIKit

class HSCoinCalculate: NSObject {

    ///输入一个 币 价格 ，返回 缩写的币价格
    class func calculateCoin(coin: String) -> String {
        
        var result = coin
        guard let temDouble = Double(coin) else {
            return "0"
        }
        result = String(format: "%.2f", temDouble)
        if(coin.count > 0){
            
            let language = Localize.currentLanguage()
            if language == "zh-Hans" {
                let unitWidht = 4
                let units = ["万","亿","万亿"]
                let temInt:Int = Int(temDouble)
                var temStr = String(temInt)
                var length:Int = temStr.count/unitWidht
                if(length > (unitWidht + 1)){
                    length = (unitWidht + 1)
                }
                if(length > 0){
                    //1426397837.9581241 ,,,, temStr:1426397838
                    let temCount:Int = temStr.count
                    let index = temStr.index(temStr.startIndex, offsetBy: (temStr.count - length * unitWidht))
                    if(temCount > (length * unitWidht)){
                        temStr.insert(".", at: index)
                    }
                    let lengIndex = temStr.index(temStr.startIndex, offsetBy: ( (temStr.count - length * unitWidht)+(unitWidht - 1) )) //保留点后两位小数
                    result = temStr.substring(to: lengIndex)
                    result += units[length-1]
                }
            }else{
                
                let units = ["K","M","B","T"]
                let temInt:Int = Int(temDouble)
                var temStr = String(temInt)
                var length:Int = temStr.count/3
                if(length > 4){
                    length = 4
                }
                if(length > 0){
                    //1426397837.9581241 ,,,, temStr:1426397838
                    let temCount:Int = temStr.count
                    let index = temStr.index(temStr.startIndex, offsetBy: (temStr.count - length * 3))
                    if(temCount > (length * 3)){
                        temStr.insert(".", at: index)
                    }
                    let lengIndex = temStr.index(temStr.startIndex, offsetBy: ( (temStr.count - length * 3)+2 )) //保留点后两位小数
                    result = temStr.substring(to: lengIndex)
                    result += units[length-1]
                }
            }
        }

        
        return result
    }
    
}
