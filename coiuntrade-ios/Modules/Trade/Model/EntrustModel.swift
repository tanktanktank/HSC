//
//  EntrustModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/16.
//

import UIKit

class EntrustModel: BaseModel {
    ///触发价格
    var trigger_price:String = ""
    ///成交数量
    var deal_num:String = ""
    ///更新时间
    var update_time:Int = 0
    ///下单总金额
    var total_amt:String = ""
    ///订单状态描述
    var status_str:String = ""
    ///成交价格
    var deal_price:String = ""
    ///成交金额
    var deal_amt:String = ""
    ///手续费
    var poundage:String = ""
    ///交易币
    var coin:String = ""
    ///计价币
    var currency:String = ""
    ///下单时间
    var create_time:Int = 0
    //订单号
    var order_no:String = ""
    ///下单数量
    var num:String = ""
    ///下单价格
    var price:String = ""
    ///买入完成的百分比
    var buy_rate_num:String = ""
    ///总数量
    var total_num : String = ""
    
    ///订单类型：1限价，2限价止盈止损，3市价
    var order_type:Int = 1
    
    ///订单状态：0未成交，1部分成交，2完全成交，3部分成交+取消，4取消
    var status:Int = 0
    
    ///买卖类型：1买，2卖
    var buy_type:Int = 1
    
    ///订单类型：1限价，2限价止盈止损，3市价
    var order_type_desc:String = ""
    
    ///订单状态：0未成交，1部分成交，2完全成交，3部分成交+取消，4取消
    var status_desc:String = ""
    
    ///买卖类型：1买，2卖
    var buy_type_desc:String = ""
    
    ///逐笔订单
    var deal_list : Array<deal_listModel> = []
    
    ///自用熟悉
    ///买卖类型 买入卖出文字
    var buy_type_title : String{
        if self.buy_type == 1 {
            return "tv_trade_buy".localized()
        }else{
            return "tv_trade_sell".localized()
        }
    }
    ///订单类型 文字
    var order_type_title : String{
        if self.order_type == 1 {
            return "entrust_limit_order".localized()
        }else if self.order_type == 2{
            return "entrust_full_stop_order".localized()
        }else{
            return "entrust_market_order".localized()
        }
    }
    ///订单状态：文字
    var status_title : String{
        if self.status == 0{
            return "entrust_unfinished_business".localized()
        }else if self.status == 1{
            return "entrust_some_business".localized()
        }else if self.status == 2{
            return "entrust_all_business".localized()
        }else{
            return "entrust_cancel_business".localized()
        }
    }
}


class deal_listModel : BaseModel{
    ///做市方向
    var is_trigger_str:String = ""
    ///价格
    var price:String = ""
    ///数量
    var num:String = ""
    ///手续费
    var poundage:String = ""
    ///创建时间
    var create_date:Int = 0
}
