//
//  MineSafeCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit

class MineSafeCell: BaseTableViewCell {

    var type : RadiusType = .none{
        didSet{
        }
    }
    var isVerify : Bool = false{
        didSet{
            if isVerify {
                detailLab.text = "tv_safe_verified".localized()
                iconView.image = UIImage(named: "mine_verify_yes")
            }else{
                detailLab.text = "tv_safe_unverified".localized()
                iconView.image = UIImage(named: "mine_verify_no")
            }
        }
    }
    
    
    static let CELLID = "MineSafeCell"
//    lazy var bgView : UIView = {
//        let v = UIView()
//        v.backgroundColor = .hexColor("2D2D2D")
//        return v
//    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("FFFFFF")
        return lab
    }()
    
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 13)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .center
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 12, y: 0, width: SCREEN_WIDTH-24, height: self.height)
        
            switch type {
            case .none:
                break
            case .top:
                bgView.addCorner(conrners: [.topLeft,.topRight], radius: 4)
                break
            case .bottom:
                bgView.addCorner(conrners: [.bottomLeft,.bottomRight], radius: 4)
                break
            case .all:
                bgView.corner(cornerRadius: 4)
                break
            }
    }

}
// MARK: - UI
extension MineSafeCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(titleLab)
        bgView.addSubview(detailLab)
        bgView.addSubview(arrow)
    }
    func initSubViewsConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        iconView.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(6)
            make.width.height.equalTo(13)
            make.centerY.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        detailLab.snp.makeConstraints { make in
            make.right.equalTo(arrow.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}
