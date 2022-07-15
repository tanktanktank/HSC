//
//  PushCoinModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/13.
//

import UIKit

class PushCoinModel: HandyJSON {
    var coin:String = ""              //币种名称
    var currency:String = ""          //计价
    var new_price:String = ""         //最新价格
    var ratio_str:String = ""         //涨幅度
    var isFall:Bool = false           //是否跌
    required init(){}
}
