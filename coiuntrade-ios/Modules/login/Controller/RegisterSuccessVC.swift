//
//  RegisterSuccessVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class RegisterSuccessVC: BaseViewController {
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "register_success")
        return v
    }()
    lazy var successLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.text = "tv_register_sucess".localized()
        lab.font = FONTR(size: 22)
        return lab
    }()
    lazy var safeTitleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_register_success".localized()
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var perfectView = RegisterSuccCellView()
    lazy var safeView = RegisterSuccCellView()
    ///跳过
    lazy var skipBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_skip".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapSkipBtn), for: .touchUpInside)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.corner(cornerRadius: 4)
        return btn
    }()
    ///开始完善
    lazy var perfectBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_start_perfect_info".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.backgroundColor = .hexColor("FCD283")
        btn.addTarget(self, action: #selector(tapPerfectBtn), for: .touchUpInside)
        btn.corner(cornerRadius: 4)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tapBack))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
// MARK: - 点击事件
extension RegisterSuccessVC{
    @objc func tapBack(){
    }
    ///点击跳过
    @objc func tapSkipBtn(){
        self.dismiss(animated: true)
    }
    ///点击开始完善
    @objc func tapPerfectBtn(){
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: PerfectInformationNotification, object: nil)
        }
    }
}
// MARK: - UI
extension RegisterSuccessVC{
    func setUI() {
        perfectView.iconView.image = UIImage(named: "register_perfect")
        perfectView.titleLab.text = "tv_perfect_personal_info".localized()
        perfectView.detailLab.text = "tv_perfect_info_tip".localized()
        safeView.iconView.image = UIImage(named: "register_safe")
        safeView.titleLab.text = "tv_security_verification".localized()
        safeView.detailLab.text = "tv_security_verfication_tip".localized()
        view.addSubview(iconView)
        view.addSubview(successLab)
        view.addSubview(safeTitleLab)
        view.addSubview(perfectView)
        view.addSubview(safeView)
        view.addSubview(skipBtn)
        view.addSubview(perfectBtn)
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
            make.width.height.equalTo(51)
        }
        successLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(12)
        }
        safeTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(successLab.snp.bottom).offset(50)
        }
        perfectView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeTitleLab.snp.bottom)
            make.height.equalTo(72)
        }
        safeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(perfectView.snp.bottom)
            make.height.equalTo(72)
        }
        skipBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.bottom.equalToSuperview().offset(-83)
            make.width.equalTo(84)
            make.height.equalTo(47)
        }
        perfectBtn.snp.makeConstraints { make in
            make.left.equalTo(skipBtn.snp.right).offset(15)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.height.equalTo(skipBtn)
        }
    }
}
