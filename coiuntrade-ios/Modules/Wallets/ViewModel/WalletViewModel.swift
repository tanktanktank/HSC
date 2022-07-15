//
//  WalletViewModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/13.
//

import Foundation
protocol WalletRequestDelegate: NSObjectProtocol{
    /// 获取现货资产总览成功回调
    func getAccountSpotcointotalSuccess(model : SpotcointotalModel)
    /// 获取现货资产总览成功回调
    func getAllbalanceSuccess(array : Array<AllbalanceModel>)
    /// 获取提币记录成功回调
    func getOutrecordSuccess(array : Array<OutrecordModel>)
    /// 获取充值记录成功回调
    func getRechargerecordSuccess(array : Array<RechargeModel>)
    /// 获取列表数据失败回调
    func getListFailure()
}
extension WalletRequestDelegate{
    func getAccountSpotcointotalSuccess(model : SpotcointotalModel){}
    func getAllbalanceSuccess(array : Array<AllbalanceModel>){}
    func getOutrecordSuccess(array : Array<OutrecordModel>){}
    func getRechargerecordSuccess(array : Array<RechargeModel>){}
    func getListFailure(){}
}
class WalletViewModel{
    weak var delegate: WalletRequestDelegate?
    ///获取现货资产总览
    func getAccountSpotcointotal(){
        NetWorkRequest(WalletApi.accountSpotcointotal, modelType: SpotcointotalModel.self) {[weak self] model in
            let spotcointotalModel : SpotcointotalModel = model as! SpotcointotalModel
            self?.delegate?.getAccountSpotcointotalSuccess(model: spotcointotalModel)
        } failureCallback: { code, message in
            HudManager.showError(message)
            self.delegate?.getListFailure()
        }

    }
    //MARK: 获取用户所有币种资产
    func getAllbalance(){
//        HudManager.show()
        NetWorkRequest(WalletApi.accountallbalance, modelType: AllbalanceModel.self) {[weak self] model in
//            HudManager.dismissHUD()
            let array : Array<AllbalanceModel> = model as! Array<AllbalanceModel>
            self?.delegate?.getAllbalanceSuccess(array: array)
        } failureCallback: { code, message in
            self.delegate?.getListFailure()
//            HudManager.dismissHUD()
            HudManager.showError(message)
        }
    }
    //MARK: 获取提币记录
    func getOutrecord(coin : String , start_time : String , end_time : String, page : Int, page_size : Int , type : FlowingWaterType){
        switch type {
        case .recharge:
            NetWorkRequest(WalletApi.getRechargerecord(coin: coin, start_time: start_time, end_time: end_time, page: page, page_size: page_size), modelType: RechargeModel.self) {[weak self] model in
                HudManager.dismissHUD()
                let array : Array<RechargeModel> = model as! Array<RechargeModel>
                self?.delegate?.getRechargerecordSuccess(array: array)
            } failureCallback: { code, message in
                self.delegate?.getListFailure()
                HudManager.dismissHUD()
                HudManager.showError(message)
            }
            break
        case .withdraw:
            NetWorkRequest(WalletApi.getOutrecord(coin: coin, start_time: start_time, end_time: end_time, page: page, page_size: page_size), modelType: OutrecordModel.self) {[weak self] model in
                HudManager.dismissHUD()
                let array : Array<OutrecordModel> = model as! Array<OutrecordModel>
                self?.delegate?.getOutrecordSuccess(array: array)
            } failureCallback: { code, message in
                self.delegate?.getListFailure()
                HudManager.dismissHUD()
                HudManager.showError(message)
            }
            break
        default:
            break
        }
    }
}
