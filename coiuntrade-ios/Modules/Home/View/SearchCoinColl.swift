//
//  SearchCoinColl.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit

class SearchCoinColl: UICollectionViewCell {

    @IBOutlet weak var lblCoin: UILabel!
    
    var rModel : RealmCoin!{
        didSet{
            self.lblCoin.text = rModel.coin
        }
    }
    var model : CoinModel!{
        didSet{
            self.lblCoin.text = model.coin
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

