//
//  HomeApi.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/6.
//

import Foundation
enum HomeApi {
    ///获取分类列表
    case getMessageCategory
    ///获取列表
    case getMessageList(model : MessageRequestModel)
    ///设置全部已读
    case getMessageAllread(parameters:[String:Any])
    ///获取详情
    case getMessageDetail(parameters:[String:Any])
    ///获取所有未读的数量
    case getMessageUnread
}
extension HomeApi:TargetType{
    var baseURL: URL {
        return Environment.current.baseUrl
    }
    
    var path: String {
        switch self {
        case .getMessageCategory:
            return "message/category/list"
        case .getMessageList:
            return "message/list"
        case .getMessageAllread:
            return "message/allread"
        case .getMessageDetail:
            return "message/details"
        case .getMessageUnread:
            return "message/unread"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getMessageCategory,.getMessageUnread:
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
        case let .getMessageList(model: model):
            let json : [String : Any] = model.toJSON()!
            return .requestParameters(parameters: json, encoding: MoyaJsonArrayEncoding.default)
        case let .getMessageAllread(parameters: parameters),let .getMessageDetail(parameters: parameters):
            return .requestParameters(parameters: parameters, encoding: MoyaJsonArrayEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}
