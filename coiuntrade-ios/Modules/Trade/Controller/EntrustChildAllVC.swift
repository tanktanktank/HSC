//
//  EntrustChildCurrentVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/2.
//

import UIKit

class EntrustChildAllVC: BaseViewController {
    
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
        table.register(EntrustAllCell.self, forCellReuseIdentifier:  EntrustAllCell.CELLID)
        return table
    }()
    lazy var repealAllBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 4)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.setTitle("撤销全部".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.addTarget(self, action: #selector(tapRepealAllBtn), for: .touchUpInside)
        return btn
    }()
    lazy var line : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    
    var typeV  = WLOptionView(frame: CGRect(x: 12, y: 12, width: 65, height: 23), type: .normal)
    lazy var headView : UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 43)
        v.backgroundColor = .hexColor("1E1E1E")
        v.addSubview(self.line)
        v.addSubview(self.typeV)
        v.addSubview(self.repealAllBtn)
        self.repealAllBtn.frame = CGRect(x: SCREEN_WIDTH-68-12, y: 12, width: 68, height: 23)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        configurationTabelViewRefresh()
        tableView.emptyData = setupEmptyDataView(type:.noData)
    }
    

}
// MARK: -  网络请求
extension EntrustChildAllVC {
    func listDataRequest(){
        self.viewModel.requestEntrust(get_type: 0, page: self.page)
    }
    func loadDataRequest() {
        self.page = 1
        listDataRequest()
    }
    func loadMoreDataRequest() {
        listDataRequest()
    }
    @objc func tapRepealAllBtn(){
        self.viewModel.requestCancelAllorders()
    }
}
extension EntrustChildAllVC : EntrustRequestDelegate{
    
    /// 获取获取所有订单成功回调
    func getAllEntrustListSuccess(){
        self.page += 1
        self.tableView.endMJRefresh()
        self.tableView.reloadData()
    }
    /// 获取列表数据失败回调
    func getListFailure(){
        self.tableView.endMJRefresh()
        self.tableView.reloadData()
    }
    /// 撤单成功回调
    func cancelorderSuccess(){
        self.page = 1
        listDataRequest()
    }
    /// 全部撤单成功回调
    func cancelAllOrderSuccess(){
        self.page = 1
        listDataRequest()
    }
}
// MARK: - UI
extension EntrustChildAllVC {
    func setUI() {
        typeV.dataSource = ["tv_all".localized(),"tv_trade_buy".localized(),"tv_trade_sell".localized()]
        typeV.title = "tv_all".localized()
        typeV.cornerRadius = 4
        typeV.selectedCallBack {[weak self] (viewTemp, index) in
            self?.typeV.title = self?.typeV.dataSource.safeObject(index: index)
            self?.page = 1
            self?.viewModel.reqModel.page = 1
            self?.viewModel.requestEntrust(get_type: 0, page: 1, startTime: 0, endTime: 0, symbol: "" ,buy_type: index, time_info: "")
            print("\(index)")
        }
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

        self.tableView.nomalMJFooterRefresh {  [weak self] in
            self?.loadMoreDataRequest()
        }
        
        self.tableView.beginMJPullRefresh()
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension EntrustChildAllVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allEntrust.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntrustAllCell.CELLID, for: indexPath) as! EntrustAllCell
        cell.delegate = self
        let model : EntrustModel = self.viewModel.allEntrust.safeObject(index: indexPath.row) ?? EntrustModel()
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : EntrustModel = self.viewModel.allEntrust.safeObject(index: indexPath.row) ?? EntrustModel()
        let vc = EntrustOrderDetailVC()
        vc.order_no = model.order_no
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension EntrustChildAllVC : EntrustAllCellDelegate{
    func cancelorder(model: EntrustModel) {
        self.viewModel.requestCancelOrder(orderno: model.order_no)
    }
}
//MARK: JXPagingViewListViewDelegate
extension EntrustChildAllVC : JXPagingViewListViewDelegate{
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
