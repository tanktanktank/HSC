//
//  FututesChildFlowwaterVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/13.
//

import UIKit

class FuturesChildFlowwaterVC: BaseViewController {
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(FuturedFlowwaterCell.self, forCellReuseIdentifier:  FuturedFlowwaterCell.CELLID)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        
        tableView.emptyData = setupEmptyDataView(type:.noData)
        configurationTabelViewRefresh()
        // Do any additional setup after loading the view.
    }

}
// MARK: - UI
extension FuturesChildFlowwaterVC {
    func setUI() {
//        self.viewModel.delegate = self
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    func configurationTabelViewRefresh() {
//        self.tableView.nomalMJHeaderRefresh { [weak self] in
//            self?.loadDataRequest()
//        }
//
//        self.tableView.nomalMJFooterRefresh { [weak self] in
//            self?.loadMoreDataRequest()
//        }
//
//        self.tableView.beginMJPullRefresh()
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension FuturesChildFlowwaterVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FuturedFlowwaterCell.CELLID, for: indexPath) as! FuturedFlowwaterCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: JXPagingViewListViewDelegate
extension FuturesChildFlowwaterVC : JXPagingViewListViewDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.scrollClosure = callback
    }

}
