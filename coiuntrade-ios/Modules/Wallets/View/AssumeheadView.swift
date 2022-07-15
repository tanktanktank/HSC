//
//  AssumeheadView.swift
//  test
//
//  Created by tfr on 2022/4/19.
//

import UIKit

class AssumeheadView: UIView {
    lazy var topLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var bottomLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var totalTitleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTB(size: 10)
        lab.textColor = .hexColor("989898")
        lab.text = "tv_fund_total_value".localized() + "(BTC)"
        return lab
    }()
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTB(size: 26)
        lab.textColor = .hexColor("EBEBEB")
        lab.text = "2.355868"
        return lab
    }()
    lazy var seeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "wallets_see"), for: .normal)
        return btn
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


extension AssumeheadView{
    func setUI() {
        self.addSubview(topLine)
        self.addSubview(bgView)
        self.addSubview(bottomLine)
        bgView.addSubview(totalTitleLab)
        bgView.addSubview(totalLab)
        bgView.addSubview(seeBtn)
    }
    func initSubViewsConstraints() {
        self.topLine.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        self.bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topLine.snp.bottom)
            make.height.equalTo(100)
        }
        self.bottomLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.bgView.snp.bottom)
            make.height.equalTo(5)
        }
        totalTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(27)
        }
        seeBtn.snp.makeConstraints { make in
            make.left.equalTo(totalTitleLab.snp.right).offset(5)
            make.centerY.equalTo(totalTitleLab)
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
        totalLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(totalTitleLab.snp.bottom).offset(4)
        }
    }
}
