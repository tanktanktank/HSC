//
//  NoticeModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/9.
//

import UIKit

class NoticeModel : BaseModel {
    var data_total:Int = 0
    var data_list:[NoticeShowModel] = []
}



class NoticeShowModel: BaseModel {
    var id:Int = 0
    var category_id:Int = 0
    var title:String = ""
    var content:String = ""
    var create_time:String = ""
    var url:String = ""
}









































