//
//  EntrustMakCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/6.
//

import UIKit

class EntrustMakCell: UITableViewCell {
    static let CELLID = "EntrustMakCell"
    lazy var coinLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 14)
        lab.text = "-"
        return lab
    }()
    lazy var currencyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 14)
        lab.text = "/-"
        return lab
    }()
    lazy var statusLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 9)
        lab.textColor = .hexColor("02C078")
        lab.textAlignment = .center
        lab.text = "--"
        lab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("02C078"),borderWidth: 1)
        return lab
    }()
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var priceTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_price".localized()
        return lab
    }()
    lazy var amountTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_amount".localized()
        return lab
    }()
    lazy var poundageTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_order_rate".localized()
        return lab
    }()
    lazy var amtTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_deal_total".localized()
        return lab
    }()
    
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
//    lazy var deal_priceLab : UILabel = {
//        let lab = UILabel()
//        lab.textColor = .hexColor("FFFFFF")
//        lab.font = FONTM(size: 11)
//        return lab
//    }()
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var poundageLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var amtLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    var model : EntrustModel = EntrustModel(){
        didSet{
            self.coinLab.text = model.coin
            self.currencyLab.text = "/\(model.currency)"
            self.statusLab.text = model.buy_type_title
            if model.buy_type == 1{
                self.poundageTitle.text = "tv_trade_order_rate".localized() + "(\(model.coin))"
                self.statusLab.textColor = .hexColor("02C078")
                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("02C078"),borderWidth: 1)
            }else{
                self.poundageTitle.text = "tv_trade_order_rate".localized() + "(\(model.currency))"
                self.statusLab.textColor = .hexColor("F03851")
                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("F03851"),borderWidth: 1)
            }
            self.timeLab.text = DateManager.getDateByYYMdStamp(model.create_time)
            self.priceTitle.text = "tv_trade_price".localized() + "(\(model.currency))"
            self.amountTitle.text = "tv_trade_order_complete_account".localized() + "(\(model.coin))"
            self.amtTitle.text = "tv_deal_total".localized() + "(\(model.currency))"
            self.priceLab.text = model.price
            self.numLab.text = model.num
            self.poundageLab.text = model.poundage
            self.amtLab.text = model.deal_amt
            
        }
    }
    
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
extension EntrustMakCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(coinLab)
        self.contentView.addSubview(currencyLab)
        self.contentView.addSubview(statusLab)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(amountTitle)
        self.contentView.addSubview(priceTitle)
        self.contentView.addSubview(poundageTitle)
        self.contentView.addSubview(amtTitle)
        self.contentView.addSubview(numLab)
        self.contentView.addSubview(priceLab)
        self.contentView.addSubview(poundageLab)
        self.contentView.addSubview(amtLab)
        self.contentView.addSubview(line)
    }
    func initSubViewsConstraints() {
        coinLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20)
        }
        currencyLab.snp.makeConstraints { make in
            make.left.equalTo(coinLab.snp.right)
            make.centerY.equalTo(coinLab)
        }
        statusLab.snp.makeConstraints { make in
            make.left.equalTo(currencyLab.snp.right).offset(10)
            make.centerY.equalTo(coinLab)
            make.width.equalTo(34)
            make.height.equalTo(15)
        }
        timeLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(coinLab)
        }
        priceTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(coinLab.snp.bottom).offset(12)
        }
        amountTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(priceTitle.snp.bottom).offset(6)
        }
        poundageTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(amountTitle.snp.bottom).offset(6)
        }
        amtTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(poundageTitle.snp.bottom).offset(6)
        }
        priceLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(priceTitle)
        }
        numLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(amountTitle)
        }
        poundageLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(poundageTitle)
        }
        amtLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(amtTitle)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
