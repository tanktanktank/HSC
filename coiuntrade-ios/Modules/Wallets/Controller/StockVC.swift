//
//  StockVC.swift
//  test
//
//  Created by tfr on 2022/4/19.
//

import UIKit

class StockVC: BaseViewController {
    
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
        table.register(BalanceListCell.self, forCellReuseIdentifier:  BalanceListCell.CELLID)
        table.rowHeight = 56
        return table
    }()
    let viewModel = WalletViewModel()
    
    lazy var headView : StockHeadView = {
        let v = StockHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 206))
        return v
    }()
    lazy var sectionHeadView : StockSectionHeadView = {
        let v = StockSectionHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        v.backgroundColor = .hexColor("1E1E1E")
        v.delegate = self
        return v
    }()
    var ishide0 : Bool = false
    var searchText : String = ""
    
    var dataArray : Array<AllbalanceModel> = []
    var allDataArray : Array<AllbalanceModel> = []
    var tmpArray : Array<AllbalanceModel> = []
    
    var ishideValue : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        viewModel.delegate = self
        getDataSource()
        
        self.tableView.nomalMJHeaderRefresh {
            self.getDataSource()
        }
    }
    
}

//MARK: ViewModel 代理
extension StockVC : WalletRequestDelegate{
    /// 获取现货资产总览成功回调
    func getAccountSpotcointotalSuccess(model : SpotcointotalModel){
        self.tableView.endMJRefresh()
        self.headView.setModelForHidden(model: model, isHiddenSee: self.ishideValue)
    }
    /// 获取现货资产总览成功回调
    func getAllbalanceSuccess(array : Array<AllbalanceModel>){
        self.tableView.endMJRefresh()
        allDataArray = array
        
        self.searchStock(isHide0: self.ishide0, searchText: self.searchText)
    }
    func getListFailure(){
        self.tableView.endMJRefresh()
    }
}
//MARK: ui
extension StockVC{
    func getDataSource(){
        viewModel.getAccountSpotcointotal()
        viewModel.getAllbalance()
    }
    func setUI() {
        self.headView.delegate = self
        self.tableView.tableHeaderView = self.headView
//        view.addSubview(self.headView)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
//        self.headView.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(266)
//        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource
extension StockVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BalanceListCell.CELLID, for: indexPath) as! BalanceListCell
        let model : AllbalanceModel = dataArray.safeObject(index: indexPath.row) ?? AllbalanceModel()
        cell.setModelValueIsHidden(model: model, ishidden: ishideValue)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeadView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : AllbalanceModel = dataArray.safeObject(index: indexPath.row) ?? AllbalanceModel()
//        self.delegate?.clickCell(indexPath: indexPath)
        let vc = CoinDetailVC()
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: StockSectionHeadViewDelegate
extension StockVC : StockSectionHeadViewDelegate{
    func searchStock(isHide0: Bool,searchText:String){
        self.tmpArray.removeAll()
        if isHide0 && searchText.count>0 {
            for model in allDataArray {
                if model.coin_code.containsIgnoringCase(find: searchText) && model.total_num != "0" {
                    self.tmpArray.append(model)
                }
            }
            self.dataArray = self.tmpArray
            self.tableView.reloadData()
            return
        }
        if !isHide0 && searchText.count == 0 {
            self.dataArray = self.allDataArray
            self.tableView.reloadData()
            return
        }
        if isHide0 {
            for model in allDataArray {
                if model.total_num != "0" {
                    self.tmpArray.append(model)
                }
            }
            self.dataArray = self.tmpArray
            self.tableView.reloadData()
            return
        }
        if searchText.count>0 {
            for model in allDataArray {
                if model.coin_code.containsIgnoringCase(find: searchText) {
                    self.tmpArray.append(model)
                }
            }
            self.dataArray = self.tmpArray
            self.tableView.reloadData()
            return
        }
    }
    func clickHidden0(isHide0: Bool) {
        self.ishide0 = isHide0
        self.searchStock(isHide0: self.ishide0, searchText: self.searchText)
    }
    
    func searchWithText(text: String) {
        self.searchText = text
        self.searchStock(isHide0: self.ishide0, searchText: self.searchText)
    }
    
}
//MARK: StockHeadViewDelegate
extension StockVC : StockHeadViewDelegate{
    
    ///充值
    func clickRecharge() {
//        let vc = TransferSearchVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        //MARK: 充值页面
        let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSearchController") as! TransferSearchController
        controller.type = .receive
        self.navigationController?.pushViewController(controller, animated: true)
    }
    ///提现
    func clickWithdraw() {
        //MARK: 提现页面
        let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSearchController") as! TransferSearchController
        controller.type = .send
        self.navigationController?.pushViewController(controller, animated: true)
    }
    ///划转
    func clickTransfer() {
    }
    ///历史记录
    func clickhHstory() {
        let vc = FlowingWaterVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///点击隐藏显示 false隐藏
    func clickSeeBtn(model:SpotcointotalModel, isHiddenSee : Bool){
        self.ishideValue = isHiddenSee
        self.headView.setModelForHidden(model: model, isHiddenSee: self.ishideValue)
        self.tableView.reloadData()
    }
    
}
// MARK: - UIScrollViewDelegate
extension StockVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension StockVC : JXPagingViewListViewDelegate{
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
