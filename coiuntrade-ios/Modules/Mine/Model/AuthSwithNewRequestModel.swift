//
//  AuthSwithNewRequestModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/8.
//

import UIKit

class AuthSwithNewRequestModel: BaseModel {
    ///操作类型：1-开启，2-更改，3-关闭
    var operation_type : Int = 0
    ///验证器类型：1-手机，2-邮箱，3-GoogleAuthenticator
    var validator_type : Int = 0
    ///手机验证码
    var sms_captcha : String = ""
    ///邮箱验证码
    var email_captcha : String = ""
    ///谷歌验证码
    var google_captcha : String = ""
    ///新手机区号：开启&更改手机验证器时必传
    var new_phone_area : String = ""
    ///新手机号：开启&更改手机验证器时必传
    var new_phone : String = ""
    ///新手机验证码：开启&更改手机验证器时必传
    var new_phone_captcha : String = ""
    ///新邮箱：开启&更改邮箱验证器时必传
    var new_email : String = ""
    ///新邮箱验证码：开启&更改邮箱验证器时必传
    var new_email_captcha : String = ""
    ///谷歌验证码：开启&更改谷歌验证器时必传
    var new_google_captcha : String = ""
    
}
