//
//  MessageModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/6.
//

import UIKit

class MessageModel : BaseModel {
    var id : Int = 0
    ///
    var user_id : Int = 0
    ///
    var message_id : Int = 0
    ///是否已读1未读2已读
    var is_read : Int = 0
    ///
    var url : String = ""
    
    ///推送类型1手动2模板自动
    var type : Int = 0
    ///创建时间
    var create_time : String = ""
    ///
    var push_time : String = ""
    ///展示标题
    var little_title : String = ""
    ///分类ID
    var category_id : Int = 0
    ///内容
    var content : String = ""
}

class MessageUnreadNum : BaseModel {
    ///分类ID
    var category_id = 0
    
    ///对应分类ID下的未读数量
    var unread_count = 0
}

class MessageData : BaseModel {
    ///总条目
    var data_total : Int = 0
    
    ///站内信内容
    var data_list : Array<MessageModel> = Array()
    ///
    var unread_num : Array<MessageUnreadNum> = Array()
}

///未读消息总数
class MessageCount :BaseModel{
    var count = ""
    
}
///设置已读数量
class MessageUpdateNum :BaseModel{
    var update_num = ""
    
}
