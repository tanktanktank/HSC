//
//  ShowCoinCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/25.
//

import UIKit

class ShowCoinCell: UITableViewCell {
    
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    var model : CoinModel!{
        didSet{
            self.lblCoin.text = model.coin
            self.lblUnit.text = model.detail_code
            self.ivIcon.kf.setImage(with: model.image_str, placeholder:nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
