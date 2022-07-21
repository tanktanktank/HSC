//
//  FuturesHoldingCell.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/15.
//

import UIKit

fileprivate let redColor = UIColor.hexColor("FF4E4F")
fileprivate let greenColor = UIColor.hexColor("02C078")

class FuturesHoldingCell: UITableViewCell {
    
    var adjustClick : NormalBlock?
    var stopPLClick : NormalBlock?
    var closePositionClick : NormalBlock?

    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var leverLabel: UILabel!

    @IBOutlet weak var unrealizedPTitleLLabel: UILabel!
    @IBOutlet weak var unrealizedPLLabel: UILabel!

    @IBOutlet weak var returnRateTitleLabel: UILabel!
    @IBOutlet weak var returnRateLabel: UILabel!
    
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var MarginTitleLabel: UILabel!
    @IBOutlet weak var MarginLabel: UILabel!

    @IBOutlet weak var MarginRateTitleLabel: UILabel!
    @IBOutlet weak var MarginRateLabel: UILabel!

    @IBOutlet weak var openTitleLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!

    @IBOutlet weak var markTitleLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!

    @IBOutlet weak var strongTitleLabel: UILabel!
    @IBOutlet weak var strongLabel: UILabel!
    
    @IBOutlet var titleViews: [UILabel]!
    @IBOutlet var normalValueViews: [UILabel]!
    @IBOutlet var btnViews: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .hexColor("1E1E1E")
        // Initialization code
        unrealizedPTitleLLabel.drawDashLine(strokeColor: .hexColor("989898"), corners: .bottom)
        amountTitleLabel.drawDashLine(strokeColor: .hexColor("989898"), corners: .bottom)
       _ = titleViews.compactMap { label in
            
           label.textColor = .hexColor("989898")
           label.font = FONTR(size: 11)
        }

       _ = btnViews.compactMap { btn in
           
            btn.corner(cornerRadius: 4)
           btn.backgroundColor =  .hexColor("2D2D2D") 
        }
        
        _ = normalValueViews.compactMap({ label in
            
            label.textColor = .hexColor("989898")
            label.font = FONTDIN(size: 14)
        })
        
        unrealizedPLLabel.font = FONTDIN(size: 16)
        returnRateLabel.font = FONTDIN(size: 16)
        unrealizedPLLabel.textColor = redColor
        returnRateLabel.textColor = greenColor

        if #available(iOS 13.0, *) {
            shareBtn.setImage(shareBtn.image(for: .normal)?.withTintColor(.hexColor("8C8C8C")), for: .normal)
        }
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func adjustBtnClick(_ sender: Any) {
    
        self.adjustClick?()
    }
    @IBAction func stopPLBtnClick(_ sender: Any) {
    
        self.stopPLClick?()
    }
    @IBAction func closePositionBtnClick(_ sender: Any) {
        self.closePositionClick?()
    }


    
}
