//
//  IndexCalculation.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/25.
//

import Foundation

class IndexCalculation : NSObject {
    
    var ma5 = Int(5)
    var ma10 = Int(10)
    var ma30 = Int(30)
    var boll20 = Int(20)
    var bollMultiple = Int(2)
    var kdj9 = Int(9)
    var kdjMid3 = Int(3)
    var kdjLast3 = Int(3)
    var rsi6 = Int(6)
    var rsi14 = Int(14)
    var rsi24 = Int(24)
    var macdFast = Int(12)
    var macdSlow = Int(26)
    var macdMid = Int(9)
    static let shared = IndexCalculation()
    
    func updateMa(newMa5: Int, newMa10: Int, newMa30: Int){
        IndexCalculation.shared.ma5 = newMa5
        IndexCalculation.shared.ma10 = newMa10
        IndexCalculation.shared.ma30 = newMa30
    }
    func updateIndexValue(index: String, maMap: [String: String]){
        if(index == "MA"){
            updateMa(newMa5: Int(maMap["one"]!)!, newMa10: Int(maMap["two"]!)!, newMa30: Int(maMap["three"]!)!)
        }else if(index == "BOLL"){
            boll20 = Int(maMap["one"]!)!
            bollMultiple = Int(maMap["two"]!)!
        }else if(index == "MACD"){
            macdFast = Int(maMap["one"]!)!
            macdSlow = Int(maMap["two"]!)!
            macdMid = Int(maMap["three"]!)!
        }else if(index == "KDJ"){
            kdj9 = Int(maMap["one"]!)!
            kdjMid3 = Int(maMap["two"]!)!
            kdjLast3 = Int(maMap["three"]!)!
        }else if(index == "RSI"){
            rsi6 = Int(maMap["one"]!)!
            rsi14 = Int(maMap["two"]!)!
            rsi24 = Int(maMap["three"]!)!
        }
    }
    
    func maWithN (mas: [CGFloat]) -> CGFloat{
        
        //计算公式；MA = (C1+C2+C3+C4+C5+....+Cn)/n （C 为收盘价，n 为移动平均周期数）
        var maSum = CGFloat(0.0)
        for ma in mas {
            maSum += ma
        }
        return maSum/CGFloat(mas.count)
    }
    
    func bollCall (dataList: [XLKLineModel]){
        
        return bollCal(dataList: dataList, period: boll20, multiple: bollMultiple)
    }
    
    func kdjCal (dataList: [XLKLineModel]){
        
        kdjCal(dataList: dataList, n1: kdj9, n2: kdjMid3, n3: kdjLast3)
    }
    
    func rsiCal (dataList: [XLKLineModel]){
        
        rsiCall(dataList: dataList, period1: rsi6, period2: rsi14, period3: rsi24)
    }
    
    func macdCal(dataList: [XLKLineModel]){
        
        macdCall(dataList: dataList, fastPeriod: macdFast, slowPeriod: macdSlow, signalPeriod: macdMid)
    }

    /**
      * BOLL(n)计算公式：
      * MA=n日内的收盘价之和÷n。 //移动平均线
      * MD=（n-1）日的平方根：（C－MA）的两次方之和除以n
      * MB=（n－1）日的MA
      * UP=MB + multiple × MD
      * DN=MB － multiple × MD
      * multiple为参数，可根据股票的特性来做相应的调整，一般默认为2（多少倍标准差）
      *
      * @param dataList 数据集合
      * @param period   周期，一般为26,20
      * @param multiple        参数，可根据股票的特性来做相应的调整，一般默认为2
      */
    func bollCal (dataList: [XLKLineModel], period: Int, multiple: Int){
        
        if (period < 0 || (period > dataList.count - 1) || dataList.count < 1) {
            return
        }
        var mb:Double;//中轨线
        var up:Double;//上轨线
        var dn:Double;//下轨线
        //n日
        var sum:Double = 0;
        //n-1日
        var sum2:Double = 0;
        //n日MA
        var ma:Double;
        //n-1日MA
        var ma2:Double;
        var md:Double;
        
        for ind in dataList.enumerated(){
            if(ind.offset - 1 >= dataList.count){
                return
            }
            let klineM = ind.element
            sum += klineM.close //ind.element
            sum2 += klineM.close //ind.element
            if (ind.offset > period - 1){
                let klineMper = dataList[ind.offset - period]
                sum -= klineMper.close
            }
            if (ind.offset > period - 2){
                let klinMperA = dataList[ind.offset - period + 1]
                sum2 -= klinMperA.close
            }

            //这个范围不计算，在View上的反应就是不显示这个范围的boll线
            if (ind.offset < period - 1){continue}
                
            ma = sum / Double(period)
            ma2 = sum2 / Double((period - 1))
            md = 0
            for indj in (ind.offset+1-period)...ind.offset {
                if(indj > dataList.count || dataList.count < 1)
                {
                    break
                }
                let klineMindj = dataList[indj]
                md += ((klineMindj.close - ma) * (klineMindj.close - ma))
            }
            md = Double(sqrt(md/Double(period)))
            //(n－1）日的MA
            mb = ma2
            up = mb + Double(multiple) * md
            dn = mb - Double(multiple) * md
            klineM.boll_mb = mb
            klineM.boll_up = up
            klineM.boll_dn = dn
        }
    }

    /**
     * KDJ
     *
     * @param n1 标准值9
     * @param n2 标准值3
     * @param n3 标准值3
     */
    func kdjCal (dataList: [XLKLineModel], n1: Int, n2: Int, n3: Int){
        
        if (dataList.count < 1 ) {
            return
        }
        
        var rsv: Double = 0.0
        var jValue: Double = 0.0
        var mk: [Double] = []
        var md: [Double] = []
        let firstData = dataList[0]
        var highValue = Double(firstData.high) //Double(dataList[0]["maxPrice"] ?? "0.00")
        var lowValue = Double(firstData.low) //Double(dataList[0]["minPrice"] ?? "0.00")
        var highPosition: Int = 0           //记录最高价位置
        var lowPosition: Int = 0         //记录最低价位置
        for index in dataList.enumerated(){
            
            let indexContent = index.element
            let maxPrice = Double(indexContent.high) //Double(indexContent["maxPrice"] ?? "0.00")
            let minPrice = Double(indexContent.low) //Double(indexContent["minPrice"] ?? "0.00")
            let closePrice = Double(indexContent.close) //Double(indexContent["closePrice"] ?? "0.00")
            if (index.offset == 0) {
                mk.append(50)
                md.append(50)
                jValue = 50
            }else{
                if(!doubleCompare(highValue, maxPrice)){
                    highValue = maxPrice
                    highPosition = index.offset
                }
                if(doubleCompare(lowValue, minPrice)){
                    lowValue = minPrice
                    lowPosition = index.offset
                }
                if (index.offset > (n1 - 1)) {
                    //判断存储的最高价是否高于当前最高价
//                    if (highValue > maxPrice) {
                    if(doubleCompare(highValue, maxPrice)){
                        //判断最高价是不是在最近n天内，若不在最近n天内，则从最近n天找出最高价并赋值
                        if (highPosition < (index.offset - (n1 - 1))) {
                            let indexCon = dataList[index.offset - (n1 - 1)]
                            highValue = indexCon.high //Double(indexCon["maxPrice"] ?? "0.00")
                            for j in (index.offset - (n1 - 2))...index.offset{
                                let indexConJ = dataList[j]
                                let indexJPrice = indexConJ.high //Double(indexConJ["maxPrice"] ?? "0.00")
                                if(!doubleCompare(highValue, indexJPrice)){
                                    highValue = indexJPrice
                                    highPosition = j
                                }
                            }
                        }
                    }
                    if(!doubleCompare(lowValue, minPrice)){
                        if (lowPosition < (index.offset - (n1 - 1))) {
                            let indexCon = dataList[index.offset]
                            lowValue = indexCon.low //Double(indexCon["minPrice"] ?? "0.00")
                            for k in (index.offset - (n1 - 2))...index.offset{
                                let indexConK = dataList[k]
                                let indexKPrice = indexConK.low //Double(indexConK["minPrice"] ?? "0.00")
                                if(doubleCompare(lowValue, indexKPrice)){
                                    lowValue = indexKPrice
                                    lowPosition = k
                                }
                            }
                        }
                    }
                    
                }
                if (highValue != lowValue) {
                    rsv = (closePrice - lowValue) / (highValue - lowValue) * 100;
                }
                mk.insert((mk[index.offset - 1] * Double((n2 - 1)) + rsv) / Double(n2), at: index.offset)
                md.insert((md[index.offset - 1] * Double((n3 - 1)) + mk[index.offset]) / Double(n3), at: index.offset)
                jValue = 3 * mk[index.offset] - 2 * md[index.offset]
            }
            indexContent.kdj_k = mk[index.offset]
            indexContent.kdj_d = md[index.offset]
            indexContent.kdj_j = jValue
        }
    }
    func doubleCompare(_ a: Double, _ b: Double) -> Bool {
        let res = a-b > 0
        if(res){
            return true
        }
        return false
    }
    
    /**
     * RSI
     *
     * @param period1 标准值6
     * @param period2 标准值12,,,币安用的14
     * @param period3 标准值24
     */
    func rsiCall (dataList: [XLKLineModel], period1: Int, period2: Int, period3: Int){
        
        //RSI=100-[100/(1+RS)]
        //RS=14天内收市价上涨数之和的平均值/14天内收市价下跌数之和的平均值
        
        for index in dataList.enumerated() {
            
            var upRateSum: Double = 0
            var upRateCount: Int = 0
            var dnRateSum: Double = 0
            var dnRateCount: Int = 0
            
            if(index.offset > period1 - 1){
                
                
                for indj in 1...period1 {
                    
                    let location = index.offset - indj
                    let curMap:XLKLineModel = dataList[location] //6-1 = 5 ,序号5，第6个数据
                    let closePrice = Double(curMap.close) //Double(curMap["closePrice"] ?? "0.00")
                    let openPrice = Double(curMap.open) //Double(curMap["openPrice"] ?? "0.00")
                    let margin = doubleCal(closePrice, openPrice)
                    let updnRate = margin/openPrice
                    
                    if (updnRate >= 0) {
                        upRateSum += updnRate
                        upRateCount += 1
                    } else {
                        dnRateSum += updnRate
                        dnRateCount += 1
                    }
                }
                var avgUpRate:Double = 0
                var avgDnRate:Double = 0
                if(upRateSum > 0) {
                    avgUpRate = upRateSum / Double(upRateCount)
                }
                if(dnRateSum < 0) {
                    avgDnRate = dnRateSum / Double(dnRateCount)
                }
                let rsi6 = avgUpRate/(avgUpRate + fabs(avgDnRate)) * 100
                let currsiMap:XLKLineModel = dataList[index.offset]
                currsiMap.rsi = rsi6
            }

        }
    }
    func doubleCal(_ a: Double, _ b: Double) -> Double{
        
        let res = a-b
        return res
    }
    
    /**
     * MACD     dif快，dea慢
     *
     * @param dataList
     * @param fastPeriod   日快线移动平均，标准为12，按照标准即可
     * @param slowPeriod   日慢线移动平均，标准为26，可理解为天数
     * @param signalPeriod 日移动平均，标准为9，按照标准即可
     */
    func macdCall(dataList: [XLKLineModel], fastPeriod: Int, slowPeriod: Int, signalPeriod: Int){
        
        var preEma_12: Double = 0
        var preEma_26: Double = 0
        var preDEA: Double = 0

        var ema_12: Double = 0
        var ema_26: Double = 0

        var dea: Double = 0
        var dif: Double = 0
        var macd: Double = 0
        
        let size = dataList.count
        for index in 0...(size-1) {
            
            let coinMap = dataList[index]
            let closePrice = Double(coinMap.close) //Double(coinMap["closePrice"] ?? "0.00")
            let ema12first = Double( Double(preEma_12) * Double((fastPeriod - 1)) / Double((fastPeriod + 1)))
            let ema26first = Double( Double(preEma_26) * Double((slowPeriod - 1)) / Double((slowPeriod + 1)))
            let deaFirst = Double(preDEA) * Double((signalPeriod - 1)) / Double((signalPeriod + 1))
            ema_12 = ema12first + closePrice * 2 / Double((fastPeriod + 1))
            ema_26 = ema26first + closePrice * 2 / Double((slowPeriod + 1))
            dif = ema_12 - ema_26
            dea = Double(deaFirst + Double(dif) * 2 / Double((signalPeriod + 1)))
            macd = 2 * (dif - dea)
            
            preEma_12 = ema_12
            preEma_26 = ema_26
            preDEA = dea
            
            coinMap.macd_diff = dif
            coinMap.macd_dea = dea
            coinMap.macd_bar = macd
        }
    }
}
