//
//  SecurtyEmailView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/7.
//

import UIKit

protocol SecurtyEmailViewDelegate {
    func clickCountry(sender:QMUIButton)
    
    func emailEditingChanged(text : String)
    
    func emailCodeChanged(text : String)
}
class SecurtyEmailView: UIView {
    var delegate:SecurtyEmailViewDelegate?
    lazy var nameTitleLab1 : UILabel = {
        let lab = UILabel()
        lab.text = "tv_input_new_email".localized()
        lab.font = FONTM(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
   
    lazy var emailText :QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.placeholder = "tv_email".localized()
        v.placeholderColor = UIColor.hexColor("989898")
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.keyboardType = .emailAddress
        v.addTarget(self, action: #selector(clickEmailText), for: .editingChanged)
        return v
    }()
    lazy var line1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var nameTitleLab2 : UILabel = {
        let lab = UILabel()
        lab.text = "将发送验证码到您的新邮箱地址"
        lab.font = FONTM(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var emailCodeText : QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.placeholder = "tv_input_email_code_hint".localized()
        v.maximumTextLength = 6
        v.placeholderColor = UIColor.hexColor("989898")
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.keyboardType = .numberPad
        v.addTarget(self, action: #selector(clickEmailCodeText), for: .editingChanged)
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

extension SecurtyEmailView{
    @objc func clickEmailText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        usernameValidLabel.text = ""
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
            if !checkEmail(email: sender.text ?? "") {
                usernameValidLabel.text = "tv_login_error_tip_one".localized()
            }
        }else{
            line1.backgroundColor = .hexColor("333333")
        }
        self.delegate?.emailEditingChanged(text: sender.text ?? "")
    }
    @objc func clickEmailCodeText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        if count > 0 {
            line2.backgroundColor = .hexColor("FCD283")
        }else{
            line2.backgroundColor = .hexColor("333333")
        }
        self.delegate?.emailCodeChanged(text: sender.text ?? "")
    }
}
extension SecurtyEmailView{
    func setUI(){
        self.addSubview(nameTitleLab1)
        self.addSubview(emailText)
        self.addSubview(nameTitleLab2)
        self.addSubview(emailCodeText)
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(sendBtn)
        self.addSubview(usernameValidLabel)
    }
    func initSubViewsConstraints(){
        nameTitleLab1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(32)
        }
        emailText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(nameTitleLab1.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(emailText.snp.bottom)
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
        emailCodeText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(sendBtn.snp.left).offset(-LR_Margin)
            make.top.equalTo(nameTitleLab2.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(emailCodeText.snp.bottom)
        }
    }
}
