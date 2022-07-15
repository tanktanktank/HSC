//
//  LoginApi.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import Foundation
import Alamofire

enum LoginApi {
    ///登录 phone   verify_code
    case login(parameters:[String:Any])
    ///获取国家，地区
    case country
    ///注册
    case register(parameters:[String:Any])
    ///发送验证码
    case sendUnidentified(parameters:[String:Any])
    ///重置密码_安全验证
    case confirmUnidentified(parameters:[String:Any])
    ///重置密码
    case resetPwd(parameters:[String:Any])
}
extension LoginApi:TargetType{
    var baseURL: URL {
        return Environment.current.baseUrl
    }
    
    var path: String {
        switch self {
        case .login:
            return "user/loginPwd"
        case .register:
            return "register/user"
        case .country:
            return "register/country"
        case .sendUnidentified:
            return "auth/send/captcha"
        case .confirmUnidentified:
            return "user/resetPwd/check"
        case .resetPwd:
            return "user/resetPwd"
        }
        
    }
    
        var method: Moya.Method {
        switch self {
        case .country:
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
            
        case let .login(parameters: parameters),
            let .sendUnidentified(parameters: parameters),
            let .confirmUnidentified(parameters: parameters),
            let .register(parameters: parameters),
            let .resetPwd(parameters: parameters):
            
            return .requestParameters(parameters: parameters, encoding: MoyaJsonArrayEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}


struct MoyaJsonArrayEncoding: ParameterEncoding {
    static let `default` = MoyaJsonArrayEncoding()

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()

        guard let json = parameters else {
            return request
        }

        let data = try JSONSerialization.data(withJSONObject: json, options: [])

        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.httpBody = data

        return request
    }
}
