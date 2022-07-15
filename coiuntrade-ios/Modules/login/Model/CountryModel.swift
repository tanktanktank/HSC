//
//  CountryModel.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class CountryModel: BaseModel ,LocalizedCollationable{
    var collationKey: String?{
        return nameen
    }
    var id = ""
    
    var nameen = ""
    
    var namezh = ""
    
    var internatabbrreviation = ""
    
    var countryphonecode = ""
    
    var czone = ""
    
    var lat = ""
    
    var lon = ""
    
    var countryicon = ""
}

class Country : BaseModel{
    var RECORDS : Array<CountryModel> = []
    
}
