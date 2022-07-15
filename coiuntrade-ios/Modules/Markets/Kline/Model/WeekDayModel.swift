//
//  WeekDayModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class WeekDayModel: HandyJSON {
    //例:[1, 15, 240, "D", "6M"]您将在周期中得到 "1 分钟, 15 分钟, 4 小时, 1 天, 6 个月" 。
    var time: String = ""
    var title:String = ""
    var isSelect:Bool = false
    required init(){}
}
