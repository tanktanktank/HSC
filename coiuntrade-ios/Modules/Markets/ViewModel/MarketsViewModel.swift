//
//  MarketsViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/10.
//

import UIKit

typealias successRequestlback = (() -> Void)
class MarketsViewModel: NSObject, WebSocketDelegate{
    private var disposeBag = DisposeBag()
    var wsBuys: [Any] = Array() //买盘
    var wsSells: [Any] = Array() //卖盘
    var reqModel = ReqCoinModel() //请求内容
    var isTrade:Bool = false //是否交易页链接
    var kLines: [Any] = Array() //k线数据
    var kLineList: [XLKLineModel] = Array() //k线数据
    
    var socketKline: WebSocket!
    var socketNewdeal: WebSocket!
    var socketBuySell: WebSocket!
    var isConnected:Bool = false
    var fiveData = PublishSubject<Any>() //买卖5推送
    var kLineData = PublishSubject<Any>() //k线数据推送
    var newdealData = PublishSubject<Any>() //最新成交推送
    var deal24Data = PublishSubject<BuySellModel>() //最新成交+24小时行情推送
    var marketsData = PublishSubject<Any>() //行情推送
    var gearChange = PublishSubject<String?>() //档位推送

    var coinDetails :[CoinModel]!  //币种详情
    var search:String = ""
    var currency:String = ""
    var letters : [String] = Array()
    var currencys: [String] = Array()
    var searchs : [CoinModel] = Array()
    var newdeals : [Any] = Array()
    var accountLike : [CoinModel] = []
    var coinGroups : [CoinModel] = Array()
    var dataArray : [RealmCoinModel] = []//未登录时自选
    var numberOfRow : Int = 5
    var buyStoreArray : [Any] = Array()
    var gears = Array<Any>(){
        
        didSet{
            
//             if self.gear == nil{
                
                 let result = RealmHelper.queryModel(model: RealmGear(), filter: "id = '\(reqModel.coin)/\(reqModel.currency)'")
                 if let model = result.first  {
                     
                     if gears.contains(where: { (element) in
                         
                         return model.selectedGear == element as! String
                     }) {
                         
                         self.gear = model.selectedGear
                     }else{
                         
                         self.gear = gears.first as? String
                     }
                     
                 }else{
                     
                     self.gear = gears.first as? String
                 }

//            }
        }
    }
    var gear : String? {
        
        didSet{
            // 重新刷新一下
//            self.sells = self.sells
//            self.buys = self.buys
            self.gearChange.onNext(gear)
            self.fiveData.onNext((type:9 , num : 0 ))
//            self.fiveData.onNext((type:11 , num : 0 ))

            let result = RealmHelper.queryModel(model: RealmGear(), filter: "id = '\(reqModel.coin)/\(reqModel.currency)'")
         
            
            if let _ = result.first  {
                
                let updateModel = RealmGear()
                updateModel.id = reqModel.coin + "/" + reqModel.currency
                updateModel.selectedGear = gear ?? ""
                RealmHelper.updateModel(model: updateModel)
            }else{
                
                let model = RealmGear()
                model.id = reqModel.coin + "/" + reqModel.currency
                model.selectedGear = gear ?? ""
                RealmHelper.addModel(model: model)
            }
        }
    }
    
    var amountDigit: Int = 0

    var buys: [Any] {
        set{
            
            buyStoreArray = newValue
        }
        get{
                           
            let filterArr = self.dealwithArray(buyStoreArray)

            if isTrade , filterArr.count > numberOfRow {

                let slice: ArraySlice = filterArr[0 ..< numberOfRow]
                let firsrtSix: Array = Array(slice)

                return firsrtSix
            }
                
            return filterArr
        }
        
    } //买盘
    
    var originBuys: [Any] = Array()
    var originSells: [Any] = Array()
 
    var sellStoreArray : [Any] = Array()
    var sells: [Any] {
        set{
            
            sellStoreArray = newValue
        }
        get{
            
            let filterArr = self.dealwithArray(sellStoreArray)
            
            if isTrade , filterArr.count > numberOfRow {
                
                let slice: ArraySlice = filterArr[0 ..< numberOfRow]
                let firsrtSix: Array = Array(slice)
                
                return firsrtSix
            }

            return filterArr
        }
    } //卖盘
    
    func dealwithArray(_ array : Array<Any>) -> Array<Any> {
        
        if let myGear = gear {
            
            var resultArray = Array<Array<Any>>()
            var sum : Double = 0
            
            for item in array {
                
                if let myItem  =  item as? Array<String>  {
                    
                    let price : Double = Double(myItem[0]) ?? 0
                    let amount : Double = Double(myItem[1]) ?? 0
                    sum += amount

                    let divisor = 1 / (Double(myGear) ?? 1)
                    let newPrices = Double(price * divisor)/divisor
                    
                    if let lastNumber = (resultArray.last as? Array<Double>) , lastNumber[0]  == newPrices {

                        let accumlation : Double = lastNumber[2]
                        let newAmount : Double = lastNumber[1] + amount
                        var arr  = Array<Double>()
                        arr.append(newPrices)
                        arr.append(newAmount)
                        arr.append((amount + accumlation))
                        
                        resultArray.removeLast()
                        resultArray.append(arr)

                     }else{
                         
                         if let lastNumber = resultArray.last as? Array<Double> { //计算累计
                             
                             let accumlation : Double = lastNumber[2]
                             var arr  = Array<Double>()
                             arr.append(newPrices)
                             arr.append(amount)
                             arr.append((amount + accumlation))
//                             print("\(arr)")
                             resultArray.append(arr)
                         }else{
                             
                             var arr  = Array<Double>()
                             arr.append(newPrices)
                             arr.append(amount)
                             arr.append(amount)
//                             print("\(arr)")
                            resultArray.append(arr)
                         }
                    }
                }
            }
            
            
            let finalArr =  resultArray.map { arr -> Array<Any> in
                
                let arrr = arr as Array<Any>
                let accumlation : Double = arrr[2] as! Double
                let percentage = accumlation / sum
                
                let digitNum = (self.gear ?? "0").numberOfDecimal
                
//                if let gear  = Double(self.gear ?? "0")  {
//
//                    if(gear < 1){
//                        digitNum =  gear.numberOfDecimal
//                    }
//                }

                let num0 : Double = arr[0] as! Double
                let num1 : Double = arr[1] as! Double

                
                let str1 =  preciseDecimal(x: "\(num0)", p: digitNum) // num0.decimalWithZeroString(Double(digitNum))
                let str2 =  preciseDecimal(x: "\(num1)", p: amountDigit)  //num1.decimalWithZeroString(amountDigit)

                return [str1,str2,"\(percentage)"]
                
            }
            
            return finalArr
        }
        
        return array
    }
    
    //MARK: 获取币种详情
    func requestCoinDetails()->(PublishSubject<CoinModel>) {
        let dataSubject = PublishSubject<CoinModel>()
        NetWorkRequest(GitHub.cointicker(reqModel: self.reqModel), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! CoinModel
            if !is_URLString(ref: model.coin) {
                dataSubject.onNext(model)
                dataSubject.onCompleted()
            } else{
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    
    
    //MARK: 获取买卖5订单
    func requestCoinBuySelllist()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.coinfivelist(reqModel: self.reqModel), modelType: BuySellModel.self) { responseInfo in
            let model = responseInfo as! Array<BuySellModel>
            if model.count > 0 {
                for asModel in model {
                    if asModel.type == 9{
                        
                        self.gears = asModel.gear["data"] as! [Any]
                        self.buys = asModel.data
                        self.originBuys = asModel.data
                        self.fiveData.onNext((type:9 , num : asModel.num ))
                    }
                    if asModel.type == 11{
                        self.sells = asModel.data
                        self.originSells = asModel.data
                        self.fiveData.onNext((type:11 , num : asModel.num))
                    }
                }

                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    
    //MARK: 获取所有交易区
    func requestCurrencygroup()->(PublishSubject<NSArray>) {
        let dataSubject = PublishSubject<NSArray>()
        self.currencys.removeAll()
        NetWorkRequest(GitHub.currencygroup) { responseInfo in
            self.currencys = responseInfo as! Array<String>
            if self.currencys.count > 0 {
                dataSubject.onNext(self.currencys as PublishSubject<NSArray>.Element)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 获取所有交易区的币种
    func requestCurrencyGroupCoin()->(PublishSubject<Any>) {
        self.coinGroups.removeAll()
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.currencytickers(reqModel: self.reqModel), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            
            self.coinGroups.removeAll()
            if model.count > 0 {
                for i in 0 ..< model.count {
                    let asModel = model[i]
                    asModel.atIndex = i
                    asModel.isFall = asModel.ratio_str.hasPrefix("-") ? true : false
                    self.coinGroups.append(asModel)
                }
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
            dataSubject.onNext(true)
            dataSubject.onCompleted()
        } failureCallback: { code, message in
            dataSubject.onError(NSError(domain: "", code: 0))
        }

        return dataSubject
    }
    
    
    //MARK: 获取自选
    func requestCurrencyLike()->(PublishSubject<Any>) {
        self.accountLike.removeAll()
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.accountlike, modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            self.accountLike.removeAll()
//            if model.count > 0 {
                for asModel in model {
                    asModel.isFall = asModel.ratio_str.hasPrefix("-") ? true : false
                    self.accountLike.append(asModel)
                }
//            } else {
//                dataSubject.onError(NSError(domain: "", code: 0))
//            }
            dataSubject.onNext(self.accountLike)
            dataSubject.onCompleted()
        } failureCallback: { code, message in
            dataSubject.onError(NSError(domain: "", code: 0))
        }

        return dataSubject
    }
    //MARK: 搜索币种
    func requestSearchCoin()->(PublishSubject<Any>) {
        self.searchs.removeAll()
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.searchticker(coin: search.uppercased()), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            if model.count > 0 {
                for asModel in model {
                    self.searchs.append(asModel)
                }
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: ticker24
    func requestTicker24(coin:String, currency: String)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.marketTicker24(coin: coin, currency: currency), modelType: Ticker24Model.self) { responseInfo in
            
            let resp = responseInfo as! Ticker24Model
            dataSubject.onNext(resp)
            dataSubject.onCompleted()
        }
        return dataSubject
    }
    //MARK: 新增自选(取消也一样)
    func requestAccountLikeAdd(reqModel : ReqCoinModel,completion: @escaping successRequestlback){
        HudManager.show()
        NetWorkRequest(GitHub.accountaddlike(reqModel: reqModel)) { responseInfo in
            HudManager.dismissHUD()
            completion()
        } failedWithCode: { msg, code in
            HudManager.dismissHUD()
            HudManager.showOnlyText(msg)
        }
    }
    
    //MARK: 编辑用户自选
    func requestAccountLikeEdit(id_list : Array<String>, completion: @escaping successRequestlback){
        HudManager.show()
        let ids_str = id_list.joined(separator: ",")
        let parameters = ["ids_str":ids_str] as [String : Any]
        NetWorkRequest(GitHub.accountEditlike(parameters: parameters)) { responseInfo in
            HudManager.dismissHUD()
//            HudManager.showOnlyText("保存成功")
            completion()
        } failedWithCode: { msg, code in
            HudManager.dismissHUD()
            HudManager.showOnlyText(msg)
        }
    }
    //MARK: 用户自选置顶
    func requestAccountLikemovetop(coin : String,currency : String, completion: @escaping successRequestlback){
            HudManager.show()
        let parameters = ["coin":coin,"currency":currency] as [String : Any]
            NetWorkRequest(GitHub.accountLikemovetop(parameters: parameters)) { responseInfo in
                HudManager.dismissHUD()
                completion()
            } failedWithCode: { msg, code in
                HudManager.dismissHUD()
                HudManager.showOnlyText(msg)
            }
    }
    //MARK: 新增自选(取消也一样)
    func requestAccountLike()->(PublishSubject<Any>) {
        self.searchs.removeAll()
        let dataSubject = PublishSubject<Any>()
        NetWorkProvider.request(.accountaddlike(reqModel: self.reqModel), completion: { result in
            if case .success(let response) = result {
                if [UInt8](response.data).count > 0{
                    let jsonDic = try! response.mapJSON() as! NSDictionary
                    let model = NetWorkStringModel.deserialize(from: jsonDic)
                    if model?.status == 1 {
                        dataSubject.onNext(true)
                        dataSubject.onCompleted()
                    } else{
                        dataSubject.onError(NSError(domain: "", code: 0))
                    }
                } else{
                    dataSubject.onError(NSError(domain: "", code: 0))
                }
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        })
        return dataSubject
    }
    //MARK: 新增自选(取消也一样)
    func reqUpdateAccountLike(reqM: ReqCoinModel)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkProvider.request(.accountaddlike(reqModel: reqM), completion: { result in
            if case .success(let response) = result {
                if [UInt8](response.data).count > 0{
                    let jsonDic = try! response.mapJSON() as! NSDictionary
                    let model = NetWorkStringModel.deserialize(from: jsonDic)
                    if model?.status == 1 {
                        dataSubject.onNext(true)
                        dataSubject.onCompleted()
                    } else{
                        dataSubject.onError(NSError(domain: "", code: 0))
                    }
                } else{
                    dataSubject.onError(NSError(domain: "", code: 0))
                }
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        })
        return dataSubject
    }
    //MARK: 获取kline
    func requestMarketKline()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        print("k线时间：\(self.reqModel.kline_type)")
        NetWorkProvider.request(.marketkline(reqModel: self.reqModel), completion: { [weak self] result in
            
            if case .success(let response) = result {
                if [UInt8](response.data).count > 0{
                    let jsonDic = try! response.mapJSON() as! NSDictionary
                    let model = NetWorkDictionaryModel<NetWorkStringListModel>.deserialize(from: jsonDic)
                    if model?.status == 1 {
                        let aModel = model!.data
                        self?.kLines = aModel?.data ?? []
                        if self!.kLines.count > 0{
                            let indexCalculate = IndexCalculation.shared
                            let ma5 = indexCalculate.ma5
                            let ma10 = indexCalculate.ma10
                            let ma30 = indexCalculate.ma30
                            
                            DispatchQueue.global().async{
                                
                                var temkLineList: [XLKLineModel] = Array()

                                for array in self!.kLines {
                                    let model = XLKLineModel()
                                    let asy = array as! Array<Any>
                                    model.time = TimeInterval(asy[0] as! String)!
                                    model.open = CGFloat(Double(asy[1] as! String)!)
                                    model.high = CGFloat(Double(asy[2] as! String)!)
                                    model.low = CGFloat(Double(asy[3] as! String)!)
                                    model.close = CGFloat(Double(asy[4] as! String)!)
                                    model.volumefrom = CGFloat(Double(asy[5] as! String)!)
//                                    self?.kLineList.append(model)
                                    temkLineList.append(model)
                                    
                                    //ma数据处理
                                    if(temkLineList.count >= ma5){
                                        let temFloats = self!.caculateTemplate(maN: ma5, xlkms: temkLineList)
                                        model.ma5 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                    }
                                    if(temkLineList.count >= ma10){
                                        let temFloats = self!.caculateTemplate(maN: ma10, xlkms: temkLineList)
                                        model.ma10 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                    }
                                    if(temkLineList.count >= ma30){
                                        let temFloats = self!.caculateTemplate(maN: ma30, xlkms: temkLineList)
                                        model.ma30 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                    }
                                }
                                //boll数据处理
                                if(temkLineList.count > indexCalculate.boll20){
                                    indexCalculate.bollCall(dataList: temkLineList)
                                }
                                //KDJ数据处理
                                if(temkLineList.count >= indexCalculate.kdj9){
                                    indexCalculate.kdjCal(dataList: temkLineList)
                                }
                                //MACD 数据处理
                                if(temkLineList.count > indexCalculate.macdSlow){
                                    indexCalculate.macdCal(dataList: temkLineList)
                                }
                                //RSI数据处理
                                if(temkLineList.count > indexCalculate.rsi6){
                                    indexCalculate.rsiCal(dataList: temkLineList)
                                }
                                DispatchQueue.main.async{
                                    
                                    self?.kLineList = temkLineList
                                    dataSubject.onNext(true)
                                    dataSubject.onCompleted()
                                }
                            }
                        } else{
                            dataSubject.onNext(false)
                            dataSubject.onCompleted()
                        }
                        
                    } else{
                        dataSubject.onNext(false)
                        dataSubject.onCompleted()
                    }
                } else {
                    dataSubject.onNext(false)
                    dataSubject.onCompleted()
                }
            }
        })
        return dataSubject
    }
    
    func requestMarketKline(reqM: ReqCoinModel)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkProvider.request(.marketkline(reqModel: reqM), completion: { [weak self] result in
            
            if case .success(let response) = result {
                if [UInt8](response.data).count > 0{
                    let jsonDic = try! response.mapJSON() as! NSDictionary
                    let model = NetWorkDictionaryModel<NetWorkStringListModel>.deserialize(from: jsonDic)
                    if model?.status == 1 {
                        let aModel = model!.data
                        self?.kLines = aModel?.data ?? []
                        if (self?.kLines.count ?? 0) > 0{
                            let indexCalculate = IndexCalculation.shared
                            let ma5 = indexCalculate.ma5
                            let ma10 = indexCalculate.ma10
                            let ma30 = indexCalculate.ma30
                            
                            DispatchQueue.global().async{
                                
                                var temkLineList: [XLKLineModel] = Array()

                                for array in self!.kLines {
                                    let model = XLKLineModel()
                                    let asy = array as! Array<Any>
                                    model.time = TimeInterval(asy[0] as! String)!
                                    model.open = CGFloat(Double(asy[1] as! String)!)
                                    model.high = CGFloat(Double(asy[2] as! String)!)
                                    model.low = CGFloat(Double(asy[3] as! String)!)
                                    model.close = CGFloat(Double(asy[4] as! String)!)
                                    model.volumefrom = CGFloat(Double(asy[5] as! String)!)
//                                    self?.kLineList.append(model)
                                    temkLineList.append(model)
                                    
                                    //ma数据处理
                                    if(temkLineList.count >= ma5){
                                        let temFloats = self!.caculateTemplate(maN: ma5, xlkms: temkLineList)
                                        model.ma5 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                    }
                                    if(temkLineList.count >= ma10){
                                        let temFloats = self!.caculateTemplate(maN: ma10, xlkms: temkLineList)
                                        model.ma10 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                    }
                                    if(temkLineList.count >= ma30){
                                        let temFloats = self!.caculateTemplate(maN: ma30, xlkms: temkLineList)
                                        model.ma30 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                    }
                                }
                                //boll数据处理
                                if(temkLineList.count > indexCalculate.boll20){
                                    indexCalculate.bollCall(dataList: temkLineList)
                                }
                                //KDJ数据处理
                                if(temkLineList.count >= indexCalculate.kdj9){
                                    indexCalculate.kdjCal(dataList: temkLineList)
                                }
                                //MACD 数据处理
                                if(temkLineList.count > indexCalculate.macdSlow){
                                    indexCalculate.macdCal(dataList: temkLineList)
                                }
                                //RSI数据处理
                                if(temkLineList.count > indexCalculate.rsi6){
                                    indexCalculate.rsiCal(dataList: temkLineList)
                                }
                                DispatchQueue.main.async{
                                    
                                    self?.kLineList = temkLineList
                                    dataSubject.onNext(true)
                                    dataSubject.onCompleted()
                                }
                            }
                        } else{
                            dataSubject.onNext(false)
                            dataSubject.onCompleted()
                        }
                        
                    } else{
                        dataSubject.onNext(false)
                        dataSubject.onCompleted()
                    }
                } else {
                    dataSubject.onNext(false)
                    dataSubject.onCompleted()
                }
            }
        })
        return dataSubject
    }
    
    //MARK: 获取最新成交
    func requestNewdeal()->(PublishSubject<Any>) {
        self.newdeals.removeAll()
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.newdeal(reqModel: self.reqModel), modelType: BuySellModel.self) { responseInfo in
            let asModel = responseInfo as! BuySellModel
            if asModel.data.count > 0 {
                self.newdeals = asModel.data
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    
    //MARK: 买卖5推送
    func websocketBuySell(){
        if socketBuySell != nil{
            socketBuySell.disconnect()
        }
        let wsString = String(Environment.current.wsUrl.absoluteString + "five" + self.reqModel.coin + "-" + self.reqModel.currency)
        let request = URLRequest(url: URL(string: wsString)!)
        socketBuySell = WebSocket(request: request)
        socketBuySell.write(ping: Data())
        socketBuySell.delegate = self
        socketBuySell.connect()
    }
    //MARK: 最新交易推送
    func websocketNewdeal(){
        if socketNewdeal != nil{
            socketNewdeal.disconnect()
        }
        let wsString = String(Environment.current.wsUrl.absoluteString + self.reqModel.coin + "-" + self.reqModel.currency)
        let request = URLRequest(url: URL(string: wsString)!)
        socketNewdeal = WebSocket(request: request)
        socketNewdeal.write(ping: Data())
        socketNewdeal.delegate = self
        socketNewdeal.connect()
    }
    func websocketNewdealClose(){
        if socketNewdeal != nil{
            socketNewdeal.disconnect()
            socketNewdeal = nil
        }
    }
    //MARK: k线推送
    func websocketKline(){
        if socketKline != nil{
            socketKline.disconnect()
        }
        let wsString = String(Environment.current.wsUrl.absoluteString + self.reqModel.coin + "-" + self.reqModel.currency + "-" + self.reqModel.kline_type)
        let request = URLRequest(url: URL(string: wsString)!)
        socketKline = WebSocket(request: request)
        socketKline.write(ping: Data())
        socketKline.delegate = self
        socketKline.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
       // print("链接地址：\(client.request.url?.absoluteString)")
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            do {
                isConnected = true
                let jsonData:Data = string.data(using: .utf8)!
                let array = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                let model = BuySellModel.deserialize(from:(array as! NSDictionary))
                if model != nil {
                    switch model!.type {
                    case 1: do {//k线数据
                        if self.kLineList.count > 0 {
                            
                            let indexCalculate = IndexCalculation.shared
                            let aModel = XLKLineModel()
                            let lModel = self.kLineList.last
                            let asy = model!.data[0] as! Array<Any>
                            aModel.time = TimeInterval(asy[0] as! String)!
                            aModel.open = CGFloat(Double(asy[1] as! String)!)
                            aModel.high = CGFloat(Double(asy[2] as! String)!)
                            aModel.low = CGFloat(Double(asy[3] as! String)!)
                            aModel.close = CGFloat(Double(asy[4] as! String)!)
                            aModel.volumefrom = CGFloat(Double(asy[5] as! String)!)
                            if ((aModel.time - lModel!.time) < 59) && self.reqModel.kline_type == "1m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 899) && self.reqModel.kline_type == "15m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 3600) && self.reqModel.kline_type == "1h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 14400) && self.reqModel.kline_type == "4h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 86400) && self.reqModel.kline_type == "1d" {
                                self.kLineList.removeLast()
                            }
                            
                            if ((aModel.time - lModel!.time) < 179) && self.reqModel.kline_type == "3m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 299) && self.reqModel.kline_type == "5m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 1799) && self.reqModel.kline_type == "30m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 7200) && self.reqModel.kline_type == "2h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 21600) && self.reqModel.kline_type == "6h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 28800) && self.reqModel.kline_type == "8h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 43200) && self.reqModel.kline_type == "12h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 259200) && self.reqModel.kline_type == "3d" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 604800) && self.reqModel.kline_type == "1w" { //一周
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 2592000) && self.reqModel.kline_type == "1M" { //一月
                                self.kLineList.removeLast()
                            }
                            
                            self.kLineList.append(aModel)
                            
                            
                            DispatchQueue.global().async{

                                //ma 数据处理
                                if(self.kLineList.count > indexCalculate.ma5){
                                    let temFloats = self.caculateTemplate(maN: indexCalculate.ma5, xlkms: self.kLineList)
                                    aModel.ma5 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                }
                                if(self.kLineList.count > indexCalculate.ma10){
                                    let temFloats = self.caculateTemplate(maN: indexCalculate.ma10, xlkms: self.kLineList)
                                    aModel.ma10 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                }
                                if(self.kLineList.count > indexCalculate.ma30){
                                    let temFloats = self.caculateTemplate(maN: indexCalculate.ma30, xlkms: self.kLineList)
                                    aModel.ma30 = CGFloat(indexCalculate.maWithN(mas: temFloats))
                                }
                                //boll 数据处理
                                if(self.kLineList.count > indexCalculate.boll20){
                                    indexCalculate.bollCall(dataList: self.kLineList)
                                }
                                //KDJ数据处理
                                if(self.kLineList.count >= indexCalculate.kdj9){
                                    indexCalculate.kdjCal(dataList: self.kLineList)
                                }
                                //RSI数据处理
                                if(self.kLineList.count > indexCalculate.rsi6){
                                    indexCalculate.rsiCal(dataList: self.kLineList)
                                }
                                //MACD 数据处理
                                if(self.kLineList.count > indexCalculate.macdSlow){
                                    indexCalculate.macdCal(dataList: self.kLineList)
                                }
                                DispatchQueue.main.async{
                                    self.kLineData.onNext("show")
                                }
                            }
                        }
                        
                    }
                    case 9:
                        self.buys = model!.data
                        self.originBuys = model!.data
                        self.fiveData.onNext((type:9 , num : model?.num ?? "0"))
                    case 11:
                        self.sells = model!.data
                        self.originSells = model!.data
                        self.fiveData.onNext((type:11 , num : model?.num ?? "0"))
                    case 2: do {//交易数据
                        if self.newdeals.count > 0 {
                            if((model?.data.count)! > 0){
                                self.newdeals.insert(model!.data[0], at: 0)
                                self.newdeals.removeLast()
                            }
                            self.newdealData.onNext("newdeals")
                        }
                    }
                    case 4: 
                        self.deal24Data.onNext(model!)
                    case 20: do { //行情数据
                        let datas = model!.data
                        if datas.count > 4 {
                            let pModel = PushCoinModel()
                            pModel.coin = datas[0] as! String
                            pModel.currency = datas[1] as! String
                            pModel.new_price = datas[3] as! String
                            pModel.ratio_str = (datas[4] as! String) + "%"
                            if pModel.ratio_str.hasPrefix("-"){
                                pModel.isFall = true
                            } else{
                                pModel.isFall = false
                                pModel.ratio_str = "+" + pModel.ratio_str
                            }
                            if self.accountLike.count > 0 {
                                for aModel in self.accountLike {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        return
                                    }
                                }
                            }
                            if self.coinGroups.count > 0 {
                                print("pmodel数据：\(datas)")
                                for aModel in self.coinGroups {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        return
                                    }
                                }
                            }
                            self.marketsData.onNext("show")
                        }
                        
                    }
                    default:
                        print("")
                    }
                }
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            print("ws error: \(error)")
            isConnected = false
        }
    }

    
    func caculateTemplate(maN: Int, xlkms: [XLKLineModel]) -> [CGFloat]{
        
        var temFloats: [CGFloat] = []
        if(xlkms.count < 1){
            return temFloats
        }
        
        var index = maN
        for _ in xlkms {
            if(index > 0){
                temFloats.append(CGFloat(xlkms[xlkms.count - index].close))
                index -= 1
            }else{
                break
            }
        }
        return temFloats
    }
    
    func invortBolDatas(xlkms: [XLKLineModel]) -> [Double]{
        
        var temDoubles: [Double] = []
        for xlkM in xlkms{
            temDoubles.append(xlkM.close)
        }
        return temDoubles
    }
    
    func invortKDJDatas(xlkms: [XLKLineModel]) -> [[String: String]]{
        
        var temKDJArr: [[String: String]] = []
        for xlkM in xlkms{
            let content = ["maxPrice":String(format: "%.5f", xlkM.high), "minPrice":String(format: "%.5f", xlkM.low), "closePrice":String(format: "%.5f", xlkM.close)]
            temKDJArr.append(content)
        }
        return temKDJArr
    }
    
    func invortRSIDatas(xlkms: [XLKLineModel]) -> [[String: String]]{
        
        var temRSIArr: [[String: String]] = []
        for xlkM in xlkms{
            let content = ["closePrice":String(format: "%.5f", xlkM.close), "openPrice":String(format: "%.5f", xlkM.open)]
            temRSIArr.append(content)
        }
        return temRSIArr
    }
    
    func invortMACDDatas(xlkms: [XLKLineModel]) -> [[String: String]]{
        
        var temMACDArr: [[String: String]] = []
        for xlkM in xlkms{
            let content = ["closePrice":String(format: "%.5f", xlkM.close)]
            temMACDArr.append(content)
        }
        return temMACDArr
    }
}


public extension String {
    var numberOfDecimal: Int {

        if self.toDouble() > 1 {
            
            return 0
        } else {
            
            let count = self.count - 2
           return  count
        }
    }

   
}
