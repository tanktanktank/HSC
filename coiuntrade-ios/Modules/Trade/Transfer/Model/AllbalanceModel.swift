//
//  AllbalanceModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/11.
//

import UIKit

class AllbalanceModel: BaseModel {
    ///手续费
    var transfer_fee:String = ""
    ///可用数量
    var use_num:String = ""
    ///最小提币数量
    var min_out_num: String = ""
    ///最大提币转量
    var max_out_num: String = ""
    ///最小充值数量
    var min_charge_num:String = ""
    ///图标路径
    var url:String = ""
//    var fee: String = ""                //手续费
    ///是否开启提币：1是 0否
    var is_open_tran:String = ""
    ///虚拟币代码
    var coin_code: String = ""
    ///币种图片
    var coin_code_image:String = ""
    ///币种ID
    var coin_id: String = ""
    ///钱包地址
    var wallet_address:String = ""
    ///币种全称
    var detail_code: String = ""
    ///排序字段
    var order_num:String = ""
    ///是否开启充币：1是 0否
    var is_recharge: String = ""
    ///是否以太坊代币 1不是 2是
    var is_eth: String = ""
    ///汇率币种符号
    var rate_symbol: String = ""
    ///总数量
    var total_num: String = ""
    ///冻结数量
    var freeze_num: String = ""
    ///可用汇率数量
    var use_num_rate: String = ""
    ///转换成USDT时的数量
    var total_num_rate: String = ""

    
   
    ///交易对名称
    var tradeName: String = ""
    ///交易对当前价
    var tradePrice: String = ""
    ///交易对当前幅度
    var tradeWidth: String = ""
    
    
}

class SymbolAssetModel: BaseModel {
    var coin_num:String = ""  //隐藏非0币种(布尔类型)
    var currency_num:String = ""   //币种
}
