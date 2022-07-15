//
//  UserCerApi.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/28.
//

import Foundation

enum UserCerApi {
    ///获取认证详情
    case userCerDetailApi
    /// 提交标准身份认证
    case userCerAddJuniorApi(reqModel:Any)
    
    /// 重新提交标准身份认证
    case userCerUpdateJuniorApi(reqModel:Any)
    
    /// 进阶身份认证
    case userCerAdvanceApi(reqModel:Any)
    
    ///上传kyc图片
    case uploadKYCImg(image:UIImage)
    
    ///上传kyc视频认证
    case uploadKYCVideo(video: NSData)
    
    ///获取视频验证码
    case userCerVideoCode
}
extension UserCerApi : TargetType{
    
    var baseURL: URL {
        return Environment.current.baseUrl
    }
    
    var path: String {
        switch self {
            case .userCerDetailApi:
                return "ident/getidentinfo"
            case .userCerAddJuniorApi:
                return "ident/addjunior"
            case .userCerUpdateJuniorApi:
                return "ident/updatejunior"
            case .userCerAdvanceApi:
                return "ident/updatemiddle"
            case .uploadKYCImg:
                return "common/uploadsysfile"
            case .uploadKYCVideo:
                return "common/uploadsysfile"
            case .userCerVideoCode:
                return "ident/getvideocode"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userCerDetailApi,.userCerVideoCode:
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
            case let .userCerAddJuniorApi(reqModel):
                let model = reqModel as! ReqUserJuniorM
                return .requestData(jsonToData(jsonDic: model.toJSON()!)!)
            case let .userCerUpdateJuniorApi(reqModel):
                let model = reqModel as! ReqUserJuniorM
                return .requestData(jsonToData(jsonDic: model.toJSON()!)!)
            case let .userCerAdvanceApi(reqModel):
                let model = reqModel as! ReqUserAdvanceM
                return .requestData(jsonToData(jsonDic: model.toJSON()!)!)
            case let .uploadKYCImg(image : image):
                //图片转成Data
                let data:Data = image.jpegData(compressionQuality: 0.9)!
                //根据当前时间设置图片上传时候的名字
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                //别忘记这里给名字加上图片的后缀哦
                dateStr = dateStr.appendingFormat(".png")
                let formData =  MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: "image/png")
                return .uploadMultipart([formData])
            case let .uploadKYCVideo(video: videoData):
                let data:Data = videoData as Data
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                dateStr = dateStr.appendingFormat(".mp4")
                let formData =  MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: "video/mp4")
                return .uploadMultipart([formData])
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .uploadKYCImg,.uploadKYCVideo:
                return ["Content-type" : "multipart/form-data"]
            default:
                return ["Content-type" : "application/json"]
        }
    }
    
    
}
