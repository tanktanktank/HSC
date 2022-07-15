//
//  HomeAuthCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/25.
//

import UIKit

class HomeAuthCell: BaseTableViewCell {
    static let CELLID = "HomeAuthCell"
    var isLogin : Bool = true{
        didSet{
            if !isLogin {
                iconView.isHidden = true
                iconLab.isHidden = false
                authView.isHidden = true
                authLab.isHidden = true
                detailLab.isHidden = true
                copyBtn.isHidden = true
                titleLab.snp.remakeConstraints { make in
                    make.left.equalTo(iconView.snp.right).offset(12)
                    make.centerY.equalToSuperview()
                }
            }else{
                iconView.isHidden = false
                iconLab.isHidden = true
                authView.isHidden = false
                authLab.isHidden = false
                detailLab.isHidden = false
                copyBtn.isHidden = false
                titleLab.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(12)
                    make.left.equalTo(iconView.snp.right).offset(12)
                    make.height.equalTo(25)
                }
            }
        }
    }
    var infoModel :InfoModel? {
        didSet{
            titleLab.text = infoModel?.nick_name
            detailLab.text = "ID" + (infoModel?.user_id ?? "")
            guard let imageStr : String = infoModel?.user_image else {
                iconView.isHidden = false
                iconLab.isHidden = true
                return
            }
            if imageStr.count > 0 {
                iconView.isHidden = false
                iconLab.isHidden = true
                iconView.kf.setImage(with: URL(string: imageStr), placeholder: PlaceholderImg())
            }else{
                iconView.isHidden = true
                iconLab.isHidden = false
                guard let name : String = infoModel?.nick_name else {
                    return
                }
                if name.count>0 {
                    iconLab.text = findFirstLetterFromString(aString: name)
                }
            }
        }
    }
    
    lazy var iconLab : UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .hexColor("1E1E1E")
        lab.textColor = .hexColor("989898")
        lab.textAlignment = .center
        lab.font = FONTM(size: 15)
        lab.text = "N"
        lab.corner(cornerRadius: 15)
        return lab
    }()
    
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 15)
        return v
    }()
    lazy var authView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "mine_authorized_yes")
        return v
    }()
    lazy var authLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 10)
        lab.textColor = .hexColor("02C078")
        lab.corner(cornerRadius: 14)
        lab.backgroundColor = .hexColor("02C078", alpha: 0.2)
        lab.text = "tv_certified".localized()
        lab.textAlignment = .center
        return lab
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
        lab.text = "ID:36409426"
        return lab
    }()
    lazy var copyBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mine_copy"), for: .normal)
        btn.addTarget(self, action: #selector(tapCopyBtn), for: .touchUpInside)
        return btn
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
    
}
extension HomeAuthCell{
    @objc func tapCopyBtn(){
        UIPasteboard.general.string = (infoModel?.invite_code ?? "")
        HudManager.showOnlyText("复制成功".localized())
    }
}
// MARK: - UI
extension HomeAuthCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        bgView.corner(cornerRadius: 4)
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(iconLab)
        bgView.addSubview(titleLab)
        bgView.addSubview(detailLab)
        bgView.addSubview(authView)
        bgView.addSubview(authLab)
        bgView.addSubview(copyBtn)
        bgView.addSubview(arrow)
    }
    func initSubViewsConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        iconLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(iconView.snp.right).offset(12)
            make.height.equalTo(25)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        authView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLab)
            make.left.equalTo(titleLab.snp.right).offset(6)
            make.width.height.equalTo(13)
        }
        authLab.snp.makeConstraints { make in
            make.left.equalTo(authView.snp.right).offset(5)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(50)
            make.height.equalTo(16)
        }
        copyBtn.snp.makeConstraints { make in
            make.left.equalTo(detailLab.snp.right).offset(8)
            make.centerY.equalTo(detailLab)
            make.width.height.equalTo(30)
        }
    }
}
