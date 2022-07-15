//
//  TradeViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit

class TradeViewModel: NSObject {
    
    var reqModel = ReqCoinModel() //请求内容
    var reqTradeModel = ReqTradeModel()  //请求内容
    var assetModel : SymbolAssetModel = SymbolAssetModel()
    var searchs : [CoinModel] = Array()
    let searchSubject = PublishSubject<NSArray>()
    var search:String = ""
    
    let balancePublish = PublishSubject<Any>()

    private var disposeBag = DisposeBag()
    
    //MARK: 搜索币种热度列表
    func requestSearchList() -> (PublishSubject<Any>){
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.allcoin, modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            if model.count > 0{
                //翻译
                let fristModel = CoinModel()
                fristModel.coin = "tv_all".localized()
                fristModel.isLast = false
                fristModel.isFrist = true
                self.searchs.append(fristModel)
                for idx in 0 ..< model.count {
                    let asModel = model[idx]
                    asModel.isLast = idx == model.count - 1 ? true : false
                    self.searchs.append(asModel)
                }
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else {
                dataSubject.onNext(false)
                dataSubject.onCompleted()
            }
        }
        return dataSubject
    }
    
    //MARK: 搜索币种
    func requestSearchCoin()->(PublishSubject<Any>) {
        self.searchs.removeAll()
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.searchticker(coin: search.uppercased()), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            
            if model.count > 0{
                //翻译
                let fristModel = CoinModel()
                fristModel.coin = "tv_all".localized()
                fristModel.isLast = false
                fristModel.isFrist = true
                self.searchs.append(fristModel)
                for idx in 0 ..< model.count {
                    let asModel = model[idx]
                    asModel.isLast = idx == model.count - 1 ? true : false
                    self.searchs.append(asModel)
                }
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            }
//            if model.count > 0 {
//                for asModel in model {
//                    self.searchs.append(asModel)
//                }
//                dataSubject.onNext(true)
//                dataSubject.onCompleted()
//            }
            else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    
    //MARK: 下单(买卖)
    func requestTradeOrder() -> (PublishSubject<Any>){
        let dataSubject = PublishSubject<Any>()
        
        
        if self.reqTradeModel.order_type == "2" {
            
            guard let trigger = Double(self.reqTradeModel.trigger_price) , trigger > 0  else {
                
                dataSubject.onError(error(NSLocalizedString("triggerPrice", comment: "")))
                return dataSubject
            }
        }
        
        if self.reqTradeModel.order_type != "3" {
            
            guard let price = Double(self.reqTradeModel.price) , price > 0  else {
                
                dataSubject.onError(error(NSLocalizedString("price", comment: "")))
                return dataSubject
            }
        }
        
        guard let amount = Double(self.reqTradeModel.num) , amount > 0 ,let total = Double(self.reqTradeModel.total) , total >= 10 else{
            
            if self.reqTradeModel.order_type != "3"{
                dataSubject.onError(error(NSLocalizedString("num", comment: "")))
            }else{
                dataSubject.onError(error(NSLocalizedString("market_num", comment: "")))
            }
            return dataSubject
        }
//        if self.reqTradeModel.order_type == "2" , Double(self.reqTradeModel.trigger_price)! <= 0 {
//
//            dataSubject.onError(error(NSLocalizedString("triggerPrice", comment: "")))
//
//        }else
//        if self.reqTradeModel.order_type != "3" , Double(self.reqTradeModel.price)! <= 0 {
//
//            dataSubject.onError(error(NSLocalizedString("price", comment: "")))
//        } else
//        if Double((self.reqTradeModel.num == "" ? "0" : self.reqTradeModel.num))! <= 0 {
//
//            if self.reqTradeModel.order_type != "3"{
//                dataSubject.onError(error(NSLocalizedString("num", comment: "")))
//            }else{
//                dataSubject.onError(error(NSLocalizedString("market_num", comment: "")))
//            }
//        } else {
            NetWorkProvider.request(.tradeorder(reqModel: self.reqTradeModel), completion: { result in
                if case .success(let response) = result {
                    if [UInt8](response.data).count > 0{
                        let jsonDic = try! response.mapJSON() as! NSDictionary
                        let model = NetWorkStringModel.deserialize(from: jsonDic)
                        if model!.status == 1 {
                            dataSubject.onNext(true)
                            dataSubject.onCompleted()
                        } else{
                            dataSubject.onError(error(NSLocalizedString(model!.msg, comment: "")))
                        }
                    } else{
                        //翻译
                        dataSubject.onError(error(NSLocalizedString("下单失败", comment: "")))
                    }
                }
            })
//        }
        return dataSubject
    }
    //MARK: 获取用户所有币种资产
    func requestAllbalance()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        if is_Blank(ref: Archive.getToken()) {
            dataSubject.onError(NSError(domain: "", code: 0))
        } else{
            let reqModel = ReqAssetModel()
            reqModel.hide_small_coin = true
            reqModel.coin_code = self.reqModel.currency
            NetWorkRequest(GitHub.accountallbalance(reqModel: reqModel), modelType: AllbalanceModel.self) { responseInfo in
                let model = responseInfo as! Array<AllbalanceModel>
                if model.count > 0 {
                    for asModel in model{
                        if asModel.coin_code == self.reqModel.currency {
                            dataSubject.onNext(asModel as PublishSubject<AllbalanceModel>.Element)
                            dataSubject.onCompleted()
                            return
                        }
                    }
                } else {
                    dataSubject.onError(NSError(domain: "", code: 0))
                }
            }
        }
        return dataSubject
    }
    
    //MARK: 获取币种资产
    func requestSymbolAsset()->(PublishSubject<Any>) {
//        let dataSubject = PublishSubject<Any>()
        if is_Blank(ref: Archive.getToken()) {
            balancePublish.onError(NSError(domain: "", code: 0))
        } else{
            let reqModel = ReqSymbolAssetModel()
            reqModel.currency = self.reqModel.currency
            reqModel.coin = self.reqModel.coin
            NetWorkRequest(GitHub.symbolAsset(reqModel: reqModel), modelType: SymbolAssetModel.self) { [self] responseInfo in
                let model = responseInfo as! SymbolAssetModel
//
                self.assetModel = model
                
//                if model != nil {
                balancePublish.onNext(model)
//                balancePublish.onCompleted()

                return
            }
        }
        return balancePublish
    }

}
