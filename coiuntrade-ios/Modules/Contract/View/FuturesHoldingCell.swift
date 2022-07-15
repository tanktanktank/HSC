//
//  FuturesHoldingCell.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/15.
//

import UIKit

class FuturesHoldingCell: UITableViewCell {
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    @IBOutlet weak var leverLabel: UILabel!

    @IBOutlet weak var unrealizedPLLabel: UILabel!
    @IBOutlet weak var unrealizedPTitleLLabel: UILabel!

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


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unrealizedPLLabel.drawDashLine(strokeColor: .hexColor("707070"), corners: .bottom)
        amountTitleLabel.drawDashLine(strokeColor: .hexColor("707070"), corners: .bottom)
       _ = titleViews.map { label in
            
            label.textColor = .red
        }
        
        if #available(iOS 13.0, *) {
            shareBtn.setImage(shareBtn.image(for: .normal)?.withTintColor(.hexColor("8C8C8C")), for: .normal)
        }
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
