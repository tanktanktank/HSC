//
//  SecurityVerificationVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit

enum FromeVCType : String{
    ///登录
    case login = "login"
    ///忘记密码
    case foget = "foget"
    ///修改密码
    case resetPwd = "resetPwd"
    ///更改手机验证
    case resetPhone = "resetPhone"
    ///更改邮箱验证
    case resetEmail = "resetEmail"
    ///更改谷歌验证
    case resetGoogle = "resetGoogle"
    ///关闭手机验证
    case closePhone = "closePhone"
    ///关闭邮箱验证
    case closeEmail = "closeEmail"
    ///关闭谷歌验证
    case closeGoogle = "closeGoogle"
    ///开启手机验证
    case openPhone = "openPhone"
    ///开启邮箱验证
    case openEmail = "openEmail"
    ///开启谷歌验证
    case openGoogle = "openGoogle"
    ///其他
    case verify = "verify"
}
enum SecurityType : Int{
    case phone = 1
    case email = 2
    case phoneAndEmail = 3
    case phoneAndGoogle = 4
    case emailAndGoogle = 5
    case all = 6
}
class SecurityVerificationVC: BaseViewController {
    var fromeVCType : FromeVCType = .login
    
    var type : SecurityType = .phone{
        didSet{
            switch type {
            case .phone:
                emailCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                googleCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                emailCodeView.isHidden = true
                googleCodeView.isHidden = true
                if userManager.isLogin {
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.infoModel?.phone_pass ?? "")
                }else{
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.loginModel?.phone_pass ?? "")
                }
                break
            case .email:
                phoneCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                googleCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                phoneCodeView.isHidden = true
                googleCodeView.isHidden = true
                if userManager.isLogin {
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.infoModel?.email_pass ?? ""))
                }else{
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.loginModel?.email_pass ?? ""))
                }
                break
            case .phoneAndEmail:
                googleCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                googleCodeView.isHidden = true
                if userManager.isLogin {
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.infoModel?.phone_pass ?? "")
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.infoModel?.email_pass ?? ""))

                }else{
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.loginModel?.phone_pass ?? "")
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.loginModel?.email_pass ?? ""))
                }
                break
            case .phoneAndGoogle:
                emailCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                emailCodeView.isHidden = true
                
                if userManager.isLogin {
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.infoModel?.phone_pass ?? "")
                }else{
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.loginModel?.phone_pass ?? "")
                }
                break
            case .emailAndGoogle:
                phoneCodeView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                phoneCodeView.isHidden = true
                
                if userManager.isLogin {
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.infoModel?.email_pass ?? ""))
                }else{
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.loginModel?.email_pass ?? ""))
                }
                break
            case .all:
                
                if userManager.isLogin {
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.infoModel?.phone_pass ?? "")
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.infoModel?.email_pass ?? ""))
                }else{
                    phoneCodeView.titleLab.text = "tv_verfiry_phone_tip".localized() + (userManager.loginModel?.phone_pass ?? "")
                    emailCodeView.titleLab.text = String(format: "tv_verfiry_mail_tip".localized(), (userManager.loginModel?.email_pass ?? ""))
                }
                break
            }
        }
    }
    
    let dataSubject = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    lazy var securtyPhoneView = SecurtyPhoneView()
    lazy var securtyEmailView = SecurtyEmailView()
    
    lazy var phoneCodeView = SecurityCellView()
    lazy var emailCodeView = SecurityCellView()
    lazy var googleCodeView = SecurityCellView()
    lazy var commitBtn :UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_commit".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "btn_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = FONTB(size: 16)
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapCommitBtn), for: .touchUpInside)
        return btn
    }()
    var sms_code = ""
    var email_code = ""
    var google_auth_code = ""
    
    var new_area_phone_code = "86"
    var new_phone_number = ""
    var new_email_addr = ""
    var new_sms_code = ""
    var new_email_code = ""
    
    var phone_number = ""
    var email_addr = ""
    var area_phone_code = "86"
    
    ///修改密码用到
    var old_password = ""
    var password = ""
    ///重置密码用到
    var retrieve_type : Int = 1 //找回密码类型 1 手机 2 邮箱
    
    
    var viewModel = LoginViewModel()
    var viewModel1 = RegisterViewModel()
    var infoViewModel = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLab.text = "安全验证"
        setUI()
        initSubViewsConstraints()
    }
    

}
extension SecurityVerificationVC{
    @objc func tapCommitBtn(){
        switch fromeVCType {
        case .login:
            
            let loginModel = userManager.loginModel
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            viewModel.loginSecurityCode(login_type: loginModel?.login_type ?? 2, sms_captcha: sms_code, email_captcha: email_code, google_captcha: google_auth_code, password: loginModel?.password ?? "", phone: loginModel?.phone_number ?? "", email: loginModel?.email_addr ?? "", phone_area_code: loginModel?.area_phone_code ?? "")
            break
        case .verify:
            self.dataSubject.onNext(true)
            self.dataSubject.onCompleted()
            self.navigationController?.dismiss(animated: true)
            break
        case .resetPwd:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            infoViewModel.userUpdatePasswd(password: password, old_password: old_password, sms_captcha: sms_code, email_captcha: email_code, google_captcha: google_auth_code)
            break
        case .foget:
            let loginModel = userManager.loginModel
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            
            viewModel.confirmSecurityCode(retrieve_type: loginModel?.retrieve_type ?? 1, phone_area_code: loginModel?.area_phone_code ?? "", phone: loginModel?.phone_number  ?? "", email: loginModel?.email_addr ?? "", sms_captcha: sms_code, email_captcha: email_code, google_captcha: google_auth_code)
            
            break
        case .openPhone:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            area_phone_code = new_area_phone_code
            phone_number = securtyPhoneView.phoneText.text ?? ""
            new_sms_code = securtyPhoneView.phoneCodeText.text ?? ""
            
            let model = AuthSwithNewRequestModel()
            model.operation_type = getOperation_type(fromeVCType: fromeVCType)
            model.validator_type = getValidator_type(fromeVCType: fromeVCType)
            model.google_captcha = google_auth_code
            model.new_phone_area = area_phone_code
            model.new_phone = phone_number
            model.new_phone_captcha = new_sms_code
            model.email_captcha = email_code
            infoViewModel.authSwitchNew(model: model)
            break
        case .resetPhone:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            new_phone_number = securtyPhoneView.phoneText.text ?? ""
            new_sms_code = securtyPhoneView.phoneCodeText.text ?? ""
            
            let model = AuthSwithNewRequestModel()
            model.operation_type = getOperation_type(fromeVCType: fromeVCType)
            model.validator_type = getValidator_type(fromeVCType: fromeVCType)
            model.sms_captcha = sms_code
            model.email_captcha = email_code
            model.google_captcha = google_auth_code
            model.new_phone_area = new_area_phone_code
            model.new_phone = new_phone_number
            model.new_phone_captcha = new_sms_code
            infoViewModel.authSwitchNew(model: model)
            break
            
        case .openEmail:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = securtyEmailView.emailCodeText.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            email_addr = securtyEmailView.emailText.text ?? ""
            
            let model = AuthSwithNewRequestModel()
            model.operation_type = getOperation_type(fromeVCType: fromeVCType)
            model.validator_type = getValidator_type(fromeVCType: fromeVCType)
            model.sms_captcha = sms_code
            model.google_captcha = google_auth_code
            model.new_email = email_addr
            model.new_email_captcha = email_code
            infoViewModel.authSwitchNew(model: model)
            break
        case .resetEmail:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            new_email_addr = securtyEmailView.emailText.text ?? ""
            new_email_code = securtyEmailView.emailCodeText.text ?? ""
            
            let model = AuthSwithNewRequestModel()
            model.operation_type = getOperation_type(fromeVCType: fromeVCType)
            model.validator_type = getValidator_type(fromeVCType: fromeVCType)
            model.sms_captcha = sms_code
            model.email_captcha = email_code
            model.google_captcha = google_auth_code
            model.new_email = new_email_addr
            model.new_email_captcha = new_email_code
            infoViewModel.authSwitchNew(model: model)
            break
        case .openGoogle:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            
            let model = AuthSwithNewRequestModel()
            model.operation_type = getOperation_type(fromeVCType: fromeVCType)
            model.validator_type = getValidator_type(fromeVCType: fromeVCType)
            model.sms_captcha = sms_code
            model.email_captcha = email_code
            model.new_google_captcha = google_auth_code
            infoViewModel.authSwitchNew(model: model)
            break
        default:
            sms_code = phoneCodeView.textV.text ?? ""
            email_code = emailCodeView.textV.text ?? ""
            google_auth_code = googleCodeView.textV.text ?? ""
            
            let model = AuthSwithNewRequestModel()
            model.operation_type = getOperation_type(fromeVCType: fromeVCType)
            model.validator_type = getValidator_type(fromeVCType: fromeVCType)
            model.sms_captcha = sms_code
            model.email_captcha = email_code
            model.google_captcha = google_auth_code
            infoViewModel.authSwitchNew(model: model)
            break
        }
    }
    //MARK: 点击发送手机验证码
    @objc func tapPhoneCodeViewSendBtn(sender : UIButton){
        sender.countDown(count: 60)
        let business_type = getBusinessType(fromeType: fromeVCType)
        
        if userManager.isLogin {
            let infoModel = userManager.infoModel
            viewModel1.phoneRegisterCode(area_phone_code: infoModel?.area_phone_code ?? "", phone_number: infoModel?.phone_number ?? "", send_type: 1, business_type: business_type)
        }else{
            let loginModel = userManager.loginModel
            viewModel1.phoneRegisterCode(area_phone_code: loginModel?.area_phone_code ?? "", phone_number: loginModel?.phone_number ?? "", send_type: 1, business_type: business_type)
        }
    }
    //MARK: 点击发送邮箱验证码
    @objc func tapEmailCodeViewSendBtn(sender : UIButton){
        sender.countDown(count: 60)
        let business_type = getBusinessType(fromeType: fromeVCType)
        if userManager.isLogin {
            let infoModel = userManager.infoModel
            viewModel1.emailRegisterCode(email_addr: infoModel?.email_addr ?? "", send_type: 2, business_type: business_type)
        }else{
            let loginModel = userManager.loginModel
            viewModel1.emailRegisterCode(email_addr: loginModel?.email_addr ?? "", send_type: 2, business_type: business_type)
        }
    }
    //MARK: 安全验证获取手机验证码
    @objc func tapSecurtyPhoneViewSendBtn(sender : UIButton){
        sender.countDown(count: 60)
        let business_type = getBusinessType(fromeType: fromeVCType)
        
        viewModel1.phoneRegisterCode(area_phone_code: new_area_phone_code, phone_number: new_phone_number, send_type: 1, business_type: business_type)
    }
    //MARK: 安全验证获取邮箱验证码
    @objc func tapSecurtyEmailViewSendBtn(sender : UIButton){
        sender.countDown(count: 60)
        let business_type = getBusinessType(fromeType: fromeVCType)
        
        viewModel1.emailRegisterCode(email_addr: new_email_addr, send_type: 2, business_type: business_type)
    }
    //MARK: 谷歌验证器粘贴
    @objc func tapGoogleCodeViewSendBtn(){
        let content = UIPasteboard.general.string
        googleCodeView.textV.text = content
    }
    ///业务类型：1-注册，2-登录，3-找回密码，4-修改密码，11-开启手机验证，21-更改手机验证，31-关闭手机验证，12-开启邮箱验证，22-更改邮箱验证，32-关闭邮箱验证，13-开启Google验证，23-更改Google验证，33-关闭Google验证
    func getBusinessType(fromeType : FromeVCType) -> Int{
        switch fromeType {
        case .login:
            return 2
        case .foget:
            return 3
        case .resetPwd:
            return 4
        case .resetPhone:
            return 21
        case .resetEmail:
            return 22
        case .resetGoogle:
            return 23
        case .closePhone:
            return 31
        case .closeEmail:
            return 32
        case .closeGoogle:
            return 33
        case .openPhone:
            return 11
        case .openEmail:
            return 12
        case .openGoogle:
            return 13
        case .verify:
            return 0
        }
    }
}
extension SecurityVerificationVC : SecurityCellViewDelegate{
    func securityCellSatisfyInput(isCanClick: Bool) {
        commitBtn.isUserInteractionEnabled = isCanClick
        commitBtn.isSelected = isCanClick
    }
    func registerPhoneCodeSuccess(){
        
    }
}
extension SecurityVerificationVC : SecurtyPhoneViewDelegate,SecurtyEmailViewDelegate{
    //MARK: 选择国家地区
    func clickCountry(sender: QMUIButton) {
        let vc = CountListVC()
        vc.selectedCountryClick = {[weak self] (model : CountryModel) in
            self?.new_area_phone_code = model.countryphonecode
            self?.securtyPhoneView.countryImageV.kf.setImage(with: model.countryicon, placeholder: nil)
            self?.securtyPhoneView.countryBtn.setTitle("+" + model.countryphonecode, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: 编辑text，赋值
    func phoneEditingChanged(text: String) {
        new_phone_number = text
    }
    
    func phoneCodeChanged(text: String) {
        new_sms_code = text
    }
    
    func emailEditingChanged(text: String) {
        new_email_addr = text
    }
    
    func emailCodeChanged(text: String) {
        new_email_code = text
    }
    
    
}
// MARK: viewModel 代理
extension SecurityVerificationVC : LoginRequestDelegate,RegisterRequestDelegate,MineRequestDelegate{
    
    //MARK: 获取用户信息成功回调
    func getUserInfoSuccess(model : InfoModel){
        self.infoViewModel.getUserRatecountry()
        NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        NotificationCenter.default.post(name: LoginSuccessNotification, object: nil)
        self.navigationController?.dismiss(animated: true)
    }
    //MARK: 邮箱登录成功回调
    func loginEmailSuccess(model : LoginModel){
        if fromeVCType == .login {
            self.infoViewModel.getUserInfo()
            return
        }
    }
    //MARK: 验证码验证成功以后生成的凭证
    func getCredentialsSuccess(model : CredentialsModel){
        if fromeVCType == .login {
            self.infoViewModel.getUserRatecountry()
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            NotificationCenter.default.post(name: LoginSuccessNotification, object: nil)
            self.navigationController?.dismiss(animated: true)
            return
        }
        if fromeVCType == .foget {
            let vc = ResetPasswordVC()
            vc.model = model
            vc.retrieve_type = self.retrieve_type
            navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    //MARK: 修改密码成功回调
    func userUpdatePasswdSuccess(){
        navigationController?.popToRootViewController(animated: false)
        userManager.userLogout()
        userManager.logoutWithVC(currentVC: self)
    }
    
    //MARK: 新  身份验证器开关（开、关、改)成功回调
    func authSwitchNewSuccess(){
        if fromeVCType == .resetGoogle {
            let vc = BackupKeyVC()
            vc.type = .getSecret
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let mineVC = MineViewController()
        var targetVC : UIViewController!
        for controller in self.navigationController!.viewControllers {
            if controller.isKind(of: mineVC.classForCoder) {
                targetVC = controller
            }
        }
        if targetVC != nil {
            NotificationCenter.default.post(name: UpdataUserInfoNotification, object: nil)
            self.navigationController?.popToViewController(targetVC, animated: true)
        }
    }
}

extension SecurityVerificationVC{
    func setUI(){
        viewModel.delegate = self
        viewModel1.delegate = self
        infoViewModel.delegate = self
        securtyPhoneView.delegate = self
        securtyEmailView.delegate = self
        phoneCodeView.delegate = self
        emailCodeView.delegate = self
        googleCodeView.delegate = self
        
        view.addSubview(commitBtn)
        view.addSubview(scrollView)
        scrollView.addSubview(securtyPhoneView)
        scrollView.addSubview(securtyEmailView)
        scrollView.addSubview(phoneCodeView)
        scrollView.addSubview(emailCodeView)
        scrollView.addSubview(googleCodeView)
        
        securtyPhoneView.sendBtn.addTarget(self, action: #selector(tapSecurtyPhoneViewSendBtn), for: .touchUpInside)
        securtyPhoneView.sendBtn.setTitle("tv_send_code".localized(), for: .normal)
        
        securtyEmailView.sendBtn.addTarget(self, action: #selector(tapSecurtyEmailViewSendBtn), for: .touchUpInside)
        securtyEmailView.sendBtn.setTitle("tv_send_code".localized(), for: .normal)
        
        phoneCodeView.sendBtn.setTitle("tv_send_code".localized(), for: .normal)
        phoneCodeView.textV.placeholder = "tv_input_phone_code_hint".localized()
        phoneCodeView.sendBtn.addTarget(self, action: #selector(tapPhoneCodeViewSendBtn), for: .touchUpInside)
        
        emailCodeView.sendBtn.setTitle("tv_send_code".localized(), for: .normal)
        emailCodeView.textV.placeholder = "tv_input_email_code_hint".localized()
        emailCodeView.sendBtn.addTarget(self, action: #selector(tapEmailCodeViewSendBtn), for: .touchUpInside)
        
        googleCodeView.titleLab.text = "tv_six_verfiry_code".localized()
        googleCodeView.sendBtn.setTitle("tv_paste".localized(), for: .normal)
        googleCodeView.textV.placeholder = "tv_input_google_code_hint".localized()
        googleCodeView.sendBtn.addTarget(self, action: #selector(tapGoogleCodeViewSendBtn), for: .touchUpInside)
    }
    func initSubViewsConstraints(){
        commitBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
            make.bottom.equalToSuperview().offset(-83)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
            make.bottom.equalTo(commitBtn.snp.top).offset(-10)
        }
        securtyPhoneView.isHidden = true
        securtyEmailView.isHidden = true
        let tmp : CGFloat = (fromeVCType == .resetPhone || fromeVCType == .resetEmail || fromeVCType == .openPhone || fromeVCType == .openEmail) ? 206 : 0
        if fromeVCType == .resetPhone || fromeVCType == .openPhone {
            securtyPhoneView.isHidden = false
        }
        if fromeVCType == .resetEmail || fromeVCType == .openEmail {
            securtyEmailView.isHidden = false
        }
        
        securtyPhoneView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(tmp)
        }
        securtyEmailView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(tmp)
        }
        
        phoneCodeView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(tmp)
            make.height.equalTo(103)
        }
        emailCodeView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(phoneCodeView.snp.bottom)
            make.height.equalTo(103)
        }
        googleCodeView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(emailCodeView.snp.bottom)
            make.height.equalTo(103)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(SCREEN_WIDTH)
        }
    }
}
