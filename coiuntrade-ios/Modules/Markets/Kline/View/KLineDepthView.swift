//
//  KLineDepthView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/27.
//

/**
 * 左右各20个点，左边20个点添加进去后需要逆序一下
 */

import Foundation
import UIKit
import Charts

class KLineDepthView: UIView,ChartViewDelegate{
    
    let lineView = LineChartView()
    let tipLab = UILabel()
    var allXPrice = [String]()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLineViewFrame(){
        lineView.frame = self.bounds
    }
    
    //MARK: ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let millisecond = Date().milliStamp
//        print("当前毫秒级时间戳是 millisecond == ",millisecond)
//        print("调用chartValueSelected")
        let lineData: LineChartData = lineView.lineData!
        let dataSets: [IChartDataSet] = lineData.dataSets
        tipLab.isHidden = false
        if(dataSets.count > 0){
            let dataset1:LineChartDataSet = dataSets[0] as! LineChartDataSet
//            let dataset2:IChartDataSet = dataSets[1]
            let dataset2:LineChartDataSet = dataSets[1] as! LineChartDataSet
            let scale:Double = entry.x / Double((dataset1.values.count + dataset2.values.count))
            //y 值比列 当前y值，除余最大 y值 百分比
            
            var locationX = self.frame.size.width * scale
            tipLab.text = allXPrice[Int(entry.x)] //"x="+String(entry.x)+"y="+String(entry.y)
            tipLab.sizeToFit()
            if(locationX > (self.frame.size.width * 0.5)){
                locationX -= tipLab.frame.size.width
            }
            tipLab.frame = CGRect(x: locationX, y: tipLab.frame.origin.y, width: tipLab.frame.size.width , height: tipLab.frame.size.height)
        }
    }
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        tipLab.isHidden = true
    }
    
    //MARK: Custom
    func updateShow(coinBuyDatas: [Any], coinSellDatas: [Any]){
        
        var buys = [[String: String]]()
        var sells = [[String: String]]()
        for coinData in coinBuyDatas {
            let coins = coinData as! Array<String>
            let volume = coins[1]
            let price = coins[0]
            let map = ["volume":volume, "price":price]
            buys.append(map)
        }
        
        for sellCoinData in coinSellDatas {
            let sellCoins = sellCoinData as! Array<String>
            let sellVolume = sellCoins[1]
            let sellPrice = sellCoins[0]
            let sellMap = ["volume":sellVolume, "price":sellPrice]
            sells.append(sellMap)
        }

        updateData(buyArr: buys, sellArr: sells)
    }
    
    func setUI(){
        
        lineView.frame = self.bounds
        lineView.delegate = self
        lineView.backgroundColor = .black
        lineView.noDataText = "tv_empty_data".localized()
        lineView.noDataTextColor = .red
        lineView.chartDescription?.enabled = false
        lineView.scaleYEnabled = false //取消Y轴缩放
        lineView.doubleTapToZoomEnabled = false //取消双击缩放
        lineView.dragEnabled = true //启用拖曳图标
        lineView.setVisibleXRangeMaximum(4)
        lineView.dragDecelerationEnabled = false //拖拽后是否有惯性效果
        lineView.dragDecelerationFrictionCoef = 0.382//0.9 //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        lineView.rightAxis.enabled = true //不绘制右边轴
        lineView.rightAxis.axisLineColor = .yellow
        lineView.rightAxis.labelTextColor = .green
        lineView.rightAxis.xOffset = 0
        lineView.rightAxis.enabled = false //不绘制右边轴,不绘制Y轴
        lineView.drawBordersEnabled = false
        lineView.borderColor = .lightGray
            
        let leftAxis = lineView.leftAxis //获取左边Y轴
        leftAxis.enabled = false

        let xAxis = lineView.xAxis
        xAxis.granularityEnabled = true //设置重复的值不显示
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom //设置x轴数据在底部
        xAxis.labelTextColor = .white //文字颜色
        xAxis.axisLineColor = .clear
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.labelCount = 4
        lineView.legend.enabled = false
        lineView.legend.formSize = 13
        lineView.legend.form = .line
        lineView.animate(xAxisDuration: 1)
        self.addSubview(lineView)
        
        tipLab.font = .systemFont(ofSize: 13)
        tipLab.textColor = .orange
        tipLab.backgroundColor = .purple.withAlphaComponent(0.88)
        tipLab.frame = CGRect(x: 0, y: 0, width: 120, height: 24)
        self.addSubview(tipLab)
        tipLab.isHidden = true
    }

    func updateData(buyArr: [[String: String]], sellArr: [[String: String]]) {
        
        if(buyArr.count < 1 || sellArr.count < 1){
            return
        }
        
        var xAll = [String]()
        var xAllPriceTem = [String]()
        var yVals: [ChartDataEntry] = []
        var ysellVals: [ChartDataEntry] = []
        var buyothe: [Double] = [] //成交量
        var allsellvo: Double = 0

        
        var haveVolume: Double = 0.0
        for buyCoin in buyArr.enumerated(){
            let buyMap = buyCoin.element
            let price = buyMap["price"] ?? "0.00"
            let volume = buyMap["volume"]
//            let pricef = Double(price ?? "0.00") ?? 0.00
            haveVolume += Double(volume ?? "0.00") ?? 0.00
            buyothe.append(haveVolume)
            if(buyCoin.offset < 1){
                xAll.append(price)
            }else if(buyCoin.offset == (buyArr.count - 1)){
                xAll.append(price)
            }
            xAllPriceTem.append(price)
        }
        buyothe = buyothe.reversed()
        for buyVolume in buyothe.enumerated() {
            let chartDataEntry = ChartDataEntry(x: Double(buyVolume.offset) , y: Double(buyVolume.element))
            yVals.append(chartDataEntry)
        }
        
        
        var dataSets: [LineChartDataSet] = []
        let set1 = LineChartDataSet(values: yVals, label: "")
        set1.lineWidth = 1 //折线宽度
//          set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.valueFormatter = SetValueFormatter() //TODO: 实现内容待修改
//          set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        set1.valueColors = [.orange] //折线拐点处显示数据的颜色
        set1.drawCircleHoleEnabled = false
        set1.drawCirclesEnabled = false
        set1.setColor(UIColor.hexColor(0x02C078)) //折线颜色
//          [set1 setMode:LineChartModeLinear];
//      //    set1.highlightColor = UIColorFromRGB(0xFF7F50);
        set1.drawFilledEnabled = false //是否开启绘制阶梯样式的折线图
          //折线拐点样式
        set1.drawFilledEnabled = true//是否填充颜色
        set1.fillColor = UIColor.hexColor(0x02C078)
        set1.circleRadius = 1.0
        set1.circleHoleRadius = 2.0 //空心的半径
        set1.circleColors = [.orange]//空心的圈的颜色
        set1.circleHoleColor = .orange//空心的颜色
        dataSets.append(set1)
        
        let chartDataEntry: ChartDataEntry = yVals.last!
        let entry = ChartDataEntry(x: Double(yVals.count - 1 ) , y: chartDataEntry.y)
        ysellVals.append(entry)
        for sellCoin in sellArr.enumerated(){
            let sellMap = sellCoin.element
            let price = sellMap["price"] ?? "0.00"
            let volume = sellMap["volume"]
            allsellvo += Double(volume ?? "0.00") ?? 0.00
            let entry = ChartDataEntry(x: Double(sellCoin.offset + buyArr.count ), y: Double(allsellvo))
            ysellVals.append(entry)
            if(sellCoin.offset < 1){
                xAll.append(price)
            }else if(sellCoin.offset == (sellArr.count - 1)){
                xAll.append(price)
            }
            xAllPriceTem.append(price)
        }
        
        allXPrice = xAllPriceTem
        let set2 = LineChartDataSet(values: ysellVals, label: "")
         //设置折线的样式
        set2.lineWidth = 1 //折线宽度
//        set2.drawValuesEnabled = true //是否在拐点处显示数据
//        set2.valueFormatter = SetValueFormatter() //TODO: 实现内容待修改 //[[SetValueFormatter alloc]initWithArr:yVals];
        set2.valueColors = [.brown] //折线拐点处显示数据的颜色
        set2.drawCircleHoleEnabled = false
        set2.drawCirclesEnabled = false
        set2.setColor(UIColor.hexColor(0xF03851))//折线颜色
//         [set2 setMode:LineChartModeLinear];
//         //    set1.highlightColor = UIColorFromRGB(0xFF7F50);
        set2.drawFilledEnabled = true //是否填充颜色
        set2.fillColor = UIColor.hexColor(0xF03851)//.red
        dataSets.append(set2)
        
        //设置x/y轴坐标
        lineView.xAxis.valueFormatter = XSetValueFormatter(min: 0, max: 30 , labelCount: 4, values: xAll)
//        lineView.xAxis.xOffset = 40
        let lineChartData = LineChartData(dataSets: dataSets)
        lineChartData.setValueFont(UIFont.systemFont(ofSize: 11))
        lineChartData.setValueTextColor(.clear)
        lineView.data = lineChartData
    }

}


class SetValueFormatter : IValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        //TODO: 修改
        return "888"
    }
    
}


class XSetValueFormatter: NSObject, IAxisValueFormatter{
    
    private var min: Double = 0
    private var max: Double = 0
    private var values = [String]()
    private var labelCount: Int = 0
    convenience init(min: Double, max: Double, labelCount: Int, values: [String]){
        self.init()
        self.min = min
        self.max = max
        self.values = values
        self.labelCount = labelCount
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let granularity = (max-min)/Double(labelCount-1)
        let index = Int(((value-min)/granularity).rounded())
//        print("索引",index)
//        print("改变值",value)
        guard index < values.count else { return "" }
        return values[index]
    }
}

