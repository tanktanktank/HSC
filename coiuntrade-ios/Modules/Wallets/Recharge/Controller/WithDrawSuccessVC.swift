//
//  WithdrawSuccessVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit

class WithDrawSuccessVC: BaseViewController {

    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "wallets_check_selscted")
        return v
    }()
    lazy var statusLab : UILabel = {
        let v = UILabel()
        v.font = FONTB(size: 16)
        v.textColor = .hexColor("FFFFFF")
        v.text = "tv_withdraw_tips".localized()
        return v
    }()
    lazy var timeLab : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 14)
        v.textColor = .hexColor("FFFFFF")
        v.text = "tv_expect_finsh_time".localized()
        return v
    }()
    lazy var detailLab : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("989898")
        v.numberOfLines = 0
        v.text = "提现完成后，您将收到一封电子邮件。请在历史记录页面查看最新的进展。".localized()
        return v
    }()
    lazy var seeHisBtn : UIButton = {
        let v = UIButton()
        v.backgroundColor = .hexColor("FCD283")
        v.setTitle("tv_check_history".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        v.titleLabel?.font = FONTB(size: 16)
        v.corner(cornerRadius: 4)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
    }

}
//MARK: ui
extension WithDrawSuccessVC{
    func setUI(){
        view.addSubview(iconView)
        view.addSubview(statusLab)
        view.addSubview(timeLab)
        view.addSubview(detailLab)
        view.addSubview(seeHisBtn)
    }
    func initSubViewsConstraints(){
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
            make.width.height.equalTo(48)
        }
        statusLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(30)
        }
        timeLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLab.snp.bottom).offset(30)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(timeLab.snp.bottom).offset(12)
        }
        seeHisBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview().offset(-83)
            make.height.equalTo(47)
        }
    }
}
