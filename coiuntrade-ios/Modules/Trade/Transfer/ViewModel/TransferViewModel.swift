//
//  TransferViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/25.
//

import UIKit

class TransferViewModel: NSObject {

    let submitSubject = PublishSubject<String>()
    var hots : [CoinModel] = Array()
    var alls  = [String:[CoinModel]]()
    var letters : [String] = Array()
    var address:String = ""
    
    private var disposeBag = DisposeBag()
    
    //MARK: 获取币种列表
    func requestAllCoin()->(PublishSubject<Bool>) {
        let dataSubject = PublishSubject<Bool>()
        NetWorkRequest(GitHub.searchticker(coin: ""), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            //表示自选
            self.letters.append("#")
            var bookDict = [String:[CoinModel]]()
            if model.count > 0 {
                for asModel in model {
                    let info = asModel
                    let coin = info.coin.uppercased()
                    let prefix = String(coin.prefix(1))
                    if bookDict[prefix] != nil {
                        bookDict[prefix]?.append(info)
                    } else {
                        let arrGroup = [info]
                        bookDict[prefix] = arrGroup
                    }
                }
                var nameKeys = Array(bookDict.keys).sorted()
                if nameKeys.first == "#" {
                    nameKeys.insert(nameKeys.first!, at: nameKeys.count)
                    nameKeys.remove(at: 0);
                }
                for i in 0..<nameKeys.count {
                    let key = nameKeys[i]
                    self.letters.append(key)
                }
                self.alls = bookDict
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            }
            else {
                dataSubject.onError(error("tv_empty_data".localized()))
            }
        }
        return dataSubject
    }
    //MARK: 提现
    func requestTransferSend()->(PublishSubject<Bool>) {
        let submitSubject = PublishSubject<Bool>()
        if is_Blank(ref: address) == true{
            submitSubject.onError(error("tv_input_address_tip".localized()))
        }
        return submitSubject
    }
    //MARK: 汉字符串, 返回大写拼音首字母
    func getFirstLetterFromString(aString: String) -> (String) {
         
         let regexA = "^[A-Z]$"
         let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
         return predA.evaluate(with: aString) ? aString : "#"
     }
}











































