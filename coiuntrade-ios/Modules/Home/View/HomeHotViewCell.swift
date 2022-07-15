//
//  HomeHotViewCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/7.
//

import UIKit

class HomeHotViewCell: UITableViewCell {
    
    static let CELLID = "HomeHotViewCell"
    
    lazy var coinLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTBINCE(size: 15)
        lab.text = "-"
        return lab
    }()
    lazy var currencyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTBINCE(size: 11)
        lab.text = "/-"
        return lab
    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "homehot")
        return v
    }()
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 16)
        lab.text = "-"
        return lab
    }()
    lazy var status_descLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 14)
        lab.backgroundColor = .hexColor("989898")
        lab.corner(cornerRadius: 4)
        lab.textAlignment = .center
        lab.text = "-%"
        return lab
    }()
    var model : CoinModel = CoinModel(){
        didSet{
            self.coinLab.text = model.coin
            self.currencyLab.text = "/\(model.currency)"
            self.priceLab.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: model.new_price, digit: model.price_digit))
//            let f = Float(model.ratio_str) ?? 0.0
            if model.isFall {
                self.status_descLab.text = self.addTwoDecimalsDownValue(value: model.ratio_str) + "%"
                self.status_descLab.backgroundColor = UIColor.hexColor(0xF03851)
            } else{
                self.status_descLab.text = "+" + self.addTwoDecimalsDownValue(value: model.ratio_str) + "%"
                self.status_descLab.backgroundColor = UIColor.hexColor(0x02C078)
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
extension HomeHotViewCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(coinLab)
        self.contentView.addSubview(currencyLab)
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(priceLab)
        self.contentView.addSubview(status_descLab)
    }
    func initSubViewsConstraints() {
        coinLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
        }
        currencyLab.snp.makeConstraints { make in
            make.left.equalTo(coinLab.snp.right)
            make.bottom.equalTo(coinLab).offset(-3)
            make.height.equalTo(8)
        }
        iconView.snp.makeConstraints { make in
            make.left.equalTo(currencyLab.snp.right).offset(10)
            make.bottom.equalTo(currencyLab)
            make.width.equalTo(11.5)
            make.height.equalTo(14.5)
        }
        status_descLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.width.equalTo(85)
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
        }
        priceLab.snp.makeConstraints { make in
            make.right.equalTo(status_descLab.snp.left).offset(-32)
            make.centerY.equalToSuperview()
        }
    }
}
