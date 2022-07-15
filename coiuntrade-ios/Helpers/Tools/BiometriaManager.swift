//
//  FaceIDAndTouchID.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/11.
//

import UIKit
import LocalAuthentication

enum LocalAuthStatus : Int {
    case success             //成功
    case failed              //失败
    case passwordNotSet      //未设置手机密码
    case touchidNotSet       //未设置指纹
    case touchidNotAvailable //不支持指纹
    case cancleSys           //系统取消
    case canclePer           //用户取消
    case inputNUm            //输入密码
}
enum BiometryType : Int {
    case none
    case touchID
    case faceID
}

typealias callback = ((LocalAuthStatus) -> Void)
let bioManager = BiometriaManager.manager
class BiometriaManager: NSObject {
    static let manager : BiometriaManager = {
       let obj = BiometriaManager()
       return obj
    }()
    
    func getBiometryType() -> BiometryType{
        //该参数必须在canEvaluatePolicy方法后才有值
        let authContent = LAContext()
        var error: NSError?
        if authContent.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            //iPhoneX出厂最低系统版本号：iOS11.0.0
            if #available(iOS 11.0, *) {
                if authContent.biometryType == .faceID {
                    return .faceID
                }else if authContent.biometryType == .touchID {
                    return .touchID
                }
            } else {
                guard let laError = error as? LAError else{
                    return .none
                }
                if laError.code != .touchIDNotAvailable {
                    return .touchID
                }
            }
        }
        return .none
    }
    
    /*
     LAPolicy有2个参数：
     用TouchID/FaceID验证，如果连续出错则需要锁屏验证手机密码，
     但是很多app都是用这个参数，等需要输入密码解锁touchId&faceId再弃用该参数。
     优点：用户在单次使用后就可以取消验证。
     1，deviceOwnerAuthenticationWithBiometrics
     
     用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面
     等错误次数过多验证被锁时启用该参数
     2，deviceOwnerAuthentication
     
     */
    func touchID (completion: @escaping callback){
        
       let context = LAContext()
       var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "请输入你的密码") {(success,error) in
                if success {
                    //evaluatedPolicyDomainState 只有生物验证成功才会有值
                    if let _ = context.evaluatedPolicyDomainState {
                        //如果不放在主线程回调可能会有5-6s的延迟
                        DispatchQueue.main.async {
                            print("验证成功")
                            completion(.success)
                        }
                    }else{
                        DispatchQueue.main.async {
                            print("设备密码输入正确")
                            completion(.success)
                        }
                    }
                }else{
                    guard let laError = error as? LAError else{
                        DispatchQueue.main.async {
                            print("touchID不可用")
                            completion(.touchidNotAvailable)
                        }
                        return
                    }
                    switch laError.code {
                    case .authenticationFailed:
                        DispatchQueue.main.async {
                            print("连续三次输入错误，身份验证失败")
                            completion(.failed)
                        }
                    case .userCancel:
                        DispatchQueue.main.async {
                            print("用户点击取消按钮。")
                            completion(.canclePer)
                        }
                    case .userFallback:
                        DispatchQueue.main.async {
                            print("用户点击输入密码")
                            completion(.inputNUm)
                        }
                    case .systemCancel:
                        DispatchQueue.main.async {
                            print("系统取消")
                            completion(.cancleSys)
                        }
                    case .passcodeNotSet:
                        DispatchQueue.main.async {
                            print("用户未设置密码")
                            completion(.passwordNotSet)
                        }
                    case .touchIDNotAvailable:
                        DispatchQueue.main.async {
                            print("touchID不可用")
                            completion(.touchidNotAvailable)
                        }
                    case .touchIDNotEnrolled:
                        DispatchQueue.main.async {
                            print("touchID未设置指纹")
                            completion(.touchidNotSet)
                        }
                    case .touchIDLockout:
                        DispatchQueue.main.async {
                            print("touchID输入次数过多验证被锁")
                            self.unlockLocalAuth()
                            completion(.cancleSys)
                        }
                    default:
                        break
                    }
                }
            }
        }else{
            print("还没开启指纹验证呢")
            HudManager.showError("还没开启指纹验证呢")
        }
    }
    private func unlockLocalAuth() {
        let passwordContent = LAContext()
        var error: NSError?
        if passwordContent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            passwordContent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "需要您的密码，才能启用 Touch ID") { (success, err) in
                if success {
                    print("密码解锁成功")
                }else{
                    print(err!)
                    print(error!)
                    
                }
                
            }
        }else{ }
    }
}
