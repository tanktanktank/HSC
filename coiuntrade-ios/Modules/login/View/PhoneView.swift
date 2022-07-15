//
//  PhoneView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit

protocol PhoneViewDelegate {
    func clickCountry(sender:QMUIButton)
    
    func phoneSatisfyLogin()
}
class PhoneView: UIView {

    var delegate:PhoneViewDelegate?
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
    lazy var phoneText :QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.keyboardType = .numberPad
        return v
    }()
    lazy var pwTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_login_password".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var seeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_nosee"), for: .normal)
        btn.setImage(UIImage(named: "login_see"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn), for: .touchUpInside)
        return btn
    }()
    lazy var pwText :QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.maximumTextLength = 16
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.isSecureTextEntry = true
        return v
    }()
    lazy var line1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var line2 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var usernameValidLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("E35461")
        lab.font = FONTR(size: 11)
        return lab
    }()
    lazy var passwordValidLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("E35461")
        lab.font = FONTR(size: 11)
        return lab
    }()
    var isPhone = false
    var isPwd = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension PhoneView{
    @objc func tapCountryBtn(sender : QMUIButton){
        print("点击国家")
        delegate?.clickCountry(sender: sender)
    }
    @objc func clickPhoneText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPhone = false
        usernameValidLabel.text = ""
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
            isPhone = true
        }else{
            line1.backgroundColor = .hexColor("333333")
        }
        if isPhone,isPwd {
            self.delegate?.phoneSatisfyLogin()
        }
    }
    @objc func clickPwText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPwd = false
        passwordValidLabel.text = ""
        if count > 0 {
            line2.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                passwordValidLabel.text = "tv_login_error_tip_two".localized()
            }else{
                isPwd = true
            }
        }else{
            line2.backgroundColor = .hexColor("333333")
        }
        if isPhone,isPwd {
            self.delegate?.phoneSatisfyLogin()
        }
    }
    ///明文密文
    @objc func tapSeeBtn(sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            pwText.isSecureTextEntry = false
        }else{
            pwText.isSecureTextEntry = true
        }
    }
}
extension PhoneView{
    func setUI() {
        self.addSubview(phoneTitleLab)
        self.addSubview(countryImageV)
        self.addSubview(countryBtn)
        self.addSubview(verticalLine)
        self.addSubview(phoneText)
        self.addSubview(pwTitleLab)
        self.addSubview(pwText)
        self.addSubview(seeBtn)
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(usernameValidLabel)
        self.addSubview(passwordValidLabel)
        phoneText.addTarget(self, action: #selector(clickPhoneText), for: .editingChanged)
        pwText.addTarget(self, action: #selector(clickPwText), for: .editingChanged)
        
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
        pwTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(line1.snp.bottom).offset(30)
        }
        seeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(40)
            make.top.equalTo(pwTitleLab.snp.bottom).offset(12)
            make.width.equalTo(30)
        }
        pwText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(seeBtn.snp.left).offset(-5)
            make.top.equalTo(pwTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(pwText.snp.bottom)
        }
        usernameValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line1)
            make.right.equalTo(line1)
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(30)
        }
        passwordValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line2)
            make.right.equalTo(line2)
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(30)
        }
    }
}
