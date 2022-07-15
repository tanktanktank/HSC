//
//  FaceTouchIDCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit

class FaceTouchIDCell: UITableViewCell {
    ///是否隐藏箭头
    var isHidderArrow : Bool = false{
        didSet{
            arrow.isHidden = isHidderArrow
            if isHidderArrow {//隐藏箭头
                swichView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-12)
                    make.centerY.equalToSuperview()
                }
            }else{
                
            }
        }
    }
    
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("FFFFFF")
        lab.text = "tv_safe_finger".localized()
        return lab
    }()
    
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .center
        return v
    }()
    lazy var swichView : UISwitch = {
        let v = UISwitch()
        return v
    }()
    static let CELLID = "FaceTouchIDCell"
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
extension FaceTouchIDCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        bgView.corner(cornerRadius: 4)
        contentView.addSubview(bgView)
        bgView.addSubview(titleLab)
        bgView.addSubview(arrow)
        bgView.addSubview(swichView)
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
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        swichView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
    }
}
