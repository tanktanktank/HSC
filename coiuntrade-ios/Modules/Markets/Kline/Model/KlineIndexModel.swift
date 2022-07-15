//
//  KlineIndexModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit

class KlineIndexModel: HandyJSON {
    var line: Int = 0 //0:细1:粗2:特粗
    var color:String = ""
    var isSelect:Bool = false
    var num: Int = 0
    var show:String = ""
    required init(){}
}
