//
//  WSCoinPushSing.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/13.
//

import UIKit

class WSCoinPushSing {
    var datas = PublishSubject<PushCoinModel>() //首页数据推送
    var tradeDatas = PublishSubject<PushCoinModel>() //首页数据推送
    private static let staticInstance = WSCoinPushSing()
    static func sharedInstance() -> WSCoinPushSing{
        return staticInstance
    }
    private init(){}
}
