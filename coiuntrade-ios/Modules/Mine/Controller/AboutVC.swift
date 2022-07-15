//
//  AboutVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit

class AboutVC: BaseViewController {
    
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
    lazy var headView : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 68))
        return v
    }()
    let iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "LOGO_icon")
        return v
    }()
    lazy var bundleLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTB(size: 16)
        return v
    }()
    
    let dataArray = [["name":"Facebook","icon":"facebook_icon"],["name":"Twitter","icon":"twitter_icon"],["name":"Telegram","icon":"telegram_icon"],["name":"tv_check_update".localized(),"icon":"check_icon"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLab.text = "tv_about_us".localized()
        setUI()
        initSubViewsConstraints()
    }

}
// MARK: - UI
extension AboutVC{
    func setUI() {
        let appVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        bundleLab.text = "v" + appVersion
        headView.addSubview(iconView)
        headView.addSubview(bundleLab)
        
        view.addSubview(tableView)
        tableView.tableHeaderView = headView
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(38)
        }
        bundleLab.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.centerY.equalTo(iconView)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
        }
        
    }
}
// MARK: - UITableViewDelegate
extension AboutVC : UITableViewDelegate,UITableViewDataSource{
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
        
        let dict = dataArray[indexPath.section]
        cell.titleLab.text = dict["name"]
        cell.iconView.image = UIImage(named: dict["icon"] ?? "")
        cell.type = .all
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let str = "https://www.baidu.com/"
            let vc = WebViewController()
            vc.urlStr = str
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
