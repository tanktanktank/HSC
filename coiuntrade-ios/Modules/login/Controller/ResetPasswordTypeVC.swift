//
//  ResetPasswordTypeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class ResetPasswordTypeVC: BaseViewController {
    var type : LoginType = .email{
        didSet{
            switch type {
            case .email:
                emailBtn.isSelected = true
                emailBtn.backgroundColor = .hexColor("2D2D2D")
                phoneBtn.isSelected = false
                phoneBtn.backgroundColor = .clear
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                phoneView.phoneText.text = ""
                nextBtn.isSelected = false
                nextBtn.isUserInteractionEnabled = false
                break;
            case .phone:
                phoneBtn.isSelected = true
                phoneBtn.backgroundColor = .hexColor("2D2D2D")
                emailBtn.isSelected = false
                emailBtn.backgroundColor = .clear
                scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: false)
                emailView.emailText.text = ""
                nextBtn.isSelected = false
                nextBtn.isUserInteractionEnabled = false
//                area_phone_code = "86"
                break;
            }
        }
    }
    
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
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: SCREEN_WIDTH*2, height: 240)
        return v
    }()
    lazy var nextBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_next".localized(), for: .normal)
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
    var area_phone_code = "86"
    
    let viewModel = LoginViewModel()
    
    
    lazy var emailView = ResetEmailView()
    lazy var phoneView = ResetPhoneView()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_reset_passpwd".localized()
        setUI()
        initSubViewsConstraints()
        
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
    }
    

}
//MARK: 极验代理 GT3CaptchaManagerViewDelegate
extension ResetPasswordTypeVC: GT3CaptchaManagerDelegate, GT3CaptchaManagerViewDelegate {

    func getDataSource(){
        viewModel.resetPwd(retrieve_type: type.rawValue, phone_area_code: area_phone_code, phone: phoneView.phoneText.text ?? "", email: emailView.emailText.text ?? "", password: "", credentials: "")
        
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
extension ResetPasswordTypeVC{
    ///点击邮箱
    @objc func tapEmailBtn(){
        type = .email
    }
    ///点击手机号码
    @objc func tapPhoneBtn(){
        type = .phone
    }
    ///点击下一步
    @objc func tapNextBtn(){
        
        self.gt3CaptchaManager.startGTCaptchaWith(animated: true)
    }
}
// MARK: - ResetEmailViewDelegate
extension ResetPasswordTypeVC : ResetEmailViewDelegate ,ResetPhoneViewDelegate{
    func clickCountry(sender: QMUIButton) {
        let vc = CountListVC()
        vc.selectedCountryClick = {[weak self] (model : CountryModel) in
            self?.area_phone_code = model.countryphonecode
            self?.phoneView.countryImageV.kf.setImage(with: model.countryicon, placeholder: nil)
            self?.phoneView.countryBtn.setTitle("+" + model.countryphonecode, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func phoneSatisfyResetPhone(isok: Bool) {
        nextBtn.isUserInteractionEnabled = isok
        nextBtn.isSelected = isok
    }
    
    func emailSatisfyResetEmail(isok : Bool){
        nextBtn.isUserInteractionEnabled = isok
        nextBtn.isSelected = isok
    }
   
}
extension ResetPasswordTypeVC : LoginRequestDelegate{
    
    func resetPwdSuccess(model : LoginModel){
        let vc = SecurityVerificationVC()
        vc.fromeVCType = .foget
        vc.retrieve_type = self.type.rawValue
        vc.type = getSecurityVerificationType(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UI
extension ResetPasswordTypeVC{
    func setUI(){
        viewModel.delegate = self
        emailView.delegate = self
        phoneView.delegate = self
        view.addSubview(typeView)
        view.addSubview(scrollView)
        view.addSubview(nextBtn)
        typeView.addSubview(emailBtn)
        typeView.addSubview(phoneBtn)
        scrollView.addSubview(emailView)
        scrollView.addSubview(phoneView)
    }
    func initSubViewsConstraints(){
        typeView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(32)
            make.width.equalTo(180)
            make.height.equalTo(32)
        }
        emailBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        phoneBtn.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom)
            make.height.equalTo(240)
            make.left.width.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
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
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
    }
}
