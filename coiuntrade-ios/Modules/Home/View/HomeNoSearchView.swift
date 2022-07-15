//
//  HomeNoSearchView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/17.
//

import UIKit

class HomeNoSearchView: UIView {
    
    lazy var titleHisV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 14)
        v.text = "tv_market_search_history".localized()
        return v
    }()
    lazy var collectionV :BaseCollectionView = {
        let v = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.backgroundColor = .clear
        v.dataSource = self
        v.delegate = self
        v.register(HomeSearchHisCell.self, forCellWithReuseIdentifier: HomeSearchHisCell.CELLID) //注册cell
        v.showsHorizontalScrollIndicator = false  //隐藏水平滚动条
        v.showsVerticalScrollIndicator = false  //隐藏垂直滚动条
        
        return v
    }()
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 14)
        v.text = "tv_market_hot_search".localized()
        return v
    }()
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("2D2D2D")
        table.showsVerticalScrollIndicator = false
        table.register(SearchHotCell.self, forCellReuseIdentifier:  SearchHotCell.CELLID)
        table.rowHeight = UITableView.automaticDimension
        table.corner(cornerRadius: 4)
        return table
    }()
    
    private var disposeBag = DisposeBag()
    var viewModel: HomeViewModel = HomeViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        //MARK: 获取所有币种
        viewModel.search = ""
        viewModel.listType = .Search
        viewModel.requestHotSearch()
            .subscribe(onNext: { value in
                if self.viewModel.searchs.count > 0 {
                }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        //MARK: 获取历史记录
        viewModel.requestHistoryCoin()
            .subscribe({ value -> Void in
                
                let nums = self.viewModel.historys.count
                var collectionVH : CGFloat = 0
                if nums > 0{
                    let h = ceil(CGFloat(nums)/3.0)
                    collectionVH = (27 + 12) * h + 12
                    self.titleHisV.isHidden = false
                    self.titleHisV.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(LR_Margin)
                        make.top.equalToSuperview().offset(12)
                    }
                }else{
                    self.titleHisV.isHidden = true
                    self.titleHisV.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(LR_Margin)
                        make.top.equalToSuperview().offset(12)
                        make.height.equalTo(0)
                    }
                }
                self.collectionV.snp.remakeConstraints { make in
                    make.top.equalTo(self.titleHisV.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(collectionVH)
                }
                self.collectionV.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension HomeNoSearchView : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.viewModel.historys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeSearchHisCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchHisCell.CELLID, for: indexPath) as! HomeSearchHisCell
        let model : RealmCoin = self.viewModel.historys.safeObject(index: indexPath.item) ?? RealmCoin()
        cell.labV.text = model.coin
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.historys[indexPath.row]
        let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        let asModel = CoinModel()
        asModel.coin = model.coin
        asModel.currency = model.currency
        controller.model = asModel
        getTopVC()?.navigationController?.pushViewController(controller, animated: true)
    }
}
extension HomeNoSearchView : UITableViewDelegate,UITableViewDataSource{
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.searchs.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHotCell.CELLID, for: indexPath) as! SearchHotCell
        let model : CoinModel = self.viewModel.searchs.safeObject(index: indexPath.row) ?? CoinModel()
        cell.model = model
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : CoinModel = self.viewModel.searchs.safeObject(index: indexPath.row) ?? CoinModel()
        let coinModel = RealmCoin()
        coinModel.coin = model.coin
        coinModel.currency = model.currency
        coinModel.id = model.coin + model.currency
        
        let result = RealmHelper.queryModel(model: RealmCoin(),filter: "id = '\(model.coin)\(model.currency)'")
        if result.count == 0 {
            RealmHelper.addModel(model: coinModel)
        }
        
        let result1 = RealmHelper.queryModel(model: RealmCoin())
        if result1.count > 8 {
            RealmHelper.deleteModel(model: result1.first)
        }
        let vc : KlineDealController = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        vc.model = model
        getTopVC()?.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

extension HomeNoSearchView{
    func setUI(){
        //设置流水布局 layout
        let layout = collectionV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 94, height: 27)
        layout.minimumLineSpacing = 12  //行间距
        layout.minimumInteritemSpacing = (SCREEN_WIDTH-LR_Margin*2-94*3)/2.0  //列间距
        layout.scrollDirection = .vertical //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 12, left: LR_Margin, bottom: 0, right: LR_Margin)
        self.addSubview(titleHisV)
        self.addSubview(collectionV)
        self.addSubview(titleV)
        self.addSubview(tableView)
    }

    func initSubViewsConstraints(){
        titleHisV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(12)
        }
        collectionV.snp.makeConstraints { make in
            make.top.equalTo(titleHisV.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(collectionV.snp.bottom)
        }
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleV.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-SafeAreaBottom)
        }
    }
    
}
