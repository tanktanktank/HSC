//
//  FuturesHisEntrusCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/13.
//

import UIKit

class FuturesHisEntrusCell: UITableViewCell {
    static let CELLID = "FuturesHisEntrusCell"
    lazy var coinLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTM(size: 14)
        v.text = "--"
        return v
    }()
    lazy var statusV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 9)
        v.textColor = .hexColor("02C078")
        v.textAlignment = .center
        v.corner(cornerRadius: 3, toBounds: true, borderColor: UIColor.hexColor("02C078"), borderWidth: 1)
        v.text = "--"
        return v
    }()
    lazy var arrowV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "futures_arrow_r")
        return v
    }()
    lazy var timeLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTDIN(size: 11)
        v.text = "--"
        return v
    }()
    lazy var typeTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("999999")
        v.font = FONTR(size: 11)
        v.text = "--"
        return v
    }()
    lazy var status_descLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("2C078")
        v.font = FONTR(size: 11)
        v.text = "--"
        return v
    }()
    lazy var numTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("999999")
        v.font = FONTR(size: 11)
        v.text = "数量(--)"
        return v
    }()
    lazy var totalLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTDIN(size: 11)
        v.text = "--/--"
        return v
    }()
    lazy var priceTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("999999")
        v.font = FONTR(size: 11)
        v.text = "价格".localized()
        return v
    }()
    lazy var deal_priceLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTDIN(size: 11)
        v.text = "--"
        return v
    }()
    lazy var priceLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTDIN(size: 11)
        v.text = "/--"
        return v
    }()
    lazy var flat_priceTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("999999")
        v.font = FONTR(size: 11)
        v.text = "强平价格".localized()
        return v
    }()
    lazy var flat_priceLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTDIN(size: 11)
        v.text = "--"
        return v
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: ui
extension FuturesHisEntrusCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(coinLab)
        self.contentView.addSubview(statusV)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(arrowV)
        self.contentView.addSubview(typeTitle)
        self.contentView.addSubview(status_descLab)
        self.contentView.addSubview(numTitle)
        self.contentView.addSubview(totalLab)
        self.contentView.addSubview(priceTitle)
        self.contentView.addSubview(deal_priceLab)
        self.contentView.addSubview(priceLab)
        self.contentView.addSubview(flat_priceTitle)
        self.contentView.addSubview(flat_priceLab)
        self.contentView.addSubview(line)
    }
    func initSubViewsConstraints() {
        coinLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(15)
        }
        statusV.snp.makeConstraints { make in
            make.left.equalTo(coinLab.snp.right).offset(10)
            make.centerY.equalTo(coinLab)
            make.width.equalTo(34)
            make.height.equalTo(15)
        }
        arrowV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(coinLab)
            make.width.equalTo(4)
            make.height.equalTo(6)
        }
        timeLab.snp.makeConstraints { make in
            make.right.equalTo(arrowV.snp.left).offset(-5)
            make.centerY.equalTo(coinLab)
        }
        typeTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(coinLab.snp.bottom).offset(12)
        }
        status_descLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(typeTitle)
        }
        numTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(typeTitle.snp.bottom).offset(12)
        }
        totalLab.snp.makeConstraints { make in
            make.right.equalTo(status_descLab)
            make.centerY.equalTo(numTitle)
        }
        priceTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(numTitle.snp.bottom).offset(12)
        }
        priceLab.snp.makeConstraints { make in
            make.right.equalTo(status_descLab)
            make.centerY.equalTo(priceTitle)
        }
        deal_priceLab.snp.makeConstraints { make in
            make.right.equalTo(priceLab.snp.left)
            make.centerY.equalTo(priceTitle)
        }
        flat_priceTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(priceTitle.snp.bottom).offset(12)
        }
        flat_priceLab.snp.makeConstraints { make in
            make.right.equalTo(status_descLab)
            make.centerY.equalTo(flat_priceTitle)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(flat_priceTitle.snp.bottom).offset(15)
            make.height.equalTo(0.5)
        }
    }
}
