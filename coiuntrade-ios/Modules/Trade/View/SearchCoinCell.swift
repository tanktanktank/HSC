//
//  SearchCoinCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit

class SearchCoinCell: UITableViewCell {
    
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var vBg: UIView!
    
    var model : CoinModel!{
        didSet{
            if model.isFrist
            {
                let topCorner: UIRectCorner = [.topLeft, .topRight]
                self.vBg.addCornerFrame(conrners: topCorner, radius: 4, frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 24, height: 56))
                self.lblUnit.text = ""
            } else{
                self.lblUnit.text = "/ " + model.currency
            }
            if model.isLast
            {
                let bottomCorner: UIRectCorner = [.bottomLeft, .bottomRight]
                self.vBg.addCornerFrame(conrners: bottomCorner, radius: 4, frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 24, height: 56))
            }
            self.lblCoin.text = model.coin
            
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
