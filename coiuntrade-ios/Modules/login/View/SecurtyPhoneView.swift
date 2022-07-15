//
//  SecurtyPhoneView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/7.
//

import UIKit
protocol SecurtyPhoneViewDelegate {
    func clickCountry(sender:QMUIButton)
    
    func phoneEditingChanged(text : String)
    
    func phoneCodeChanged(text : String)
}
class SecurtyPhoneView: UIView {
    var delegate:SecurtyPhoneViewDelegate?
    lazy var nameTitleLab1 : UILabel = {
        let lab = UILabel()
        lab.text = "tv_input_new_phone".localized()
        lab.font = FONTM(size: 14)
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
        v.addTarget(self, action: #selector(clickPhoneText), for: .editingChanged)
        return v
    }()
    lazy var line1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var nameTitleLab2 : UILabel = {
        let lab = UILabel()
        lab.text = "请输入短信验证码"
        lab.font = FONTM(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var phoneCodeText : QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.placeholder = "tv_input_phone_code_hint".localized()
        v.maximumTextLength = 6
        v.placeholderColor = UIColor.hexColor("989898")
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.keyboardType = .numberPad
        v.addTarget(self, action: #selector(clickPhoneCodeText), for: .editingChanged)
        return v
    }()
    lazy var line2 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var sendBtn : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 13)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    lazy var usernameValidLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("E35461")
        lab.font = FONTR(size: 11)
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
extension SecurtyPhoneView{
    @objc func tapCountryBtn(sender : QMUIButton){
        print("点击国家")
        delegate?.clickCountry(sender: sender)
    }
    @objc func clickPhoneText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        usernameValidLabel.text = ""
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
        }else{
            line1.backgroundColor = .hexColor("333333")
        }
        self.delegate?.phoneEditingChanged(text: sender.text ?? "")
    }
    @objc func clickPhoneCodeText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        if count > 0 {
            line2.backgroundColor = .hexColor("FCD283")
        }else{
            line2.backgroundColor = .hexColor("333333")
        }
        self.delegate?.phoneCodeChanged(text: sender.text ?? "")
    }
}
extension SecurtyPhoneView{
    func setUI(){
        self.addSubview(nameTitleLab1)
        self.addSubview(countryImageV)
        self.addSubview(countryBtn)
        self.addSubview(verticalLine)
        self.addSubview(phoneText)
        self.addSubview(nameTitleLab2)
        self.addSubview(phoneCodeText)
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(sendBtn)
        self.addSubview(usernameValidLabel)
        countryImageV.kf.setImage(with: self.getDefaultCountryicon(), placeholder: nil)
    }
    func initSubViewsConstraints(){
        nameTitleLab1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(32)
        }
        countryImageV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.height.equalTo(15)
            make.top.equalTo(nameTitleLab1.snp.bottom).offset(25)
        }
        countryBtn.snp.makeConstraints { make in
            make.left.equalTo(countryImageV.snp.right)
            make.top.equalTo(nameTitleLab1.snp.bottom).offset(12)
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
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(nameTitleLab1.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(phoneText.snp.bottom)
        }
        usernameValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line1)
            make.right.equalTo(line1)
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(30)
        }
        nameTitleLab2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(line1.snp.bottom).offset(30)
        }
        sendBtn.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        sendBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(nameTitleLab2.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        phoneCodeText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(sendBtn.snp.left).offset(-LR_Margin)
            make.top.equalTo(nameTitleLab2.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(phoneCodeText.snp.bottom)
        }
    }
}
