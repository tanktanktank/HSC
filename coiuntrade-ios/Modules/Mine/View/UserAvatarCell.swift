//
//  UserAvatarCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/26.
//

import UIKit

class UserAvatarCell: UITableViewCell {
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "mine_avatar")
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("FFFFFF")
        lab.text = "tv_head_image".localized()
        return lab
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898")
        return v
    }()
    
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 12)
        lab.textColor = .hexColor("989898")
        lab.text = "tv_preference_tip".localized()
        return lab
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .center
        return v
    }()
    lazy var avatarView : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 15)
//        v.image = UIImage(named: "mine_avatar")
        return v
    }()
    static let CELLID = "UserAvatarCell"
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
extension UserAvatarCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        contentView.addSubview(iconView)
        contentView.addSubview(titleLab)
        contentView.addSubview(detailLab)
        contentView.addSubview(arrow)
        contentView.addSubview(line)
        contentView.addSubview(avatarView)
    }
    func initSubViewsConstraints() {
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(20)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(4)
            make.centerY.equalTo(iconView)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        avatarView.snp.makeConstraints { make in
            make.right.equalTo(arrow.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(iconView.snp.bottom)
            make.bottom.equalTo(line.snp.top)
        }
    }
}
