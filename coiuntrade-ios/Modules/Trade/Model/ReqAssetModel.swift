//
//  ReqAssetModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/17.
//

import UIKit

class ReqAssetModel: HandyJSON {
    var hide_small_coin:Bool = false //隐藏非0币种(布尔类型)
    var coin_code:String = ""   //币种
    required init(){}
}

class ReqSymbolAssetModel: HandyJSON {
    var coin:String = ""  //隐藏非0币种(布尔类型)
    var currency:String = ""   //币种
    required init(){}
}
