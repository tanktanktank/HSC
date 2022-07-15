//
//  KDepthView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/15.
//

import UIKit

class KDepthView: UIView {

    /// 卖单买单计算数据源时，注意计算那个数据也有先后的
    var bids = [MarketDepthData](){
        didSet{
            self.decodeDatasToAppend(datas: bids.reversed(), type: .bid)
            self.depthChart.reloadData()
        }
    }
    var asks = [MarketDepthData](){
        didSet{
            if self.depthDatas.count > 0{
                self.depthDatas.removeAll()
            }
            self.maxAmount = 0
            self.decodeDatasToAppend(datas: asks, type: .ask)
        }
    }
    //最大深度
    var maxAmount: Float = 0
    /// 数据源
    var depthDatas: [CHKDepthChartItem] = [CHKDepthChartItem]()

    
    /// 解析分析
    func decodeDatasToAppend(datas: [MarketDepthData], type: CHKDepthChartItemType) {
        var total: Float = 0
        if datas.count > 0 {
            for data in datas {
                let item = CHKDepthChartItem()
                item.value = CGFloat(data.price)
                item.amount = CGFloat(data.quantity.toDouble())
                item.type = type
                self.depthDatas.append(item)
                total += Float(item.amount)
            }
        }
        if total > self.maxAmount {
            self.maxAmount = total
        }
    }
    
    func updateShow(coinBuyDatas: [Any], coinSellDatas: [Any]){

//        let datas = json["datas"]
        let asksArr = coinSellDatas //datas["asks"].arrayValue
        var asks = [MarketDepthData]()
        for asksJson in asksArr {
            let sellCoins = asksJson as! Array<String>
            let ask = MarketDepthData(datas: sellCoins, currencyType: "", exchangeType: ExchangeType.Sell)
            asks.append(ask)
        }
        let bidsArr = coinBuyDatas //datas["bids"].arrayValue
        var bids = [MarketDepthData]()
        for bidsJson in bidsArr {
            let coins = bidsJson as! Array<String>
            let bid = MarketDepthData(datas: coins, currencyType: "", exchangeType: ExchangeType.Buy)
            bids.append(bid)
        }
//        bids.reverse()
        self.asks = asks
        self.bids = bids
    }
    func updateLineViewFrame(){
        self.depthChart.snp.updateConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(self.height - 20)
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.hexColor("383838")//.white
        self.addSubview(self.depthChart)
        self.depthChart.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(self.height - 20)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// **** 重要的事情要注意一下：该深度图的横坐标是以档位个数为单位，所以没有中间缺口，市面上的深度图的横坐标是以价格范围为横坐标长度 ****
    lazy var depthChart: CHDepthChartView = {
        // 如果使用第三方布局，深度图创建时需要给一个frame,否则不显示
        let view = CHDepthChartView(frame: CGRect(x: 0, y: 0, width: 100, height: 180))
        view.delegate = self
        view.style = .depthStyle
        view.yAxis.referenceStyle = .solid(color: UIColor(hex:0xefefef).withAlphaComponent(0.218)) //0x2E3F53 和 383838背景色 相似
        view.xAxis.referenceStyle = .solid(color: UIColor(hex:0xefefef).withAlphaComponent(0.218)) //0x2E3F53 和 383838背景色 相似
        return view
    }()
}


//MARK:深度图表
extension KDepthView: CHKDepthChartDelegate {
    
    
    /// 图表的总条数
    /// 总数 = 买方 + 卖方
    /// - Parameter chart:
    /// - Returns:
    func numberOfPointsInDepthChart(chart: CHDepthChartView) -> Int {
        return self.depthDatas.count
    }
    
    
    /// 每个点显示的数值项
    ///
    /// - Parameters:
    ///   - chart:
    ///   - index:
    /// - Returns:
    func depthChart(chart: CHDepthChartView, valueForPointAtIndex index: Int) -> CHKDepthChartItem {
        return self.depthDatas[index]
    }
    
    
    /// y轴以基底值建立
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func baseValueForYAxisInDepthChart(in depthChart: CHDepthChartView) -> Double {
        return 0
    }
    
    /// y轴以基底值建立后，每次段的增量
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func incrementValueForYAxisInDepthChart(in depthChart: CHDepthChartView) -> Double {
        
        let step = Double(self.maxAmount / 4)
//        print("setp == \(step)")
        return step
    }
    /// 纵坐标值显示间距
    func widthForYAxisLabelInDepthChart(in depthChart: CHDepthChartView) -> CGFloat {
        return 30
    }
    /// 纵坐标值
    func depthChart(chart: CHDepthChartView, labelOnYAxisForValue value: CGFloat) -> String {
        if value >= 1000{
            let newValue = value / 1000
            return newValue.ch_toString(maxF: 0) + "K"
        }else {
            return value.ch_toString(maxF: 1)
        }
    }
    
    /// 价格的小数位
    func depthChartOfDecimal(chart: CHDepthChartView) -> Int {
        return 4
    }
    
    /// 量的小数位
    func depthChartOfVolDecimal(chart: CHDepthChartView) -> Int {
        return 6
    }
    
    //    /// 自定义点击显示信息view
    //    func depthChartShowItemView(chart: CHDepthChartView, Selected item: CHKDepthChartItem) -> UIView? {
    //        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    //        view.backgroundColor = UIColor.red
    //        return view
    //    }
    //    /// 点击标记图
    //    func depthChartTagView(chart: CHDepthChartView, Selected item: CHKDepthChartItem) -> UIView? {
    //        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    //        view.backgroundColor = UIColor.blue
    //        return view
    //    }
}


// MARK: - 扩展样式
extension CHKLineChartStyle {
    
    
    /// 深度图样式
    static var depthStyle: CHKLineChartStyle = {
        
        let style = CHKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor.orange //UIColor(white: 0.7, alpha: 1)
        //背景颜色
        style.backgroundColor = UIColor.hexColor("383838") //UIColor.hexColor("383838") //
        //文字颜色
        style.textColor = UIColor(white: 0.5, alpha: 1)
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //Y轴是否内嵌式
        style.isInnerYAxis = false
        //Y轴显示在右边
        style.showYAxisLabel = .right
        
        /// 买单居右
        style.bidChartOnDirection = .left
        
        //边界宽度
        style.borderWidth = (0, 0, 0, 0)
        
        //是否允许手势点击
        style.enableTap = true
        
        //买方深度图层的颜色 UIColor(hex:0xAD6569) UIColor(hex:0x469777)
        style.bidColor = (UIColor(hex:0x469777), UIColor(hex:0x469777).withAlphaComponent(0.382), 1)
        //        style.askColor = (UIColor(hex:0xAD6569), UIColor(hex:0xAD6569), 1)
        //买方深度图层的颜色
        style.askColor = (UIColor(hex:0xAD6569), UIColor(hex:0xAD6569).withAlphaComponent(0.382), 1)
        //        style.bidColor = (UIColor(hex:0x469777), UIColor(hex:0x469777), 1)
        
        return style
        
    }()
}


