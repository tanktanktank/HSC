//
//  ConutListCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class ConutListCell: UITableViewCell {
    static let CELLID = "ConutListCell"
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 14)
        return lab
    }()
    lazy var codeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 14)
        return lab
    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 12)
        return v
    }()
    var model : CountryModel?{
        didSet{
            nameLab.text = model?.namezh
            codeLab.text = model?.countryphonecode
            iconView.kf.setImage(with: URL(string: model?.countryicon ?? ""), placeholder: UIImage(named: "country_noml"))
        }
    }
    
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
extension ConutListCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(nameLab)
        contentView.addSubview(codeLab)
        contentView.addSubview(iconView)
    }
    func initSubViewsConstraints() {
        nameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        codeLab.snp.makeConstraints { make in
            make.right.equalTo(iconView.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
