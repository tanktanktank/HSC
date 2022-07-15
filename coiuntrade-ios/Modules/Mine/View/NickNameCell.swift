//
//  NickNameCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/26.
//

import UIKit

class NickNameCell: UITableViewCell {
    
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "mine_edit")
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("FFFFFF")
        lab.text = "tv_nick_name".localized()
        return lab
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898")
        return v
    }()
    lazy var textV : QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("989898")
        v.font = FONTR(size: 12)
        v.maximumTextLength = 15
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        return v
    }()
    static let CELLID = "NickNameCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
// MARK: - UI
extension NickNameCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        contentView.addSubview(iconView)
        contentView.addSubview(titleLab)
        contentView.addSubview(line)
        contentView.addSubview(textV)
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.height.equalTo(20)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(4)
            make.centerY.equalTo(iconView)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        textV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(iconView.snp.bottom)
            make.bottom.equalTo(line.snp.top)
        }
    }
}
