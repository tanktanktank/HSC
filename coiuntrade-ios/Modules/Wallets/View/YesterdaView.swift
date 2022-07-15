//
//  YesterdaView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/19.
//

import UIKit

class YesterdaView: UIView {
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTB(size: 10)
        lab.textColor = .hexColor("989898")
        lab.text = "tv_yester_day_value".localized()
        return lab
    }()
    lazy var detailBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "wallets_instructions"), for: .normal)
        return btn
    }()
    ///收益率
    lazy var earningsLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("EBEBEB")
        lab.font = FONTDIN(size: 12)
        lab.text = "-"
        return lab
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "arrow_r")
        return v
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
extension YesterdaView{
    func setUI() {
        self.addSubview(titleLab)
        self.addSubview(detailBtn)
        self.addSubview(earningsLab)
        self.addSubview(arrow)
    }
    func initSubViewsConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        detailBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(18)
            make.height.equalTo(11)
        }
        earningsLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(3)
            make.height.equalTo(16)
        }
        arrow.snp.makeConstraints { make in
            make.left.equalTo(earningsLab.snp.right).offset(10)
            make.centerY.equalTo(earningsLab)
            make.width.equalTo(5)
            make.height.equalTo(10)
//            make.bottom.right.equalToSuperview()
        }
    }
}
