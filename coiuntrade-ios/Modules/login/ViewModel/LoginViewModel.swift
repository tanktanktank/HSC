//
//  LoginViewModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/5.
//

import Foundation
import UIKit

protocol LoginRequestDelegate: NSObjectProtocol{
    /// 邮箱登录成功回调
    func loginEmailSuccess(model : LoginModel)
    ///验证码验证成功以后生成的凭证
    func getCredentialsSuccess(model : CredentialsModel)
    /// 重置密码成功回调
    func resetPwdSuccess(model : LoginModel)
    ///登录失败回调
    func loginFailure(code : Int,msg : String)
}
extension LoginRequestDelegate{
    func getCredentialsSuccess(model : CredentialsModel){}
    func loginEmailSuccess(model : LoginModel){}
    func resetPwdSuccess(model : LoginModel){}
    func loginFailure(code : Int,msg : String){}
}
class LoginViewModel{
    
    weak var delegate: LoginRequestDelegate?
    ///邮箱登录登录
    func emailLogin(email_addr : String , password : String,logintype : Int){
        
        let parameters = ["login_type":logintype,"password":password,"email":email_addr] as [String : Any]
        HudManager.show()
        NetWorkRequest(LoginApi.login(parameters: parameters), modelType: LoginModel.self) { model in
            HudManager.dismissHUD()
            let loginModel = model as! LoginModel
            loginModel.password = password
            userManager.loginModel = loginModel
            self.delegate?.loginEmailSuccess(model: loginModel)
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            self.delegate?.loginFailure(code: code, msg: message)
//            HudManager.showError(message)
        }
    }
    ///手机登录
    func phoneLogin(area_phone_code : String,phone_number : String , password : String,logintype : Int){
        
        let parameters = ["login_type":logintype,"password":password,"phone_area_code":area_phone_code,"phone":phone_number] as [String : Any]
        HudManager.show()
        NetWorkRequest(LoginApi.login(parameters: parameters), modelType: LoginModel.self) { model in
            HudManager.dismissHUD()
            let loginModel = model as! LoginModel
            loginModel.password = password
            userManager.loginModel = loginModel
            self.delegate?.loginEmailSuccess(model: loginModel)
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            self.delegate?.loginFailure(code: code, msg: message)
//            HudManager.showError(message)
        }
    }
    
    ///手机登录  安全验证
    ///business_type登录类型 1 手机 2 邮箱
    func loginSecurityCode(login_type : Int,sms_captcha : String,email_captcha : String,google_captcha : String,password : String,phone:String,email:String,phone_area_code:String){
        let parameters = ["login_type":login_type,"sms_captcha":sms_captcha,"email_captcha":email_captcha,"google_captcha":google_captcha,"password":password,"phone":phone,"email":email,"phone_area_code":phone_area_code] as [String : Any]
        HudManager.show()
        NetWorkRequest(LoginApi.login(parameters: parameters), modelType: LoginModel.self) { model in
            HudManager.dismissHUD()
            let loginModel = model as! LoginModel
            loginModel.password = password
            userManager.loginModel = loginModel
            Archive.saveToken(loginModel.jwt_token)
            self.delegate?.loginEmailSuccess(model: loginModel)
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }
    }
    ///校验验证码
    ///business_type校验类型 28 设置交易密码 27 设置邮箱 37 修改邮箱 4 设置手机 36 修改手机 34 设置谷歌验证器 35 更改谷歌验证器 41 打开手机验证 38 关闭手机验证 42 打开邮箱验证 39 关闭邮箱验证 43 打开谷歌验证 40关闭谷歌验证  45 确认更改谷歌验证器
    func confirmSecurityCode(retrieve_type : Int,phone_area_code : String,phone : String,email : String,sms_captcha : String,email_captcha : String,google_captcha : String){
        let parameters = ["retrieve_type":retrieve_type,"phone_area_code":phone_area_code,"phone":phone,"email":email,"sms_captcha":sms_captcha,"email_captcha":email_captcha,"google_captcha":google_captcha] as [String : Any]
        HudManager.show()
        NetWorkRequest(LoginApi.confirmUnidentified(parameters: parameters), modelType: CredentialsModel.self) { model in
            HudManager.dismissHUD()
            let creModel = model as! CredentialsModel
            Archive.saveToken(creModel.jwt_token)
            self.delegate?.getCredentialsSuccess(model: creModel)
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }
    }
    ///重置密码
    ///credentials 1 不带凭证时，仅验证账号是否存在；2 携带凭证时，重置密码。
    func resetPwd(retrieve_type:Int,phone_area_code:String,phone:String,email:String,password:String,credentials:String){
        let parameters = ["retrieve_type":retrieve_type,"phone_area_code":phone_area_code,"phone":phone,"email":email,"password":password,"credentials":credentials] as [String : Any]
        HudManager.show()
        NetWorkRequest(LoginApi.resetPwd(parameters: parameters), modelType: LoginModel.self) { model in
            HudManager.dismissHUD()
            let loginModel = model as! LoginModel
            userManager.loginModel = loginModel
            self.delegate?.resetPwdSuccess(model: loginModel)
        } failureCallback: { code, message in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }

    }
}
