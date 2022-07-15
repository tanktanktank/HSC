//
//  SettingViewController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit

class SettingViewController: BaseViewController {
    
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
    
    var dataArray  = Array<Array<[String : String]>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_personal_setting".localized()
        self.dataArray = getDatas()
        setUI()
        initSubViewsConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
    }

}
extension SettingViewController {
    ///更换语言
    @objc func changeLangage(){
        titleLab.text = "tv_personal_setting".localized()
        self.dataArray = getDatas()
        self.tableView.reloadData()
    }
}
extension SettingViewController{
    ///获取缓存
    func getCacheSize()-> String {
        // 取出cache文件夹目录
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = cachePath! + ("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (key, fileSize) in floder {
                // 累加文件大小
                if key == FileAttributeKey.size {
                    size += (fileSize as AnyObject).integerValue
                }
            }
        }
        let totalCache = Double(size) / 1024.00 / 1024.00
        return String(format: "%.2f", totalCache) + "M"
    }
    ///删除缓存
    func clearCache() {
        // 取出cache文件夹目录
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                }
            }
        }
        HudManager.showOnlyText("tv_clear_cache_tips".localized())
        
        self.dataArray = getDatas()
        self.tableView.reloadData()
    }
}
// MARK: - UI
extension SettingViewController{
    func setUI() {
        view.addSubview(tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
        }
    }
    func getDatas() -> Array<Array<[String : String]>>{
        let cacheStr = getCacheSize()
        
        let appVersion : String = "v" + ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "")
        let rate = userManager.tocoin
        var language : String = "tv_simplified_chinese".localized()
        if Archive.getLanguage() == "en" {
            language = "tv_english".localized()
        }else if Archive.getLanguage() == "zh-HK" {
            language = "tv_traditional_chinese".localized()
        }else{
            language = "tv_simplified_chinese".localized()
        }
        
        let array = [[["name":"tv_more_language".localized(),"content":language],["name":"exchange_rate".localized(),"content":rate]],[["name":"tv_setting_clear_cache".localized(),"content":cacheStr],["name":"tv_setting_sevice".localized(),"content":""],["name":"tv_setting_privacy".localized(),"content":""],["name":"tv_about_us".localized(),"content":appVersion]]]
        return array
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}
// MARK: - UITableViewDelegate
extension SettingViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmpArray = dataArray[section]
        return tmpArray.count
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
        let tmpArray = dataArray[indexPath.section]
        let dict  = tmpArray[indexPath.row]
        cell.titleLab.text = dict["name"]
        cell.detailLab.text = dict["content"]
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                cell.detailLab.text = userManager.tocoin
            }
        }
        
        if indexPath.row == 0 {
            cell.type = .top
        }else if indexPath.row == tmpArray.count-1 {
            cell.type = .bottom
        }else{
            cell.type = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {//多语言
                let vc = LanguageVC()
                navigationController?.pushViewController(vc, animated: true)
                return
            }else{
                let vc = ExchangeViewController()
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }else{
            if indexPath.row == 0{
                
                tipManager.showAlert(icon: "alert_question", title: "tv_setting_clear_cache".localized(), message: "tv_setting_clear_cache_tip".localized(), actionArray: ["common_cancel".localized(),"tv_continue".localized()] ,completion:{[weak self] isok in
                    if isok{
                        //清楚缓存
                        self?.clearCache()
                    }
                })
            }else if indexPath.row == 1{
                
            }else if indexPath.row == 2{
                
            }else{//关于
                let vc = AboutVC()
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
    }
}
