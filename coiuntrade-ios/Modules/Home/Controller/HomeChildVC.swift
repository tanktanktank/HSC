//
//  HomeChildVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/7.
//

import UIKit


class HomeChildVC: BaseViewController {
    var listType : SearchCoinType = .Hots
    
    var viewModel : HomeViewModel = HomeViewModel()
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    private var disposeBag = DisposeBag()
    
    lazy var nameTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_home_pair".localized()
        lab.font = FONTR(size: 10)
        return lab
    }()
    lazy var priceTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_home_last_price".localized()
        lab.font = FONTR(size: 10)
        return lab
    }()
    lazy var maxTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_home_chg".localized()
        lab.font = FONTR(size: 10)
        return lab
    }()
    lazy var topView = UIView()
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
//        table.register(HomeHotViewCell.self, forCellReuseIdentifier:  HomeHotViewCell.CELLID)
        table.rowHeight = UITableView.automaticDimension
        table.bounces = false
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        getDataSource()
        
    }
    
    
}
extension HomeChildVC{
    func getDataSource(){
        self.viewModel.reqList = true
        self.viewModel.listType = self.listType
        viewModel.requestHotSearch()
            .subscribe(onNext: {[weak self] value in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
    }
    func refreshData(){
        self.tableView.reloadData()
    }
}
extension HomeChildVC : UITableViewDelegate,UITableViewDataSource{
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.listType {
        case .Hots:
            return self.viewModel.allHots.count
        case .Ups:
            return self.viewModel.allUps.count
        case .Downs:
            return self.viewModel.allDowns.count
        default:
            return self.viewModel.allMaxs.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "\(NSStringFromClass(HomeHotViewCell.self))\(indexPath.row)type\(listType.rawValue)"
        var cell : HomeHotViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeHotViewCell
        if cell == nil {
            cell = HomeHotViewCell(style: .default, reuseIdentifier: identifier)
        }
//        let cell : HomeHotViewCell = tableView.dequeueReusableCell(withIdentifier: HomeHotViewCell.CELLID) as! HomeHotViewCell
        
        switch self.listType {
        case .Hots:
            let model : CoinModel = self.viewModel.allHots.safeObject(index: indexPath.row) ?? CoinModel()
            cell!.model = model
            return cell!
        case .Ups:
            let model : CoinModel = self.viewModel.allUps.safeObject(index: indexPath.row) ?? CoinModel()
            cell!.model = model
            return cell!
        case .Downs:
            let model : CoinModel = self.viewModel.allDowns.safeObject(index: indexPath.row) ?? CoinModel()
            cell!.model = model
            return cell!
        default:
            let model : CoinModel = self.viewModel.allMaxs.safeObject(index: indexPath.row) ?? CoinModel()
            cell!.model = model
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        
        switch self.listType {
        case .Hots:
            let model : CoinModel = self.viewModel.allHots.safeObject(index: indexPath.row) ?? CoinModel()
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
        case .Ups:
            let model : CoinModel = self.viewModel.allUps.safeObject(index: indexPath.row) ?? CoinModel()
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
        case .Downs:
            let model : CoinModel = self.viewModel.allDowns.safeObject(index: indexPath.row) ?? CoinModel()
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            let model : CoinModel = self.viewModel.allMaxs.safeObject(index: indexPath.row) ?? CoinModel()
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension HomeChildVC{
    func setUI(){
        view.addSubview(topView)
        topView.addSubview(nameTitle)
        topView.addSubview(priceTitle)
        topView.addSubview(maxTitle)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints(){
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(30)
        }
        nameTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
        }
        maxTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
        }
        priceTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-(114+LR_Margin))
            make.centerY.equalToSuperview()
        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
// MARK: - UIScrollViewDelegate
extension HomeChildVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension HomeChildVC : JXPagingViewListViewDelegate{
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
