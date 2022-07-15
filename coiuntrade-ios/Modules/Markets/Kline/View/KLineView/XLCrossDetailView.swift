//
//  XLCrossDetailView.swift
//  XLStockChart
//
//  Created by 夏磊 on 2018/11/20.
//  Copyright © 2018 夏磊. All rights reserved.
//

import UIKit

/// 长按详情视图 可自定义
class XLCrossDetailView: UIView {
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: SCREEN_WIDTH, height: 70)
        self.backgroundColor = UIColor.hexColor("282828") //UIColor.xlChart.color(rgba: "#1e1e1e")
        self.setupViews()
    }
    
    // MARK: - Method
    func bind(model: XLKLineModel, preClose: CGFloat) {
        // 时间
        oneLabArray[0].text = String.init(format: "%@: %@", "时间", model.time.xlChart.toTimeString("MM-dd HH:mm"))
        setAttriColor(label: oneLabArray[0], lightStr: "时间")
        // 成交量
        oneLabArray[1].text = String.init(format: "%@: %@", "成交量", model.volumefrom.xlChart.kLineVolNumber())
        setAttriColor(label: oneLabArray[1], lightStr: "成交量")

        // 涨跌额
        let changeVol = calaRiseAndFallVol(model: model, preClose: preClose)
        twoLabArray[0].text = String.init(format: "%@: %@", "涨跌额", changeVol == 0 ? "--" : changeVol.xlChart.kLineVolNumber())
        setAttriColor(label: twoLabArray[0], lightStr: "涨跌额")

        // 开盘
        twoLabArray[1].text = String.init(format: "%@: %@", "开", model.open.xlChart.kLinePriceNumber())
        setAttriColor(label: twoLabArray[1], lightStr: "开")

        // 最高
        twoLabArray[2].text = String.init(format: "%@: %@", "高", model.high.xlChart.kLinePriceNumber())
        setAttriColor(label: twoLabArray[2], lightStr: "高")

        // 涨跌幅
        let changePricePercent = calaRiseAndFallPrice(model: model, preClose: preClose)
        threeLabArray[0].text = String.init(format: "%@: %@", "涨跌幅", changePricePercent == 0 ? "--" : changePricePercent.xlChart.percent())
        setAttriColor(label: threeLabArray[0], lightStr: "涨跌幅")

        // 收盘
        threeLabArray[1].text = String.init(format: "%@: %@", "收", model.close.xlChart.kLinePriceNumber())
        setAttriColor(label: threeLabArray[1], lightStr: "收")

        // 最低
        threeLabArray[2].text =  String.init(format: "%@: %@", "低", model.low.xlChart.kLinePriceNumber())
        setAttriColor(label: threeLabArray[2], lightStr: "低")

    }
    func setAttriColor(label: UILabel, lightStr: String){
        let temLab = label
        let attributedString = NSMutableAttributedString(string: temLab.text!)
        attributedString.setAttributes([.foregroundColor: UIColor.hexColor("989898"), .font:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(0, lightStr.count+1))
        temLab.attributedText = attributedString
    }
    
    
    func calaRiseAndFallVol(model: XLKLineModel, preClose: CGFloat) -> CGFloat {
        return model.close - preClose
    }
    
    func calaRiseAndFallPrice(model: XLKLineModel, preClose: CGFloat) -> CGFloat {
        if preClose == 0 {
            return 0
        }
        
        return (model.close - preClose) / preClose * 100
    }
    
    func updateShow(isVerticl: Bool){
        
        var labels = [oneLabArray[0],twoLabArray[1],twoLabArray[2],threeLabArray[2],threeLabArray[1],twoLabArray[0],threeLabArray[0],oneLabArray[1]]
        if(isVerticl){
            self.frame = CGRect(x: 5, y: self.y, width: 120, height: 192) //192 = 24 * 8

            let labelH = 24
            let labelW = 120
            for i in 0..<labels.count{
                let temLab = labels[i]
                
                temLab.frame = CGRect(x: 6 , y: (i*labelH), width: labelW, height: labelH)
            }
        }else{
            
            labels = [twoLabArray[1],twoLabArray[2],oneLabArray[1],threeLabArray[1],threeLabArray[2],twoLabArray[0],threeLabArray[0],oneLabArray[0]]
            self.frame = CGRect(x: 0, y: self.y, width: SCREEN_WIDTH, height: 70)//210*3 , 70/3

            let topMargin: CGFloat = 10
            let space: CGFloat = 6
            var labelH = 23
            let btnH: CGFloat = (self.bounds.size.height - 2*topMargin - space*2) / 3
            labelH = Int(btnH)
            let offset: CGFloat = 15
            let margin: CGFloat = 0
            let btnW: CGFloat = (SCREEN_WIDTH - offset*2 - margin*2) / 3
            for i in 0..<labels.count{
                let temLab = labels[i]
                if(i < 3){
                    temLab.frame = CGRect(x: Int(btnW + 10) * (i%3) + Int(offset), y: Int(topMargin), width: Int(btnW), height: labelH)
                }else if(i<5){
                    temLab.frame = CGRect(x: Int(btnW + 10) * (i%3) + Int(offset), y: Int(topMargin) + labelH + Int(space), width: Int(btnW), height: labelH)
                }else{
                    temLab.frame = CGRect(x: Int(btnW + 10) * (i-5) + Int(offset), y: Int(topMargin) + (labelH + Int(space))*2, width: Int(btnW), height: labelH)
                }
            }
        }
    }
    
    func setupViews() {
        let offset: CGFloat = 15
        var maxX: CGFloat = offset
        let topMargin: CGFloat = 10
        let space: CGFloat = 6
        let btnH: CGFloat = (self.bounds.size.height - 2*topMargin - space*2) / 3
        let margin: CGFloat = 0
        let btnW: CGFloat = (SCREEN_WIDTH - offset*2 - margin*2) / 3
        
        for i in 0..<3 {
            maxX = offset
            
            let oneLab = UILabel()
            oneLab.adjustsFontSizeToFitWidth = true
            oneLab.frame = CGRect(x: maxX, y: topMargin + CGFloat(i) * (btnH+space), width: btnW, height: btnH)
            oneLab.textColor = UIColor.white
            oneLab.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(oneLab)
            if i == 0 {
                oneLabArray.append(oneLab)
            }else if i == 1 {
                twoLabArray.append(oneLab)
            }else if i == 2 {
                threeLabArray.append(oneLab)
            }
            maxX = oneLab.frame.maxX
            
            
            let twoLab = UILabel()
            twoLab.adjustsFontSizeToFitWidth = true
            twoLab.frame = CGRect(x: maxX + margin + 10, y: topMargin + CGFloat(i) * (btnH+space), width: btnW, height: btnH)
            twoLab.textColor = UIColor.white
            twoLab.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(twoLab)
            if i == 0 {
                oneLabArray.append(twoLab)
            }else if i == 1 {
                twoLabArray.append(twoLab)
            }else if i == 2 {
                threeLabArray.append(twoLab)
            }
            maxX = twoLab.frame.maxX
            
            
            if i == 1 || i == 2 {
                let threeLab = UILabel()
                threeLab.adjustsFontSizeToFitWidth = true
                threeLab.frame = CGRect(x: maxX + margin, y: topMargin + CGFloat(i) * (btnH+space), width: btnW, height: btnH)
                threeLab.textColor = UIColor.white
                threeLab.font = UIFont.systemFont(ofSize: 12)
                self.addSubview(threeLab)
                if i == 1 {
                    twoLabArray.append(threeLab)
                }else if i == 2 {
                    threeLabArray.append(threeLab)
                }
            }
        }
    }
  
    
    // MARK: - Lazy
    lazy var oneLineArray = [KLINETIME, KLINEVOL]
    lazy var twoLineArray = [KLINERISEANDFALLVOL, KLINEOPEN, KLINEHIGH]
    lazy var threeLineArray = [KLINERISEANDFALLPERCENT, KLINECLOSE, KLINELOW]
    lazy var oneLabArray = [UILabel]()
    lazy var twoLabArray = [UILabel]()
    lazy var threeLabArray = [UILabel]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
