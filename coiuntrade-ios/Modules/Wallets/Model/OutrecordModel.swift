//
//  OutrecordModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/13.
//

import UIKit

class OutrecordModel: BaseModel {
    ///数量
    var num = ""
    ///手续费
    var num_fee = ""
    ///币种
    var coin_code = ""
    ///类型：1线上提币，2内部转账
    var tran_type = ""
    ///提币地址(外部提币时--外部地址)
    var address_name = ""
    ///订单号
    var order_no = ""
    ///错误信息
    var remark = ""
    ///交易hash，如果是外部就有
    var tran_hash = ""
    ///
    var create_time = ""
    ///
    var update_time = ""
    
}
