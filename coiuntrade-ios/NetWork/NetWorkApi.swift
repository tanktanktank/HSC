//
//  NetWorkApi.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/21.
//

import Foundation

private func JSONResponseDataFormatter(_ data: Data) -> String {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
    let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return String(data: prettyData, encoding: .utf8) ?? ""
  } catch {
    if JSONSerialization.isValidJSONObject(data) {
        return String(data: data, encoding: .utf8) ?? ""
    }
    return ""
  }
}

let configuration = NetworkLoggerPlugin.Configuration(
    formatter: NetworkLoggerPlugin.Configuration.Formatter(
        requestData: JSONResponseDataFormatter,
        responseData: JSONResponseDataFormatter
    ),
    logOptions: .verbose
)
let NetWorkProvider = MoyaProvider<GitHub>(plugins: [NetworkLoggerPlugin(configuration: configuration)])

// MARK: - Provider support
private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

public enum GitHub {
    //MARK: 首页
    //获取滚动图片
    case banner
    //获取热门币种
    case traderanklist
    //搜索币种
    case searchticker(coin:String)
    //获取首页公告
    case noticelist(reqModel:Any)
    //获取排行榜
    case getsymbollist(getType:Int)
    //获取所有币种（币对列表）
    case allcoin
    
    //MARK: 行情
    //获取单个交易对
    case cointicker(reqModel:Any)
    //获取买卖5订单
    case coinfivelist(reqModel:Any)
    //获取所有交易区
    case currencygroup
    //获取单个交易区所有币种
    case currencytickers(reqModel:Any)
    //获取最新成交
    case newdeal(reqModel:Any)
    //获取获取kline
    case marketkline(reqModel:Any)
    //获取币详情 头部 24小时数据
    case marketTicker24(coin:String, currency: String)
    
    //MARK: 用户
    //获取用户自选
    case accountlike
    //新增自选(取消也一样)
    case accountaddlike(reqModel:Any)
    //编辑用户自选
    case accountEditlike(parameters : [String:Any])
    //用户自选置顶
    case accountLikemovetop(parameters : [String:Any])
    //获取用户资产
    case accountallbalance(reqModel:Any)
    //获取币对可用资产
    case symbolAsset(reqModel:Any)

    //MARK: 交易
    //下单(买卖)
    case tradeorder(reqModel:Any)
    //获取汇率
    case marketrate
    //获取所有委托订单
    case orderspending(reqModel:Any)
    //撤单
    case cancelorder(orderno:String)
    //批量撤单
    case cancelbatchorders
    ///获取单个订单
    case getorderDetail(order_no:String)
    //获取历史订单列表
    case getHistoryOrders(reqModel:Any)
}

extension GitHub: TargetType {
    
    public var baseURL: URL {
        //MARK: 拼接参数
        switch self {
        case let .noticelist(reqModel):
            return showUrl(reqModel: reqModel, reqType:1)!
        case let .cointicker(reqModel):
            return showUrl(reqModel: reqModel, reqType:2)!
        case let .coinfivelist(reqModel):
            return showUrl(reqModel: reqModel, reqType:3)!
        case let .currencytickers(reqModel):
            return showUrl(reqModel: reqModel, reqType:4)!
        case let .newdeal(reqModel):
            return showUrl(reqModel: reqModel, reqType:5)!
        case let .accountallbalance(reqModel):
            return showUrl(reqModel: reqModel, reqType:6)!
        case let .marketkline(reqModel):
            return showUrl(reqModel: reqModel, reqType:7)!
        case let .orderspending(reqModel):
            return showUrl(reqModel: reqModel, reqType:8)!
        case let .symbolAsset(reqModel):
            return showUrl(reqModel: reqModel, reqType:9)!
        case let .getHistoryOrders(reqModel):
            return showUrl(reqModel: reqModel, reqType:10)!
        case let .getsymbollist(getType):
            return URL(string: Environment.current.baseUrl.absoluteString + "home/getsymbollist?get_type=" + String(getType))!
        default:
            return Environment.current.baseUrl
        }
    }
    public var path: String {
        switch self {
        case .banner:
            return "home/banner"
        case .traderanklist:
            return "home/traderanklist"
        case .searchticker:
            return "home/searchticker"
        case .currencygroup:
            return "market/currencygroup"
        case .accountlike,.accountaddlike:
            return "account/like"
        case .accountEditlike:
            return "account/updatelike"
        case .accountLikemovetop:
            return "account/likemovetop"
        case .tradeorder:
            return "trade/order"
        case .marketrate:
            return "market/rate"
        case .cancelorder:
            return "trade/cancelorder"
        case .cancelbatchorders:
            return "trade/cancelbatchorders"
        case .allcoin:
            return "market/tickers"
        case .marketTicker24(let coin, let currency):
            return "market/ticker?coin=\(coin)&currency=\(currency)"
        case .getorderDetail(let order_no):
            return "trade/order?order_no=\(order_no)"
        default:
            return ""
        }
    }
  public var method: Moya.Method {
      switch self {
      case .searchticker,.accountaddlike,.tradeorder,.cancelorder,.cancelbatchorders,.accountEditlike,.accountLikemovetop:
          return .post
      default:
          return .get
      }
  }
    public var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    public var task: Task {
        switch self {
        case let .searchticker(coin):
            return .requestData(jsonToData(jsonDic: ["coin":coin])!)
        case let .accountaddlike(reqModel):
            let model = reqModel as! ReqCoinModel
            return .requestData(jsonToData(jsonDic: model.toJSON()!)!)
        case let .tradeorder(reqModel):
            let model = reqModel as! ReqTradeModel
            return .requestData(jsonToData(jsonDic: model.toJSON()!)!)
        case let .cancelorder(orderno):
            return .requestData(jsonToData(jsonDic: ["order_no":orderno])!)
        case let.accountEditlike(parameters),let.accountLikemovetop(parameters):
            return .requestParameters(parameters: parameters, encoding: MoyaJsonArrayEncoding.default)
        default:
            return Task.requestPlain
        }
    }
  public var headers: [String : String]? {
      return ["Content-type" : "application/json",
              "country":"CN",
              "brand":UIDevice.current.systemName,
              "model":UIDevice.current.model,
              "version":UIDevice.current.systemVersion,
              "token":Archive.getToken(),
              "erate":"usdt_cny"] //汇率
  }
    public var sampleData: Data {
        switch self {
        default:
            return "json.".data(using: String.Encoding.utf8)!
        }
    }
     
}

public func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        return nil
    }
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    let str = String(data:data!, encoding: String.Encoding.utf8)
    print("请求数据:\(str!)")
    return data
}

public func showUrl(reqModel:Any, reqType:Int) -> URL? {
    var toJson = [String: Any]()
    var requestUrl:String = ""
    switch reqType {
    case 1:
        requestUrl = "notice/list?"
        toJson = (reqModel as! ReqNoticeModel).toJSON()!
    case 2:
        requestUrl = "market/ticker?"
        toJson = (reqModel as! ReqCoinModel).toJSON()!
    case 3:
        requestUrl = "market/fivelist?"
        toJson = (reqModel as! ReqCoinModel).toJSON()!
    case 4:
        requestUrl = "market/currencytickers?"
        toJson = (reqModel as! ReqCoinModel).toJSON()!
    case 5:
        requestUrl = "market/newdeal?"
        toJson = (reqModel as! ReqCoinModel).toJSON()!
    case 6:
        requestUrl = "account/getcoinasset?"
        toJson = (reqModel as! ReqAssetModel).toJSON()!
    case 7:
        requestUrl = "market/kline?"
        toJson = (reqModel as! ReqCoinModel).toJSON()!
    case 8:
        requestUrl = "trade/orders?"
        toJson = (reqModel as! ReqOrdersModel).toJSON()!
    case 9:
        requestUrl = "account/getsymbolasset?"
        toJson = (reqModel as! ReqSymbolAssetModel).toJSON()!
    case 10:
        requestUrl = "trade/GetHistoryOrders?"
        toJson = (reqModel as! ReqOrdersModel).toJSON()!
    default:
        print("null")
    }
    let array = toJson.sorted{ (t1, t2) -> Bool in
        return t1.0 < t2.0
    }
    let keyString = array.map{ (k:String,v:Any) -> String in
//        if is_Blank(ref: v! as! String) == true {
//            return ""
//        } else{
//
//        }
        return String(format:"%@=%@",k,String(describing: v))
    }
    return URL(string: Environment.current.baseUrl.absoluteString + requestUrl + keyString.joined(separator:"&"))
    
}

