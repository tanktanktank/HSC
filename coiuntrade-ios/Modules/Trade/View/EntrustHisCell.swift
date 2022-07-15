//
//  EntrustHisCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/2.
//

import UIKit

class EntrustHisCell: UITableViewCell {
    static let CELLID = "EntrustHisCell"
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
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "cellright")
        return v
    }()
    lazy var amountTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_amount".localized()
        return lab
    }()
    lazy var priceTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_price".localized()
        return lab
    }()
    lazy var deal_numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var deal_priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var status_descLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTR(size: 10)
        lab.backgroundColor = .hexColor("989898")
        lab.corner(cornerRadius: 4)
        lab.textAlignment = .center
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
                self.statusLab.textColor = .hexColor("02C078")
                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("02C078"),borderWidth: 1)
            }else{
                self.statusLab.textColor = .hexColor("F03851")
                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("F03851"),borderWidth: 1)
            }
            self.timeLab.text = DateManager.getDateByYYMdStamp(model.create_time)
            self.deal_numLab.text = model.deal_num
            
            self.numLab.text = "/\(model.total_num)"
            self.deal_priceLab.text = model.deal_price
            self.priceLab.text = "/\(model.price)"
            self.status_descLab.text = model.status_title
            ///订单状态：部分成交-绿  ； 完全成交-绿 ； 已取消-灰色； 待成交-灰色
            ///订单方向：买入绿色 ，  卖出红色
            if model.status == 1 || model.status == 2 {
                self.status_descLab.backgroundColor = .hexColor("02C078", alpha: 0.2)
                self.status_descLab.textColor = .hexColor("02C078")
            }else{
                self.status_descLab.backgroundColor = .hexColor("989898")
                self.status_descLab.textColor = .hexColor("FFFFFF")
            }
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
extension EntrustHisCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(coinLab)
        self.contentView.addSubview(currencyLab)
        self.contentView.addSubview(statusLab)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(arrow)
        self.contentView.addSubview(amountTitle)
        self.contentView.addSubview(priceTitle)
        self.contentView.addSubview(deal_numLab)
        self.contentView.addSubview(numLab)
        self.contentView.addSubview(priceLab)
        self.contentView.addSubview(deal_priceLab)
        self.contentView.addSubview(status_descLab)
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
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(statusLab.snp.bottom).offset(2)
        }
        arrow.snp.makeConstraints { make in
            make.left.equalTo(timeLab.snp.right)
            make.centerY.equalTo(timeLab)
            make.width.height.equalTo(10)
        }
        amountTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(timeLab.snp.bottom).offset(6)
        }
        priceTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(amountTitle.snp.bottom).offset(6)
        }
        numLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(amountTitle)
        }
        deal_numLab.snp.makeConstraints { make in
            make.right.equalTo(numLab.snp.left)
            make.centerY.equalTo(amountTitle)
        }
        priceLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(priceTitle)
        }
        deal_priceLab.snp.makeConstraints { make in
            make.right.equalTo(priceLab.snp.left)
            make.centerY.equalTo(priceTitle)
        }
        status_descLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(coinLab)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
