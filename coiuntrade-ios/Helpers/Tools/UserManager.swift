//
//  UserManager.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/25.
//

import UIKit
let userManager = UserManager.manager
class UserManager: NSObject {
    static let manager : UserManager = {
       let obj = UserManager()
       return obj
    }()
    
    ///是否登录
    var isLogin : Bool {
        let token = Archive.getToken()
        if token.count > 0 {
            return true
        }else{
            return false
        }
        
    }
    ///汇率
    var rate : Float = 1
    ///汇率货币
    var rateSymbol : String = "$"
    var tocoin : String = "usd"
    
    var infoModel : InfoModel? {
        set {
            let json = newValue?.toJSONString()
            CacheDataManager.set(json, forKey: .info)
        }
        get {
            let json : String? = CacheDataManager.value(forKey: .info)
            guard let tmpJson = json else {
                return InfoModel()
            }
            let obj : InfoModel = InfoModel.deserialize(from: tmpJson) ?? InfoModel()
            return obj
        }
    }
    
    
    var loginModel : LoginModel?
}
// MARK: - 退出登录试清空用户模型
extension UserManager {
    ///登出
    func userLogout() {
        let token = ""
        Archive.saveToken(token)
        Archive.saveFaceID(false)
        self.clearLoginModel()
        NotificationCenter.default.post(name: SignoutSuccessNotification, object: nil)
    }
    
    func clearLoginModel() {
        self.loginModel = nil
        self.infoModel = nil
    }
    
    func logoutWithVC(currentVC : UIViewController){
        if currentVC.isKind(of: LoginVC.classForCoder()) {
            return
        }
        let vc = LoginVC()
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        currentVC.present(nav, animated: true)
    }
    
}
