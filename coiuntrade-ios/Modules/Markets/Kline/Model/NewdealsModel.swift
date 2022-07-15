//
//  NewdealsModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/11.
//

import UIKit

class NewdealsModel: HandyJSON {
    var Num:String = ""
    var Price:String = ""
    var CreateTime: String = ""
    var type: Int = 0
    required init(){}
    
    func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.type <-- "Type"
     }
}
