//
//  UserDefaults.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/6.
//

import Foundation


struct Archive {
    ///token 有关
    static func saveToken(_ token : String){
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.synchronize()
    }
    static func getToken() -> (String){
//        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjQzLCJuaWNrbmFtZSI6ImJuNDE4NDM0IiwicGhvbmUiOiIxODE3MDA1ODYwMCIsImVtYWlsIjoiIiwiZXhwIjoxNjU1ODY3OTM0LCJpc3MiOiJydWllY2Jhc3MifQ.667s20HpPl7T9AMrX3lWHRtEGx4GuhB38TwgWIpaAfE"
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    ///faceID
    static func saveFaceID(_ faceID : Bool){
         UserDefaults.standard.setValue(faceID, forKey: "faceID")
     UserDefaults.standard.synchronize()
     
         UserDefaults.standard.synchronize()
     }
     static func getFaceID() -> (Bool){
         return UserDefaults.standard.bool(forKey: "faceID")
     }
    ///faceIDtoken 有关
    static func saveFaceIDtoken (_ token : String){
        UserDefaults.standard.setValue(token, forKey: "saveFaceIDtoken")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.synchronize()
    }
    static func getFaceIDtoken() -> (String){
        return UserDefaults.standard.string(forKey: "saveFaceIDtoken") ?? ""
    }
    ///language 语言
    static func saveLanguage (_ language : String){
        UserDefaults.standard.setValue(language, forKey: "language")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.synchronize()
    }
    static func getLanguage() -> (String){
        return UserDefaults.standard.string(forKey: "language") ?? "zh-CN"
    }
}
