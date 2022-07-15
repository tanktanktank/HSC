//
//  ReqOrdersModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/18.
//

import UIKit

//请求订单实体类
class ReqOrdersModel: HandyJSON {
    var get_type:Int = 0 //0委托订单 -1历史订单包含取消 1历史订单不包含取消
    var page:Int = 0
    var page_size:Int = 10
    var start_time:Int = 0
    var end_time:Int = 0
//    var coin:String?
    ///交易对
    var symbol:String?
    var buy_type:Int = 0 //0全部,1买，2卖
    ///具体时间段 1d 7d 1m 3m
    var time_info : String = ""
    
    required init(){}
}























