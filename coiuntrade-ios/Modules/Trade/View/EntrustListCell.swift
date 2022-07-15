//
//  EntrustListCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/22.
//

import UIKit

class EntrustListCell: UITableViewCell {
    
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var vType: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var vProgress: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    
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
            self.lblAmount.text = model.num
            self.lblPrice.text = model.price
            self.lblCoin.text = model.coin + " / " + model.currency
            self.lblTime.text = DateManager.getDateByMdStamp(model.create_time)
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
