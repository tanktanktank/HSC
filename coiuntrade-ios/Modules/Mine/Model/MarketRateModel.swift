//
//  MarketRateModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/7.
//

import UIKit

class MarketRateModel: BaseModel,LocalizedCollationable {
    
    var collationKey: String?{
        return tocoin
    }
    ///汇率代码
    var tocoin = ""
    ///汇率
    var rate = ""
    ///汇率单位
    var ratesymbol = ""
    
}
