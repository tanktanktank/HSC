//
//  ChangePWVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit

class ChangePWDVC: BaseViewController {
    lazy var oldPwdView : PasswordView = {
        let v = PasswordView()
        v.titleV.text = "tv_input_old_pwd".localized()
        return v
    }()
    lazy var newPwdView : PasswordView = {
        let v = PasswordView()
        v.titleV.text = "tv_input_new_pwd".localized()
        return v
    }()
    lazy var againNewPwdView : PasswordView = {
        let v = PasswordView()
        v.titleV.text = "tv_confirm_input_new_pwd".localized()
        return v
    }()
    lazy var commitBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_commit".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "btn_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapCommitBtn), for: .touchUpInside)
        return btn
    }()
    lazy var iconV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "alert_tip")
        return v
    }()
    lazy var msgV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FCD283")
        v.font = FONTR(size: 11)
        v.text = "tv_reset_password_tip".localized()
        return v
    }()
    private var isOldPwd = false
    private var isNewPwd = false
    private var isAgainPwd = false
    private var viewModel = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_safe_update_pwd".localized()
        self.viewModel.delegate = self
        setUI()
        initSubViewsConstraints()
    }

}
extension ChangePWDVC : MineRequestDelegate{
    
    func userUpdatePasswdSuccess(){
        let vc = SecurityVerificationVC()
        vc.fromeVCType = .resetPwd
        vc.old_password = oldPwdView.textV.text ?? ""
        vc.password = newPwdView.textV.text ?? ""
        let model : InfoModel = userManager.infoModel ?? InfoModel()
        vc.type = getSecurityVerificationInfoType(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 点击事件
extension ChangePWDVC{
    @objc func tapOldTextV(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isOldPwd = false
        oldPwdView.passwordValidLabel.text = ""
        if count > 0 {
            oldPwdView.line.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                oldPwdView.passwordValidLabel.text = "tv_login_error_tip_two".localized()
            }else{
                isOldPwd = true
            }
        }else{
            oldPwdView.line.backgroundColor = .hexColor("333333")
        }
        if isOldPwd && isNewPwd && isAgainPwd {
            commitBtn.isSelected = true
            commitBtn.isUserInteractionEnabled = true
        }else{
            commitBtn.isSelected = false
            commitBtn.isUserInteractionEnabled = false
        }
    }
    @objc func tapNewTextV(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        
        isNewPwd = false
        newPwdView.passwordValidLabel.text = ""
        if count > 0 {
            newPwdView.line.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                newPwdView.passwordValidLabel.text = "tv_login_error_tip_two".localized()
            }else{
                isNewPwd = true
            }
        }else{
            newPwdView.line.backgroundColor = .hexColor("333333")
        }
        if isOldPwd && isNewPwd && isAgainPwd {
            commitBtn.isSelected = true
            commitBtn.isUserInteractionEnabled = true
        }else{
            commitBtn.isSelected = false
            commitBtn.isUserInteractionEnabled = false
        }
    }
    @objc func tapAgainTextV(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        isAgainPwd = false
        againNewPwdView.passwordValidLabel.text = ""
        if count > 0 {
            againNewPwdView.line.backgroundColor = .hexColor("FCD283")
            if !checkPwd(pwd: sender.text ?? ""){
                againNewPwdView.passwordValidLabel.text = "tv_login_error_tip_two".localized()
            }else{
                if newPwdView.textV.text == sender.text {
                    isAgainPwd = true
                    againNewPwdView.passwordValidLabel.text = ""
                }else{
                    againNewPwdView.passwordValidLabel.text = "tv_login_error_tip_three".localized()
                }
            }
        }else{
            againNewPwdView.line.backgroundColor = .hexColor("333333")
        }
        if isOldPwd && isNewPwd && isAgainPwd {
            commitBtn.isSelected = true
            commitBtn.isUserInteractionEnabled = true
        }else{
            commitBtn.isSelected = false
            commitBtn.isUserInteractionEnabled = false
        }
    }
    ///点击提交
    @objc func tapCommitBtn(){
        self.viewModel.userUpdatePasswd(password: newPwdView.textV.text ?? "", old_password: oldPwdView.textV.text ?? "", sms_captcha: "",email_captcha: "",google_captcha: "")
        
    }
}
// MARK: - UI
extension ChangePWDVC{
    func setUI() {
        view.addSubview(oldPwdView)
        view.addSubview(newPwdView)
        view.addSubview(againNewPwdView)
        view.addSubview(commitBtn)
        view.addSubview(iconV)
        view.addSubview(msgV)
        oldPwdView.textV.addTarget(self, action: #selector(tapOldTextV), for: .editingChanged)
        newPwdView.textV.addTarget(self, action: #selector(tapNewTextV), for: .editingChanged)
        againNewPwdView.textV.addTarget(self, action: #selector(tapAgainTextV), for: .editingChanged)
    }
    func initSubViewsConstraints() {
        oldPwdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
            make.height.equalTo(103)
        }
        newPwdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oldPwdView.snp.bottom)
            make.height.equalTo(103)
        }
        againNewPwdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(newPwdView.snp.bottom)
            make.height.equalTo(103)
        }
        commitBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
        msgV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(31)
            make.top.equalTo(againNewPwdView.snp.bottom).offset(30)
        }
        iconV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(msgV)
            make.width.height.equalTo(12)
        }
    }
}
