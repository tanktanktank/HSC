//
//  EntrustChildHistoryVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/2.
//

import UIKit


class EntrustChildHistoryVC: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    var page = 1
    var viewModel = EntrustViewModel()
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(EntrustHisCell.self, forCellReuseIdentifier:  EntrustHisCell.CELLID)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        
        tableView.emptyData = setupEmptyDataView(type:.noData)
        configurationTabelViewRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateHistory), name: Notification.Name("TradeUpdateFilterHistoryKey"), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TradeUpdateFilterHistoryKey"), object: nil)
    }
    
    @objc func updateHistory(noti: Notification){
        
        let info = noti.userInfo
        self.page = 1
        self.viewModel.requestEntrust(get_type: -1, page: self.page, startTime: info!["startTime"] as! Int, endTime: info!["endTime"] as! Int, symbol: info!["symbol"] as! String ,buy_type: 0,time_info: info!["time_info"] as! String)
    }
    

}
// MARK: -  网络请求
extension EntrustChildHistoryVC {
    func listDataRequest(){
        self.viewModel.requestEntrust(get_type: -1, page: self.page)
    }
    func loadDataRequest() {
        self.page = 1
        listDataRequest()
        self.tableView.reloadData()
    }
    func loadMoreDataRequest() {
        listDataRequest()
    }
}
extension EntrustChildHistoryVC : EntrustRequestDelegate{
    
    /// 获取获取历史委托订单成功回调
    func getHistoryEntrustSuccess(){
        self.page += 1
        self.tableView.endMJRefresh()
        self.tableView.reloadData()
    }
    /// 获取列表数据失败回调
    func getListFailure(){
        self.tableView.reloadData()
        self.tableView.endMJRefresh()
    }
}
// MARK: - UI
extension EntrustChildHistoryVC {
    func setUI() {
        self.viewModel.delegate = self
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    func configurationTabelViewRefresh() {
        self.tableView.nomalMJHeaderRefresh { [weak self] in
            self?.loadDataRequest()
        }

        self.tableView.nomalMJFooterRefresh { [weak self] in
            self?.loadMoreDataRequest()
        }
        
        self.tableView.beginMJPullRefresh()
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension EntrustChildHistoryVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.historyEntrust.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
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
        let cell = tableView.dequeueReusableCell(withIdentifier: EntrustHisCell.CELLID, for: indexPath) as! EntrustHisCell
        
        let model : EntrustModel = self.viewModel.historyEntrust.safeObject(index: indexPath.row) ?? EntrustModel()
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : EntrustModel = self.viewModel.historyEntrust.safeObject(index: indexPath.row) ?? EntrustModel()
        let vc = EntrustOrderDetailVC()
        vc.order_no = model.order_no
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: JXPagingViewListViewDelegate
extension EntrustChildHistoryVC : JXPagingViewListViewDelegate{
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
