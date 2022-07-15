//
//  WalletApi.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/13.
//

import Foundation

enum WalletApi {
    ///获取现货资产总览
    case accountSpotcointotal
    ///获取用户所有币种资产
    case accountallbalance
    ///获取提币记录
    case getOutrecord(coin : String , start_time : String , end_time : String, page : Int, page_size : Int)
    ///获取提币记录
    case getRechargerecord(coin : String , start_time : String , end_time : String, page : Int, page_size : Int)
    ///获取币交易对
    case getCoinTradeSet(coin : String)
}
extension WalletApi:TargetType{
    var baseURL: URL {
        return Environment.current.baseUrl
    }
    
    var path: String {
        switch self {
        case .accountSpotcointotal:
            return "account/spotcointotal"
        case .accountallbalance:
            return "account/getcoinasset"
        case .getOutrecord(let coin, let start_time, let end_time, let page, let page_size):
            return "account/outrecord?coin=\(coin)&start_time=\(start_time)&end_time=\(end_time)&page=\(page)&page_size=\(page_size)"
        case .getRechargerecord(let coin, let start_time, let end_time, let page, let page_size):
            return "account/rechargerecord?coin=\(coin)&start_time=\(start_time)&end_time=\(end_time)&page=\(page)&page_size=\(page_size)"
        case .getCoinTradeSet(let coin):
            return "account/getCoinTradeSet?coin=\(coin)"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .accountSpotcointotal,.accountallbalance,.getOutrecord,.getRechargerecord,.getCoinTradeSet:
            return .get
        default:
            return .post
        }
    }
        //    这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        
        switch self {
            
       
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}
