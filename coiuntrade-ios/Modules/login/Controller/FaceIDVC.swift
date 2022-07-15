//
//  FaceIDVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/12.
//

import UIKit

class FaceIDVC: BaseViewController {
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var iconView : QMUIButton = {
        let v = QMUIButton()
        v.spacingBetweenImageAndTitle = 30
        v.imagePosition = QMUIButtonImagePosition.top
        v.setImage(UIImage(named: (bioManager.getBiometryType() == .touchID) ? "icon_touchID" : "icon_faceID"), for: .normal)
        v.setTitle((bioManager.getBiometryType() == .touchID) ? "touch_ID_login_tip".localized() : "face_ID_login_tip".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.titleLabel?.font = FONTM(size: 14)
        v.addTarget(self, action: #selector(getFaceID), for: .touchUpInside)
        return v
    }()
    lazy var psdBtn : UIButton = {
        let btn  = UIButton()
        btn.setTitle("password_login".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapPsdBtn), for: .touchUpInside)
        return btn
    }()
    
//    var backClosure:(() -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLab.text = (bioManager.getBiometryType() == .touchID) ? "touch_ID_login".localized() : "face_ID_login".localized()
        setUI()
        initSubViewsConstraints()
    }
    
}


extension FaceIDVC{
    @objc func tapPsdBtn(){
        self.dismiss(animated: false) {
            let vc = getTopVC()
            userManager.logoutWithVC(currentVC: vc ?? BaseViewController())
        }

    }
    @objc func getFaceID(){
        bioManager.touchID { status in
            if status == .success {
                let token = Archive.getFaceIDtoken()
                Archive.saveToken(token)
                NotificationCenter.default.post(name: LoginSuccessNotification, object: nil)
                self.dismiss(animated: true)
            }else{
            }
        }
    }
}
extension FaceIDVC{
    func setUI(){
        view.addSubview(detailLab)
        view.addSubview(iconView)
        view.addSubview(psdBtn)
        
        let info : InfoModel = userManager.infoModel ?? InfoModel()
        detailLab.text = "tip_hello".localized() + info.user_account
        
    }
    func initSubViewsConstraints(){
        titleLab.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20+TOP_HEIGHT)
            make.height.equalTo(30)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(30)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(125)
        }
        psdBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(95+SafeAreaBottom))
            make.centerX.equalToSuperview()
        }
    }
}
