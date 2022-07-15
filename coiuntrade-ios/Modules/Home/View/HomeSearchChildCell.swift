//
//  HomeSearchChildCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/21.
//

import UIKit

protocol HomeSearchChildCelllDelegate : NSObjectProtocol {
    func clickBtnStart(model : CoinModel , isDelete : Bool)
}
class HomeSearchChildCell: BaseTableViewCell {
    public weak var delegate: HomeSearchChildCelllDelegate? = nil
    static let CELLID = "HomeSearchChildCell"
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
    lazy var lblPrice : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTBINCE(size: 14)
        lab.text = "-"
        return lab
    }()
    lazy var lblRate : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("02C078")
        lab.font = FONTBINCE(size: 12)
        lab.text = "-"
        return lab
    }()
    
    lazy var btnStart : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "searchgaygary"), for: .normal)
        btn.setImage(UIImage(named: "searchgayew"), for: .selected)
        btn.addTarget(self, action: #selector(tapBtnStart), for: .touchUpInside)
        return btn
    }()
    var model : CoinModel = CoinModel(){
        didSet{
            self.coinLab.text = model.coin
            self.currencyLab.text = "/" + model.currency
            self.lblPrice.text = model.new_price
            
            if model.ratio_str.contains(find: "-")
            {
                self.lblRate.textColor = UIColor.hexColor(0xF03851 )
            } else{
                self.lblRate.textColor = UIColor.hexColor(0x02C078)
            }
//            let f = Float(model.ratio_str) ?? 0.0
            self.lblRate.text = self.addTwoDecimalsDownValue(value: model.ratio_str) + "%"
            
            if userManager.isLogin {
                if model.user_like == 1 {
                    self.btnStart.isSelected = true
                }else{
                    self.btnStart.isSelected = false
                }
            }else{
                self.btnStart.isSelected = false
                let array = RealmHelper.queryModel(model: RealmCoinModel())
                for tmp in array {
                    if tmp.coin == model.coin && tmp.currency == model.currency {
                        self.btnStart.isSelected = true
                        break
                    }
                }
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
extension HomeSearchChildCell{
    @objc func tapBtnStart(sender : UIButton){
        sender.isSelected = !sender.isSelected
        if userManager.isLogin {
            if sender.isSelected {
                self.delegate?.clickBtnStart(model: self.model, isDelete: false)
            }else{
                self.delegate?.clickBtnStart(model: self.model, isDelete: true)
            }
        }else{
            if sender.isSelected {
                let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(model.coin)' AND currency = '\(model.currency)'")
                guard let model1 = result.first else {
                    let realmModel = RealmCoinModel()
                    realmModel.coin = model.coin
                    realmModel.currency = model.currency
                    realmModel.price = model.new_price
                    realmModel.ratio_str = model.ratio_str
                    realmModel.deal_num = model.deal_num
                    realmModel.isFall = model.isFall
                    realmModel.id = model.coin + "/" + model.currency
                    realmModel.isSelected = model.isSelected
                    realmModel.price_digit = model.price_digit
                    realmModel.priceColor = model.priceColor
                    RealmHelper.addModel(model: realmModel)
                    NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
                    return
                }
                let updateModel = RealmCoinModel()
                updateModel.coin = model.coin
                updateModel.currency = model.currency
                updateModel.deal_num = model.deal_num
                updateModel.isFall = model.isFall
                updateModel.price = model.new_price
                updateModel.ratio_str = model.ratio_str
                updateModel.id = model.coin + "/" + model.currency
                updateModel.isSelected = model.isSelected
                updateModel.price_digit = model.price_digit
                updateModel.priceColor = model.priceColor
                RealmHelper.updateModel(model: updateModel)
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }else{
                let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(model.coin)' AND currency = '\(model.currency)'")
                guard let aModel = result.first else {
                    return
                }
                RealmHelper.deleteModel(model: aModel)
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }
        }
    }
}
extension HomeSearchChildCell{
    func setUI(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(bgView)
        bgView.addSubview(coinLab)
        bgView.addSubview(currencyLab)
        bgView.addSubview(lblPrice)
        bgView.addSubview(lblRate)
        bgView.addSubview(btnStart)
    }

    func initSubViewsConstraints(){
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        coinLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
        }
        currencyLab.snp.makeConstraints { make in
            make.left.equalTo(coinLab.snp.right)
            make.bottom.equalTo(coinLab).offset(-3)
            make.height.equalTo(8)
        }
        btnStart.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(42)
        }
        lblPrice.snp.makeConstraints { make in
            make.right.equalTo(btnStart.snp.left)
            make.bottom.equalTo(bgView.snp.centerY).offset(-2)
        }
        lblRate.snp.makeConstraints { make in
            make.right.equalTo(lblPrice)
            make.top.equalTo(bgView.snp.centerY).offset(2)
        }
    }
    
}
