//
//  VerificationCodeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class VerificationCodeVC: BaseViewController {
    var type : LoginType = .email{
        didSet{
            switch type {
            case .email:
                titleL.text = "tv_verifi_code_mail_tip".localized()
                break
            case .phone:
                titleL.text = "tv_verfiy_code_phone_tip".localized()
                break
            }
        }
    }
    var password = ""
    var repassword = ""
    var invite_code = ""
    var email_addr = ""
    ///话区域代码
    var area_phone_code = ""
    ///手机号码
    var phone_number = ""
    ///
    var user_address = ""
    ///输入的验证码
    var codeStr = ""
    
    let infoViewModel : InfoViewModel = InfoViewModel()
    
    
    lazy var titleL : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var countDownView : CountDownView = {
        let v = CountDownView()
        v.corner(cornerRadius: 4)
        v.backgroundColor = .hexColor("2D2D2D")
        return v
    }()
    
    private lazy var codeTF: CodeTextField = {
        
        let temTextField = CodeTextField(codeLength: 6, characterSpacing: (kScreenWidth - 40 * 6 - 24)/5.0 , validCharacterSet: CharacterSet(charactersIn: "0123456789"), characterLabelGenerator: { (_) -> LableRenderable in
            
            let label = StyleLabel(size: CGSize(width: 40, height: 40))
//            label.backgroundColor = backco
            label.font = FONTR(size: 24)
            label.style = Style.border(nomal: UIColor.hexColor("333333"), selected: UIColor.hexColor("333333"))
            label.corner(cornerRadius: 4)
            label.layer.borderColor = UIColor.hexColor("333333").cgColor
            return label
        })
        temTextField.codeDelegate = self
        temTextField.textColor  = .hexColor("FCD283")
        temTextField.keyboardType = .numberPad
        temTextField.translatesAutoresizingMaskIntoConstraints = false
        return temTextField
    }()

    
    lazy var doneBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_register_done".localized(), for: .normal)
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
    
    var viewModel = RegisterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_input_verify_code_tip".localized()
        setUI()
        initSubViewsConstraints()
        countDownView.countDownDidSeleted()
        viewModel.delegate = self
        infoViewModel.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}
// MARK: viewModel 代理
extension VerificationCodeVC : RegisterRequestDelegate,MineRequestDelegate{
    
    /// 获取用户信息成功回调
    func getUserInfoSuccess(model : InfoModel){
        self.infoViewModel.getUserRatecountry()
        NotificationCenter.default.post(name: LoginSuccessNotification, object: nil)
        let vc = RegisterSuccessVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///注册成功
    func registerAccountSuccess() {
        self.infoViewModel.getUserInfo()
    }
}
// MARK: - 点击事件
extension VerificationCodeVC{
    ///点击完成
    @objc func tapNextBtn(){
        if type == .email {
            viewModel.registerAccount(register_type: 2, phone_area_code: "", phone: "", email: email_addr, password: password, captcha: codeStr, invite_code: invite_code, user_address: user_address)
//            viewModel.emailRegisterAccount(password: password, repassword: repassword, invite_code: invite_code, register_type: self.type.rawValue, email_addr: email_addr, verify_code: codeStr, user_address: user_address)
        }else{
            viewModel.registerAccount(register_type: 1, phone_area_code: area_phone_code, phone: phone_number, email: "", password: password, captcha: codeStr, invite_code: invite_code, user_address: user_address)
//            viewModel.phoneRegisterAccount(password: password, repassword: repassword, invite_code: invite_code, register_type: self.type.rawValue, phone_number: phone_number, area_phone_code: area_phone_code, verify_code: codeStr, user_address: user_address)
        }
    }
}

// MARK: - UI
extension VerificationCodeVC{
    func setUI() {
//        codeView.delegate = self
        view.addSubview(titleL)
//        view.addSubview(codeView)
        view.addSubview(codeTF)
        codeTF.becomeFirstResponder()
        
        view.addSubview(countDownView)
        view.addSubview(doneBtn)
    }
    func initSubViewsConstraints() {
        titleL.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
//        codeView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(titleL.snp.bottom).offset(30)
//            make.height.equalTo(40)
//        }
        codeTF.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleL.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
        countDownView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(180)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        doneBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
    }
}

extension VerificationCodeVC : CodeTextFieldDelegate {
  
    func codeTextField(_ sender: CodeTextField, valueChanged: String) {
        
        print("\(valueChanged)")
        
        if valueChanged.count  == 6 {
            
            doneBtn.isUserInteractionEnabled = true
            doneBtn.isSelected = true
            codeStr = valueChanged
            sender.resignFirstResponder()
        }
    }
}
