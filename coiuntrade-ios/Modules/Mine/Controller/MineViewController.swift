//
//  MineViewController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/25.
//

import UIKit

class MineViewController: BaseViewController {
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(MineTableViewCell.self, forCellReuseIdentifier:  MineTableViewCell.CELLID)
        table.register(HomeAuthCell.self, forCellReuseIdentifier:  HomeAuthCell.CELLID)
        return table
    }()
    
    lazy var authCell : HomeAuthCell = HomeAuthCell(style: .default, reuseIdentifier: HomeAuthCell.CELLID)
    
    var dataArray = [[["name":"tv_personal_safety".localized(),"icon":"mine_safe"],["name":"tv_personal_setting".localized(),"icon":"mine_setting"]],[["name":"tv_personal_help".localized(),"icon":"mine_help"],["name":"tv_personal_share".localized(),"icon":"mine_share"]],[["name":"认证中心","icon":"mine_safe"]]]
    
    lazy var msgLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 10)
        lab.text = "tv_personal_tip".localized()
        lab.textColor = .hexColor("989898")
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    lazy var logoutBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_personal_log_out".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 13)
        btn.corner(cornerRadius: 4)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.addTarget(self, action: #selector(tapLogout), for: .touchUpInside)
        return btn
    }()
    var viewModel = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        getDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: LoginSuccessNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: UpdataUserInfoNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotoSafe), name: PerfectInformationNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signout), name: SignoutSuccessNotification, object: nil)
    }
    ///被挤掉线
    @objc func signout(notify : Notification){
        upDateUI()
    }
    ///登录成功
    @objc func loginSuccess(notify : Notification){
        getDataSource()
    }
    @objc func gotoSafe(notify : Notification){
        let vc = MineSafeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    ///更换语言
    @objc func changeLangage(){
        authCell.authLab.text = "tv_certified".localized()
        logoutBtn.setTitle("tv_personal_log_out".localized(), for: .normal)
        self.dataArray = [[["name":"tv_personal_safety".localized(),"icon":"mine_safe"],["name":"tv_personal_setting".localized(),"icon":"mine_setting"]],[["name":"tv_personal_help".localized(),"icon":"mine_help"],["name":"tv_personal_share".localized(),"icon":"mine_share"]],[["name":"认证中心","icon":"mine_safe"]]]
        upDateUI()
    }
}
// MARK: -
extension MineViewController{
    ///获取用户数据
    func getDataSource(){
        viewModel.getUserInfo()
    }
    ///退出登录
    @objc func tapLogout(){
        tipManager.showAlert(icon: "alert_tip", title: "tv_quit_login".localized(), message: "tv_quit_login_tip".localized(), actionArray: ["common_cancel".localized(),"tv_continue".localized()], completion: {[weak self] isok in
            if isok {
                userManager.userLogout()
                self?.upDateUI()
                userManager.logoutWithVC(currentVC: self ?? MineViewController())
            }
        })
    }
}
// MARK: - ViewModel代理
extension MineViewController : MineRequestDelegate{
    func getUserInfoSuccess(model: InfoModel) {
        upDateUI()
    }
    
}
// MARK: - UI
extension MineViewController{
    func upDateUI(){
        authCell.isLogin = userManager.isLogin
        if userManager.isLogin {
            authCell.infoModel = userManager.infoModel
            logoutBtn.isHidden = false
        }else{
            authCell.titleLab.text = "tv_login_or_register".localized()
            authCell.iconView.image = UIImage(named: "")
            logoutBtn.isHidden = true
        }
        tableView.reloadData()
    }
    func setUI() {
        viewModel.delegate = self
        view.addSubview(tableView)
        view.addSubview(msgLab)
        view.addSubview(logoutBtn)
        upDateUI()
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        msgLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-42)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
        logoutBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview().offset(-83)
            make.height.equalTo(40)
        }
    }
}
// MARK: - UITableViewDelegate
extension MineViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count+1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            let array = dataArray[section-1]
            return array.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 66
        }else{
            return 56
        }
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
            return authCell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MineTableViewCell.CELLID, for: indexPath) as! MineTableViewCell
            let tmpArray = dataArray[indexPath.section-1]
            let dict  = tmpArray[indexPath.row]
            cell.titleLab.text = dict["name"]
            cell.iconView.image = UIImage(named: dict["icon"] ?? "")
            if indexPath.section == 3 {
                cell.type = .all
            }else{
                if indexPath.row == 0 {
                    cell.type = .top
                }else if indexPath.row == tmpArray.count-1 {
                    cell.type = .bottom
                }else{
                    cell.type = .none
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {//偏好设置
            if userManager.isLogin {
                let vc = UserDefaultVC()
                navigationController?.pushViewController(vc, animated: true)
            }else{
                if Archive.getFaceID() {
                    let vc = FaceIDVC()
                    
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }else{
                    userManager.logoutWithVC(currentVC: self)
                }
            }
            return
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {//安全
                if userManager.isLogin {
                    let vc = MineSafeVC()
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }else{
                    userManager.logoutWithVC(currentVC: self)
                    return
                }
            }else{
                //设置
                let vc = SettingViewController()
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {//帮助中心
                let vc = HelpCenterVC()
                navigationController?.pushViewController(vc, animated: true)
                return
            }else{//分享
                let vc = ShareVC()
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }else{
            let vc = UserCertificationVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
