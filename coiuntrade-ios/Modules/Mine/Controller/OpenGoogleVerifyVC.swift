//
//  OpenGoogleVerifyVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit

class OpenGoogleVerifyVC: BaseViewController {
    let headView : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 76))
        return v
    }()
    
    let headLab : UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(x: LR_Margin, y: 0, width: SCREEN_WIDTH-LR_Margin*2, height: 76)
        lab.text = "tv_google_setting_tip_one".localized()
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
        return table
    }()
    
    lazy var downLoadCell : MineNormalCell = MineNormalCell(style: .default, reuseIdentifier: MineNormalCell.CELLID)
    lazy var bandCell : MineNormalCell = MineNormalCell(style: .default, reuseIdentifier: MineNormalCell.CELLID)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLab.text = "tv_safe_google".localized()
        setUI()
        initSubViewsConstraints()
    }
    

}
// MARK: - UI
extension OpenGoogleVerifyVC{
    func setUI() {
        downLoadCell.titleLab.text = "tv_upload_google".localized()
        bandCell.titleLab.text = "tv_bing_google_account".localized()
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
extension OpenGoogleVerifyVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
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
            return downLoadCell
        }else{
            return bandCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let str  = "https://apps.apple.com/cn/app/google-authenticator/id388497605"
            guard let url = URL(string: str) else { return }
            let can = UIApplication.shared.canOpenURL(url)
            if can {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:]) { (b) in
                        print("打开结果: \(b)")
                    }
                } else {
                    //iOS 10 以前
                    UIApplication.shared.openURL(url)
                }
            }
        }else{
            let vc = BackupKeyVC()
            vc.type = .getSecret
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
