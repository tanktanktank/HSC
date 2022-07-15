//
//  NetworkHelper.swift
//
//
//  Created by  tfr on 2021/12/3.
//

import Foundation
import Moya
import Alamofire
import UIKit
enum QiResponseCode : Int {
    case tokenEnable
    case unknow
}
///超时时长
private var requestTimeOut: Double = 30
///成功数据回调
typealias successCallback = ((_ responseInfo : Any) -> Void)
/// 失败的回调
typealias failedCallback = ((String) -> Void)
typealias failedWithCodeCallback = ((String,Int) -> Void)
/// 网络错误的回调
typealias errorCallback = (() -> Void)
/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task

    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
//    let additionalParameters = ["token":"888888"]
//    let defaultEncoding = URLEncoding.default
//    switch target.task {
//        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
//    case .requestPlain:
//        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
//    case .requestParameters(var parameters, let encoding):
//        additionalParameters.forEach { parameters[$0.key] = $0.value }
//        task = .requestParameters(parameters: parameters, encoding: encoding)
//    default:
//        break
//    }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */

    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30 // 每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    // 针对于某个具体的业务模块来做接口配置
//    if let apiTarget = target as? TargetType {
//        switch apiTarget {
//        case .easyRequset:
//            return endpoint
//        case .register:
//            requestTimeOut = 5
//            return endpoint
//
//        default:
//            return endpoint
//        }
//    }
    
    let token  = Archive.getToken()
//    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjEsIm5pY2tuYW1lIjoi5ZGo5Lic5rW3IiwicGhvbmUiOiIxMTAiLCJlbWFpbCI6IjExMCIsImV4cCI6MTkzODUyOTU0NywiaXNzIjoicnVpZWNiYXNzIn0.rnqeI7Vmaoy01dyp9B8KJH_M2RWmG5kDrMpmvY-SKC0"
    
    print(Localize.currentLanguage())
    var header : [String:String] = ["brand":UIDevice.current.systemName,
                                    "os":"2",//1安卓2苹果
                                    "device_id":UIDevice.current.identifierForVendor?.uuidString ?? "",//uuid
                                    "model":UIDevice.current.model,
                                    "language":Archive.getLanguage(),//语言
                                    "version":UIDevice.current.systemVersion]
    if token.count > 0 {
        header["token"] = token
    }
    
    return endpoint.adding(newHTTPHeaderFields: header)
}
/// 网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "发送参数" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            print("\(request.url!)" + "\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}
/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
     publicKeys: ServerTrustPolicy.publicKeysInBundle(),
     validateCertificateChain: true,
     validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
// private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
// }
// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
/// 但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
    print("networkPlugin \(changeType)")
    // targetType 是当前请求的基本信息
    switch changeType {
    case .began:
        print("开始请求网络")

    case .ended:
        print("结束")
    }
}
// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
// stubClosure   用来延时发送网络请求
/// /网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

let Provider2 = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个 (可以给调用的NetWorkReques方法的写参数默认值达到一样的效果,这里为解释方便做抽出来二次封装)
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func NetWorkRequest(_ target: TargetType, completion: @escaping successCallback) {
    NetWorkRequest(target, completion: completion, failed: nil, failedWithCode:nil, errorResult: nil)
}

/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个 (可以给调用的NetWorkRequest方法的参数默认值达到一样的效果,这里为解释方便做抽出来二次封装)
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failedWithCode: 请求失败的回调 带有状态码
func NetWorkRequest(_ target: TargetType, completion: @escaping successCallback, failedWithCode: failedWithCodeCallback?) {
    NetWorkRequest(target, completion: completion, failed: nil, failedWithCode:failedWithCode, errorResult: nil)
}
///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
@discardableResult // 当我们需要主动取消网络请求的时候可以用返回值Cancellable, 一般不用的话做忽略处理
func NetWorkRequest(_ target: TargetType, completion: @escaping successCallback, failed: failedCallback?,failedWithCode: failedWithCodeCallback?, errorResult: errorCallback?,_ haveMeta : Bool = false) -> Cancellable? {
    // 先判断网络是否有链接 没有的话直接返回--代码略
  
    if !UIDevice.isNetworkConnect {
        print("提示用户网络似乎出现了问题")
        return nil
    }
    // 这里显示loading图
    return Provider.request(MultiTarget(target)) { result in
        HudManager.dismissHUD()
        // 隐藏hud
        switch result {
        case let .success(response):
            do {
                print("http 状态码\(response.statusCode)")
                let jsonData = try JSON(data: response.data)
                print(jsonData)
                //               这里的completion和failed判断条件依据不同项目来做，为演示demo我把判断条件注释了，直接返回completion。
                let statusCode = jsonData["status"].intValue
                if statusCode == 1 {
                    
                    if haveMeta {
                        
                        completion(jsonData.dictionaryObject! as Dictionary)
                    }else{
                        if jsonData["data"].dictionaryObject != nil {
                            completion(jsonData["data"].dictionaryObject! as Dictionary)
                        }else if jsonData["data"].arrayObject != nil{
                            completion(jsonData["data"].arrayObject! as Array)
                        }else{
                            completion(jsonData.dictionaryObject as Any)
                        }
                    }
                   
                    
                   
                }else{
                    
                    if statusCode == -1 {//-1未登录
                        userManager.userLogout()
                    }else if statusCode == -2{//-2挤掉线
                        guard let currentVC = getTopVC() else { return }
                        if currentVC.isKind(of: LoginVC.self) {
                            return
                        }
                        userManager.userLogout()
                        userManager.logoutWithVC(currentVC: currentVC)
                    }else{
                        HudManager.showOnlyText(jsonData["msg"].stringValue)
                    }
                    
                
                }
            } catch {
                print("res" + String(data: response.data, encoding: String.Encoding.utf8)!)
            }
        case let .failure(error):
            HudManager.dismissHUD()
            // 网络连接失败，提示用户
           
            print("网络连接失败\(error)")
            errorResult?()
        }
    }
}

/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
func OtherNetWorkRequest(_ target: TargetType, completion: @escaping successCallback)  {
    HudManager.show()
    // 这里显示loading图
    Provider.request(MultiTarget(target)) { result in
        // 隐藏hud
        HudManager.dismissHUD()
        switch result {
        case let .success(response):
            do {
                let jsonData = try JSON(data: response.data)
                print(jsonData)
                completion(jsonData.dictionaryObject as Any)
            } catch {
                print("res" + String(data: response.data, encoding: String.Encoding.utf8)!)
            }
        case let .failure(error):
            // 网络连接失败，提示用户
            print("网络连接失败\(error)")
            
        }
    }
}

// 成功回调
typealias RequestSuccessCallback = ((_ model: Any?) -> ())
// 失败回调
typealias RequestFailureCallback = ((_ code: Int, _ message: String) -> Void)

/// 带有模型转化的底层网络请求的基础方法    可与 179 行核心网络请求方法项目替换 唯一不同点是把数据转模型封装到了网络请求基类中
///  本方法只写了大概数据转模型的实现，具体逻辑根据业务实现。
/// - Parameters:
///   - target: 网络请求接口
///   - isHideFailAlert: 是否隐藏失败的弹框
///   - modelType: 数据转模型所需要的模型
///   - successCallback: 网络请求成功的回调 转好的模型返回出来
///   - failureCallback: 网络请求失败的回调
/// - Returns: 可取消网络请求的实例
@discardableResult
func NetWorkRequest<T: HandyJSON>(_ target: TargetType, modelType: T.Type?, successCallback: RequestSuccessCallback?, failureCallback: RequestFailureCallback? = nil) -> Cancellable? {
    // 这里显示loading图
    return Provider.request(MultiTarget(target)) { result in
        // 隐藏hud
        HudManager.dismissHUD()
        switch result {
        case let .success(response):
            do {
                let jsonData = try JSON(data: response.data)
                print(jsonData)
                let statusCode = jsonData["status"].intValue
                if statusCode == 1{
                    // data里面不返回数据 只是简单的网络请求 无需转模型
                    if jsonData["data"].dictionaryObject == nil, jsonData["data"].arrayObject == nil ,jsonData["data"].string != nil { // 返回字符串
                        successCallback?(jsonData["data"].string)
                        return
                    }

                    if jsonData["data"].dictionaryObject != nil { // 字典转model
                        
                        if let model =  T.deserialize(from: jsonData["data"].dictionaryObject)  {
                            successCallback?(model)
                        } else {
                            print("解析失败")
                            failureCallback?(statusCode, "解析失败")
                        }
                    } else if jsonData["data"].arrayObject != nil { // 数组转model
                        if let model = [T].deserialize(from: jsonData["data"].arrayObject) {
                            successCallback?(model)
                        } else {
                            print("解析失败")
                            failureCallback?(statusCode, "解析失败")
                        }
                    }
                }else{
                    failureCallback?(statusCode, jsonData["msg"].stringValue)
                    if statusCode == -1 {//-1未登录
                        userManager.userLogout()
                    }else if statusCode == -2{//-2挤掉线
                        guard let currentVC = getTopVC() else { return }
                        if currentVC.isKind(of: LoginVC.self) {
                            return
                        }
                        userManager.userLogout()
                        userManager.logoutWithVC(currentVC: currentVC)
                    }else{
                        HudManager.showOnlyText(jsonData["msg"].stringValue)
                    }
                }
            } catch {
                failureCallback?(response.statusCode, String(data:response.data,encoding:.utf8) ?? "解析失败")
            }
        case let .failure(error):
            // 网络连接失败，提示用户****
            print("网络连接失败\(error)")
            failureCallback?(error.errorCode, "网络连接失败")
            HudManager.showOnlyText("网络连接失败")
        }
    }
}

func dealErrorCode(code : QiResponseCode){
    
}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用计算型属性是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork

extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
}


