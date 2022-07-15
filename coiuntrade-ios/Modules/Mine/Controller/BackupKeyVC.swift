//
//  BackupKeyVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit
enum GoogleSecretType : Int{
    ///获取
    case getSecret = 1
    ///更改
    case changSecret = 2
}
class BackupKeyVC: BaseViewController {
    var type : GoogleSecretType = .getSecret
    
    lazy var topTitleV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 11)
        v.text = "tv_bind_google_account_tip".localized()
        v.numberOfLines = 0
        return v
    }()
    lazy var qrCodeV : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var keyView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var keyLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        return v
    }()
    lazy var copyBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_copy".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 14)
        btn.addTarget(self, action: #selector(tapCopyBtn), for: .touchUpInside)
        return btn
    }()
    lazy var bottomTitleV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 11)
        v.text = "tv_bind_google_code_tip".localized()
        v.numberOfLines = 0
        return v
    }()
    lazy var bandBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_google_bind".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.backgroundColor = .hexColor("FCD283")
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapBandBtn), for: .touchUpInside)
        return btn
    }()
    let viewModel = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "备份密钥".localized()
        setUI()
        initSubViewsConstraints()
        viewModel.getGoogleAuth(type: type.rawValue)
    }
    

}

// MARK: - 点击事件
extension BackupKeyVC{
    ///点击绑定
    @objc func tapBandBtn(){
        let vc = SecurityVerificationVC()
        vc.fromeVCType = (type == .getSecret) ? .openGoogle : .resetGoogle
        let model : InfoModel = userManager.infoModel ?? InfoModel()
        vc.type = getSecurityGoole(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    ///点击copy
    @objc func tapCopyBtn(){
        
        let str = keyLab.text
        UIPasteboard.general.string = str
        HudManager.showOnlyText("复制成功".localized())
    }
    
    func getSecurityGoole(model : InfoModel) -> SecurityType{
        
        if model.is_email_auth == 1, model.is_google_auth == 0, model.is_phone_auth == 0{
            return .emailAndGoogle
        }
        if model.is_email_auth == 0, model.is_google_auth == 0, model.is_phone_auth == 1{
            return .phoneAndGoogle
        }
        return .all
    }
}
// MARK: - Viewmodel 代理
extension BackupKeyVC : MineRequestDelegate{
    func getGoogleAuthSuccess(model : SecretGoogle){
        qrCodeV.image = QRcode.createQRCodeByCIFilterWithString(model.google_auth, andImage: UIImage(named: "") ?? UIImage())
        keyLab.text = model.secret
    }
}
// MARK: - UI
extension BackupKeyVC{
    func setUI() {
        viewModel.delegate = self
        view.addSubview(bandBtn)
        view.addSubview(topTitleV)
        view.addSubview(qrCodeV)
        view.addSubview(keyView)
        view.addSubview(bottomTitleV)
        keyView.addSubview(keyLab)
        keyView.addSubview(copyBtn)
    }
    func initSubViewsConstraints() {
        let space = is_iPhoneXSeries() ? 60 : 50
        
        bandBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-83)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
        topTitleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(30)
        }
        qrCodeV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topTitleV.snp.bottom).offset(space)
            make.width.height.equalTo(154)
        }
        keyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(qrCodeV.snp.bottom).offset(space)
            make.height.equalTo(56)
        }
        bottomTitleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(keyView.snp.bottom).offset(12)
        }
        copyBtn.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(52)
        }
        keyLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(copyBtn.snp.left)
        }
    }
}
