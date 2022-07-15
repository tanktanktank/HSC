//
//  RegisterEmailView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

protocol RegisterEmailViewDelegate {
    func phoneSatisfyRegisterEmail()
}
class RegisterEmailView: UIView {
    var delegate:RegisterEmailViewDelegate?
    lazy var backView : BaseScrollView = {
        let v = BaseScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.bounces = false
        return v
    }()
    lazy var emailTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_email".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var emailText :QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
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
    lazy var againPwTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_login_password".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var againPwText :QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.maximumTextLength = 16
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.isSecureTextEntry = true
        return v
    }()
    ///推荐
    var reTitleLab  = WLOptionView(frame: .zero, type: .btnType)
    
    lazy var reText :UITextField = {
        let v = UITextField()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.isHidden = true
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
    lazy var line3 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var line4 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        v.isHidden = true
        return v
    }()
    lazy var seeBtn1 : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_nosee"), for: .normal)
        btn.setImage(UIImage(named: "login_see"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn1), for: .touchUpInside)
        return btn
    }()
    lazy var seeBtn2 : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_nosee"), for: .normal)
        btn.setImage(UIImage(named: "login_see"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn2), for: .touchUpInside)
        return btn
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
    lazy var passwordValid1Label : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("E35461")
        lab.font = FONTR(size: 11)
        return lab
    }()
    
    var isPhone = false
    var isPwd1 = false
    var isPwd2 = false
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
extension RegisterEmailView{
    ///明文密文
    @objc func tapSeeBtn1(sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            pwText.isSecureTextEntry = false
        }else{
            pwText.isSecureTextEntry = true
        }
    }
    ///明文密文
    @objc func tapSeeBtn2(sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            againPwText.isSecureTextEntry = false
        }else{
            againPwText.isSecureTextEntry = true
        }
    }
    
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
        if isPhone,isPwd1,isPwd2 {
            self.delegate?.phoneSatisfyRegisterEmail()
        }
    }
    @objc func clickPwText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPwd1 = false
        passwordValidLabel.text = ""
        if count > 0 {
            line2.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                passwordValidLabel.text = "tv_login_error_tip_two".localized()
            }else{
                isPwd1 = true
            }
        }else{
            line2.backgroundColor = .hexColor("333333")
        }
        if isPhone,isPwd1,isPwd2 {
            self.delegate?.phoneSatisfyRegisterEmail()
        }
    }
    @objc func clickAgainPwTextb(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPwd2 = false
        passwordValid1Label.text = ""
        if count > 0 {
            line3.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                passwordValid1Label.text = "tv_login_error_tip_two".localized()
            }else{
                isPwd2 = true
            }
        }else{
            line3.backgroundColor = .hexColor("333333")
        }
        if isPhone,isPwd1,isPwd2 {
            self.delegate?.phoneSatisfyRegisterEmail()
        }
    }
    @objc func clickReText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        if count > 0 {
            line4.backgroundColor = .hexColor("FCD283")
        }else{
            line4.backgroundColor = .hexColor("333333")
        }
    }
}
extension RegisterEmailView{
    func setUI() {
        self.addSubview(backView)
        backView.addSubview(emailTitleLab)
        backView.addSubview(emailText)
        backView.addSubview(pwTitleLab)
        backView.addSubview(pwText)
        backView.addSubview(againPwTitleLab)
        backView.addSubview(againPwText)
        backView.addSubview(line1)
        backView.addSubview(line2)
        backView.addSubview(line3)
        backView.addSubview(reTitleLab)
        backView.addSubview(reText)
        backView.addSubview(line4)
        backView.addSubview(seeBtn1)
        backView.addSubview(seeBtn2)
        backView.addSubview(usernameValidLabel)
        backView.addSubview(passwordValidLabel)
        backView.addSubview(passwordValid1Label)
        emailText.addTarget(self, action: #selector(clickEmailText), for: .editingChanged)
        pwText.addTarget(self, action: #selector(clickPwText), for: .editingChanged)
        againPwText.addTarget(self, action: #selector(clickAgainPwTextb), for: .editingChanged)
        reText.addTarget(self, action: #selector(clickReText), for: .editingChanged)
        
        reTitleLab.title = "tv_referrer_id".localized()
        reTitleLab.clickBlock {[weak self] isDirectionUp in
            self?.reText.isHidden = !isDirectionUp
            self?.line4.isHidden = !isDirectionUp
            
        }
    }
    func initSubViewsConstraints() {
        backView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        emailTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview().offset(32)
            make.width.equalTo(SCREEN_WIDTH-LR_Margin*2)
        }
        emailText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(emailTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(emailText.snp.bottom)
        }
        pwTitleLab.snp.makeConstraints { make in
            make.left.equalTo(emailText)
            make.top.equalTo(line1.snp.bottom).offset(30)
        }
        seeBtn1.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(40)
            make.top.equalTo(pwTitleLab.snp.bottom).offset(12)
            make.width.equalTo(30)
        }
        pwText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(seeBtn1.snp.left).offset(-5)
            make.top.equalTo(pwTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(pwText.snp.bottom)
        }
        againPwTitleLab.snp.makeConstraints { make in
            make.left.equalTo(emailText)
            make.top.equalTo(line2.snp.bottom).offset(30)
        }
        seeBtn2.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(40)
            make.top.equalTo(againPwTitleLab.snp.bottom).offset(12)
            make.width.equalTo(30)
        }
        againPwText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(seeBtn2.snp.left).offset(-5)
            make.top.equalTo(againPwTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(againPwText.snp.bottom)
        }
        usernameValidLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(30)
        }
        passwordValidLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(30)
        }
        passwordValid1Label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(line3.snp.bottom)
            make.height.equalTo(30)
        }
        
        reTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(line3.snp.bottom).offset(30)
        }
        reText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(reTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line4.snp.makeConstraints { make in
            make.left.right.equalTo(line3)
            make.height.equalTo(1)
            make.top.equalTo(reText.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}

