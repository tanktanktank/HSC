//
//  Environment.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import Foundation

enum Environment {
    case debug
    case production
    case release
}

extension Environment {
    var baseUrl: URL {
        switch self {
        case .debug:
//            return URL(string: "http://192.168.3.34:6225/api/")!
           return URL(string: "http://8.218.110.85/api/")!
//            return URL(string: "http://192.168.3.110:6225/api/")!
        default:
            return URL(string: "http://8.218.110.85/api/")!
        }
    }
    
    var wsUrl: URL {
        switch self {
        case .debug:
            return URL(string: "ws://8.218.110.85:3333/")!
        default:
            return URL(string: "ws://8.218.110.85:3333/")!
        }
    }
    
    
    static var current: Environment {
        #if DEBUG
        return .debug
        #elseif PRODUCTION
        return .production
        #elseif RELEASE
        return .release
        #endif
        return .debug
    }
    
   
    var rcKey: String {
        switch self {
        case .debug:
            return ""
        default:
            return ""
        }
    }
    
  
}
