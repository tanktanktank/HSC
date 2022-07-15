//
//  RealmCoinModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/16.
//

import UIKit

class RealmCoinModel: Object {
    @objc dynamic var coin:String = ""              //币种名称
    @objc dynamic var currency:String = ""          //币种单位
    @objc dynamic var price:String = ""         //最新价格
    @objc dynamic var ratio_str:String = ""         //涨幅度
    @objc dynamic var deal_num:String = ""          //成交量
    @objc dynamic var isFall:Bool = false           //是否跌
    @objc dynamic var isSelected:Bool = false           //是选中
    ///价格精度
    @objc dynamic var price_digit:String = "0"
    ///最新价颜色 0 白色 1绿色 2红色
    @objc dynamic var priceColor : Int = 0
    
    @objc dynamic var id : String = ""
    //设置主键
    override class func primaryKey() -> String? {
        return "id"
    }
}
