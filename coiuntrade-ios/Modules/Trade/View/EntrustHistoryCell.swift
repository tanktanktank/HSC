//
//  EntrustHistoryCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/22.
//

import UIKit

class EntrustHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var vType: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var vStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
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
            switch model.status {
            case 1:
                self.lblStatus.text = "部分成交"
                self.lblStatus.textColor = .white
                self.vStatus.backgroundColor = UIColor.hexColor(0x989898)
            case 2:
                self.lblStatus.text = "完全成交"
                self.lblStatus.textColor = UIColor.hexColor(0x02C078)
                self.vStatus.backgroundColor = UIColor.hexColor("0x02C078", alpha: 0.2)
            case 4:
                self.lblStatus.text = "已取消"
                self.lblStatus.textColor = UIColor.hexColor(0xF03851)
                self.vStatus.backgroundColor = UIColor.hexColor("0xF03851", alpha: 0.2)
            default:
                self.lblStatus.text = "未成交"
                self.lblStatus.textColor = .white
                self.vStatus.backgroundColor = UIColor.hexColor(0x989898)
            }
            self.lblCoin.text = model.coin
            self.lblCurrency.text = model.currency
            self.lblTime.text = DateManager.getDateByYYMdStamp(model.create_time)
            
            self.lblAmount.text = model.deal_num
            self.lblTotal.text = model.deal_price
            self.lblTotalAmount.text = "/" + model.num
            self.lblTotalPrice.text = "/" + model.price
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
