//
//  InfoModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/6.
//

import UIKit

class InfoModel: BaseModel {
    ///账号
    var user_account = ""
    ///用户id
    var user_id = ""
    ///用户头像
    var user_image = ""
    ///手机区号
    var area_phone_code = ""
    ///用户手机号
    var phone_number = ""
    ///用户邮箱
    var email_addr = ""
    ///手机号加密
    var phone_pass = ""
    ///邮箱加密
    var email_pass = ""
    ///昵称
    var nick_name = ""
    ///是否设置交易密码 0 设置 1 未设置
    var is_set_tran_pwd = 0
    ///是否开启手机验证 0 未开启 1 开启
    var is_phone_auth = 0
    ///是否开启邮箱验证 0 未开启 1 开启
    var is_email_auth = 0
    ///是否开启谷歌验证器验证 0 未开启 1 开启
    var is_google_auth = 0
    ///用户的邀请码
    var invite_code = ""
    ///用户邀请的总人数
    var recommend_total_num = 0
    
}
