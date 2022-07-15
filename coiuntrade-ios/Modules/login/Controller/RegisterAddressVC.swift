//
//  RegisterAddressVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

class RegisterAddressVC: BaseViewController {
    lazy var regDitailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTM(size: 14)
        lab.textColor = .hexColor("989898")
        lab.text = "tv_welcom_area_tip".localized()
        return lab
    }()
    lazy var countTitleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTM(size: 14)
        lab.textColor = .hexColor("989898")
        lab.text = "tv_welcom_area".localized()
        return lab
    }()
    
    lazy var countImageView: UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 10)
        return v
    }()
    lazy var countBtn : QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("中国", for: .normal)
        btn.titleLabel?.font = FONTR(size: 14)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.addTarget(self, action: #selector(tapCountBtn), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("333333")
        return v
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .center
         return v
    }()
    lazy var otherLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 11)
        lab.textColor = .hexColor("989898")
        lab.text = "tv_welcom_area_tip_one".localized()
        return lab
    }()
    lazy var sureBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_confirm".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.backgroundColor = .hexColor("FCD283")
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapSureBtn), for: .touchUpInside)
        return btn
    }()
    
    var user_address = "中国"
    var countrymodel : CountryModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_welcome_hdex".localized()
        setUI()
        initSubViewsConstraints()
    }
    
}
// MARK: - 点击事件
extension RegisterAddressVC{
    @objc func tapSureBtn(){
        let vc = RegisterTypeVC()
        vc.type = .email
        vc.user_address = self.user_address
        if self.countrymodel != nil {
            vc.countrymodel = self.countrymodel
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    ///点击选取国家地区
    @objc func tapCountBtn(){
        let vc = CountListVC()
        vc.selectedCountryClick = {[weak self](model : CountryModel) in
            self?.countImageView.kf.setImage(with: model.countryicon, placeholder: nil)
            self?.user_address = model.namezh
            self?.countBtn.setTitle(model.namezh, for: .normal)
            self?.countrymodel = model
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UI
extension RegisterAddressVC{
    func setUI(){
        view.addSubview(regDitailLab)
        view.addSubview(countTitleLab)
        view.addSubview(countImageView)
        view.addSubview(countBtn)
        view.addSubview(arrow)
        view.addSubview(line)
        view.addSubview(otherLab)
        view.addSubview(sureBtn)
        
        countImageView.kf.setImage(with: self.getDefaultCountryicon(), placeholder: nil)
    }
    func initSubViewsConstraints(){
        regDitailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(30)
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.width.equalTo(11)
            make.height.equalTo(40)
            make.top.equalTo(regDitailLab.snp.bottom).offset(15)
        }
        countImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalTo(arrow)
            make.width.height.equalTo(20)
        }
        countBtn.snp.makeConstraints { make in
            make.left.equalTo(countImageView.snp.right).offset(8)
            make.right.equalTo(arrow.snp.left).offset(-3)
            make.top.height.equalTo(arrow)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(1)
            make.top.equalTo(countBtn.snp.bottom)
        }
        otherLab.snp.makeConstraints { make in
            make.left.equalTo(line)
            make.top.equalTo(line.snp.bottom).offset(12)
        }
        sureBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
    }
}
