//
//  SearchShowCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/27.
//

import UIKit
protocol SearchShowCellDelegate : NSObjectProtocol {
    func clickBtnStart(model : CoinModel , isDelete : Bool)
}
class SearchShowCell: UITableViewCell {
    
    public weak var delegate: SearchShowCellDelegate? = nil
    
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var lblLeverage: UILabel!
    @IBOutlet weak var vLeverage: UIView!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblExtent: UILabel!
    
    @IBOutlet weak var btnStart: UIButton!
    
    var model : CoinModel!{
        didSet{
            self.lblCoin.text = model.coin
            self.lblUnit.text = "/" + model.currency
            self.lblPrice.text = model.new_price
            
            if model.ratio_str.contains(find: "-")
            {
                self.lblExtent.textColor = UIColor.hexColor(0xF03851 )
            } else{
                self.lblExtent.textColor = UIColor.hexColor(0x02C078)
            }
            self.lblExtent.text = model.ratio_str
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnStart.addTarget(self, action: #selector(tapBtnStart), for: .touchUpInside)
    }

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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
