//
//  FuturesOrderDetailVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/13.
//

import UIKit

class FuturesOrderDetailVC: BaseViewController {
    
    lazy var headView = FuturesDetailHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 408))
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(FuturesOrderDetailCell.self, forCellReuseIdentifier:  FuturesOrderDetailCell.CELLID)
        return table
    }()
    
    var dataArray = ["1","2","3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "tv_order_detail".localized()
        setUI()
        initSubViewsConstraints()
        // Do any additional setup after loading the view.
    }
    

}
//MARK: ui
extension FuturesOrderDetailVC{
    func setUI() {
        self.tableView.tableHeaderView = headView
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension FuturesOrderDetailVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 189
        }
        return 156
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FuturesOrderDetailCell.CELLID, for: indexPath) as! FuturesOrderDetailCell
        if indexPath.row == 0 {
            if self.dataArray.count == 1 {
                cell.changeUI(isShowTitleName: true, isShowLine: false, type: .all)
            }else{
                cell.changeUI(isShowTitleName: true, isShowLine: true, type: .top)
            }
        }else{
            if indexPath.row == self.dataArray.count-1 {
                cell.changeUI(isShowTitleName: false, isShowLine: false, type: .bottom)
            }else{
                cell.changeUI(isShowTitleName: false, isShowLine: true, type: .none)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
