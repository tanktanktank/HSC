//
//  InfoApi.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/6.
//

import Foundation

enum InfoApi {
    ///获取用户信息
    case getUserInfo
    ///获取内置头像列表
    case getHeadImage
    ///获取汇率列表
    case getMarketRate
    ///设置目前用户使用的汇率(基础货币)
    case userRatecountry(parameters:[String:Any])
    ///获取目前用户使用的汇率(基础货币)
    case getuserRatecountry
    ///更新用户信息
    case userUpdate(parameters:[String:Any])
    ///身份验证器开关（新）
    case authSwitchNew(model:AuthSwithNewRequestModel)
    ///上传头像
    case uploadimg(image:UIImage)
    ///获取谷歌验证器秘钥
    case getGoogleAuth(type:Int)
    ///修改密码
    case userUpdatePasswd(parameters:[String:Any])
}
extension InfoApi:TargetType{
    var baseURL: URL {
        return Environment.current.baseUrl
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "user/info"
        case .getHeadImage:
            return "user/headImage"
        case .getMarketRate:
            return "market/rate"
        case .userRatecountry:
            return "user/ratecountry"
        case .getuserRatecountry:
            return "user/ratecountry"
        case .userUpdate:
            return "user/update"
        case .uploadimg:
            return "common/uploadfile"
        case .getGoogleAuth(let type):
            return "user/googleAuth/get?type=\(type)"
        case .userUpdatePasswd:
            return "user/changePwd"
        case .authSwitchNew:
            return "user/auth/switch/new"
        }
        
    }
    
        var method: Moya.Method {
        switch self {
        case .getUserInfo,.getHeadImage,.getMarketRate,.getGoogleAuth,.getuserRatecountry:
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
            
        case let .userUpdate(parameters: parameters),
            let .userUpdatePasswd(parameters: parameters),
            let .userRatecountry(parameters: parameters):
            
            return .requestParameters(parameters: parameters, encoding: MoyaJsonArrayEncoding.default)
            
        case let .uploadimg(image : image):
            
            //图片转成Data
            let data:Data = image.jpegData(compressionQuality: 0.9)!
            //根据当前时间设置图片上传时候的名字
            let date:Date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            var dateStr:String = formatter.string(from: date as Date)
            //别忘记这里给名字加上图片的后缀哦
            dateStr = dateStr.appendingFormat(".png")
            let formData =  MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        case let .authSwitchNew(model: model):
            let json : [String : Any] = model.toJSON()!
            return .requestParameters(parameters: json, encoding: MoyaJsonArrayEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .uploadimg:
            return ["Content-type" : "multipart/form-data"]
        default:
            return ["Content-type" : "application/json"]
        }
    }
    
    
}

