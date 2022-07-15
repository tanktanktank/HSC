//
//  FuturedFlowwaterCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/13.
//

import UIKit

class FuturedFlowwaterCell: UITableViewCell {
    static let CELLID = "FuturedFlowwaterCell"
    lazy var coinLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTM(size: 14)
        v.text = "--"
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
        v.text = "类型".localized()
        return v
    }()
    lazy var typeLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTM(size: 11)
        v.text = "--"
        return v
    }()
    lazy var futuresTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("999999")
        v.font = FONTR(size: 11)
        v.text = "合约".localized()
        return v
    }()
    lazy var futuresLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.font = FONTDIN(size: 11)
        v.text = "--"
        return v
    }()
    lazy var amoutTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("999999")
        v.font = FONTR(size: 11)
        v.text = "总额".localized()
        return v
    }()
    lazy var amoutLab : UILabel = {
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
extension FuturedFlowwaterCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(coinLab)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(typeTitle)
        self.contentView.addSubview(typeLab)
        self.contentView.addSubview(futuresTitle)
        self.contentView.addSubview(futuresLab)
        self.contentView.addSubview(amoutTitle)
        self.contentView.addSubview(amoutLab)
        self.contentView.addSubview(line)
    }
    func initSubViewsConstraints() {
        coinLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(15)
        }
        timeLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(coinLab)
        }
        typeTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(coinLab.snp.bottom).offset(12)
        }
        typeLab.snp.makeConstraints { make in
            make.right.equalTo(timeLab)
            make.centerY.equalTo(typeTitle)
        }
        futuresTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(typeTitle.snp.bottom).offset(12)
        }
        futuresLab.snp.makeConstraints { make in
            make.right.equalTo(timeLab)
            make.centerY.equalTo(futuresTitle)
        }
        amoutTitle.snp.makeConstraints { make in
            make.left.equalTo(coinLab)
            make.top.equalTo(futuresTitle.snp.bottom).offset(12)
        }
        amoutLab.snp.makeConstraints { make in
            make.right.equalTo(timeLab)
            make.centerY.equalTo(amoutTitle)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(amoutTitle.snp.bottom).offset(15)
            make.height.equalTo(0.5)
        }
    }
}
