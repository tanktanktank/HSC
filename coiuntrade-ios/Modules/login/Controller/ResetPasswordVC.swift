//
//  ResetPasswordVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit
class ResetPasswordVC: BaseViewController {    
    lazy var pwTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_input_new_pwd".localized()
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
        lab.text = "tv_confirm_input_new_pwd".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var againpPwText :QMUITextField = {
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
    lazy var tipIcon : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "alert_tip")
        return v
    }()
    lazy var tipLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_reset_password_tip".localized()
        lab.font = FONTR(size: 10)
        lab.textColor = .hexColor("989898")
        lab.numberOfLines = 0
        return lab
    }()
    lazy var doneBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_complete".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "btn_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapNextBtn), for: .touchUpInside)
        return btn
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
    var model : CredentialsModel = CredentialsModel()
    var retrieve_type : Int = 1 //找回密码类型 1 手机 2 邮箱
    
    let viewModel = LoginViewModel()
    
    var isPwd1 = false
    var isPwd2 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_reset_passpwd".localized()
        setUI()
        initSubViewsConstraints()
    }

}
// MARK: - 点击事件
extension ResetPasswordVC{
    ///点击完成
    @objc func tapNextBtn(){
        let loginModel : LoginModel = userManager.loginModel ?? LoginModel()
        
        
        viewModel.resetPwd(retrieve_type: retrieve_type, phone_area_code: loginModel.area_phone_code, phone: loginModel.phone_number, email: loginModel.email_addr, password: pwText.text ?? "", credentials: model.business_credentials)
//        viewModel.resetPwd(password: pwText.text ?? "", repassword: againpPwText.text ?? "", credentials: model.business_credentials, phone_number: loginModel.phone_number, email_addr: loginModel.email_addr, area_phone_code: loginModel.area_phone_code)
    }
    
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
            againpPwText.isSecureTextEntry = false
        }else{
            againpPwText.isSecureTextEntry = true
        }
    }
    @objc func clickPwText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPwd1 = false
        passwordValidLabel.text = ""
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                passwordValidLabel.text = "tv_login_error_tip_two".localized()
            }else{
                isPwd1 = true
            }
        }else{
            line1.backgroundColor = .hexColor("333333")
        }
        if isPwd1,isPwd2 {
            doneBtn.isUserInteractionEnabled = true
            doneBtn.isSelected = true
        }
    }
    @objc func clickAgainpPwText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isPwd2 = false
        passwordValid1Label.text = ""
        if count > 0 {
            line2.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                passwordValid1Label.text = "tv_login_error_tip_two".localized()
            }else{
                if pwText.text == sender.text {
                    isPwd2 = true
                    passwordValid1Label.text = ""
                }else{
                    passwordValid1Label.text = "tv_login_error_tip_three".localized()
                }
            }
        }else{
            line2.backgroundColor = .hexColor("333333")
        }
        if isPwd1,isPwd2 {
            doneBtn.isUserInteractionEnabled = true
            doneBtn.isSelected = true
        }
    }
}
extension ResetPasswordVC : LoginRequestDelegate{
    func resetPwdSuccess(model : LoginModel){
        navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - UI
extension ResetPasswordVC{
    func setUI(){
        viewModel.delegate = self
        view.addSubview(pwTitleLab)
        view.addSubview(pwText)
        view.addSubview(againPwTitleLab)
        view.addSubview(againpPwText)
        view.addSubview(seeBtn1)
        view.addSubview(seeBtn2)
        view.addSubview(line1)
        view.addSubview(line2)
        view.addSubview(tipIcon)
        view.addSubview(tipLab)
        view.addSubview(doneBtn)
        view.addSubview(passwordValidLabel)
        view.addSubview(passwordValid1Label)
        pwText.addTarget(self, action: #selector(clickPwText), for: .editingChanged)
        againpPwText.addTarget(self, action: #selector(clickAgainpPwText), for: .editingChanged)
    }
    func initSubViewsConstraints(){
        pwTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(30)
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
        line1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(pwText.snp.bottom)
        }
        againPwTitleLab.snp.makeConstraints { make in
            make.left.equalTo(pwText)
            make.top.equalTo(line1.snp.bottom).offset(30)
        }
        seeBtn2.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(40)
            make.top.equalTo(againPwTitleLab.snp.bottom).offset(12)
            make.width.equalTo(30)
        }
        againpPwText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(seeBtn2.snp.left).offset(-5)
            make.top.equalTo(againPwTitleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(againpPwText.snp.bottom)
        }
        tipIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(line2.snp.bottom).offset(30)
            make.width.height.equalTo(13)
        }
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(tipIcon.snp.right).offset(2)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(tipIcon)
        }
        doneBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
        passwordValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line1)
            make.right.equalTo(line1)
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(30)
        }
        passwordValid1Label.snp.makeConstraints { make in
            make.left.equalTo(line2)
            make.right.equalTo(line2)
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(30)
        }
    }
}
