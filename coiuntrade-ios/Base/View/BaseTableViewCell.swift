//
//  BaseTableViewCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/14.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            bgView.backgroundColor = .hexColor("434343")
        }else{
            bgView.backgroundColor = .hexColor("2D2D2D")
        }
    }

}
