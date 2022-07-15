//
//  IndexModule.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/6.
//

import Foundation
import UIKit

class IndexModule: NSObject {

}

struct MainBoolItem: Codable{
    
    var cauculateWeek: String
    var cauculateWidth: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case cauculateWeek
        case cauculateWidth
    }
}

struct SecondMACDItem: Codable{
    
    var fastWeek: String
    var slowWeek: String
    var avgWeek: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case fastWeek
        case slowWeek
        case avgWeek
    }
}

struct SecondKDJItem: Codable{
    
    var calWeek: String
    var avg1: String
    var avg2: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case calWeek
        case avg1
        case avg2
    }
}
 
struct MainMAItem: Codable {
    var maDay: String
    var maLineWidth: String
    var maColor: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case maDay
        case maLineWidth
        case maColor
    }
    
    func dealColor() -> UIColor{
        
        if(maColor == "yellow"){
            return .yellow
        }else if(maColor == "pink"){
            return UIColor(red: 255/255.0, green: 192/255.0, blue:  203/255.0, alpha: 1.0)
        }else if(maColor == "red"){
            return .red
        }else if(maColor == "purple"){
            return .purple
        }
        return .green
    }
}

extension UserDefaults {
    
    func setItem<T: Encodable>(_ object: T, forKey key: String) {
        
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        self.set(encoded, forKey: key)
    }
    
    func getItem<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        
        guard let data = self.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Couldnt find key")
            return nil
        }
        
        return object
    }
}




