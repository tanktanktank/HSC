//
//  BuyShowCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/13.
//

import UIKit

class BuyShowCell: UITableViewCell {
    
    @IBOutlet weak var lblShow: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    
    var datas: Array<String>! {
        didSet{
            //datas[0] 价格， datas[1] 量， datas[2] 深度 ；lblShow左边， lblNumber 右边
            self.lblShow.text = datas[1]
            self.lblNumber.text = self.addMicrometerLevel(valueSwift: datas[0]) //datas[0]
            self.widthLayout.constant = (SCREEN_WIDTH / 2.0) * Double(datas[2])!
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
