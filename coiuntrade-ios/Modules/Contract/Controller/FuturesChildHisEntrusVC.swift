//
//  FuturesEntrusChildHistoryVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/12.
//

import UIKit

class FuturesChildHisEntrusVC: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    lazy var line : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    
    var typeV : QMUIButton = {
        let v = QMUIButton()
        v.setImage(UIImage(named: "index_top_down"), for: .normal)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.titleLabel?.font = FONTR(size: 13)
        v.imagePosition = QMUIButtonImagePosition.right
        v.spacingBetweenImageAndTitle = 4
        v.setTitle("合约:".localized()+"tv_all".localized(), for: .normal)
        v.addTarget(self, action: #selector(tapTypeV), for: .touchUpInside)
        return v
    }()
    lazy var headView : UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 43)
        v.backgroundColor = .hexColor("1E1E1E")
        v.addSubview(self.line)
        return v
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(FuturesHisEntrusCell.self, forCellReuseIdentifier:  FuturesHisEntrusCell.CELLID)
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
extension FuturesChildHisEntrusVC {
    @objc func tapTypeV(){
        
        let datas = ["全仓","转账","已实现盈亏","资金费用","手续费","爆仓清算","推荐返现","手续费返还","cc转账","期权购置手续费"]
        
        tipManager.showActionSheet(datas: datas) { index in
            print("\(index)")
        }
    }
    @objc func tapRepealAllBtn(){
    }
    func setUI() {
        view.addSubview(headView)
        headView.addSubview(typeV)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(43)
        }
        typeV.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(12)
            make.height.equalTo(23)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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
extension FuturesChildHisEntrusVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 43
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.headView
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FuturesHisEntrusCell.CELLID, for: indexPath) as! FuturesHisEntrusCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FuturesOrderDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: JXPagingViewListViewDelegate
extension FuturesChildHisEntrusVC : JXPagingViewListViewDelegate{
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
