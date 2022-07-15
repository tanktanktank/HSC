//
//  EntrustViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit
import Starscream

protocol EntrustRequestDelegate: NSObjectProtocol{
    /// 获取获取历史成交订单成功回调
    func getMakeEntrustListSuccess()
    /// 获取获取历史委托订单成功回调
    func getHistoryEntrustSuccess()
    /// 获取获取所有订单成功回调
    func getAllEntrustListSuccess()
    /// 撤单成功回调
    func cancelorderSuccess()
    /// 全部撤单成功回调
    func cancelAllOrderSuccess()
    /// 获取列表数据失败回调
    func getListFailure()
}
extension EntrustRequestDelegate{
    func getAllEntrustListSuccess(){}
    func getMakeEntrustListSuccess(){}
    func getHistoryEntrustSuccess(){}
    func cancelorderSuccess(){}
    func cancelAllOrderSuccess(){}
    func getListFailure(){}
}
class EntrustViewModel: NSObject {
    
    weak var delegate: EntrustRequestDelegate?
    var search:String = ""
    var orderno:String = "" //委托订单
    var allEntrust : [EntrustModel] = Array()
    var makeEntrust : [EntrustModel] = Array()
    var historyEntrust : [EntrustModel] = Array()
    var reqModel = ReqOrdersModel() // 请求内容
    var socketUser: WebSocket!
    var isConnected:Bool = false
    var personData = PublishSubject<Any>() //个人信息数据推送
    var allEntrustPublish = PublishSubject<Any>() // 数据推送

    var detailModel = EntrustModel() // 请求内容
    private var disposeBag = DisposeBag()
    
    //MARK: 获取所有订单,添加时间、币种条件
    func requestEntrust(get_type : Int, page : Int, startTime: Int, endTime: Int, symbol: String,buy_type:Int,time_info:String){
        
        self.reqModel.start_time = startTime
        self.reqModel.end_time = endTime
        self.reqModel.symbol = symbol
        self.reqModel.buy_type = buy_type
        self.reqModel.time_info = time_info
//        if get_type == -1 && page == 1 {
//            self.historyEntrust.removeAll()
//        }
//        if get_type == 0 && page == 1 {
//            self.historyEntrust.removeAll()
//        }
        
        requestEntrust(get_type: get_type, page: page)
    }
    //MARK: 历史成交
    func requestHistoryOrders(get_type : Int, page : Int){
        self.reqModel.page = page
        self.reqModel.get_type = get_type
        NetWorkRequest(GitHub.getHistoryOrders(reqModel: self.reqModel), modelType: EntrustModel.self) { responseInfo in
            let model = responseInfo as! Array<EntrustModel>
            if model.count > 0 {
                if self.reqModel.page == 1 {
                    self.makeEntrust.removeAll()
                }
                for aModel in model {
                    self.makeEntrust.append(aModel)
                }
                self.delegate?.getMakeEntrustListSuccess()
            }else{
                
                self.delegate?.getListFailure()
            }
        } failureCallback: { code, message in
            self.delegate?.getListFailure()
        }

    }
    //MARK: 获取所有订单
    func requestEntrust(get_type : Int, page : Int){
        self.reqModel.page = page
        self.reqModel.get_type = get_type
        if self.reqModel.get_type == -1 &&  self.reqModel.page == 1{
            self.historyEntrust.removeAll()
        }
        if self.reqModel.get_type == 0 && (self.reqModel.page == 1 ){
            self.allEntrust.removeAll()
        }
        if self.reqModel.get_type == 1 &&  self.reqModel.page == 1{
            self.makeEntrust.removeAll()
        }
        //http://8.218.110.85/api/trade/orders?end_time=0&get_type=-1&page=0&page_size=10&start_time=0 
        NetWorkRequest(GitHub.orderspending(reqModel: self.reqModel), modelType: EntrustModel.self) { responseInfo in
            let model = responseInfo as! Array<EntrustModel>
            if model.count > 0 {
                switch self.reqModel.get_type {
                case -1:
                    for aModel in model {
                        self.historyEntrust.append(aModel)
                    }
                    self.delegate?.getHistoryEntrustSuccess()
                case 1:
                    for aModel in model {
                        self.makeEntrust.append(aModel)
                    }
                    self.delegate?.getMakeEntrustListSuccess()
                default:
                    
                    if page == 0 {
                        
                        self.allEntrust.removeAll()
                        for aModel in model {
                            self.allEntrust.append(aModel)
                        }

                        self.allEntrustPublish.onNext(true)

                    }else{
                     
                        for aModel in model {
                            self.allEntrust.append(aModel)
                        }
                        self.delegate?.getAllEntrustListSuccess()
                    }
                    
                }
            }else{
                
                if page == 0 {
                    
                    self.allEntrust.removeAll()
                    self.allEntrustPublish.onNext(true)
                }

//                switch self.reqModel.get_type {
//                case -1:do {
//                    self.historyEntrust.removeAll()
//                }
//                case 1:do {
//                    
//                }
//                default:do {
//                    if self.reqModel.page == 1 {
//                        self.allEntrust.removeAll()
//                    }
//                }
//                }
                self.delegate?.getListFailure()
            }
        } failureCallback: { code, message in
            self.delegate?.getListFailure()
        }

    }
    //MARK: 获取单个订单
    func requestOrderDetail(order_no : String)->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.getorderDetail(order_no: order_no), modelType: EntrustModel.self) { responseInfo in
            self.detailModel = responseInfo as! EntrustModel
            dataSubject.onNext(self.detailModel)
            dataSubject.onCompleted()
        }
        return dataSubject
    }
    //MARK: 获取历史委托订单(包含取消)
    func requestHistoryEntrust()->(PublishSubject<Any>) {
        self.reqModel.page = 1
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.orderspending(reqModel: self.reqModel), modelType: EntrustModel.self) { responseInfo in
            let model = responseInfo as! Array<EntrustModel>
            if model.count > 0 {
                switch self.reqModel.get_type {
                case -1:
                    self.historyEntrust.removeAll()
                    for aModel in model {
                        self.historyEntrust.append(aModel)
                    }
                case 1:
                    self.makeEntrust.removeAll()
                    for aModel in model {
                        self.makeEntrust.append(aModel)
                    }
                default:
                    self.allEntrust.removeAll()
                    for aModel in model {
                        self.allEntrust.append(aModel)
                    }
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
    func moreHistoryEntrust()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        self.reqModel.page += 1
        NetWorkRequest(GitHub.orderspending(reqModel: self.reqModel), modelType: EntrustModel.self) { responseInfo in
            let model = responseInfo as! Array<EntrustModel>
            if model.count > 0 {
                switch self.reqModel.get_type {
                case -1:
                    for aModel in model {
                        self.historyEntrust.append(aModel)
                    }
                case 1:
                    for aModel in model {
                        self.makeEntrust.append(aModel)
                    }
                default:
                    for aModel in model {
                        self.allEntrust.append(aModel)
                    }
                }
                if model.count == self.reqModel.page_size {
                    dataSubject.onNext(true)
                    dataSubject.onCompleted()
                } else{
                    dataSubject.onNext(false)
                    dataSubject.onCompleted()
                }
            }
        }
        return dataSubject
    }
    //MARK: 撤单
    func requestCancelOrder(orderno : String){
        HudManager.show()
        NetWorkRequest(GitHub.cancelorder(orderno: orderno)) { responseInfo in
            self.delegate?.cancelorderSuccess()
        } failedWithCode: { msg, code in
            HudManager.showOnlyText(msg)
        }

    }
    //MARK: 撤单
    func requestCancelorder()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkProvider.request(.cancelorder(orderno: self.orderno), completion: { result in
            if case .success(let response) = result {
                if response.data.count > 0 {
                    let jsonDic = try! response.mapJSON() as! NSDictionary
                    let model = NetWorkStringModel.deserialize(from: jsonDic)
                    if model!.status == 1 {
                        dataSubject.onNext(true)
                        dataSubject.onCompleted()
                    } else{
                        dataSubject.onError(error(NSLocalizedString(model!.msg, comment: "")))
                    }
                } else {
                    dataSubject.onError(NSError(domain: "", code: 0))
                }
            }
        })
        return dataSubject
    }
    //MARK: 批量撤单
    func requestCancelAllorders(){
        if self.allEntrust.count <= 0 {
            HudManager.showOnlyText("当前没有撤销订单")
        }else{
            HudManager.show()
            NetWorkRequest(GitHub.cancelbatchorders) { responseInfo in
                self.delegate?.cancelAllOrderSuccess()
            } failedWithCode: { msg, code in
                HudManager.showError(msg)
            }

        }
    }
    //MARK: 批量撤单
    func requestCancelbatchorders()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        if self.allEntrust.count <= 0 {
            //翻译
            dataSubject.onError(error(NSLocalizedString("当前没有撤销订单", comment: "")))
        } else {
            NetWorkProvider.request(.cancelbatchorders, completion: { result in
                if case .success(let response) = result {
                    if response.data.count > 0 {
                        let jsonDic = try! response.mapJSON() as! NSDictionary
                        let model = NetWorkStringModel.deserialize(from: jsonDic)
                        if model!.status == 1 {
                            dataSubject.onNext(true)
                            dataSubject.onCompleted()
                        } else{
                            dataSubject.onError(error(NSLocalizedString(model!.msg, comment: "")))
                        }
                    } else {
                        dataSubject.onError(NSError(domain: "", code: 0))
                    }
                }
            })
        }
        return dataSubject
    }

    
    //MARK: k线推送
    func websocketUser(){
        if socketUser != nil{
            socketUser.disconnect()
        }
        let userId = "user-" + (userManager.infoModel?.user_id ?? "")
        let wsString = String(Environment.current.wsUrl.absoluteString + userId)
        let request = URLRequest(url: URL(string: wsString)!)
//        let token  = Archive.getToken()

//        request.setValue(token, forHTTPHeaderField: "token")
        
        socketUser = WebSocket(request: request)
        socketUser.write(ping: Data())
        socketUser.delegate = self
        socketUser.connect()
    }

}

extension EntrustViewModel : WebSocketDelegate {
    
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
                let dict = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                
//                let model = BuySellModel.deserialize(from:(array as! NSDictionary))
                if dict != nil {

                    let theDict = dict as! Dictionary<String , Any>
                    
                    if let type =  theDict["type"] as? Int, type == 13{
                        
                        personData.onNext("")
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
            print("ws error: \(String(describing: error))")
            isConnected = false
        }
    }


    
}
