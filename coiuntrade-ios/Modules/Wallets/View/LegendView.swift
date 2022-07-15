//
//  LegendView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/2.
//

import UIKit

class LegendView: UIView {
    lazy var colorV : UIView = {
        let v = UIView()
        v.corner(cornerRadius: 2)
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 8)
        return lab
    }()
    lazy var vauleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTB(size: 8)
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
extension LegendView{
    func setUI() {
        self.addSubview(colorV)
        self.addSubview(titleLab)
        self.addSubview(vauleLab)
    }
    func initSubViewsConstraints() {
        colorV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(4)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(colorV.snp.right).offset(2)
            make.centerY.equalToSuperview()
        }
        vauleLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
