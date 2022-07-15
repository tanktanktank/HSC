//
//  TipManager.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit

///成功数据回调
typealias clickCallback = ((_ isok : Bool) -> Void)
let tipManager = TipManager.manager

class TipManager: NSObject {
    static let manager : TipManager = {
       let obj = TipManager()
       return obj
    }()
    ///alert
    public func showAlert(icon : String?,title : String, message : String, actionArray : [String] ,completion: @escaping clickCallback){
        let view = TipsView()
        view.icon = icon ?? "alert_tip"
        view.title = title
        view.message = message
        view.actionArray = actionArray
        view.backAtion = { isok in
            completion(isok)
        }
        view.show()
    }
    
    ///alert
    public func showOnlyTitleAlert(title : String, actionArray : [String] ,completion: @escaping clickCallback){
        let view = TipsView()
        view.title = title
        view.type = .OnlyTitle
        view.actionArray = actionArray
        view.backAtion = { isok in
            completion(isok)
        }
        view.show()
    }
    public func showLoginErrorAlert(message : String, actionArray : [String] ,completion: @escaping clickCallback){
        let view = TipsView()
        view.icon = "alert_tip"
        view.message = message
        view.type = .LoginError
        view.actionArray = actionArray
        view.backAtion = { isok in
            completion(isok)
        }
        view.show()
    }
}
