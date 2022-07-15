//
//  HomeMainKLineCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/8.
//

import UIKit
import Charts

protocol HomeMainKLineCellDelegate : NSObjectProtocol {
    ///点击用户
    func clickCell(model : CoinModel)
}
class HomeMainKLineCell: UICollectionViewCell {
    public weak var delegate: HomeMainKLineCellDelegate? = nil
    static let CELLID = "HomeMainKLineCell"
    lazy var bgView : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 6)
        return v
    }()
    ///交易对
    lazy var symbolLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("858D97")
        lab.font = FONTBINCE(size: 11)
        lab.text = "-/-"
        lab.textAlignment = .center
        return lab
    }()
    lazy var pricelLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTDIN(size: 17)
        lab.text = "-"
        lab.textAlignment = .center
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    lazy var ratelLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTM(size: 12)
        lab.text = "-%"
        lab.textAlignment = .center
        return lab
    }()
    lazy var kLineV : LineChartView = {
        let v = LineChartView(frame: CGRect(x: 6, y: self.height/2+12, width: self.width-12, height: self.height/2-12))
        v.borderLineWidth = 1.5
        v.isUserInteractionEnabled = false
        v.noDataText = "暂无统计数据" //无数据的时候显示
        v.chartDescription?.enabled = false //是否显示描述
        v.scaleXEnabled = false
        v.scaleYEnabled = false
        
        v.leftAxis.drawGridLinesEnabled = false //左侧y轴设置，不画线
        v.leftAxis.enabled = false //禁用右侧的Y轴
        v.rightAxis.drawGridLinesEnabled = false //右侧y轴设置，不画线
        v.rightAxis.drawAxisLineEnabled = false
        v.rightAxis.enabled = false
        v.legend.enabled = false
        v.legend.form = .none
        v.xAxis.labelPosition = .bottom //x轴的位置
        v.xAxis.labelFont = .systemFont(ofSize: 0)
        v.xAxis.drawGridLinesEnabled = false
        v.xAxis.drawAxisLineEnabled = false
        v.xAxis.granularity = 1.5
        return v
    }()
    lazy var btn : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        return btn
    }()
    @objc func tapBtn(){
        self.delegate?.clickCell(model: self.model)
    }
    var model : CoinModel!{
        didSet{
            
//            let f = Float(model.ratio_str) ?? 0.0
            self.ratelLab.text = self.addTwoDecimalsDownValue(value: model.ratio_str) + "%"
            
            self.pricelLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: model.new_price, digit: model.price_digit))
            self.symbolLab.text = model.coin + "/" + model.currency
            if model.isFall {
                bgView.image = UIImage(named: "klinebgred")
                self.ratelLab.textColor = .hexColor("FF4E4F")
                self.pricelLab.textColor = .hexColor("FF4E4F")
            } else{
                bgView.image = UIImage(named: "klinebgrend")
                self.ratelLab.textColor = .hexColor("02C078")
                self.pricelLab.textColor = .hexColor("02C078")
            }
            self.setLineChartViewData(model.KlineData)
        }
    }
    //配置折线图
    func setLineChartViewData(_ values: [Double]) {
        
        var dataEntris: [ChartDataEntry] = []
        var dataPoints: [String] = []
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntris.append(dataEntry)
            dataPoints.append(String(i))
        }
        let lineChartDataSet = LineChartDataSet(values: dataEntris, label: "")
        lineChartDataSet.drawCirclesEnabled = false //不绘制转折点
        lineChartDataSet.drawValuesEnabled = false //不绘制拐点上的文字
        lineChartDataSet.highlightEnabled = false  //不启用十字线
        lineChartDataSet.highlightLineWidth = 1
        lineChartDataSet.highlightLineDashPhase = 1
        
        //线条显示样式
        if self.model.isFall {
            lineChartDataSet.colors = [UIColor.hexColor("FF4E4F")]
        }else{
            lineChartDataSet.colors = [UIColor.hexColor("02C078")]
        }
        lineChartDataSet.lineWidth = 1.5
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        self.kLineV.data = lineChartData
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeMainKLineCell{
    func setUI(){
        self.addSubview(bgView)
        bgView.addSubview(symbolLab)
        bgView.addSubview(pricelLab)
        bgView.addSubview(ratelLab)
        bgView.addSubview(kLineV)
        self.addSubview(btn)
    }
    func initSubViewsConstraints(){
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        symbolLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(8)
        }
        pricelLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(25)
            make.top.equalTo(symbolLab.snp.bottom).offset(4)
        }
        ratelLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(pricelLab.snp.bottom).offset(6)
        }
//        kLineV.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalTo(ratelLab.snp.bottom).offset(10)
//            make.height.equalTo(40)
//        }
        btn.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}
