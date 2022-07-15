//
//  CoinModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit

class CoinModel: BaseModel {
    var coin:String = ""              //币种名称
    var currency:String = ""          //币种单位
    var isLast:Bool = false           //是否最后一个
    var isFrist:Bool = false          //是否第一个
    var isFall:Bool = false           //是否跌
    var image_str:String = ""         //币种图片
    var detail_code:String = ""       //币种全称
    var new_price:String = ""         //最新价格
    var ratio_str:String = ""         //涨幅度
    var ratio:String = ""         //涨幅度
    
    
    var over_nigh_rate:String = ""    //
    var deal_amt:String = ""          //unit 成交量
    var price_change:String = ""
    var sell_commission:String = ""   //卖方手续费比例
    ///交易对id
    var symbol_id:String = ""
    var force_rate:String = ""
    var buy_commission:String = ""    //买方手续费比例
    ///价格精度
    var price_digit:String = ""
    var commission_type:String = ""
    
    var open_price:String = ""        //开盘价
    var deal_num:String = ""          //成交量
    var amount_digit:String = ""
    var min_buy_val:String = ""       //最小购买
    var deposit_num:String = ""
    var high_price:String = ""        //最高价
    var low_price:String = ""         //最低价
    var atIndex: Int = 0              //记录默认排序
    
    ///是否自选 0未自选，1已自选
    var user_like:Int = 0         //用户是否自选
    
    ///
    var rate_price:String = ""
    ///
    var rate_symbol:String = ""
    ///K线数据
    var Kline : KlineModel?
    
    ///自定义属性
    ///是否选中
    var isSelected = false
    ///最新价颜色 0 白色 1绿色 2红色
    var priceColor : Int = 0
    ///
    var KlineData : Array<Double>{
        var array : Array<Double> = []
        if(Kline != nil){
            for tmp in Kline!.data {
                guard let str = tmp.safeObject(index: 4) else {
                    return []
                }
                array.append(Double(str) ?? 0)
            }
        }
        return array
    }
    
}
class KlineModel: BaseModel {
     var data : Array<Array<String>> = []
    
}
