//
//  LanguageVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/28.
//

import UIKit

class LanguageVC: BaseViewController {
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("2D2D2D")
        table.showsVerticalScrollIndicator = false
        table.corner(cornerRadius: 4)
        table.register(LanguageCell.self, forCellReuseIdentifier:  LanguageCell.CELLID)
        return table
    }()
    /*
     language：
     英语 en
     日本语 jp
     韩语 kr
     马来西亚语 my
     泰国语 th
     越南语 vn
     简体中文 zh-CN
     繁体中文 zh-HK
     */
    var dataArray = [["title" : "tv_simplified_chinese".localized(),"type" : 0],["title" :"tv_traditional_chinese".localized(),"type" : 1],["title" : "tv_english".localized(),"type" : 2]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLab.text = "tv_language".localized()
        setUI()
        initSubViewsConstraints()
        print("\(Localize.availableLanguages())")
    }
}

// MARK: - UI
extension LanguageVC{
    func setUI() {
        view.addSubview(tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(30)
            make.height.equalTo(56*dataArray.count)
        }
    }
}
// MARK: - UITableViewDelegate
extension LanguageVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.CELLID, for: indexPath) as! LanguageCell
        
        let dic : [String : Any]  = dataArray.safeObject(index: indexPath.row) ?? [:]
        cell.nameLab.text = dic["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dic : [String : Any]  = dataArray.safeObject(index: indexPath.row) ?? [:]
        let type : Int = dic["type"] as! Int
        //en jp kr  my th vn zh-CN zh-HK
        if type == 0 {
            Localize.setCurrentLanguage("zh-Hans")
            Archive.saveLanguage("zh-CN")
        }else if type == 1 {
            Localize.setCurrentLanguage("zh-Hant")
            Archive.saveLanguage("zh-HK")
        }else{
            Localize.setCurrentLanguage("en")
            Archive.saveLanguage("en")
        }
        HudManager.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.titleLab.text = "tv_language".localized()
            self.dataArray = [["title" : "tv_simplified_chinese".localized(),"type" : 0],["title" :"tv_traditional_chinese".localized(),"type" : 1],["title" : "tv_english".localized(),"type" : 2]]
            NotificationCenter.default.post(name: SettingLanguageNotification, object: nil)
            self.tableView.reloadData()
            HudManager.dismissHUD()
        }
    }
}
