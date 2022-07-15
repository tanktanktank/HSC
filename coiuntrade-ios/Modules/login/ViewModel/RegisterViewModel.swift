//
//  RegisterViewModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/5.
//

import Foundation

protocol RegisterRequestDelegate: NSObjectProtocol{
    /// 邮箱验证码获取成功回调
    func registerEmailCodeSuccess()
    /// 邮箱验证码获取成功回调
    func registerPhoneCodeSuccess()
    /// 注册成功回调
    func registerAccountSuccess()
}
extension RegisterRequestDelegate{
    func registerEmailCodeSuccess(){}
    func registerPhoneCodeSuccess(){}
    func registerAccountSuccess(){}
}
class RegisterViewModel{
    
    weak var delegate: RegisterRequestDelegate?
    
    ///获取邮箱验证码
    ///business_type业务类型：1-注册，2-登录，3-找回密码，4-修改密码，11-开启手机验证，21-更改手机验证，31-关闭手机验证，12-开启邮箱验证，22-更改邮箱验证，32-关闭邮箱验证，13-开启Google验证，23-更改Google验证，33-关闭Google验证
    func emailRegisterCode(email_addr : String,send_type : Int,business_type : Int){
        
        let param = ["email" : email_addr,"send_type": send_type,"business_type":business_type] as [String : Any]
        NetWorkRequest(LoginApi.sendUnidentified(parameters: param)) {[weak self] responseInfo in
            self?.delegate?.registerEmailCodeSuccess()
        } failedWithCode: { msg, code in
            HudManager.showOnlyText(msg)
        }
    }
    ///获取手机注册验证码
    ///business_type业务类型：1-注册，2-登录，3-找回密码，4-修改密码，11-开启手机验证，21-更改手机验证，31-关闭手机验证，12-开启邮箱验证，22-更改邮箱验证，32-关闭邮箱验证，13-开启Google验证，23-更改Google验证，33-关闭Google验证
    func phoneRegisterCode(area_phone_code : String,phone_number : String,send_type : Int,business_type : Int){
        
        let param = ["phone_area_code":area_phone_code,"phone":phone_number,"send_type": send_type,"business_type":business_type] as [String : Any]
        
        NetWorkRequest(LoginApi.sendUnidentified(parameters: param)) {[weak self] responseInfo in
            self?.delegate?.registerPhoneCodeSuccess()
        } failedWithCode: { msg, code in
            HudManager.showOnlyText(msg)
        }
    }
    
    ///用户注册
    func registerAccount(register_type : Int,phone_area_code: String, phone:String, email:String,password:String, captcha:String, invite_code:String, user_address:String){
        
        let param = ["register_type" : register_type, "phone_area_code": phone_area_code, "phone":phone, "email":email, "password":password, "captcha":captcha, "invite_code":invite_code, "user_address":user_address] as [String : Any]
//        let param = ["password" : password, "repassword": repassword, "invite_code":invite_code, "register_type":register_type, "email_addr":email_addr, "verify_code":verify_code, "user_address":user_address] as [String : Any]
        HudManager.show()
        NetWorkRequest(LoginApi.register(parameters: param), modelType: CredentialsModel.self) {[weak self] model in
            HudManager.dismissHUD()
            let creModel = model as! CredentialsModel
            if creModel.jwt_token.count > 0{
                Archive.saveToken(creModel.jwt_token)
            }
            self?.delegate?.registerAccountSuccess()
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }

    }
    ///用户手机注册
    func phoneRegisterAccount(password : String,repassword: String, invite_code:String, register_type:Int, phone_number:String, area_phone_code:String, verify_code:String, user_address:String){
//        let strNumber = NumberFormatter().number(from: verify_code)
//        let verifyCode:Int = strNumber!.intValue
        let param = ["password" : password, "repassword": repassword, "invite_code":invite_code, "register_type":register_type, "phone_number":phone_number, "area_phone_code":area_phone_code ,"verify_code":verify_code, "user_address":user_address] as [String : Any]
        
        HudManager.show()
        NetWorkRequest(LoginApi.register(parameters: param), modelType: CredentialsModel.self) {[weak self] model in
            HudManager.dismissHUD()
            let creModel = model as! CredentialsModel
            Archive.saveToken(creModel.jwt_token)
//            self?.delegate?.registerPhoneSuccess()
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }
    }
}
