//
//  SellShowCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/29.
//

import UIKit

class SellShowCell: UITableViewCell {
    
    @IBOutlet weak var lblShow: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    
    var datas: Array<String>! {
        didSet{
            self.lblShow.text = self.addMicrometerLevel(valueSwift: datas[0]) //datas[0]
            self.lblNumber.text = datas[1]
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
