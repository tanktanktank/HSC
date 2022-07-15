//
//  PasswordView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit

class PasswordView: UIView {
    lazy var titleV : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var textV : QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.maximumTextLength = 16
        v.clearButtonMode = .whileEditing
        v.isSecureTextEntry = true
        v.setModifyClearButton()
        return v
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var seeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "login_nosee"), for: .normal)
        btn.setImage(UIImage(named: "login_see"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn), for: .touchUpInside)
        return btn
    }()
    lazy var passwordValidLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("E35461")
        lab.font = FONTR(size: 11)
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
extension PasswordView{
    
    ///明文密文
    @objc func tapSeeBtn(sender : UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textV.isSecureTextEntry = false
        }else{
            textV.isSecureTextEntry = true
        }
    }
}
//MARK: ui
extension PasswordView{
    func setUI() {
        self.addSubview(titleV)
        self.addSubview(textV)
        self.addSubview(line)
        self.addSubview(seeBtn)
        self.addSubview(passwordValidLabel)
    }
    func initSubViewsConstraints() {
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(30)
        }
        seeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(40)
            make.top.equalTo(titleV.snp.bottom).offset(12)
            make.width.equalTo(30)
        }
        textV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(seeBtn.snp.left).offset(-5)
            make.top.equalTo(titleV.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
        passwordValidLabel.snp.makeConstraints { make in
            make.left.equalTo(line)
            make.right.equalTo(line)
            make.top.equalTo(line.snp.bottom)
            make.height.equalTo(30)
        }
    }
}
