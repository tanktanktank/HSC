//
//  KlineSetViewModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit
import HandyJSON

class KlineSetViewModel: NSObject {
    
    var weeks : [WeekDayModel] = Array()
    let originWeeks = ["1m","15m","1h","4h","1d"]
    var curWeeks = ["1m","15m","1h","4h","1d"]
    var selects :[String] {
        
        set{
        }
        get{
            var temArr = [String]()
            var index = 0
            for wdayM in weeks{
                if(wdayM.isSelect){
                    temArr.append(String(index))
                }
                index += 1
            }
            
            return temArr
        }
    }
    private var disposeBag = DisposeBag()
    
    var indexs: [KlineIndexModel] = Array() //指标列表
    var klineType : KlineIndex = .ma
    var klineMaxType : KlineIndexMax = .kdj
    
    //MARK: 周期列表  翻译
    func requestWeekDayList(isReset: Bool)->(PublishSubject<Bool>) {
        self.weeks.removeAll()
        let dataSubject = PublishSubject<Bool>()
        let items = [["title":"period_time_sharing".localized(), "time":"1m","isSelect": false],
                     ["title":"period_time_3m".localized(), "time":"3m","isSelect": false],
                     ["title":"period_time_5m".localized(), "time":"5m","isSelect": false],
                     ["title":"period_time_15m".localized(), "time":"15m","isSelect": false],
                     ["title":"period_time_30m".localized(), "time":"30m","isSelect": false],
                     ["title":"period_time_1h".localized(), "time":"1h","isSelect": false],
                     ["title":"period_time_2h".localized(), "time":"2h","isSelect": false],
                     ["title":"period_time_4h".localized(), "time":"4h","isSelect": false],
                     ["title":"period_time_6h".localized(), "time":"6h","isSelect": false],
                     ["title":"period_time_8h".localized(), "time":"8h","isSelect": false],
                     ["title":"period_time_12h".localized(), "time":"12h","isSelect": false],
                     ["title":"period_time_1d".localized(), "time":"1d","isSelect": false],
                     ["title":"period_time_3d".localized(), "time":"3d","isSelect": false],
                     ["title":"period_time_1w".localized(), "time":"1w","isSelect": false],
                     ["title":"period_time_1M".localized(), "time":"1M","isSelect": false]]
        
        if selects.count > 0 {
            
        } else{
//            selects = ["0","15","120","720","1D"]
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: items, options: []) as NSData?
        let jsonString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        let models = JSONDeserializer<WeekDayModel>.deserializeModelArrayFrom(json: jsonString as String?)! as NSArray
        for model in models {
            let week = model as! WeekDayModel
            let temWeeks = isReset ? originWeeks : curWeeks
            if temWeeks.contains(where: {String($0) == String(week.time)}) {
                week.isSelect = true
            }
            weeks.append(week)
        }
        dataSubject.onNext(true)
        dataSubject.onCompleted()
        return dataSubject
    }
    
    func requestTargetList(style: String)->(PublishSubject<Bool>) {
        self.indexs.removeAll()
        let dataSubject = PublishSubject<Bool>()
        //默认数据
        let items = (style == "First") ? loadItems() : loadSecondItems()
        
        let data : NSData! = try? JSONSerialization.data(withJSONObject: items, options: []) as NSData?
        let jsonString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        let models = JSONDeserializer<KlineIndexModel>.deserializeModelArrayFrom(json: jsonString as String?)! as NSArray
        for model in models {
            let imodel = model as! KlineIndexModel
            if self.klineType == .rsi && imodel.num>0{
                self.indexs.append(imodel)
            } else{
                self.indexs.append(imodel)
            }
        }
        dataSubject.onNext(true)
        dataSubject.onCompleted()
        return dataSubject
    }
    
    func loadItems() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        if(self.klineType == .ma){
            
            //ma 1-999, 颜色可以相同
            items = [["line":0, "color":"yellow","num": 5],
                     ["line":0, "color":"pink","num":  10],
                     ["line":0, "color":"green","num":  30]]
            let tem = loadItemsForMA()
            if(tem.count > 0){
                items = tem
            }
        }else if(self.klineType == .ema){
            
        }else if(self.klineType == .rsi){
            
            items = [["line":0, "color":"yellow","num": 6],
                     ["line":0, "color":"pink","num":  12],
                     ["line":0, "color":"green","num":  24]]
            let tem = loadItemsForRSI()
            if(tem.count > 0){
                items = tem
            }
        }
        else{
           
            items = [["line":0, "color":"yellow","num":self.klineType == .rsi ? 6 : 7,"isSelect":true,"show":self.klineType.rawValue],
                         ["line":0, "color":"systemPink","num": self.klineType == .rsi ? 12 : 25,"isSelect":true,"show":self.klineType.rawValue],
                         ["line":0, "color":"purple","num": self.klineType == .rsi ? 24 : 99,"isSelect":true,"show":self.klineType.rawValue]]
        }
        return items
    }
    
    func loadSecondItems() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        if(self.klineMaxType == .boll){
            
            items = [["line":0, "color":"yellow","num": 5],
                     ["line":0, "color":"pink","num":  10],
                     ["line":0, "color":"green","num":  30]]
            let tem = loadItemsForBoll()
            if(tem.count > 0){
                items = tem
            }
        }else if(self.klineMaxType == .macd){
            
            items = [["line":0, "color":"yellow","num": 5],
                     ["line":0, "color":"pink","num":  10]]
            let tem = loadItemsForMACD()
            if(tem.count > 0){
                items = tem
            }
        }else if(self.klineMaxType == .kdj){
            items = [["line":0, "color":"yellow","num": 5],
                     ["line":0, "color":"pink","num":  10],
                     ["line":0, "color":"green","num":  30]]
            let tem = loadItemsForKDJ()
            if(tem.count > 2){
                items = tem
            }
        }
        return items
    }
    
    func loadItemsForMA() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        guard let mainma0 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "ma50") else {
            return items
        }
        items.append(["line":Int(mainma0.maLineWidth), "color":mainma0.maColor,"num": mainma0.maDay])
        guard let mainma1 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "ma51") else{
            return items
        }
        items.append(["line":Int(mainma1.maLineWidth), "color":mainma1.maColor,"num":  mainma1.maDay])
        guard let mainma2 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "ma52") else{
            return items
        }
        items.append(["line":Int(mainma2.maLineWidth), "color":mainma2.maColor,"num":  mainma2.maDay])
        return items
    }
    func loadItemsForBoll() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        guard let mainBoll0 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexBoll0") else {
            return items
        }
        items.append(["line":Int(mainBoll0.maLineWidth), "color":mainBoll0.maColor,"num": mainBoll0.maDay])
        guard let mainBoll1 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexBoll1") else{
            return items
        }
        items.append(["line":Int(mainBoll1.maLineWidth), "color":mainBoll1.maColor,"num":  mainBoll1.maDay])
        guard let mainBoll2 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexBoll2") else{
            return items
        }
        items.append(["line":Int(mainBoll2.maLineWidth), "color":mainBoll2.maColor,"num":  mainBoll2.maDay])
        return items
    }
    func loadItemsForMACD() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        guard let secondMacd0 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexMacd0") else {
            return items
        }
        items.append(["line":Int(secondMacd0.maLineWidth), "color":secondMacd0.maColor,"num": secondMacd0.maDay])
        guard let secondMacd1 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexMacd1") else{
            return items
        }
        items.append(["line":Int(secondMacd1.maLineWidth), "color":secondMacd1.maColor,"num":  secondMacd1.maDay])
        return items
    }
    func loadItemsForKDJ() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        guard let secondKDJ0 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexKDJ0") else {
            return items
        }
        items.append(["line":Int(secondKDJ0.maLineWidth), "color":secondKDJ0.maColor,"num": secondKDJ0.maDay])
        guard let secondKDJ1 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexKDJ1") else{
            return items
        }
        items.append(["line":Int(secondKDJ1.maLineWidth), "color":secondKDJ1.maColor,"num":  secondKDJ1.maDay])
        guard let secondKDJ2 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexKDJ2") else{
            return items
        }
        items.append(["line":Int(secondKDJ2.maLineWidth), "color":secondKDJ2.maColor,"num":  secondKDJ2.maDay])
        return items
    }
    func loadItemsForRSI() -> [[String: Any]]{
        
        var items = [[String: Any]]()
        guard let secondRSI0 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexRSI0") else {
            return items
        }
        items.append(["line":Int(secondRSI0.maLineWidth), "color":secondRSI0.maColor,"num": secondRSI0.maDay])
        guard let secondRSI1 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexRSI1") else{
            return items
        }
        items.append(["line":Int(secondRSI1.maLineWidth), "color":secondRSI1.maColor,"num":  secondRSI1.maDay])
        guard let secondRSI2 = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexRSI2") else{
            return items
        }
        items.append(["line":Int(secondRSI2.maLineWidth), "color":secondRSI2.maColor,"num":  secondRSI2.maDay])
        return items
    }

}
