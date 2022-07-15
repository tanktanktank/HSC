//
//  HomeViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/19.
//

import Foundation

enum SearchCoinType : Int{
    case Ups = 1
    case Downs = 2
    case Hots = 3
    case Mstream = 4
    case Maxs = 5
    case Search = 6
    //1 涨幅, 2跌幅, 3热度, 4主流, 5交易量, 6搜索
}

class HomeViewModel: NSObject, WebSocketDelegate{
    
    var search:String = ""
    var hots : [CoinModel] = Array()
    var searchs : [CoinModel] = Array()
    var historys : [RealmCoin] = Array()
    var mainstreamlist: [CoinModel] = Array()
    var allHots : [CoinModel] = Array() //获取列表热门
    var allUps : [CoinModel] = Array() //获取列表热门
    var allDowns : [CoinModel] = Array() //获取列表热门
    var allMaxs : [CoinModel] = Array() //获取列表热门
    var listType : SearchCoinType = .Hots
    var reqList:Bool = false //是否请求列表
    var isConnected:Bool = false
    var homeSocket: WebSocket!
    private var disposeBag = DisposeBag()
    var homeData = PublishSubject<NSArray>() //首页数据推送
    var notices:[NoticeShowModel] = Array()
    
    var messageList:[MessageModel] = Array()//站内信列表
    var reqModel = MessageRequestModel()
    //MARK: 站内信设置全部已读
    func requestMessageClearUnread(category_id:Int)->(PublishSubject<String>) {
        let dataSubject = PublishSubject<String>()
        let param = ["category_id" : category_id] as [String : Any]
        NetWorkRequest(HomeApi.getMessageAllread(parameters: param), modelType: MessageUpdateNum.self) { responseInfo in
            let model = responseInfo as! MessageUpdateNum
            dataSubject.onNext(model.update_num)
            dataSubject.onCompleted()
        } failureCallback: { code, message in
            dataSubject.onError(NSError(domain: "", code: 0))
            HudManager.dismissHUD()
            HudManager.showError(message)
        }

        return dataSubject
    }
    //MARK: 站内信分类列表
    func requestMessageCategory()->(PublishSubject<NSArray>) {
        let dataSubject = PublishSubject<NSArray>()
        NetWorkRequest(HomeApi.getMessageCategory, modelType: MassageCategoryModel.self) { responseInfo in
            let model = responseInfo as! Array<MassageCategoryModel>
            if model.count > 0 {
                dataSubject.onNext(model as PublishSubject<NSArray>.Element)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 获取站内信未读数
    func requestMessageUnread()->(PublishSubject<String>) {
        let dataSubject = PublishSubject<String>()
        NetWorkRequest(HomeApi.getMessageUnread, modelType: MessageCount.self) { responseInfo in
            let model = responseInfo as! MessageCount
            dataSubject.onNext(model.count)
            dataSubject.onCompleted()
        } failureCallback: { code, message in
            dataSubject.onError(NSError(domain: message, code: code))
            HudManager.dismissHUD()
            HudManager.showError(message)
        }

        return dataSubject
    }
    //MARK: 站内信列表
    func requestMessageList(page_index : Int,category_id : Int,is_read :Int = 0)->(PublishSubject<MessageData>) {
        let dataSubject = PublishSubject<MessageData>()
        self.reqModel.page_index = page_index
        self.reqModel.category_id = category_id
        self.reqModel.is_read = is_read
        NetWorkRequest(HomeApi.getMessageList(model: self.reqModel), modelType: MessageData.self) { responseInfo in
            let model = responseInfo as! MessageData
            
            if model != nil {
                dataSubject.onNext(model as PublishSubject<MessageData>.Element)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 站内信获取详情
    func requestMessageDetail(id : Int,type : Int)->(PublishSubject<MessageModel>) {
        let dataSubject = PublishSubject<MessageModel>()
        let param = ["id" : id,"type":type] as [String : Any]
        NetWorkRequest(HomeApi.getMessageDetail(parameters: param), modelType: MessageModel.self) { responseInfo in
            let model = responseInfo as! MessageModel
            
            if model != nil {
                dataSubject.onNext(model as PublishSubject<MessageModel>.Element)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 获取广告数据
    func requestBanner()->(PublishSubject<NSArray>) {
        let dataSubject = PublishSubject<NSArray>()
        NetWorkRequest(GitHub.banner, modelType: BannerModel.self) { responseInfo in
            let model = responseInfo as! Array<BannerModel>
            if model.count > 0 {
                dataSubject.onNext(model as PublishSubject<NSArray>.Element)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    
    //MARK: 获取公告
    func requestAnnouncement()->(PublishSubject<NSArray>) {
        let dataSubject = PublishSubject<NSArray>()
        let reqModel = ReqNoticeModel()
        reqModel.page_size = 10
        reqModel.page_index = 1
        reqModel.category_id = 1
        NetWorkRequest(GitHub.noticelist(reqModel: reqModel), modelType: NoticeModel.self) { responseInfo in
            let dataModel = responseInfo as! NoticeModel
            if dataModel.data_list.count > 0 {
                self.notices.removeAll()
                self.notices = dataModel.data_list
                dataSubject.onNext(dataModel.data_list as PublishSubject<NSArray>.Element)
                dataSubject.onCompleted()
            } else{
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 获取主流行情
    func requestMainstreamlist()->(PublishSubject<Bool>) {
        let dataSubject = PublishSubject<Bool>()
        NetWorkRequest(GitHub.getsymbollist(getType: 4), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            if model.count > 0 {
                self.mainstreamlist.removeAll()
                for asModel in model {
                    if asModel.ratio_str.hasPrefix("-"){
                        asModel.isFall = true
                    }
                    self.mainstreamlist.append(asModel)
                }
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else{
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 滚动热门币种
    func requestHeadHotSearch()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        self.hots.removeAll()
        NetWorkRequest(GitHub.getsymbollist(getType: 3), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            if model.count > 0 {
                for asModel in model {
                    asModel.isFall = asModel.ratio_str.hasPrefix("-") ? true : false
                    self.hots.append(asModel)
                }
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else{
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    //MARK: 热门币种
    func requestHotSearch()->(PublishSubject<Any>) {
        let dataSubject = PublishSubject<Any>()
        NetWorkRequest(GitHub.getsymbollist(getType: self.listType.rawValue), modelType: CoinModel.self) { responseInfo in
            let model = responseInfo as! Array<CoinModel>
            if model.count > 0 {
                switch self.listType {
                case .Hots:
                    self.allHots.removeAll()
                case .Ups:
                    self.allUps.removeAll()
                case .Downs:
                    self.allDowns.removeAll()
                case .Maxs:
                    self.allMaxs.removeAll()
                case .Search:
                    self.searchs.removeAll()
                default:
                    break
                }
                for asModel in model {
                    asModel.isFall = asModel.ratio_str.hasPrefix("-") ? true : false
                    if self.listType == .Hots {
                        self.allHots.append(asModel)
                    }else if self.listType == .Ups {
                        self.allUps.append(asModel)
                    }else if self.listType == .Downs {
                        self.allDowns.append(asModel)
                    }else if self.listType == .Maxs {
                        self.allMaxs.append(asModel)
                    }else if self.listType == .Search {
                        self.searchs.append(asModel)
                    }else{
                    }
                }
                dataSubject.onNext(true)
                dataSubject.onCompleted()
            } else{
                dataSubject.onError(NSError(domain: "", code: 0))
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
            if model.count > 0 {
                self.searchs.removeAll()
                for asModel in model {
                    self.searchs.append(asModel)
                }
                dataSubject.onNext("")
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(NSError(domain: "", code: 0))
            }
        }
        return dataSubject
    }
    
    //MARK: 获取历史记录
    func requestHistoryCoin()->(PublishSubject<Int>) {
        let dataSubject = PublishSubject<Int>()
        //MARK: 查询
        let results = RealmHelper.queryModel(model: RealmCoin())
        if results.count > 0 {
            for i in (0...results.count-1).reversed(){
                print(i)
                if (results.count-1 - i) < 8 {
                    let model : RealmCoin = results[i] as! RealmCoin
                    self.historys.append(model)
                }
            }
            dataSubject.onNext(self.historys.count)
            dataSubject.onCompleted()
        } else{
            dataSubject.onError(NSError(domain: "", code: 0))
        }
        return dataSubject
    }
    
    //MARK: 币种数据推送
    func websocketAllpush()->(PublishSubject<Any>) {
        if homeSocket != nil{
            homeSocket.disconnect()
        }
        let dataSubject = PublishSubject<Any>()
        let wsString = String(Environment.current.wsUrl.absoluteString + "allpush")
        let request = URLRequest(url: URL(string: wsString)!)
        homeSocket = WebSocket(request: request)
        homeSocket.write(ping: Data())
        homeSocket.delegate = self
        homeSocket.connect()
        dataSubject.onNext(true)
        dataSubject.onCompleted()
        return dataSubject
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        //print("链接地址：\(client.request.url?.absoluteString)")
        switch event {
        case .text(let string):
            do {
                isConnected = true
                let jsonData:Data = string.data(using: .utf8)!
                let array = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                let model = BuySellModel.deserialize(from:(array as! NSDictionary))
                if model != nil {
                    if model?.type == 20 {
                        let datas = model!.data
                        //print("推送数据:\(datas)")
                        if datas.count > 4 {
                            let pModel = PushCoinModel()
                            pModel.coin = datas[0] as! String
                            pModel.currency = datas[1] as! String
                            pModel.new_price = datas[3] as! String
                            pModel.ratio_str = (datas[4] as! String)
                            if pModel.ratio_str.hasPrefix("-"){
                                pModel.isFall = true
                            } else{
                                pModel.isFall = false
                                pModel.ratio_str = "+" + pModel.ratio_str
                            }
                            WSCoinPushSing.sharedInstance().tradeDatas.onNext(pModel)
                            if self.allHots.count > 0 {
                                for aModel in self.allHots {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        break
                                    }
                                }
                            }
                            if self.allUps.count > 0 {
                                for aModel in self.allUps {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        break
                                    }
                                }
                            }
                            if self.allDowns.count > 0 {
                                for aModel in self.allDowns {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        break
                                    }
                                }
                            }
                            if self.allMaxs.count > 0 {
                                for aModel in self.allMaxs {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        break
                                    }
                                }
                            }
                            if self.mainstreamlist.count > 0 {
                                for aModel in self.mainstreamlist {
                                    if aModel.coin ==  pModel.coin
                                        && aModel.currency == pModel.currency {
                                        aModel.isFall = pModel.isFall
                                        aModel.new_price = pModel.coin
                                        aModel.currency = pModel.currency
                                        aModel.new_price = pModel.new_price
                                        aModel.ratio_str = pModel.ratio_str
                                        break
                                    }
                                }
                                WSCoinPushSing.sharedInstance().datas.onNext(pModel)
                            }
                            
                        }
                    }
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
        case .error(_):
            isConnected = false
        case .connected(_):
            break
        case .disconnected(_, _):
            break
        case .binary(_):
            break
        case .ping(_):
            break
        }
    }
}


