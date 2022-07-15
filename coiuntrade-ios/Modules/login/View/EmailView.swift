//
//  EmailView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit
protocol EmailViewDelegate {
    
    func emailSatisfyLogin()
}
class EmailView: UIView {
    var delegate:EmailViewDelegate?
    lazy var emailTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_email".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var emailText :UITextField = {
        let v = UITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.clearButtonMode = .whileEditing
        v.keyboardType = .emailAddress
        return v
    }()
    lazy var pwTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_login_password".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
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
    lazy var seeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_nosee"), for: .normal)
        btn.setImage(UIImage(named: "login_see"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn), for: .touchUpInside)
        return btn
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
//MARK: 事件处理
extension EmailView{
    @objc func clickEmailText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPhone = false
        usernameValidLabel.text = ""
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
            if !checkEmail(email: sender.text ?? "") {
                usernameValidLabel.text = "tv_login_error_tip_one".localized()
            }else{
                isPhone = true
            }
        }else{
            line1.backgroundColor = .hexColor("333333")
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
            self.delegate?.emailSatisfyLogin()
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
//MARK: UI
extension EmailView{
    func setUI() {
        self.addSubview(emailTitleLab)
        self.addSubview(emailText)
        self.addSubview(pwTitleLab)
        self.addSubview(pwText)
        self.addSubview(seeBtn)
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(usernameValidLabel)
        self.addSubview(passwordValidLabel)
        emailText.addTarget(self, action: #selector(clickEmailText), for: .editingChanged)
        pwText.addTarget(self, action: #selector(clickPwText), for: .editingChanged)
    }
    func initSubViewsConstraints() {
        emailTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(32)
        }
        emailText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(emailTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line1.snp.makeConstraints { make in
            make.left.right.equalTo(emailText)
            make.height.equalTo(1)
            make.top.equalTo(emailText.snp.bottom)
        }
        usernameValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line1)
            make.right.equalTo(line1)
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(30)
        }
        pwTitleLab.snp.makeConstraints { make in
            make.left.equalTo(emailText)
            make.top.equalTo(line1.snp.bottom).offset(30)
        }
        seeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(40)
            make.top.equalTo(pwTitleLab.snp.bottom).offset(12)
            make.width.equalTo(30)
        }
        pwText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
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
        passwordValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line2)
            make.right.equalTo(line2)
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(30)
        }
    }
}

