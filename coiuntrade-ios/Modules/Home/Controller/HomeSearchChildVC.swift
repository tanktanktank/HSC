//
//  HomeSearchChildVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/21.
//

import UIKit

class HomeSearchChildVC: BaseViewController {
    
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(HomeSearchChildCell.self, forCellReuseIdentifier:  HomeSearchChildCell.CELLID)
        table.rowHeight = UITableView.automaticDimension
        table.bounces = false
        return table
    }()
    var viewModel : HomeViewModel = HomeViewModel()
    var viewModel1 = MarketsViewModel()
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    private var disposeBag = DisposeBag()
    
    var searchStr : String = ""{
        didSet{
            self.viewModel.search = searchStr
            self.viewModel.requestSearchCoin().catch {[weak self] error in
                self?.tableView.reloadData()
                return Observable.empty()
            }
                .subscribe(onNext: {[weak self] value in
                    self?.tableView.reloadData()
                })
            
                .disposed(by: disposeBag)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
    }
    
}
// MARK: - HomeSearchChildCelllDelegate
extension HomeSearchChildVC : HomeSearchChildCelllDelegate{
    func clickBtnStart(model: CoinModel, isDelete: Bool) {
        let rModel = ReqCoinModel()
        rModel.currency = model.currency
        rModel.coin = model.coin
        self.viewModel1.requestAccountLikeAdd(reqModel: rModel){[weak self] in
            HudManager.showOnlyText((isDelete ? "删除成功":"添加成功"))
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        }
    }

}
extension HomeSearchChildVC : UITableViewDelegate,UITableViewDataSource{
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.searchs.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeSearchChildCell = tableView.dequeueReusableCell(withIdentifier: HomeSearchChildCell.CELLID) as! HomeSearchChildCell
        cell.delegate = self
        cell.model = viewModel.searchs.safeObject(index: indexPath.row) ?? CoinModel()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : CoinModel = self.viewModel.searchs.safeObject(index: indexPath.row) ?? CoinModel()
        let coinModel = RealmCoin()
        coinModel.coin = model.coin
        coinModel.currency = model.currency
        coinModel.id = model.coin + "/" + model.currency
        
        let result = RealmHelper.queryModel(model: RealmCoin(),filter: "coin = '\(model.coin)'")
        if result.count == 0 {
            RealmHelper.addModel(model: coinModel)
        }
        let vc : KlineDealController = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeSearchChildVC{
    func setUI(){
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints(){
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-SafeAreaBottom)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
    }
}
// MARK: - UIScrollViewDelegate
extension HomeSearchChildVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension HomeSearchChildVC : JXPagingViewListViewDelegate{
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
