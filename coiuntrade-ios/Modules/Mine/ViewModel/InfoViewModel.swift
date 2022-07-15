//
//  InfoViewModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/6.
//

import Foundation
protocol MineRequestDelegate: NSObjectProtocol{
    /// 获取用户信息成功回调
    func getUserInfoSuccess(model : InfoModel)
    /// 获取汇率成功回调
    func getMarketRateSuccess(array : [MarketRateModel])
    /// 获取谷歌验证器秘钥成功回调
    func getGoogleAuthSuccess(model : SecretGoogle)
    /// 更新用户信息成功回调
    func userUpdaeSuccess()
    ///修改密码成功回调
    func userUpdatePasswdSuccess()
    ///设置目前用户使用的汇率(基础货币)成功回调
    func setUserRatecountrySuccess(model : MarketRateModel)
    ///获取目前用户使用的汇率(基础货币)
    func getUserRatecountrySuccess(model : MarketRateModel)
    ///新  身份验证器开关（开、关、改)成功回调
    func authSwitchNewSuccess()
}
extension MineRequestDelegate{
    func getUserInfoSuccess(model : InfoModel){}
    func getMarketRateSuccess(array : [MarketRateModel]){}
    func getGoogleAuthSuccess(model : SecretGoogle){}
    func userUpdaeSuccess(){}
    func userUpdatePasswdSuccess(){}
    func setUserRatecountrySuccess(model : MarketRateModel){}
    func getUserRatecountrySuccess(model : MarketRateModel){}
    func authSwitchNewSuccess(){}
}
class InfoViewModel{
    weak var delegate: MineRequestDelegate?
    ///获取用户信息
    func getUserInfo(){
        NetWorkRequest(InfoApi.getUserInfo, modelType: InfoModel.self) {[weak self] model in
            let infoModel = model as! InfoModel
            userManager.infoModel = infoModel
            self?.delegate?.getUserInfoSuccess(model: infoModel)
        }
    }
    ///获取汇率
    func getMarketRate(){
        NetWorkRequest(InfoApi.getMarketRate, modelType: MarketRateModel.self) {[weak self]  model in
            let array : [MarketRateModel] = model as! [MarketRateModel]
            self?.delegate?.getMarketRateSuccess(array: array)
        }
    }
    ///设置目前用户使用的汇率(基础货币)
    func setUserRatecountry(model : MarketRateModel){
        HudManager.show()
        let parameters = ["ratecountry":model.tocoin] as [String : Any]
        NetWorkRequest(InfoApi.userRatecountry(parameters: parameters)) {[weak self] responseInfo in
            HudManager.dismissHUD()
            self?.delegate?.setUserRatecountrySuccess(model: model)
        } failedWithCode: { message, code in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }
    }
    ///获取目前用户使用的汇率(基础货币)
    func getUserRatecountry(){
        HudManager.show()
        NetWorkRequest(InfoApi.getuserRatecountry, modelType: MarketRateModel.self) {[weak self] model in
            let marketRateModel : MarketRateModel = model as! MarketRateModel
            userManager.tocoin = marketRateModel.tocoin
            userManager.rate = Float(marketRateModel.rate) ?? 1
            userManager.rateSymbol = marketRateModel.ratesymbol
            self?.delegate?.getUserRatecountrySuccess(model: marketRateModel)
        }
    }
    ///验证器开关（开、关、改)   新
    ///validator_type  验证器类型：1-手机，2-邮箱，3-GoogleAuthenticator
    ///operation_type  操作类型：1-开启，2-更改，3-关闭
    func authSwitchNew(model : AuthSwithNewRequestModel){
        HudManager.show()
        NetWorkRequest(InfoApi.authSwitchNew(model: model)) { responseInfo in
            HudManager.dismissHUD()
            self.delegate?.authSwitchNewSuccess()
        } failedWithCode: { message, code in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }

    }
    ///更新用户信息
    func userUpdae(nick_name:String, head_image:String){
        let parameters = ["nick_name":nick_name,
                          "head_image":head_image] as [String : Any]
        NetWorkRequest(InfoApi.userUpdate(parameters: parameters)) {[weak self] responseInfo in
            self?.delegate?.userUpdaeSuccess()
        } failedWithCode: { msg, code in
            HudManager.showOnlyText(msg)
        }
    }
    ///获取谷歌验证器秘钥
    ///type  秘钥类型：1-获取绑定秘钥，2-获取更改秘钥
    func getGoogleAuth(type : Int){
        NetWorkRequest(InfoApi.getGoogleAuth(type: 1), modelType: SecretGoogle.self) { model in
            let secretModel = model as! SecretGoogle
            self.delegate?.getGoogleAuthSuccess(model: secretModel)
        } failureCallback: { code, message in
            HudManager.showError(message)
        }
    }
    ///修改密码
    func userUpdatePasswd(password : String ,old_password : String,sms_captcha:String,email_captcha:String,google_captcha:String){
        let parameters = ["new_password":password,
                          "old_password":old_password,
                          "sms_captcha":sms_captcha,
                          "email_captcha":email_captcha,
                          "google_captcha":google_captcha] as [String : Any]
        HudManager.show()
        NetWorkRequest(InfoApi.userUpdatePasswd(parameters: parameters)) { responseInfo in
            HudManager.dismissHUD()
            self.delegate?.userUpdatePasswdSuccess()
        } failedWithCode: { message, code in
            HudManager.dismissHUD()
            HudManager.showError(message)
        }

    }
}
