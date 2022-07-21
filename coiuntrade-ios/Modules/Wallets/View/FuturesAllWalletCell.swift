//
//  FuturesAllWalletCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/20.
//

import UIKit

class FuturesAllWalletCell: UITableViewCell {
    static let CELLID = "FuturesAllWalletCell"
    lazy var iconV : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 9)
        return v
    }()
    lazy var coinName : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 14)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var purseTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "钱包余额".localized() + "（--）"
        return v
    }()
    lazy var purseV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var profitTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "未实现盈亏".localized() + "（--）"
        return v
    }()
    lazy var profitV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var securityTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "保证金余额".localized() + "（--）"
        return v
    }()
    lazy var securityV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var withdrawTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "可提现".localized() + "（--）"
        return v
    }()
    lazy var withdrawV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
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
extension FuturesAllWalletCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        contentView.addSubview(iconV)
        contentView.addSubview(coinName)
        contentView.addSubview(purseTitle)
        contentView.addSubview(purseV)
        contentView.addSubview(profitTitle)
        contentView.addSubview(profitV)
        contentView.addSubview(securityTitle)
        contentView.addSubview(securityV)
        contentView.addSubview(withdrawTitle)
        contentView.addSubview(withdrawV)
        contentView.addSubview(line)
    }
    func initSubViewsConstraints() {
        iconV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(13)
            make.width.height.equalTo(18)
        }
        coinName.snp.makeConstraints { make in
            make.left.equalTo(iconV.snp.right).offset(1)
            make.centerY.equalTo(iconV)
        }
        purseTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(contentView.snp.centerX)
            make.top.equalTo(iconV.snp.bottom).offset(11)
            make.height.equalTo(16)
        }
        purseV.snp.makeConstraints { make in
            make.left.right.equalTo(purseTitle)
            make.top.equalTo(purseTitle.snp.bottom)
            make.height.equalTo(19)
        }
        profitTitle.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.height.equalTo(purseTitle)
        }
        profitV.snp.makeConstraints { make in
            make.left.right.equalTo(profitTitle)
            make.top.height.equalTo(purseV)
        }
        
        securityTitle.snp.makeConstraints { make in
            make.left.right.height.equalTo(purseTitle)
            make.top.equalTo(purseV.snp.bottom).offset(11)
        }
        securityV.snp.makeConstraints { make in
            make.left.right.height.equalTo(purseV)
            make.top.equalTo(securityTitle.snp.bottom)
        }
        withdrawTitle.snp.makeConstraints { make in
            make.left.right.height.equalTo(profitTitle)
            make.top.equalTo(securityTitle)
        }
        withdrawV.snp.makeConstraints { make in
            make.left.right.equalTo(profitTitle)
            make.top.height.equalTo(securityV)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(withdrawV.snp.bottom).offset(11)
            make.height.equalTo(1)
        }
    }
}
