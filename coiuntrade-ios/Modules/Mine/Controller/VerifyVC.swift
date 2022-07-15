//
//  GoogleVerifyVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit
enum VerifyType : Int{
    case google = 1
    case phone = 2
    case email = 3
}
class VerifyVC: BaseViewController {
    var type : VerifyType = .google
    
    let headView : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 76))
        return v
    }()
    
    let headLab : UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(x: LR_Margin, y: 0, width: SCREEN_WIDTH-LR_Margin*2, height: 76)
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 11)
        return lab
    }()
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(MineNormalCell.self, forCellReuseIdentifier:  MineNormalCell.CELLID)
        table.register(FaceTouchIDCell.self, forCellReuseIdentifier:  FaceTouchIDCell.CELLID)
        return table
    }()
    
    lazy var googleChCell : MineNormalCell = MineNormalCell(style: .default, reuseIdentifier: MineNormalCell.CELLID)
    lazy var googleSwichCell : FaceTouchIDCell = FaceTouchIDCell(style: .default, reuseIdentifier: FaceTouchIDCell.CELLID)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        setDataSource()
    }
    

}
// MARK: - 事件交互
extension VerifyVC{
    @objc func switchDidChange(sender:UISwitch) {
        if sender.isOn {///去开启
            switch type {
            case .google:
                let vc = OpenGoogleVerifyVC()
                navigationController?.pushViewController(vc, animated: true)
                break
            case .phone:
                self.skipvc(fromeVCType: .openPhone)
                break
            case .email:
                self.skipvc(fromeVCType: .openEmail)
                break
            }
            sender.isOn = false
        }else{///去关闭
            
            let securityType : SecurityType = getSecurityVerificationInfoType(model: userManager.infoModel ?? InfoModel())
            if securityType != .all {
                self.googleSwichCell.swichView.isOn = true
                switch type {
                case .google:
                    HudManager.showOnlyText("您在解绑谷歌验证之前需要先绑定所有验证。".localized())
                    break
                case .phone:
                    HudManager.showOnlyText("您在解绑手机验证之前需要先绑定所有验证。".localized())
                    break
                case .email:
                    HudManager.showOnlyText("您在解绑邮箱验证之前需要先绑定所有验证。".localized())
                    break
                }
                return
            }
            var titleStr = ""
            var msgStr = ""
            var fromeVCType : FromeVCType = .closeEmail
            switch type {
            case .google:
                titleStr = "tv_confirm_close_google_title".localized()
                msgStr = "tv_confirm_close_google_tip".localized()
                fromeVCType = .closeGoogle
                break
            case .phone:
                titleStr = "tv_safe_close_phone".localized()
                msgStr = "tv_safe_close_phone_content".localized()
                fromeVCType = .closePhone
                break
            case .email:
                titleStr = "tv_close_safe_mail_title".localized()
                msgStr = "tv_close_safe_mail_content".localized()
                fromeVCType = .closeEmail
                break
            }
            
            tipManager.showAlert(icon: "alert_tip", title: titleStr, message: msgStr, actionArray: ["common_cancel".localized(),"tv_continue".localized()] ,completion:{[weak self] isok in
                if isok{
                    self?.googleSwichCell.swichView.isOn = false
                    self?.skipvc(fromeVCType: fromeVCType)
                }else{
                    self?.googleSwichCell.swichView.isOn = true
                }
            })
        }
    }
    func skipvc(fromeVCType : FromeVCType){
        let vc = SecurityVerificationVC()
        vc.fromeVCType = fromeVCType
        let model : InfoModel = userManager.infoModel ?? InfoModel()
        vc.type = getSecurityVerificationInfoType(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UI
extension VerifyVC{
    
    func setDataSource(){
        let info = userManager.infoModel
        switch type {
        case .email:
            titleLab.text = "tv_safe_mail".localized()
            headLab.text = "tv_mail_setting_tip".localized()
            googleChCell.titleLab.text = "tv_safe_update_mail".localized()
            googleSwichCell.titleLab.text = "tv_safe_mail".localized()
            googleSwichCell.isHidderArrow = true
            googleSwichCell.swichView.setOn((info?.is_email_auth == 0) ? false : true, animated: false)
            break
        case .phone:
            titleLab.text = "tv_safe_phone".localized()
            headLab.text = "tv_phone_setting_tip".localized()
            googleChCell.titleLab.text = "tv_safe_update_phone".localized()
            googleSwichCell.titleLab.text = "tv_safe_phone".localized()
            googleSwichCell.isHidderArrow = true
            googleSwichCell.swichView.setOn((info?.is_phone_auth == 0) ? false : true, animated: false)
            break
        case .google:
            titleLab.text = "tv_safe_google".localized()
            headLab.text = "tv_google_setting_tip_two".localized()
            googleChCell.titleLab.text = "tv_safe_update_google".localized()
            googleSwichCell.titleLab.text = "tv_safe_google".localized()
            googleSwichCell.isHidderArrow = true
            googleSwichCell.swichView.setOn((info?.is_google_auth == 0) ? false : true, animated: false)
            break
        }
    }
    func setUI() {
        googleSwichCell.swichView.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        view.addSubview(tableView)
        headView.addSubview(headLab)
        tableView.tableHeaderView = headView
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(15)
        }
    }
}
// MARK: - UITableViewDelegate
extension VerifyVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        let info = userManager.infoModel
        switch type {
        case .email:
            if info?.is_email_auth == 0 {
                return 1
            }else{
                return 2
            }
        case .phone:
            if info?.is_phone_auth == 0 {
                return 1
            }else{
                return 2
            }
        case .google:
            if info?.is_google_auth == 0 {
                return 1
            }else{
                return 2
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }else{
            return 30
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return googleSwichCell
        }else{
            return googleChCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            
        }else{
            var titleStr = ""
            var msgStr = ""
            
            switch type {
            case .google:
                titleStr = "tv_confirm_update_google_tip".localized()
                msgStr = "tv_confirm_update_google_title".localized()
                break
            case .phone:
                titleStr = "tv_safe_phone_dialog_title".localized()
                msgStr = "tv_safe_phone_dialog_content".localized()
                break
            case .email:
                titleStr = "tv_safe_mail_dialog_title".localized()
                msgStr = "tv_safe_mail_dialog_content".localized()
                break
            }
            tipManager.showAlert(icon: nil, title: titleStr, message: msgStr, actionArray: ["common_cancel".localized(),"tv_continue".localized()],completion: {[weak self] isok in
                if isok{
                    if self?.type == .phone {
                        self?.skipvc(fromeVCType: .resetPhone)
                    }else if self?.type == .email{
                        self?.skipvc(fromeVCType: .resetEmail)
                    }else{
                        self?.skipvc(fromeVCType: .resetGoogle)
//                        let vc = BackupKeyVC()
//                        vc.type = .changSecret
//                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }
}
