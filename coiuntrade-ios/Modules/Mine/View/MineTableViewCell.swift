//
//  MineTableViewCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/25.
//

import UIKit

enum RadiusType : Int{
    case none = 1
    case top = 2
    case bottom = 3
    case all = 4
}
class MineTableViewCell: BaseTableViewCell {
    var type : RadiusType = .none{
        didSet{
        }
    }
    var isHidddIcon : Bool = false{
        didSet{
            iconView.isHidden = isHidddIcon
            if isHidddIcon {//隐藏icon
                titleLab.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(12)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
    
    static let CELLID = "MineTableViewCell"
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 16)
        lab.textColor = .hexColor("FFFFFF")
        return lab
    }()
    
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 12)
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
        bgView.frame = CGRect(x: LR_Margin, y: 0, width: SCREEN_WIDTH-LR_Margin*2, height: self.height)
        
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
extension MineTableViewCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
//        self.contentView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(titleLab)
        bgView.addSubview(detailLab)
        bgView.addSubview(arrow)
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(17)
            make.centerY.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        titleLab.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        detailLab.snp.makeConstraints { make in
            make.right.equalTo(arrow.snp.left)
            make.centerY.equalToSuperview()
        }
    }
}
