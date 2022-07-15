//
//  RealmGear.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/6/23.
//  档位 保存到本地

import UIKit

class RealmGear: Object {

//    @objc dynamic var coin:String = ""                 //币种名称
//    @objc dynamic var currency:String = ""             //币种单位
//    @objc dynamic var gears : Array = Array<Any>()     //档位合集
    @objc dynamic var selectedGear : String = ""       //当前选择档位
    @objc dynamic var id : String = ""                 //币对  coin+currency

    
    //设置主键
    override class func primaryKey() -> String? {
        return "id"
    }

}
