//
//  HSSocketManager.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/12.
// TODO:1 K线计算抽取出去

import UIKit

class HSSocketManager: NSObject {

    let queue = Queuer(name: "HSSocketManagerQueue", maxConcurrentOperationCount: 1, qualityOfService: .default)
    var socketKline: WebSocket?
    /// 24h成交 + 最新成交
    var socketNewdeal: WebSocket?
    /// 买卖6档数据
    var socketBuySell: WebSocket?
    /// 行情-现货
    var hqActualsSocket: WebSocket?
    
    //买卖5推送
    var fiveData = PublishSubject<Any>()
    //最新成交for最新成交
    var newdealData = PublishSubject<Any>()
    //最新成交for24小时行情
    var deal24Data = PublishSubject<BuySellModel>()
    //k线数据推送
    var kLineData = PublishSubject<Any>()
    //k线数据
    var kLineList: [XLKLineModel] = Array()
    //最新成交
    var latestDeals = [Any]()
    //档位
    var gears = [Any]()
    var gear: String?
    
    var buys = [Any]()
    var sells = [Any]()
    var originBuys = [Any]()
    var originSells = [Any]()
    
    var isConnected:Bool = false
    private var kline_type = "15m"
    
    
    func hqSocketActuals(){
        
        if hqActualsSocket != nil{
            hqActualsSocket?.disconnect()
        }
        let wsString = String(Environment.current.wsUrl.absoluteString)
        let request = URLRequest(url: URL(string: wsString)!)
        hqActualsSocket = WebSocket(request: request)
        hqActualsSocket?.write(ping: Data())
        hqActualsSocket?.delegate = self
        hqActualsSocket?.connect()
        queue.pause()
    }
    
    func reqHQActuals(update: [String:Any]){
                
        let concurrentOperation = ConcurrentOperation {[weak self] _ in

            guard let data = try? JSONSerialization.data(withJSONObject: update, options: []) else { return }
            let jsonString:String = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)! as String
            guard let data = jsonString.data(using: String.Encoding.utf8) else { return }
            self?.hqActualsSocket?.write(data: data, completion: {})
        }
        queue.addOperation(concurrentOperation)
    }
    
    
    func websocketNewdeal(coin: String, currency: String){
        if socketNewdeal != nil{
            socketNewdeal?.disconnect()
        }
        let wsString = String(Environment.current.wsUrl.absoluteString + coin + "-" + currency)
        let request = URLRequest(url: URL(string: wsString)!)
        socketNewdeal = WebSocket(request: request)
        socketNewdeal?.write(ping: Data())
        socketNewdeal?.delegate = self
        socketNewdeal?.connect()
    }
    
    func websocketKline(coin: String, currency: String , kline_type: String){
        if socketKline != nil{
            socketKline?.disconnect()
        }
        self.kline_type = kline_type
        let wsString = String(Environment.current.wsUrl.absoluteString + coin + "-" + currency + "-" + kline_type)
        let request = URLRequest(url: URL(string: wsString)!)
        socketKline = WebSocket(request: request)
        socketKline?.write(ping: Data())
        socketKline?.delegate = self
        socketKline?.connect()
    }
    
    func websocketBuySell(coin: String, currency: String){
        if socketBuySell != nil{
            socketBuySell?.disconnect()
        }
        let wsString = String(Environment.current.wsUrl.absoluteString + "five" + coin + "-" + currency)
        let request = URLRequest(url: URL(string: wsString)!)
        socketBuySell = WebSocket(request: request)
        socketBuySell?.write(ping: Data())
        socketBuySell?.delegate = self
        socketBuySell?.connect()
    }
    
    func requestMarketKline(reqM: ReqCoinModel)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkProvider.request(.marketkline(reqModel: reqM), completion: { [weak self] result in
            
            if(self == nil){
                
                dataSubject.onNext(false)
                dataSubject.onCompleted()
                return
            }
            
            if case .success(let response) = result {
                if [UInt8](response.data).count > 0{
                    let jsonDic = try! response.mapJSON() as! NSDictionary
                    let model = NetWorkDictionaryModel<NetWorkStringListModel>.deserialize(from: jsonDic)
                    if model?.status == 1 {
                        let aModel = model!.data
                        let kLines = aModel?.data ?? []
                        if kLines.count > 0{
                            let indexCalculate = IndexCalculation.shared
                            let ma5 = indexCalculate.ma5
                            let ma10 = indexCalculate.ma10
                            let ma30 = indexCalculate.ma30
                            
                            DispatchQueue.global().async{
                                var temkLineList: [XLKLineModel] = Array()
                                for array in kLines {
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
    
    func requestCoinBuySelllist(reqM: ReqCoinModel)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.coinfivelist(reqModel: reqM), modelType: BuySellModel.self) {[weak self] responseInfo in
            let model = responseInfo as! Array<BuySellModel>
            if model.count > 0 {
                for asModel in model {
                    if asModel.type == 9{
                        
                        //TODO: 2 档位数据 特殊计算
                        if(self != nil){
                            self!.gears = asModel.gear["data"] as! [Any]
                            self!.buys = asModel.data
                            self!.originBuys = asModel.data
                        }
                    }
                    if asModel.type == 11{
                        if(self != nil){
                            self!.sells = asModel.data
                            self!.originSells = asModel.data
                        }
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
    
    func requestNewdeal(reqM: ReqCoinModel)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.newdeal(reqModel: reqM), modelType: BuySellModel.self) {[weak self] responseInfo in
            let asModel = responseInfo as! BuySellModel
            if asModel.data.count > 0 {
                self?.latestDeals = asModel.data
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
}

extension HSSocketManager: WebSocketDelegate{
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            queue.resume()
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
                            print("k线时间: " + (client.request.url?.absoluteString ?? "空") + (asy[6] as! String) + "时间END")
                            if ((aModel.time - lModel!.time) < 59) && self.kline_type == "1m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 899) && self.kline_type == "15m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 3600) && self.kline_type == "1h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 14400) && self.kline_type == "4h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 86400) && self.kline_type == "1d" {
                                self.kLineList.removeLast()
                            }
                            
                            if ((aModel.time - lModel!.time) < 179) && self.kline_type == "3m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 299) && self.kline_type == "5m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 1799) && self.kline_type == "30m" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 7200) && self.kline_type == "2h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 21600) && self.kline_type == "6h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 28800) && self.kline_type == "8h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 43200) && self.kline_type == "12h" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 259200) && self.kline_type == "3d" {
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 604800) && self.kline_type == "1w" { //一周
                                self.kLineList.removeLast()
                            }
                            if ((aModel.time - lModel!.time) < 2592000) && self.kline_type == "1M" { //一月
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
                    case 2: do {//最新交易数据
                        if self.latestDeals.count > 0 {
                            if((model?.data.count ?? 0) > 0){
                                self.latestDeals.insert(model!.data[0], at: 0)
                                self.latestDeals.removeLast()
                            }
                            self.newdealData.onNext("newdeals")
                        }
                    }
                    case 9: //TODO: 2 档位数据特殊处理
                        self.buys = model!.data
                        self.originBuys = model!.data
                        self.fiveData.onNext("type=9")
                    case 11:
                        self.sells = model!.data
                        self.originSells = model!.data
                        self.fiveData.onNext("type=11")
                    case 4:
                        self.deal24Data.onNext(model!)
                    case 20: do { //行情数据
                    }
                    default:
                        print("")
                    }
                }
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(let data):
            do{
                let pingContent = String(data: data ?? Data(), encoding: String.Encoding.utf8)
                if((pingContent?.contains(find: "type")) != nil){
                    print("ping包内容"+(pingContent ?? "空")+"")
                }
            }
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
}

extension HSSocketManager{
    
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
