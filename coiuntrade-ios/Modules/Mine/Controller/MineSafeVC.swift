//
//  MineSafeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit

class MineSafeVC: BaseViewController {
    lazy var headView = MineSafeHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 97))
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(MineSafeCell.self, forCellReuseIdentifier:  MineSafeCell.CELLID)
        table.register(MineNormalCell.self, forCellReuseIdentifier:  MineNormalCell.CELLID)
        table.register(FaceTouchIDCell.self, forCellReuseIdentifier:  FaceTouchIDCell.CELLID)
        return table
    }()
    lazy var GoogleCell : MineSafeCell = MineSafeCell(style: .default, reuseIdentifier: MineSafeCell.CELLID)
    lazy var phoneCell : MineSafeCell = MineSafeCell(style: .default, reuseIdentifier: MineSafeCell.CELLID)
    lazy var emailCell : MineSafeCell = MineSafeCell(style: .default, reuseIdentifier: MineSafeCell.CELLID)
    lazy var pwCell : MineNormalCell = MineNormalCell(style: .default, reuseIdentifier: MineNormalCell.CELLID)
    lazy var faceCell : FaceTouchIDCell = FaceTouchIDCell(style: .default, reuseIdentifier: FaceTouchIDCell.CELLID)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLab.text = "tv_personal_safety".localized()
        setUI()
        initSubViewsConstraints()
        setDataSource()
        // Do any additional setup after loading the view.
    }
}

// MARK: - UI
extension MineSafeVC{
    func setDataSource(){
        let info = userManager.infoModel
        
        GoogleCell.titleLab.text = "tv_safe_google".localized()
        GoogleCell.isVerify = (info?.is_google_auth == 0) ? false : true
        GoogleCell.type = .top
        phoneCell.titleLab.text = "tv_safe_phone".localized()
        phoneCell.isVerify = (info?.is_phone_auth == 0) ? false : true
        phoneCell.type = .none
        emailCell.titleLab.text = "tv_safe_mail".localized()
        emailCell.isVerify = (info?.is_email_auth == 0) ? false : true
        emailCell.type = .bottom
        
        pwCell.titleLab.text = "tv_safe_update_pwd".localized()
        faceCell.titleLab.text = "face_ID_unlocked".localized()
        faceCell.isHidderArrow = true
        faceCell.swichView.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        
        faceCell.swichView.isOn = Archive.getFaceID()
    }
    func setUI() {
        view.addSubview(tableView)
        tableView.tableHeaderView = headView
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(15)
        }
    }
}
extension MineSafeVC{
    ///开启关闭faceID
    @objc func switchDidChange(sender:UISwitch) {
        if sender.isOn {
            bioManager.touchID {[weak self] status in
                if status == .success {
                    self?.faceCell.swichView.isOn = true
                    Archive.saveFaceID(true)
                    let token = Archive.getToken()
                    Archive.saveFaceIDtoken(token)
                }else{
                    self?.faceCell.swichView.isOn = false
                }
            }
        }else{
            bioManager.touchID {[weak self] status in
                if status == .success {
                    self?.faceCell.swichView.isOn = false
                    Archive.saveFaceID(false)
                    Archive.saveFaceIDtoken("")
                    let token = Archive.getToken()
                    Archive.saveFaceIDtoken(token)
                }else{
                    self?.faceCell.swichView.isOn = true
                }
            }
        }
    }
}
// MARK: - UITableViewDelegate
extension MineSafeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 1
        }
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
            if indexPath.row == 0 {
                return GoogleCell
            }else if indexPath.row == 1 {
                return phoneCell
            }else{
                return emailCell
            }
        }else if indexPath.section == 1 {
            return pwCell
        }else{
            return faceCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                ///谷歌验证器
                let vc = VerifyVC()
                vc.type = .google
                navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                ///手机验证
                let vc = VerifyVC()
                vc.type = .phone
                navigationController?.pushViewController(vc, animated: true)
            }else{
                ///邮箱验证
                let vc = VerifyVC()
                vc.type = .email
                navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1 {
            ///修改密码
            let vc = ChangePWDVC()
            navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
}
