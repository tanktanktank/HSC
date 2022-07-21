//
//  TipManager.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit

///成功数据回调
typealias clickCallback = ((_ isok : Bool) -> Void)
///选中index
typealias selectedIndexback = ((_ index : Int) -> Void)
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
//    //sheet
//    public func showActionSheet(datas : [String],completion: @escaping selectedIndexback){
//        
//        let actionSheet = HSActionSheet()
//        actionSheet.datas = datas
//        actionSheet.clickCellAtion = { index in
//            completion(index)
//        }
//        actionSheet.show()
//    }
    
    //sheet
    public func showActionSheet(datas : [String] , selectedIndex : Int = -1 ,completion: @escaping selectedIndexback){
        
        let actionSheet = HSActionSheet()
        actionSheet.selectedIndex = selectedIndex
        actionSheet.datas = datas
        actionSheet.clickCellAtion = { index in
            completion(index)
        }
        actionSheet.show()
    }
    public func showSingleActionSheet(datas : [String] , selectedIndex : Int = 0 ,completion: @escaping selectedIndexback){
        let actionSheet = HSActionSheetNormal()
        actionSheet.selectedIndex = selectedIndex
        actionSheet.datas = datas
        actionSheet.clickCellAtion = { index in
            completion(index)
        }
        actionSheet.show()
    }

    public func showActionSheetNormal(title : String,datas : [String],selectedIndex : Int,completion: @escaping selectedIndexback){
        
        let actionSheet = HSSearchActionSheet()
        actionSheet.title = title
        actionSheet.datas = datas
        actionSheet.selectedIndex = selectedIndex
        actionSheet.clickCellAtion = { index in
            completion(index)
        }
        actionSheet.show()
    }
    
    
    public func showSingleAlert(title:String = "" , message : String , buttonTitle: String = "好的" , style: HPAlertAction.Style = .default , handler: @escaping () -> Void = {}){
        
        let alert = HPAlertController(title: title,
                                      message: message ,
                                      icon: .none,
                                      alertTintColor:.hexColor("ffffff"))
                
        let actionBtn = HPAlertAction(title: buttonTitle, style: style , handler: handler)
        alert.addAction(actionBtn)
        
        let vc =  UIApplication.shared.windows.first?.rootViewController
        vc?.present(alert, animated: true)

    }

}
