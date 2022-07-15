//
//  DemoAsyncTask.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/11.
//

import UIKit

class DemoAsyncTask: NSObject {
    
    var asyncTaskResult: ((_ isOk : Bool) -> Void)?
    var api1: String?
    var api2: String?
    
    private var validateTask: URLSessionDataTask?
    private var registerTask: URLSessionDataTask?
}

extension DemoAsyncTask : GT3AsyncTaskProtocol {
    
    func executeRegisterTask(completion: @escaping (GT3RegisterParameter?, GT3Error?) -> Void) {
        /**
         *  解析和配置验证参数
         */
        guard let api1 = self.api1,
              let url = URL(string: "\(api1)?ts=\(Date().timeIntervalSince1970)") else {
            print("invalid api1 address")
            let gt3Error = GT3Error(domainType: .extern, code: -9999, withGTDesciption: "Invalid API1 address.")
            completion(nil, gt3Error)
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                let gt3Error = GT3Error(domainType: .extern, originalError: error, withGTDesciption: "Request API2 fail.")
                completion(nil , gt3Error)
                return
            }
            
            guard let data = data,
                let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
                let gt3Error = GT3Error(domainType: .extern, code: -9999, withGTDesciption: "Invalid API2 response.")
                completion(nil , gt3Error)
                return
            }
            
            if let param = try? JSONDecoder().decode(API1Response.self, from: data) {
                let registerParameter = GT3RegisterParameter()
                registerParameter.gt = param.gt
                registerParameter.challenge = param.challenge
                registerParameter.success = NSNumber(integerLiteral: param.success)
                completion(registerParameter, nil)
            }
            else {
                let gt3Error = GT3Error(domainType: .extern, code: -9999, userInfo: nil, withGTDesciption: "API1 invalid JSON. Origin data: \(String(data: data, encoding: .utf8) ?? "")")
                completion(nil, gt3Error)
            }
        }
        dataTask.resume()
        self.registerTask = dataTask
    }
    
    func executeValidationTask(withValidate param: GT3ValidationParam, completion: @escaping (Bool, GT3Error?) -> Void) {
        
        var indicatorStatus = false
        
        /**
         *  处理result数据, 进行二次校验
         */
        print("executeValidationTask param code: \(param.code), result: \(param.result ?? [:])")
        
        guard let api2 = self.api2,
            let url = URL(string: api2) else {
            print("invalid api2 address")
            let gt3Error = GT3Error(domainType: .extern, code: -9999, withGTDesciption: "Invalid API2 address.")
            completion(false, gt3Error)
            return
        }
        
        var mRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        mRequest.httpMethod = "POST"
        
        let headerFields = ["Content-Type" : "application/x-www-form-urlencoded;charset=UTF-8"]
        mRequest.allHTTPHeaderFields = headerFields
        
        var postArray = Array<String>()
        if let result = param.result {
            for (key, value) in result {
                let item = String(format: "%@=%@", key as! String, value as! String)
                postArray.append(item)
            }
        }
        
        let postForm = postArray.joined(separator: "&")
        mRequest.httpBody = postForm.data(using: .utf8)
        
        let dataTask = URLSession.shared.dataTask(with: mRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                let gt3Error = GT3Error(domainType: .extern, originalError: error, withGTDesciption: "Request API2 fail.")
                completion(false , gt3Error)
                return
            }
            
            guard let data = data,
                let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
                let gt3Error = GT3Error(domainType: .extern, code: -9999, withGTDesciption: "Invalid API2 response.")
                completion(false , gt3Error)
                return
            }
            
            if let result = try? JSONDecoder().decode(API2Response.self, from: data) {
                if result.status == "success" {
                    completion(true, nil)
                    indicatorStatus = true
                } else {
                    completion(false, nil)
                }
            }
            else {
                let gt3Error = GT3Error(domainType: .extern, code: -9999, withGTDesciption: "Invalid API2 data.")
                completion(false , gt3Error)
            }
            
            DispatchQueue.main.async {
                if self.asyncTaskResult != nil {
                    self.asyncTaskResult!(indicatorStatus)
                }
                if indicatorStatus {
                    print("Demo 提示: 校验成功")
                } else {
                    print("Demo 提示: 校验失败")
                }
            }
        }
        dataTask.resume()
        self.validateTask = dataTask
    }
    
    func cancel() {
        self.registerTask?.cancel()
        self.validateTask?.cancel()
    }
}

struct API1Response: Codable {
    var gt: String
    var challenge: String
    var success: Int
    var new_captcha: Bool?
}

struct API2Response: Codable {
    var status: String
}
