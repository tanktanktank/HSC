//
//  TradeShowCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/22.
//

import UIKit

class TradeShowCell: UITableViewCell {

    
    @IBOutlet weak var lblShow: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!

    var type: Bool = false {
        didSet{
            if type == true {
                self.lblShow.textColor = UIColor.HexColor(0x02C078)
                self.vLine.backgroundColor = UIColor.HexColor(0x02C078)
            } else{
                self.lblShow.textColor = UIColor.HexColor(0xF03851)
                self.vLine.backgroundColor = UIColor.HexColor(0xF03851)
            }
        }
    }
    
    var datas: Array<String>! {
        didSet{
            self.lblShow.text =  self.addMicrometerLevel(valueSwift: datas[0])
            self.lblNumber.text = datas[1]
            self.widthLayout.constant = (SCREEN_WIDTH / 2.0) * Double(datas[2])!
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblShow.font = FONTDIN(size: 12)
        self.lblNumber.font = FONTDIN(size: 12)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
