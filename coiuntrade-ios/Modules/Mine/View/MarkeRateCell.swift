//
//  MarkeRateCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/7.
//

import UIKit

class MarkeRateCell: UITableViewCell {
    static let CELLID = "MarkeRateCell"
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var selectedView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "klineyes")
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    var model : MarketRateModel?{
        didSet{
            nameLab.text = model?.tocoin ?? ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - UI
extension MarkeRateCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(nameLab)
//        contentView.addSubview(iconView)
        contentView.addSubview(selectedView)
    }
    func initSubViewsConstraints() {
//        iconView.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(12)
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(18)
//        }
        nameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        selectedView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(17)
        }
    }
}
