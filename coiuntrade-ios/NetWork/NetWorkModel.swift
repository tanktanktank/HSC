//
//  NetWorkModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/19.
//

import Foundation
import HandyJSON

/**
 * 字符串类型
 */
class NetWorkStringModel: HandyJSON {
    var status:Int = 0
    var code:Int = 0
    var msg:String = ""
    var data:String = ""
    required init(){}
}
/**
 * 字符串数组类型
 */
class NetWorkStringListModel: HandyJSON {
    var status:Int = 0
    var code:Int = 0
    var msg:String = ""
    var data:[Any] = Array()
    required init(){}
}
/**
 * 字典类型
 */
class NetWorkDictionaryModel<T:HandyJSON>: HandyJSON {
    var status:Int = 0
    var code:Int = 0
    var msg:String = ""
    var data:T?
    required init(){}
}
/**
 * 数组类型
 */
class NetWorkArrayModel<T:HandyJSON>: HandyJSON {
    var status:Int = 0
    var code:Int = 0
    var msg:String = ""
    var data:[T] = []
    required init(){}
}

class SYNewModel<T:HandyJSON>:HandyJSON{
    var status:String = ""
    var msg:String = ""
    var result:T?

    required init(){}
}
