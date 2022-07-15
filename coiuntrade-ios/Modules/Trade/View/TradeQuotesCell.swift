//
//  TradeQuotesCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit

class TradeQuotesCell: UITableViewCell {
    
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    var model : CoinModel!{
        didSet{
            self.lblCoin.text = model.coin
            self.lblCurrency.text =  " / " +  model.currency
            
            let str = String(format: "%.2f", model.ratio_str.toDouble())

            self.lblPrice.text = model.new_price
            if model.isFall {

                self.lblRate.text =  str + "%"
                self.lblRate.textColor = UIColor.hexColor(0xF03851)
                self.lblPrice.textColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblRate.text = "+" + str + "%"
                self.lblRate.textColor = UIColor.hexColor(0x02C078)
                self.lblPrice.textColor = UIColor.hexColor(0x02C078)
            }
        }
    }
    
    var realmModel : RealmCoinModel!{
        didSet{
            self.lblCoin.text = realmModel.coin
            self.lblCurrency.text =  " / " +  realmModel.currency
            
            let str = String(format: "%.2f", realmModel.ratio_str.toDouble())
            self.lblRate.text =  str + "%"
            self.lblPrice.text = realmModel.price
            if realmModel.isFall {
                self.lblRate.textColor = UIColor.hexColor(0xF03851)
                self.lblPrice.textColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblRate.textColor = UIColor.hexColor(0x02C078)
                self.lblPrice.textColor = UIColor.hexColor(0x02C078)
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblPrice.font = FONTDIN(size: 14)
        self.lblRate.font = FONTDIN(size: 12)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
