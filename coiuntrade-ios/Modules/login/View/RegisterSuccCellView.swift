//
//  RegisterSuccCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class RegisterSuccCellView: UIView {
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 13)
        return lab
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: UI
extension RegisterSuccCellView{
    func setUI() {
        self.addSubview(iconView)
        self.addSubview(titleLab)
        self.addSubview(detailLab)
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.height.equalTo(21)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.top.equalTo(iconView)
            make.height.equalTo(21)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(2)
        }
    }
}
