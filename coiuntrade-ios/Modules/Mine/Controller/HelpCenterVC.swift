//
//  HelpCenterVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit

class HelpCenterVC: BaseViewController {
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(MineTableViewCell.self, forCellReuseIdentifier:  MineTableViewCell.CELLID)
        return table
    }()
    
    let dataArray = ["tv_personal_help".localized(),"tv_setting_feedback".localized(),"tv_online_sevice".localized()]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLab.text = "tv_personal_help".localized()
        setUI()
        initSubViewsConstraints()
    }

}
// MARK: - UI
extension HelpCenterVC{
    func setUI() {
        view.addSubview(tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
        }
    }
}
// MARK: - UITableViewDelegate
extension HelpCenterVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MineTableViewCell.CELLID, for: indexPath) as! MineTableViewCell
        cell.isHidddIcon = true
        let str = dataArray[indexPath.section]
        cell.titleLab.text = str
        
        cell.type = .all
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
        }
    }
}
