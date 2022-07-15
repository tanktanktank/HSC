//
//  UserCerViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/28.
//

import UIKit

protocol UserCerViewMDelegate: NSObjectProtocol{

    func getUserCerSuccess(model : UserCerModel)///认证中心成功
    func getUserCerInfoSuccess() ///提交资料成功
    func getVideoCodeSuccess(code: String) ///获取视频验证码
}
extension UserCerViewMDelegate{
    func getUserCerSuccess(model : UserCerModel){}
    func getUserCerInfoSuccess(){}
    func getVideoCodeSuccess(code: String){}
}

class UserCerViewModel: NSObject {

    weak var delegate: UserCerViewMDelegate?
    
    func getVideoCode(){

        //todo: 模型修改
        NetWorkRequest(UserCerApi.userCerVideoCode, modelType: UserCerModel.self) {[weak self] model in

            print("result is code")
            let curCode = model as! String
            self?.delegate?.getVideoCodeSuccess(code: curCode)

        } failureCallback: { code, message in
        }
    }
    
    func reqPostUserAdvanceInfo(reqModel : ReqUserAdvanceM,completion: @escaping successRequestlback){

        HudManager.show()
        NetWorkRequest(UserCerApi.userCerAdvanceApi(reqModel: reqModel)) { responseInfo in
            
            HudManager.dismissHUD()
            print("addadvancecard result")
            self.delegate?.getUserCerInfoSuccess()
            completion()
        } failedWithCode: { msg, code in
            
            HudManager.dismissHUD()
            HudManager.showError(msg)
            print("error addcard result")
        }
    }
    
    func getUserCerInfo(){

        NetWorkRequest(UserCerApi.userCerDetailApi, modelType: UserCerModel.self) {[weak self] model in
            let temM = model as! UserCerModel
            self?.delegate?.getUserCerSuccess(model: temM)
            print("result is")
        } failureCallback: { code, message in
        }
    }
    
    func reqPostUserCerInfo(reqModel : ReqUserJuniorM,completion: @escaping successRequestlback){

        HudManager.show()
        NetWorkRequest(UserCerApi.userCerAddJuniorApi(reqModel: reqModel)) { responseInfo in
            
            HudManager.dismissHUD()
            print("addcard result")
            self.delegate?.getUserCerInfoSuccess()
            completion()
        } failedWithCode: { msg, code in
            
            HudManager.dismissHUD()
            HudManager.showError(msg)
            print("error addcard result")
        }
    }
    
    func reqUpdateUserCerInfo(reqModel : ReqUserJuniorM,completion: @escaping successRequestlback){

        HudManager.show()
        NetWorkRequest(UserCerApi.userCerUpdateJuniorApi(reqModel: reqModel)) { responseInfo in
            
            HudManager.dismissHUD()
            print("addcard result")
            self.delegate?.getUserCerInfoSuccess()
            completion()
        } failedWithCode: { msg, code in
            
            HudManager.dismissHUD()
            HudManager.showError(msg)
            print("error addcard result")
        }
    }
}
