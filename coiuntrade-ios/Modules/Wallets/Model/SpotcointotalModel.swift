//
//  SpotcointotalModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/13.
//

import UIKit

class SpotcointotalModel: BaseModel {
    ///SDT总数
    var amount = ""
    ///相较昨日盈亏
    var ratio_str = ""
    ///较昨日盈亏数量
    var ratio_num = "0"
    ///
    var create_time = ""
    ///备注
    var remarks = ""
    ///计价数量
    var base_num = ""
    ///计价类型
    var base_coin = ""
    ///单位
    var rate_symbol = ""
    ///折算总usdt数量
    var usdt_total = ""
    ///
    var coin_proportion_list : Array<Coin_proportion> = []
    
    
    
}

class Coin_proportion : BaseModel{
    ///币种
    var coin = ""
    ///总数量
    var total_num = ""
    ///最新价
    var new_price = ""
    ///USDT计价
    var usdt_total = ""
    ///涨跌幅
    var proportion_str = ""
}
