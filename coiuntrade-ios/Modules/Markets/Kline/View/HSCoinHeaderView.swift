//
//  HSCoinHeaderView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/11.
//

import UIKit

class HSCoinHeaderView: UIView {
    
    var isAgreement: Bool = false{
        didSet{
            if(isAgreement){
                if(isAgreement){
                    addMarketLab()
                }
            }
        }
    }
    var tickerM: Ticker24Model?{
        
        didSet{
            priceLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: tickerM?.new_price ?? "", digit: tickerM?.price_digit ?? ""))
            pricePercentLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: tickerM?.ratio ?? "", digit: tickerM?.price_digit ?? "")) + "%"
            priceRateLab.text = self.addRateSymbol(value: tickerM?.new_price ?? "")

            oneDayVolLab.text = "24h Vol(" + (tickerM?.coin ?? "") + ")"
            oneDayAmoLab.text = "24h Vol(" + (tickerM?.currency ?? "") + ")"
            dayHightValueLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: tickerM?.high_price ?? "", digit: tickerM?.price_digit ?? ""))
            dayLowValueLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: tickerM?.low_price ?? "", digit: tickerM?.price_digit ?? ""))
            dayVolValueLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: tickerM?.deal_num ?? "", digit: tickerM?.price_digit ?? ""))
            dayAmoValueLab.text = HSCoinCalculate.calculateCoin(coin:tickerM?.deal_amt ?? "")
            
            if ( (tickerM?.ratio_str ?? "").hasPrefix("-")){
                priceLab.textColor = UIColor.hexColor("F03851",alpha: 0.9)
                pricePercentLab.textColor = UIColor.hexColor("F03851",alpha: 0.9)
            } else{
                priceLab.textColor = UIColor.hexColor("02C078",alpha: 0.9)
                pricePercentLab.textColor = UIColor.hexColor("02C078",alpha: 0.9)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    
    func addMarketLab(){
        addSubview(marketLab)
        priceLab.snp.updateConstraints { make in
            make.top.equalTo(12)
        }
        marketLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(priceRateLab.snp.bottom)
            make.height.equalTo(16)
        }
    }
    
    func setupUI(){
        
        addSubview(priceLab)
        addSubview(priceRateLab)
        addSubview(pricePercentLab)
        addSubview(rightView)

        
        rightView.addSubview(oneDayHightLab)
        rightView.addSubview(oneDayLowLab)
        rightView.addSubview(oneDayVolLab)
        rightView.addSubview(oneDayAmoLab)

        rightView.addSubview(dayHightValueLab)
        rightView.addSubview(dayLowValueLab)
        rightView.addSubview(dayVolValueLab)
        rightView.addSubview(dayAmoValueLab)
    }
    
    func setupConstraints(){
        
        rightView.snp.makeConstraints { make in
            
            make.width.equalTo(160)
            make.right.top.bottom.equalToSuperview()
        }
        
        priceLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(23)
            make.height.equalTo(45)
        }
        priceRateLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(priceLab.snp.bottom)
            make.height.equalTo(16)
        }
        pricePercentLab.snp.makeConstraints { make in
            make.left.equalTo(priceRateLab.snp.right).offset(4)
            make.top.equalTo(priceLab.snp.bottom)
            make.height.equalTo(16)
        }
        
        oneDayHightLab.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(50)
        }
        
        oneDayLowLab.snp.makeConstraints { make in
            make.top.equalTo(oneDayHightLab.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(50)
        }
        
        oneDayVolLab.snp.makeConstraints { make in
            make.top.equalTo(oneDayLowLab.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(75)
        }
        
        oneDayAmoLab.snp.makeConstraints { make in
            make.top.equalTo(oneDayVolLab.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(75)
        }
        
        dayHightValueLab.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(oneDayHightLab)
            make.left.equalTo(oneDayHightLab.snp.right).offset(4)
            make.height.equalTo(12)
        }
        
        dayLowValueLab.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(oneDayLowLab)
            make.left.equalTo(oneDayLowLab.snp.right).offset(4)
            make.height.equalTo(12)
        }
        
        dayVolValueLab.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(oneDayVolLab)
            make.left.equalTo(oneDayVolLab.snp.right).offset(4)
            make.height.equalTo(12)
        }
        
        dayAmoValueLab.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(oneDayAmoLab)
            make.left.equalTo(oneDayAmoLab.snp.right).offset(4)
            make.height.equalTo(12)
        }
    }
    
    
    
    lazy var priceLab: UILabel = {
        
        let lab = UILabel()
        lab.font = FONTDIN(size: 32)
        lab.textColor = .white
        lab.text = "0.00"
        return lab
    }()
    
    lazy var marketLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 13)
        lab.textColor = .lightGray
        lab.text = "标记价格 22,854.0"
        return lab
    }()
    
    lazy var priceRateLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 13)
        lab.textColor = .white
        lab.text = "≈ 0.00"
        return lab
    }()
    
    lazy var pricePercentLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textColor = .white
        lab.text = "0.00%"
        return lab
    }()
    
    lazy var rightView: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var oneDayHightLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("979797")
        lab.text = "24h High"
        return lab
    }()
    
    lazy var oneDayLowLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("979797")
        lab.text = "24h Low"
        return lab
    }()
    
    lazy var oneDayVolLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("979797")
        lab.text = "24h Vol(BTC)"
        return lab
    }()
    
    lazy var oneDayAmoLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("979797")
        lab.text = "24h Vol(USDT)"
        return lab
    }()
    
    lazy var dayHightValueLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "0.00"
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var dayLowValueLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "0.00"
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var dayVolValueLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "0.00"
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var dayAmoValueLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "0.00"
        lab.textAlignment = .right
        return lab
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
