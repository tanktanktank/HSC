//
//  EntrustMakeCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit

class EntrustMakeCell: UITableViewCell {

    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblHave: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var vType: UIView!
    @IBOutlet weak var lblType: UILabel!
    
    var model : EntrustModel!{
        didSet{
            //翻译
            if model.order_type == 1 {
                self.lblType.text = "Buy"
                self.lblType.textColor = UIColor.HexColor(0x02C078)
                self.vType.layer.borderColor = UIColor.HexColor(0x02C078).cgColor
            } else if model.order_type == 2 {
                self.lblType.text = "Sell"
                self.lblType.textColor = UIColor.HexColor(0x02C078)
                self.vType.layer.borderColor = UIColor.HexColor(0xF03851).cgColor
            }
            
            self.lblCoin.text = model.coin
            self.lblAll.text = "/" + model.price
            self.lblFee.text = model.poundage
            self.lblTotal.text = model.deal_amt
            self.lblHave.text = model.deal_price
            self.lblNumber.text = model.deal_num
            self.lblCurrency.text = model.currency
            self.lblTime.text = DateManager.getDateByYYMdStamp(model.create_time)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vType.layer.borderColor = UIColor.HexColor(0x02C078).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
