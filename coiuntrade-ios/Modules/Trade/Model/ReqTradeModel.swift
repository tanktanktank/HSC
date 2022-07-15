//
//  ReqTradeModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/16.
//

import UIKit

class ReqTradeModel: HandyJSON {
    var order_type:String = "1" //订单类型：1限价，2限价止盈止损，3市价
    var currency:String = ""   //计价币
    var coin:String = ""       //交易币
    var buy_type:String = "1"   //买卖类型：1买，2卖
    var price:String = "0"      //下单价格
    var num:String = "0"        //下单数量
    var total:String = "0"        //下单总金额 用于判断 不需要传给后台
    var trigger_price:String = ""  //触发价格
    var poundage:String = "0"       //手续费
    required init(){}
}
