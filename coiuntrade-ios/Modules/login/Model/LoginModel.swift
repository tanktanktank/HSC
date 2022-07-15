//
//  LoginModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/6.
//

import UIKit

class LoginModel: BaseModel {
    ///账号
    var user_account = ""
    ///手机区号
    var area_phone_code = ""
    ///电话号码
    var phone_number = ""
    ///邮箱地址
    var email_addr = ""
    ///手机加密显示
    var phone_pass = ""
    ///邮箱加密显示
    var email_pass = ""
    ///是否开启手机验证 0否，1是
    var is_phone_auth = 0
    ///是否开启邮箱验证 0否，1是
    var is_email_auth = 0
    ///是否开启谷歌验证 0否，1是
    var is_google_auth = 0
    ///登录类型 1 手机 2 邮箱
    var login_type = 2
    ///token
    var jwt_token = ""
    ///是否实名认证  0否，1是
    var id_card_state = 0
    ///密码
    var password = ""
    ///业务类型
    var retrieve_type = 0

    
}

class CredentialsModel: BaseModel {
    ///token
    var jwt_token = ""
    ///验证码校验通过返回的凭证
    var business_credentials = ""
    
}
