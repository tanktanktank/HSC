//
//  RechargeModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/26.
//

import UIKit

class RechargeModel: BaseModel {

    ///
    var coin_code = ""
    ///区块确认数
    var confirms = ""
    ///类型：1线上提币，2内部转账
    var tran_type = ""
    ///区块高度
    var block_index = ""
    ///数量
    var amount = ""
    ///账户
    var account = ""
    ///地址
    var address = ""
    ///交易id
    var tx_id = ""
    ///交易hash
    var tran_hash = ""
    ///同步时间
    var block_time = ""
    ///确认时间
    var time_received = ""
}
