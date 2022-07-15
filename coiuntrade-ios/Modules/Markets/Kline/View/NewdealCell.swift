//
//  NewdealCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/11.
//

import UIKit

class NewdealCell: UITableViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    var model : NewdealsModel!{
        didSet{
            self.lblNumber.text = model.Num
            self.lblPrice.text = model.Price
            self.lblDay.text = DateManager.getDateBytimeStamp(Int(model.CreateTime)!)
            
            if model.type == 2 {
                self.lblPrice.textColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblPrice.textColor = UIColor.hexColor(0x02C078)
            }
        }
    }
    var datas: Array<Any>! {
        didSet{
            if datas.count > 3 {
                if datas[0] is String {
                    self.lblPrice.text = self.addMicrometerLevel(valueSwift: datas[0] as? String ?? "")
                }
                if datas[1] is String {
                    self.lblNumber.text = datas[1] as? String
                }
                self.lblDay.text = DateManager.getDateBytimeStamp(Int(datas[2] as! String)!)
                if Int((datas[3] as! String)) == 2 {
                    self.lblPrice.textColor = UIColor.hexColor(0xF03851)
                } else{
                    self.lblPrice.textColor = UIColor.hexColor(0x02C078)
                }
            }

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
