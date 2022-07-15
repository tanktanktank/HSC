//
//  WelcomeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/21.
//

import UIKit

class WelcomeVC: BaseViewController {

    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "login_welcome")
        return v
    }()
    lazy var registerBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_welcom_register_prompt".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 16)
        btn.addTarget(self, action: #selector(tapRegisterBtn), for: .touchUpInside)
        return btn
    }()
    lazy var leftArrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "login_right_arrow")
        v.contentMode = .center
        return v
    }()
    lazy var rightArrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "login_left_arrow")
        v.contentMode = .center
        return v
    }()
    lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(taploginBtn), for: .touchUpInside)
        return btn
    }()
    lazy var label = ActiveLabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLab.text = "tv_welcome_hdex".localized()
        setUI()
        initSubViewsConstraints()
    }
    
}

// MARK: - 点击事件
extension WelcomeVC{
    ///点击注册
    @objc func tapRegisterBtn(){
        let vc = RegisterAddressVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///点击登录
    @objc func taploginBtn(){
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UI
extension WelcomeVC {
    func setUI() {
        view.addSubview(iconView)
        view.addSubview(registerBtn)
        view.addSubview(leftArrow)
        view.addSubview(rightArrow)
        view.addSubview(loginBtn)
        view.addSubview(label)
        
        let attributedString = NSMutableAttributedString.init()//初始化
        attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: "tv_welcom_registered".localized(), font: 13, color: .hexColor("989898")))
        attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: "tv_login".localized(), font: 13, color: .hexColor("FFFFFF")))
        loginBtn.setAttributedTitle(attributedString, for: .normal)
        
        
        label.font = FONTR(size: 10)
        //   "筛选条件" ： :筛选文本
        let customType = ActiveType.custom(pattern: "tv_welcom_protocol_part_two".localized()) //Looks for "条款和条件"
        let customType1 = ActiveType.custom(pattern: "tv_welcom_protocol_part_three".localized()) //Looks for "数据保护指南"
        label.enabledTypes = [customType,customType1]
        label.customize { (label) in
            label.text = "tv_welcom_protocol_part_one".localized() + "tv_welcom_protocol_part_two".localized() + "tv_and".localized() + "tv_welcom_protocol_part_three".localized()
            label.numberOfLines = 0
            label.lineSpacing = 4
            label.textColor = .hexColor("989898")
            
            //Custom types
            label.customColor[customType] = .hexColor("FCD283")
            label.customColor[customType1] = .hexColor("FCD283")
            
            
            label.handleCustomTap(for: customType) {_ in
                print("条款和条件")
            }
            label.handleCustomTap(for: customType1) {_ in
                print("数据保护指南")
            }
        }
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(66)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(165)
        }
        registerBtn.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(76)
            make.centerX.equalToSuperview()
        }
        leftArrow.snp.makeConstraints { make in
            make.right.equalTo(registerBtn.snp.left).offset(-5)
            make.centerY.equalTo(registerBtn)
            make.height.equalTo(22)
        }
        rightArrow.snp.makeConstraints { make in
            make.left.equalTo(registerBtn.snp.right).offset(5)
            make.centerY.equalTo(registerBtn)
            make.height.equalTo(22)
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(registerBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-42)
            make.centerX.equalToSuperview()
        }
    }
}
