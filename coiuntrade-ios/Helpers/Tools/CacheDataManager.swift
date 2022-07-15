//
//  CacheDataManager.swift
//  SaaS
//
//  Created by  on 2021/10/25.
//

import UIKit


enum CacheDataKey : String {
    case info =  "CacheDataKey.info"
}

class CacheDataManager {
    
    // MARK: - Cache
    
    class func set(_ value : Any?, forKey key : CacheDataKey) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
 
    class func set(_ value : String?, forKey key : CacheDataKey) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    
    // MARK: - Obtaining
    
    class func value(forKey key : CacheDataKey) -> Any? {
        return UserDefaults.standard.value(forKey:key.rawValue)
    }
    
    class func value(forKey key : CacheDataKey) -> String? {
        return UserDefaults.standard.value(forKey:key.rawValue) as? String
    }
    
    
    
}


