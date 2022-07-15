//
//  HomeSearchHisCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/21.
//

import UIKit

class HomeSearchHisCell: UICollectionViewCell {
    
    static let CELLID = "HomeSearchHisCell"
    
    lazy var labV : UILabel = {
        let v = UILabel()
        v.backgroundColor = .hexColor("2D2D2D")
        v.textAlignment = .center
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTDIN(size: 14)
        v.corner(cornerRadius: 4)
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(labV)
        labV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(27)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
