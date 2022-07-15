//
//  RealmCoin.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/28.
//

import UIKit

class RealmCoin: Object {
    @objc dynamic var coin:String = ""              //币种名称
    @objc dynamic var currency:String = ""          //币种单位
    @objc dynamic var id : String = ""
    //设置主键
    override class func primaryKey() -> String? {
        return "id"
    }
}
