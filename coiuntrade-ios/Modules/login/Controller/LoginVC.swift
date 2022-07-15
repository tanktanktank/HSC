//
//  LoginVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/21.
//

import UIKit

enum LoginType : Int{
    case phone = 1
    case email = 2
}

class LoginVC: BaseViewController {
    
    var type : LoginType = .email{
        didSet{
            switch type {
            case .email:
                iconView.image = UIImage(named: "login_icon_email")
                emailBtn.isSelected = true
                emailBtn.backgroundColor = .hexColor("2D2D2D")
                phoneBtn.isSelected = false
                phoneBtn.backgroundColor = .clear
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                phoneView.phoneText.text = ""
                phoneView.pwText.text = ""
                loginBtn.isSelected = false
                loginBtn.isUserInteractionEnabled = false
                break;
            case .phone:
                iconView.image = UIImage(named: "login_icon_phone")
                phoneBtn.isSelected = true
                phoneBtn.backgroundColor = .hexColor("2D2D2D")
                emailBtn.isSelected = false
                emailBtn.backgroundColor = .clear
                scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: false)
                emailView.emailText.text = ""
                emailView.pwText.text = ""
                loginBtn.isSelected = false
                loginBtn.isUserInteractionEnabled = false
                break;
            }
        }
    }
    
    lazy var backBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(tapBackBtn), for: .touchUpInside)
        return btn
    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "login_icon_email")
        return v
    }()
    lazy var typeView : UIView = {
        let v = UIView()
        v.corner(cornerRadius: 4)
        v.backgroundColor = .hexColor("191818")
        return v
    }()
    lazy var emailBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_email".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapEmailBtn), for: .touchUpInside)
        return btn
    }()
    lazy var phoneBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_phone".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.backgroundColor = .clear
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapPhoneBtn), for: .touchUpInside)
        return btn
    }()
    
    var demoAsyncTask: DemoAsyncTask?
            
    fileprivate lazy var gt3CaptchaManager: GT3CaptchaManager = {
        let manager = GT3CaptchaManager(api1: nil, api2: nil, timeout: 5.0)
        manager.delegate = self as GT3CaptchaManagerDelegate
        manager.viewDelegate = self as GT3CaptchaManagerViewDelegate

        // 开启日志和Debug模式
        manager.enableDebugMode(true)
        GT3CaptchaManager.setLogEnabled(true)

        return manager
    }()
    lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_login".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "btn_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapLoginBtn), for: .touchUpInside)
        return btn
    }()
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: SCREEN_WIDTH*2, height: 240)
        v.isScrollEnabled = false
        return v
    }()
    lazy var emailView = EmailView()
    lazy var phoneView = PhoneView()
    var area_phone_code = "86"
    
    lazy var registerBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_register".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 12)
        btn.addTarget(self, action: #selector(tapRegisterBtn), for: .touchUpInside)
        return btn
    }()
    lazy var fogetBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_login_forget_password".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 12)
        btn.addTarget(self, action: #selector(tapFogetBtn), for: .touchUpInside)
        return btn
    }()
    private var isToLogin : Bool = true
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLab.text = "tv_login_title".localized()
        
        // 创建自定义的注册和校验任务
        let demoAsyncTask = DemoAsyncTask()
        demoAsyncTask.api1 = API1
        demoAsyncTask.api2 = API2
        // 为验证管理器注册自定义的异步任务
        // 此步骤不建议放到管理器的懒加载中
        // 保障内部注册动作，在调用开启验证之前完成
        gt3CaptchaManager.registerCaptcha(withCustomAsyncTask: demoAsyncTask, completion: nil);
        demoAsyncTask.asyncTaskResult = {[weak self] (isOk : Bool) in
            if isOk {
                self?.getDataSource()
            }
        }
        self.demoAsyncTask = demoAsyncTask // 在 manager 内是弱引用，为避免在后续使用时 asyncTask 不会已被提前释放，建议在外部将其保持到全局
        setUI()
        initSubViewsConstraints()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
//MARK: 极验代理 GT3CaptchaManagerViewDelegate
extension LoginVC: GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate {

    func getDataSource(){
        if isToLogin {
            if type == .email {
                viewModel.emailLogin(email_addr: emailView.emailText.text ?? "", password: emailView.pwText.text ?? "", logintype: type.rawValue)
            }else{
                viewModel.phoneLogin(area_phone_code: area_phone_code, phone_number: phoneView.phoneText.text ?? "", password: phoneView.pwText.text ?? "", logintype: type.rawValue)
            }
        }
    }
    // MARK: GT3CaptchaManagerDelegate

    func gtCaptcha(_ manager: GT3CaptchaManager, errorHandler error: GT3Error) {
        print("error code: \(error.code)")
        print("error desc: \(error.error_code) - \(error.gtDescription)")

        // 处理验证中返回的错误
        if (error.code == -999) {
            // 请求被意外中断, 一般由用户进行取消操作导致
        }
        else if (error.code == -10) {
            // 预判断时被封禁, 不会再进行图形验证
        }
        else if (error.code == -20) {
            // 尝试过多
        }
        else {
            // 网络问题或解析失败, 更多错误码参考开发文档
        }
    }

    func gtCaptcha(_ manager: GT3CaptchaManager, didReceiveSecondaryCaptchaData data: Data?, response: URLResponse?, error: GT3Error?, decisionHandler: ((GT3SecondaryCaptchaPolicy) -> Void)) {
        if let error = error {
            print("API2 error: \(error.code) - \(error.error_code) - \(error.gtDescription)")
            decisionHandler(.forbidden)
            return
        }

        if let data = data {
            print("API2 repsonse: \(String(data: data, encoding: .utf8) ?? "")")
            decisionHandler(.allow)
            return
        }
        else {
            print("API2 repsonse: nil")
            decisionHandler(.forbidden)
        }
        decisionHandler(.forbidden)
    }

    // MARK: GT3CaptchaManagerViewDelegate

    func gtCaptchaWillShowGTView(_ manager: GT3CaptchaManager) {
        print("gtcaptcha will show gtview")
    }
}
// MARK: - 点击事件
extension LoginVC{
    ///点击返回
    @objc func tapBackBtn(){
        self.dismiss(animated: true)
    }
    ///点击注册
    @objc func tapRegisterBtn(){
        let vc = WelcomeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///点击邮箱
    @objc func tapEmailBtn(){
        type = .email
    }
    ///点击手机号码
    @objc func tapPhoneBtn(){
        type = .phone
    }
    @objc func tapFogetBtn(){
        isToLogin = false
        tipManager.showAlert(icon: "alert_tip", title: "tv_confirm_update_password".localized(), message: "tv_update_password_tip".localized(), actionArray: ["common_cancel".localized(),"tv_continue".localized()] ,completion: {[weak self] isok in
            if isok{
                self?.phoneView.phoneText.text = ""
                self?.phoneView.pwText.text = ""
                self?.emailView.emailText.text = ""
                self?.emailView.pwText.text = ""
                let vc = ResetPasswordTypeVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    ///点击登录
    @objc func tapLoginBtn(){
        isToLogin = true
        self.gt3CaptchaManager.startGTCaptchaWith(animated: true)

        //tem 临时调试
//        if type == .email {
//            viewModel.emailLogin(email_addr: emailView.emailText.text ?? "", password: emailView.pwText.text ?? "", logintype: type.rawValue)
//        }else{
//            viewModel.phoneLogin(area_phone_code: area_phone_code, phone_number: phoneView.phoneText.text ?? "", password: phoneView.pwText.text ?? "", logintype: type.rawValue)
//        }
    }
    
}
extension LoginVC : PhoneViewDelegate,EmailViewDelegate{
    func emailSatisfyLogin() {
        loginBtn.isUserInteractionEnabled = true
        loginBtn.isSelected = true
    }
    
    func clickCountry(sender: QMUIButton) {
        let vc = CountListVC()
        vc.selectedCountryClick = {[weak self] (model : CountryModel) in
            self?.phoneView.countryImageV.kf.setImage(with: model.countryicon, placeholder: nil)
            self?.phoneView.countryBtn.setTitle("+" + model.countryphonecode, for: .normal)
            self?.area_phone_code = model.countryphonecode
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func phoneSatisfyLogin() {
        loginBtn.isUserInteractionEnabled = true
        loginBtn.isSelected = true
    }
    
}
// MARK: viewModel 代理
extension LoginVC : LoginRequestDelegate{
    /// 登录成功回调
    func loginEmailSuccess(model: LoginModel) {
        let vc = SecurityVerificationVC()
        vc.type = getSecurityVerificationType(model: model)
        vc.fromeVCType = .login
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loginFailure(code : Int,msg : String){
        tipManager.showLoginErrorAlert(message: msg, actionArray: ["已知晓".localized()]){isok in
            
        }
    }
}
// MARK: - UI
extension LoginVC{
    func setUI(){
        
        phoneView.delegate = self
        emailView.delegate = self
        view.addSubview(backBtn)
        view.addSubview(iconView)
        view.addSubview(typeView)
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        view.addSubview(fogetBtn)
        view.addSubview(scrollView)
        typeView.addSubview(emailBtn)
        typeView.addSubview(phoneBtn)
        scrollView.addSubview(emailView)
        scrollView.addSubview(phoneView)
        
    }
    func initSubViewsConstraints(){
        self.titleLab.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(TOP_HEIGHT+20)
            make.height.equalTo(30)
        }
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.centerY.equalTo(self.titleLab)
            make.width.height.equalTo(48)
        }
        typeView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalTo(titleLab.snp.bottom).offset(32)
            make.width.equalTo(180)
            make.height.equalTo(32)
        }
        loginBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom)
            make.height.equalTo(240)
            make.left.width.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        registerBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(scrollView.snp.bottom)
        }
        fogetBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(scrollView.snp.bottom)
        }
        emailBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        phoneBtn.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        emailView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(240)
        }
        phoneView.snp.makeConstraints { make in
            make.left.equalTo(emailView.snp.right)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(240)
        }
    }
}
