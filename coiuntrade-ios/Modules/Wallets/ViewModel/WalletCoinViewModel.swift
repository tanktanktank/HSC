//
//  WalletCoinViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/17.
//

import UIKit

protocol WalletCoinRequestDelegate: NSObjectProtocol{
    /// 获取币交易对
    func getCoinUnitSuccess(model : CoinAssetsModel)
}
extension WalletCoinRequestDelegate{
    func getCoinUnitSuccess(model : CoinAssetsModel){}
}

class WalletCoinViewModel: NSObject {

    weak var delegate: WalletCoinRequestDelegate?
    ///获取币交易对
    func getCoinUnit(coin : String){

        NetWorkRequest(WalletApi.getCoinTradeSet(coin: coin), modelType: CoinAssetsModel.self) {[weak self] model in
            let temM = CoinAssetsModel()
            let result = model as! Array<CoinAssetsModel>
            if(result.count > 0){
                let firstM = result[0]
                temM.coin_code = firstM.coin_code
                temM.currency_code = firstM.currency_code
                temM.new_price = firstM.new_price
                temM.change_rate = firstM.change_rate
            }
            self?.delegate?.getCoinUnitSuccess(model: temM)
        } failureCallback: { code, message in
        }
    }
}
