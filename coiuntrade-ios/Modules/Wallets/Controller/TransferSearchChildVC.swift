//
//  TransferSearchChildVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/29.
//

import UIKit

class TransferSearchChildVC: BaseViewController {
    
    
    lazy var titleHisV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 14)
        v.text = "热门".localized()
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
        v.text = "tv_coin_list".localized()
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
    
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    private var disposeBag = DisposeBag()
    
    var viewModel: TransferViewModel = TransferViewModel()
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        getDataSource()
    }
 
}
extension TransferSearchChildVC{
    func getDataSource(){
        //MARK: 获取热门币种
        homeViewModel.requestHotSearch()
            .subscribe(onNext: { array in
                self.collectionV.reloadData()
            })
            .disposed(by: disposeBag)

        //MARK: 获取所有币种
        viewModel.requestAllCoin()
            .subscribe(onNext: { value in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
//MARK: ui
extension TransferSearchChildVC{
    func setUI(){
        //设置流水布局 layout
        let layout = collectionV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 94, height: 27)
        layout.minimumLineSpacing = 12  //行间距
        layout.minimumInteritemSpacing = (SCREEN_WIDTH-LR_Margin*2-94*3)/2.0  //列间距
        layout.scrollDirection = .vertical //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 12, left: LR_Margin, bottom: 0, right: LR_Margin)
        view.addSubview(titleHisV)
        view.addSubview(collectionV)
        view.addSubview(titleV)
        view.addSubview(tableView)
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

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension TransferSearchChildVC : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.homeViewModel.allHots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeSearchHisCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchHisCell.CELLID, for: indexPath) as! HomeSearchHisCell
//        let model : RealmCoin = self.viewModel.historys.safeObject(index: indexPath.item) ?? RealmCoin()
//        cell.labV.text = model.coin
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension TransferSearchChildVC : UITableViewDelegate,UITableViewDataSource{
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.letters.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHotCell.CELLID, for: indexPath) as! SearchHotCell
//        let model : CoinModel = self.viewModel.letters.safeObject(index: indexPath.row) ?? CoinModel()
//        cell.model = model
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
//MARK: JXPagingViewListViewDelegate
extension TransferSearchChildVC : JXPagingViewListViewDelegate{
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
