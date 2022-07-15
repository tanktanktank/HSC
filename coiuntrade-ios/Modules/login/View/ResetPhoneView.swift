//
//  ResetPhoneView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit
protocol ResetPhoneViewDelegate {
    func phoneSatisfyResetPhone(isok : Bool)
    
    func clickCountry(sender:QMUIButton)
}
class ResetPhoneView: UIView {
    var delegate:ResetPhoneViewDelegate?
    lazy var phoneTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_phone".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var countryImageV : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 7.5)
        return v
    }()
    ///国家地区
    lazy var countryBtn : QMUIButton = {
        let btn = QMUIButton()
        btn.imagePosition = QMUIButtonImagePosition.left
        btn.setTitle("+ 86", for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 14)
        btn.addTarget(self, action: #selector(tapCountryBtn), for: .touchUpInside)
        return btn
    }()
    lazy var verticalLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var phoneText :UITextField = {
        let v = UITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.keyboardType = .phonePad
        return v
    }()
    
    lazy var line1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var tipIcon : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "alert_tip")
        return v
    }()
    lazy var tipLab : UILabel = {
        let lab = UILabel()
        lab.text = "为了保护您的资产安全，修改密码后该账号将禁用支付服务、提币和C2C卖币24小时。"
        lab.font = FONTR(size: 10)
        lab.textColor = .hexColor("989898")
        lab.numberOfLines = 0
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
extension ResetPhoneView{
    @objc func tapCountryBtn(sender : QMUIButton){
        delegate?.clickCountry(sender: sender)
        print("点击国家")
    }
    @objc func clickPhoneText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
            
            self.delegate?.phoneSatisfyResetPhone(isok: true)
        }else{
            line1.backgroundColor = .hexColor("333333")
            self.delegate?.phoneSatisfyResetPhone(isok: false)
        }
    }
}
extension ResetPhoneView{
    func setUI() {
        self.addSubview(phoneTitleLab)
        self.addSubview(countryImageV)
        self.addSubview(countryBtn)
        self.addSubview(verticalLine)
        self.addSubview(phoneText)
        self.addSubview(line1)
        self.addSubview(tipIcon)
        self.addSubview(tipLab)
        phoneText.addTarget(self, action: #selector(clickPhoneText), for: .editingChanged)
        countryImageV.kf.setImage(with: self.getDefaultCountryicon(), placeholder: nil)
    }
    func initSubViewsConstraints() {
        phoneTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(32)
        }
        countryImageV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.height.equalTo(15)
            make.top.equalTo(phoneTitleLab.snp.bottom).offset(25)
        }
        countryBtn.snp.makeConstraints { make in
            make.left.equalTo(countryImageV.snp.right)
            make.top.equalTo(phoneTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        verticalLine.snp.makeConstraints { make in
            make.centerY.equalTo(countryBtn)
            make.left.equalTo(countryBtn.snp.right).offset(0)
            make.width.equalTo(1)
            make.height.equalTo(15)
        }
        phoneText.snp.makeConstraints { make in
            make.left.equalTo(verticalLine.snp.right).offset(5)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(phoneTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(phoneText.snp.bottom)
        }
        tipIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(line1.snp.bottom).offset(12)
            make.width.height.equalTo(13)
        }
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(tipIcon.snp.right).offset(2)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(tipIcon)
        }
    }
}

