//
//  FuturesEntrustCell.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/20.
//

import UIKit

class FuturesEntrustCell : UITableViewCell {
    static let CELLID = "FuturesEntrustCell"
    
    lazy var coinLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 14)
        lab.text = "PEOPLEUSDT永续"
        return lab
    }()

    lazy var statusLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 13)
        lab.textColor = .hexColor("02C078")
        lab.textAlignment = .center
        lab.text = "限价 / 买入"
        return lab
    }()
    
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "2022-07-20 04:13:29"
        return lab
    }()
    
    lazy var amountTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "数量(USDT)".localized()
        return lab
    }()
    lazy var priceTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "价格".localized()
        return lab
    }()
    
    lazy var amountLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        lab.text = "20.8/300.0".localized()
        return lab
    }()
    lazy var priceLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        lab.text = "20,800.0".localized()
        return lab
    }()
    
    lazy var triggerTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "触发类型".localized()
        return lab
    }()
    
    lazy var triggerLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        lab.text = "标记价格 ≥ 1,550.00".localized()
        return lab
    }()

 
    lazy var progressV : CircleProgressView = {
        let v = CircleProgressView()
        return v
    }()
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("撤销".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for: .normal)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.titleLabel?.font = FONTR(size: 11)
        btn.corner(cornerRadius: 4)
        return btn
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    
    var isTrigger = false {
        
        didSet{
            
            triggerTitle.isHidden = !isTrigger
            triggerLabel.isHidden = !isTrigger
        }
    }
    
//    var model : EntrustModel = EntrustModel(){
//        didSet{
//
//            self.coinLab.text = model.coin
//            self.currencyLab.text = "/\(model.currency)"
//            self.statusLab.text = model.buy_type_title
//            let foat = (model.buy_rate_num as NSString).floatValue * 0.01*1000.0
//
//            let tmp : Int = NSNumber(value: foat).intValue
//            ///买卖类型：1买，2卖
//            if model.buy_type == 1{
//                self.statusLab.textColor = .hexColor("02C078")
//                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("02C078"),borderWidth: 1)
//                self.progressV.setProgress(tmp, progressColor: .hexColor("02C078"),text: "\(model.buy_rate_num)%")
//            }else{
//                self.statusLab.textColor = .hexColor("F03851")
//                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("F03851"),borderWidth: 1)
//                self.progressV.setProgress(tmp, progressColor: .hexColor("F03851"),text: "\(model.buy_rate_num)%")
//
//            }
//            self.timeLab.text = DateManager.getDateByMdStamp(model.create_time)
//            self.deal_numLab.text = model.deal_num
////            let totalNum : Float = (Float(model.num) ?? 0) + (Float(model.deal_num) ?? 0)
//            self.numLab.text = "/\(model.total_num)"
//            self.priceLab.text = model.price
//        }
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UI
extension FuturesEntrustCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(coinLab)
        self.contentView.addSubview(statusLab)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(amountTitle)
        self.contentView.addSubview(priceTitle)
        self.contentView.addSubview(amountLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(progressV)
        self.contentView.addSubview(cancelBtn)
        self.contentView.addSubview(line)
        
        self.contentView.addSubview(triggerTitle)
        self.contentView.addSubview(triggerLabel)
        triggerTitle.isHidden = !isTrigger
        triggerLabel.isHidden = !isTrigger

        
    }
    func initSubViewsConstraints() {
        
        coinLab.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(LR_Margin)
            make.height.equalTo(20)
            
        }
        
        timeLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(coinLab)
        }

        statusLab.snp.makeConstraints { make in
            make.top.equalTo(coinLab.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(LR_Margin)
            make.height.equalTo(18)
        }
        
        progressV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.top.equalTo(statusLab.snp.bottom).offset(8)
            make.width.height.equalTo(36)
        }

        
        amountTitle.snp.makeConstraints { make in
            make.left.equalTo(progressV.snp.right).offset(12)
            make.top.equalTo(statusLab.snp.bottom).offset(6)
            make.height.equalTo(16)
        }
        
        priceTitle.snp.makeConstraints { make in
            make.left.equalTo(progressV.snp.right).offset(12)
            make.top.equalTo(amountTitle.snp.bottom).offset(6)
            make.height.equalTo(16)
        }
        
        triggerTitle.snp.makeConstraints { make in
            make.left.equalTo(progressV.snp.right).offset(12)
            make.top.equalTo(priceTitle.snp.bottom).offset(6)
            make.height.equalTo(16)
        }

        amountLabel.snp.makeConstraints { make in
            
            make.left.equalTo(progressV.snp.right).offset(87)
            make.centerY.equalTo(amountTitle)
        }
        
        priceLabel.snp.makeConstraints { make in
            
            make.left.equalTo(progressV.snp.right).offset(87)
            make.centerY.equalTo(priceTitle)
        }
        
        triggerLabel.snp.makeConstraints { make in
            
            make.left.equalTo(progressV.snp.right).offset(87)
            make.centerY.equalTo(triggerTitle)
        }

        cancelBtn.corner(cornerRadius: 4)
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalTo(progressV)
            make.width.equalTo(42)
            make.height.equalTo(23)
        }
        
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

