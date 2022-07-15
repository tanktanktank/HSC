//
//  WeekDayCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class WeekDayCell: UICollectionViewCell {
    
    @IBOutlet weak var vBg: UIView!
    @IBOutlet weak var lblShow: UILabel!
    
    var model : WeekDayModel!{
        didSet{
            if model.isSelect == true {
                self.lblShow.textColor = UIColor.hexColor(0xFCD283)
                self.vBg.backgroundColor = UIColor.hexColor("0xFCD283", alpha: 0.2)
            } else{
                self.lblShow.textColor = UIColor.hexColor(0xEBEBEB)
                self.vBg.backgroundColor = UIColor.hexColor(0x2D2D2D)
            }
            self.lblShow.text = model.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
