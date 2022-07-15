//
//  ResetEmailView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit
protocol ResetEmailViewDelegate {
    func emailSatisfyResetEmail(isok : Bool)
}
class ResetEmailView: UIView {
    var delegate:ResetEmailViewDelegate?
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
        v.keyboardType = .emailAddress
        return v
    }()
    lazy var line1 : UIView = {
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
        lab.text = "为了保护您的资产安全，修改密码后该账号将禁用支付服务、提币和C2C卖币24小时。"
        lab.font = FONTR(size: 10)
        lab.textColor = .hexColor("989898")
        lab.numberOfLines = 0
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
//MARK: 事件处理
extension ResetEmailView{
    @objc func clickEmailText(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        if count > 0 {
            line1.backgroundColor = .hexColor("FCD283")
            if checkEmail(email: sender.text ?? "") {
                self.delegate?.emailSatisfyResetEmail(isok: true)
                return
            }
        }else{
            line1.backgroundColor = .hexColor("333333")
        }
        self.delegate?.emailSatisfyResetEmail(isok: false)
    }
}
extension ResetEmailView{
    func setUI() {
        self.addSubview(emailTitleLab)
        self.addSubview(emailText)
        self.addSubview(line1)
        self.addSubview(tipIcon)
        self.addSubview(tipLab)
        emailText.addTarget(self, action: #selector(clickEmailText), for: .editingChanged)
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
        tipIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(line1.snp.bottom).offset(12)
            make.width.height.equalTo(13)
        }
        tipLab.snp.makeConstraints { make in
            make.left.equalTo(tipIcon.snp.right).offset(2)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(tipIcon)
        }
    }
}

