//
//  Float+Extension.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/16.
//

import UIKit

extension Float {
    /// 准确的小数尾截取 - 没有进位
    func decimalString(_ base: Self = 1) -> String {
        let tempCount: Self = pow(10, base)
        let temp = self*tempCount
        let target = Self(Int(temp))
        let stepone = target/tempCount
        if stepone.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", stepone)
        }else{
            return "\(stepone)"
        }
    }
}

extension Double {
    /// 准确的小数尾截取 - 没有进位
    func decimalString(_ base: Self = 1) -> String {
        let tempCount: Self = pow(10, base)
        let temp = self*tempCount
        let target = Self(Int(temp))
        let stepone = target/tempCount
        var result = ""
        if stepone.truncatingRemainder(dividingBy: 1) == 0 {
            result = String(format: "%.0f", stepone)
        }else{
            result = "\(stepone)"
        }
        return result
    }
    
    /// 准确的小数尾截取 - 没有进位 ,,根据小数位数保0
    func decimalWithZeroString(_ base: Self = 1) -> String {
        let tempCount: Self = pow(10, base)
        let temp = self*tempCount
        let target = Self(Int(temp))
        let stepone = target/tempCount
        var result = ""
        if stepone.truncatingRemainder(dividingBy: 1) == 0 {
            result = String(format: "%.0f", stepone)
        }else{
            result = "\(stepone)"
        }
        let baseInt = Int(base)
        if(baseInt > 0){
            let rang = result.range(of: ".")
            if(rang != nil){
                let lastStr = result.substring(from: rang!.lowerBound)
                if(lastStr.count <= baseInt){
                    for tem in 1...(baseInt-lastStr.count+1){
                        result = result+"0"
                    }
                }
            }else{
                result = result+"."
                for tem in 1...baseInt{
                    result = result+"0"
                }
            }
        }
        return result
    }
}
