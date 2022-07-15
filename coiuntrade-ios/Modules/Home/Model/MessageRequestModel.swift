//
//  MessageRequestModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/6.
//

import UIKit

class MessageRequestModel: BaseModel {
    var is_read : Int = 0 //是否已读    1未读  2已读   0全部
    var category_id :Int = 0  //分类ID  全部的话传0      否则传相应的分类ID
    var page_index : Int = 1
    var page_size : Int = 10
    
}
