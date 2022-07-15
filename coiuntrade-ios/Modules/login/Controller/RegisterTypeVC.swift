//
//  RegisterTypeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class RegisterTypeVC: BaseViewController {
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
                phoneView.againPwText.text = ""
                phoneView.reText.text = ""
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
                emailView.againPwText.text = ""
                emailView.reText.text = ""
                break;
            }
            nextBtn.isSelected = false
            nextBtn.isUserInteractionEnabled = false
        }
    }
    
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
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: SCREEN_WIDTH*2, height: 240)
        return v
    }()
    
    lazy var emailView = RegisterEmailView()
    lazy var phoneView = RegisterPhoneView()
    
    var area_phone_code = "86"
    
    var user_address = "中国"
    
    var viewModel = RegisterViewModel()
    
    var countrymodel : CountryModel?{
        didSet{
            self.phoneView.countryImageV.kf.setImage(with: self.countrymodel?.countryicon ?? "", placeholder: nil)
            self.area_phone_code = self.countrymodel?.countryphonecode ?? ""
            self.phoneView.countryBtn.setTitle("+\(self.area_phone_code)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "输入账号信息"
        setUI()
        initSubViewsConstraints()
        viewModel.delegate = self
    }

}
// MARK: viewModel 代理
extension RegisterTypeVC : RegisterRequestDelegate{
    
    ///注册成功回调
    func registerAccountSuccess() {
        if self.type == .email {
            viewModel.emailRegisterCode(email_addr: emailView.emailText.text ?? "", send_type: self.type.rawValue, business_type: 1)
        }else{
            viewModel.phoneRegisterCode(area_phone_code: area_phone_code, phone_number: phoneView.phoneText.text ?? "", send_type: self.type.rawValue, business_type: 1)
        }
        
    }
    ///获取邮箱验证码成功
    func registerEmailCodeSuccess() {
        let vc = VerificationCodeVC()
        vc.type = .email
        vc.password = emailView.pwText.text ?? ""
        vc.repassword = emailView.againPwText.text ?? ""
        vc.invite_code = emailView.reText.text ?? ""
        vc.email_addr = emailView.emailText.text ?? ""
        vc.user_address = self.user_address
        self.navigationController?.pushViewController(vc, animated: true)
    }
    ///获取手机验证码成功
    func registerPhoneCodeSuccess(){
        let vc = VerificationCodeVC()
        vc.type = .phone
        vc.password = phoneView.pwText.text ?? ""
        vc.repassword = phoneView.againPwText.text ?? ""
        vc.invite_code = phoneView.reText.text ?? ""
        vc.phone_number = phoneView.phoneText.text ?? ""
        vc.area_phone_code = area_phone_code
        vc.user_address = self.user_address
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - 点击事件
extension RegisterTypeVC{
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
        if type == .email {
            viewModel.registerAccount(register_type: 2, phone_area_code: "", phone: "", email: emailView.emailText.text ?? "", password: emailView.pwText.text ?? "", captcha: "", invite_code: emailView.reText.text ?? "", user_address: user_address)
        }else{
            viewModel.registerAccount(register_type: 1, phone_area_code: area_phone_code, phone: phoneView.phoneText.text ?? "", email: "", password: phoneView.pwText.text ?? "", captcha: "", invite_code: phoneView.reText.text ?? "", user_address: user_address)
        }
    }
}
// MARK: - RegisterPhoneViewDelegate
extension RegisterTypeVC : RegisterPhoneViewDelegate,RegisterEmailViewDelegate{
    func phoneSatisfyRegisterEmail() {
        nextBtn.isUserInteractionEnabled = true
        nextBtn.isSelected = true
    }
    
    func phoneSatisfyRegisterPhone() {
        nextBtn.isUserInteractionEnabled = true
        nextBtn.isSelected = true
    }
    
    func clickCountry(sender: QMUIButton) {
        let vc = CountListVC()
        vc.selectedCountryClick = {[weak self] (model : CountryModel) in
            self?.area_phone_code = model.countryphonecode
            self?.phoneView.countryImageV.kf.setImage(with: model.countryicon, placeholder: nil)
            self?.phoneView.countryBtn.setTitle("+" + model.countryphonecode, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension RegisterTypeVC{
    func setUI(){
        phoneView.delegate = self
        emailView.delegate = self
        view.addSubview(typeView)
        view.addSubview(scrollView)
        view.addSubview(nextBtn)
        typeView.addSubview(emailBtn)
        typeView.addSubview(phoneBtn)
        scrollView.addSubview(emailView)
        scrollView.addSubview(phoneView)
        
//        emailView.emailText.text = "136627923@qq.com"
//        emailView.pwText.text = "Aa123456"
//        emailView.againPwText.text = "Aa123456"
//        nextBtn.isUserInteractionEnabled = true
//        nextBtn.isSelected = true
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
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom)
            make.left.width.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        emailView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(scrollView)
        }
        phoneView.snp.makeConstraints { make in
            make.left.equalTo(emailView.snp.right)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(scrollView)
        }
    }
}
