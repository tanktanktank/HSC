//
//  BuySellModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/11.
//

import UIKit

class BuySellModel: BaseModel {
    var type:Int = 0
    var num:String = ""
    var data:[Any] = []
    var gear: Dictionary = Dictionary<String, Any>()
}


class Ticker24Model : BaseModel{

//    var data:[String:Any] = [:]
    
    var amount_digit:String = ""
    var coin:String = ""
    var currency:String = ""
    var new_price:String = ""
    var rate_price:String = ""

    var deal_num:String = ""
    var deal_amt:String = ""
    var open_price:String = ""
    var high_price:String = ""
    var low_price:String = ""
    var ratio:String = ""
    var ratio_str:String = ""
    ///价格精度
    var price_digit:String = ""
}
