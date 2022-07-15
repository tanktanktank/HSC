//
//  KlineTapFitController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class KlineTapFitController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    var type = DisposeBag()
    
    var selectIndex : IndexPath = [] {
        
        didSet{
            
            if oldValue == selectIndex || oldValue == [] {
                
                tableview.reloadRows(at: [selectIndex], with: .automatic)
            }else {
                
                tableview.reloadRows(at: [selectIndex , oldValue], with: .automatic)
            }
        }
    }
    
    lazy var tableview : BaseTableView = {
        let tableview = BaseTableView()
        
        tableview.register(KlineSetSubCell.self, forCellReuseIdentifier: "KlineSetSubCell")
        tableview.backgroundColor = .hexColor("1E1E1E")
        tableview.isScrollEnabled = false
        tableview.rowHeight = 86
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        return tableview
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLab.text = "双击副图效果".localized()
        titleLab.textColor = .hexColor("ffffff")
        
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
        }

    }
    
    func showSelect(select:Int) {
    }
    
}

extension KlineTapFitController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KlineSetSubCell") as! KlineSetSubCell
        cell.title = title
        
        if indexPath.row == 0{
            
            cell.title = "切换副图指标"
        }else if indexPath.row == 1 {
            
            cell.title = "无"
        }
        cell.checkImgview.isHidden =  selectIndex != indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.addSectionCorner(at: indexPath, radius: 4)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        self.selectIndex = indexPath
        
    }
}

