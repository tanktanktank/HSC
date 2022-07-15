//
//  TestListBaseView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/10.
//

import UIKit

class MarketsChildListView: UIView {
    
    var type : MarketsType = .accountLike{
        didSet{
            if type == .other {
                ivName.isHidden = true
                ivVol.isHidden = true
                ivPrice.isHidden = true
                ivChange.isHidden = true
                
                self.topView.snp.remakeConstraints{ make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(0)
                }
            }else{
                ivName.isHidden = false
                ivVol.isHidden = false
                ivPrice.isHidden = false
                ivChange.isHidden = false
                self.topView.snp.remakeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(44)
                }
            }
        }
    }
    ///
    var currency : String = ""{
        didSet{
            self.viewModel.reqModel.currency = currency
        }
    }
    lazy var topView : UIView = {
        let v = UIView()
        return v
    }()
    lazy var ivName : QMUIButton = {
        let btn = QMUIButton()
        btn.tag = 0
        btn.setTitle("tv_coin_name".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setImage(UIImage(named: "downup0"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 10)
        btn.imagePosition = QMUIButtonImagePosition.right
        btn.spacingBetweenImageAndTitle = 2
        btn.addTarget(self, action: #selector(tapIvName), for: .touchUpInside)
        return btn
    }()
    lazy var ivVol : QMUIButton = {
        let btn = QMUIButton()
        btn.tag = 1
        btn.setTitle("tv_market_coin_vol".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setImage(UIImage(named: "downup0"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 10)
        btn.imagePosition = QMUIButtonImagePosition.right
        btn.spacingBetweenImageAndTitle = 2
        btn.addTarget(self, action: #selector(tapIvVol), for: .touchUpInside)
        return btn
    }()
    lazy var ivPrice : QMUIButton = {
        let btn = QMUIButton()
        btn.tag = 2
        btn.setTitle("tv_market_last_price".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setImage(UIImage(named: "downup0"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 10)
        btn.imagePosition = QMUIButtonImagePosition.right
        btn.spacingBetweenImageAndTitle = 2
        btn.addTarget(self, action: #selector(tapIvPrice), for: .touchUpInside)
        return btn
    }()
    lazy var ivChange : QMUIButton = {
        let btn = QMUIButton()
        btn.tag = 3
        btn.setTitle("tv_market_raise".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setImage(UIImage(named: "downup0"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 10)
        btn.imagePosition = QMUIButtonImagePosition.right
        btn.spacingBetweenImageAndTitle = 2
        btn.addTarget(self, action: #selector(tapIvChange), for: .touchUpInside)
        return btn
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
//        table.register(MarketsChildCell.self, forCellReuseIdentifier:  MarketsChildCell.CELLID)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    lazy var addLikeBtn : QMUIButton = {
        let v = QMUIButton()
        v.corner(cornerRadius: 2, toBounds: true, borderColor: UIColor.hexColor("FCD283"), borderWidth: 1)
        v.setTitle("tv_market_add_optional".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        v.titleLabel?.font = FONTM(size: 14)
        v.setImage(UIImage(named: "marke_addlike"), for: .normal)
        v.imagePosition = QMUIButtonImagePosition.left
        v.spacingBetweenImageAndTitle = 12
        v.isHidden = true
        v.addTarget(self, action: #selector(tapAddLikeBtn), for: .touchUpInside)
        return v
    }()
    
    var isSort : Int = 0 //0:默认 1:上 2:下
    var selectSort : Int = 0 //0:Name 1:vol 2:price 3:change
    var selectIndex : Int = 0
    var viewModel = MarketsViewModel()
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        
        if type == .spot {
            tableView.emptyData = BaseViewController().setupEmptyDataView(type:.noData)
        }else{
        
        }
        self.tableView.nomalMJHeaderRefresh {
            self.getDataSource()
        }
//        getDataSource()
        if type == .accountLike {
            NotificationCenter.default.addObserver(self, selector: #selector(updataAccountLike), name: UpdataAccountlikeNotification, object: nil)
        }
        WSCoinPushSing.sharedInstance().tradeDatas
            .subscribe(onNext: {pModel in
                switch self.type {
                case .accountLike:
                    if !userManager.isLogin {
                        
                        if self.viewModel.dataArray.count > 0 {
                            let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(pModel.coin)' AND currency = '\(pModel.currency)'")
                            guard let model = result.first else {
                                return
                            }
                            let updateModel = RealmCoinModel()
                            updateModel.coin = model.coin
                            updateModel.currency = model.currency
                            updateModel.deal_num = model.deal_num
                            updateModel.isFall = pModel.isFall
                            updateModel.price = pModel.new_price
                            updateModel.ratio_str = pModel.ratio_str
                            updateModel.id = model.id
                            updateModel.isSelected = model.isSelected
                            updateModel.price_digit = model.price_digit
                            if (Double(pModel.new_price) ?? 0.0) > (Double(model.price) ?? 0.0) {
                                updateModel.priceColor = 1
                            }else if (Double(pModel.new_price) ?? 0.0) < (Double(model.price) ?? 0.0){
                                updateModel.priceColor = 2
                            }else{
                                updateModel.priceColor = 0
                            }
                            RealmHelper.updateModel(model: updateModel)
                            let result2 = RealmHelper.queryModel(model: RealmCoinModel())
                            self.viewModel.dataArray = result2
                            self.tableView.reloadData()
                            
                            
                        }
                        break
                    }
                    if self.viewModel.accountLike.count > 0 {
                        for aModel in self.viewModel.accountLike {
                            if aModel.coin ==  pModel.coin
                                && aModel.currency == pModel.currency {
                                if (Double(pModel.new_price) ?? 0.0) > (Double(aModel.new_price) ?? 0.0) {
                                    aModel.priceColor = 1
                                }else if (Double(pModel.new_price) ?? 0.0) < (Double(aModel.new_price) ?? 0.0){
                                    aModel.priceColor = 2
                                }else{
                                    aModel.priceColor = 0
                                }
                                aModel.isFall = pModel.isFall
                                aModel.new_price = pModel.new_price
                                aModel.ratio_str = pModel.ratio_str
                                return
                            }
                        }
                        self.tableView.reloadData()
                    }
                    break
                case .spot:
                    if self.viewModel.coinGroups.count > 0 {
                        for aModel in self.viewModel.coinGroups {
                            if aModel.coin ==  pModel.coin
                                && aModel.currency == pModel.currency {
                                if (Double(pModel.new_price) ?? 0.0) > (Double(aModel.new_price) ?? 0.0) {
                                    aModel.priceColor = 1
                                }else if (Double(pModel.new_price) ?? 0.0) < (Double(aModel.new_price) ?? 0.0){
                                    aModel.priceColor = 2
                                }else{
                                    aModel.priceColor = 0
                                }
                                aModel.isFall = pModel.isFall
                                aModel.new_price = pModel.new_price
                                aModel.ratio_str = pModel.ratio_str
                                return
                            }
                        }
                        self.tableView.reloadData()
                    }
                    break
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 事件点击
extension MarketsChildListView{
    ///点击添加自选按钮
    @objc func tapAddLikeBtn(){
        let vc = HomeSearchVC()
        getTopVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func updataAccountLike(){
        self.getDataSource()
    }
    @objc func tapIvName(sender : QMUIButton){
        if self.selectIndex != sender.tag {
            self.isSort = 0
        }
        self.isSort += 1
        if self.isSort == 3 {
            self.isSort = 0
        }
        self.selectIndex = sender.tag
        self.selectSort = sender.tag
        self.ivVol.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivPrice.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivChange.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivName.setImage(UIImage(named: "downup\(self.isSort)"), for: .normal)
        self.clickCoinSort()
    }
    @objc func tapIvVol(sender : QMUIButton){
        if self.selectIndex != sender.tag {
            self.isSort = 0
        }
        self.isSort += 1
        if self.isSort == 3 {
            self.isSort = 0
        }
        self.selectIndex = sender.tag
        self.selectSort = sender.tag
        self.ivName.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivPrice.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivChange.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivVol.setImage(UIImage(named: "downup\(self.isSort)"), for: .normal)
        self.clickCoinSort()
        
    }
    @objc func tapIvPrice(sender : QMUIButton){
        if self.selectIndex != sender.tag {
            self.isSort = 0
        }
        self.isSort += 1
        if self.isSort == 3 {
            self.isSort = 0
        }
        self.selectIndex = sender.tag
        self.selectSort = sender.tag
        self.ivVol.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivName.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivChange.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivPrice.setImage(UIImage(named: "downup\(self.isSort)"), for: .normal)
        self.clickCoinSort()
        
    }
    @objc func tapIvChange(sender : QMUIButton){
        if self.selectIndex != sender.tag {
            self.isSort = 0
        }
        self.isSort += 1
        if self.isSort == 3 {
            self.isSort = 0
        }
        self.selectIndex = sender.tag
        self.selectSort = sender.tag
        self.ivVol.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivPrice.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivName.setImage(UIImage(named: "downup0"), for: .normal)
        self.ivChange.setImage(UIImage(named: "downup\(self.isSort)"), for: .normal)
        self.clickCoinSort()
    }
    //MARK: 拍序
    func clickCoinSort(){
        switch self.type {
        case .accountLike : do {
                    switch self.isSort {
                    case 1 : do {
                        //降序
                        if self.viewModel.accountLike.count > 1 {
                            switch self.selectSort {
                                case 1 : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.deal_num > $1.deal_num
                                    }
                                }
                                case 2 : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.new_price > $1.new_price
                                    }
                                }
                                case 3 : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.ratio_str > $1.ratio_str
                                    }
                                }
                                default : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.coin > $1.coin
                                    }
                                }
                            }
                        }
                    }
                    case 2 : do {
                        //升序
                        if self.viewModel.accountLike.count > 1 {
                            switch self.selectSort {
                                case 1 : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.deal_num < $1.deal_num
                                    }
                                }
                                case 2 : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.new_price < $1.new_price
                                    }
                                }
                                case 3 : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.ratio_str < $1.ratio_str
                                    }
                                }
                                default : do {
                                    self.viewModel.accountLike.sort(){
                                        $0.coin < $1.coin
                                    }
                                }
                            }
                        }
                    }
                    default: do {
                        //默认排序
                        if self.viewModel.accountLike.count > 1 {
                            self.viewModel.accountLike.sort(){
                                $0.atIndex < $1.atIndex
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        case .spot : do {
                    switch self.isSort {
                    case 1 : do {
                        //降序
                        if self.viewModel.coinGroups.count > 1 {
                            switch self.selectSort {
                                case 1 : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.deal_num > $1.deal_num
                                    }
                                }
                                case 2 : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.new_price > $1.new_price
                                    }
                                }
                                case 3 : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.ratio_str > $1.ratio_str
                                    }
                                }
                                default : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.coin > $1.coin
                                    }
                                }
                            }
                        }
                    }
                    case 2 : do {
                        //升序
                        if self.viewModel.coinGroups.count > 1 {
                            switch self.selectSort {
                                case 1 : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.deal_num < $1.deal_num
                                    }
                                }
                                case 2 : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.new_price < $1.new_price
                                    }
                                }
                                case 3 : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.ratio_str < $1.ratio_str
                                    }
                                }
                                default : do {
                                    self.viewModel.coinGroups.sort(){
                                        $0.coin < $1.coin
                                    }
                                }
                            }
                        }
                    }
                    default: do {
                        //默认排序
                        if self.viewModel.coinGroups.count > 1 {
                            self.viewModel.coinGroups.sort(){
                                $0.atIndex < $1.atIndex
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
            default:
                print("")
        }
    }
}

// MARK: - UI
extension MarketsChildListView{
    func getDataSource(){
        switch self.type {
        case .accountLike:
            //MARK: 获取用户自选
            if userManager.isLogin {
//                self.viewModel.requestCurrencyLike()
//                    .subscribe(onNext: {value in
//                        self.tableView.endMJRefresh()
//                        self.tableView.reloadData()
//                    }).disposed(by: disposeBag)
                self.viewModel.requestCurrencyLike().subscribe { _result in
                    self.tableView.endMJRefresh()
                    self.tableView.reloadData()
                    
                    if self.viewModel.accountLike.count == 0 {
                        self.addLikeBtn.isHidden = false
                    }else{
                        self.addLikeBtn.isHidden = true
                    }
                } onError: { Error in
                    self.tableView.endMJRefresh()
                    self.tableView.reloadData()
                } onCompleted: {
                    
                } onDisposed: {
                    
                }.disposed(by: disposeBag)

                
            }else{
                self.viewModel.dataArray = RealmHelper.queryModel(model: RealmCoinModel())
                self.tableView.reloadData()
                print("result: ", self.viewModel.dataArray)
                self.tableView.endMJRefresh()
                if self.viewModel.dataArray.count == 0 {
                    self.addLikeBtn.isHidden = false
                }else{
                    self.addLikeBtn.isHidden = true
                }
            }
            break
        case .spot:
            //MARK: 获取所有交易对
            self.viewModel.requestCurrencyGroupCoin().subscribe { _result in
                self.tableView.endMJRefresh()
                self.tableView.reloadData()
            } onError: { Error in
                self.tableView.endMJRefresh()
            } onCompleted: {
                
            } onDisposed: {
                
            }.disposed(by: disposeBag)
            break
        default:
            self.tableView.endMJRefresh()
            break
        }
    }
    func setUI(){
        self.addSubview(self.topView)
        self.topView.addSubview(ivName)
        self.topView.addSubview(ivVol)
        self.topView.addSubview(ivPrice)
        self.topView.addSubview(ivChange)
        self.addSubview(self.tableView)
        tableView.addSubview(addLikeBtn)
    }
    func initSubViewsConstraints(){
        self.topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }
        addLikeBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(114)
            make.height.equalTo(32)
        }
        ivName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        ivVol.snp.makeConstraints { make in
            make.left.equalTo(ivName.snp.right)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        ivChange.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        ivPrice.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-(103+LR_Margin))
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource
extension MarketsChildListView : UITableViewDelegate,UITableViewDataSource{
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .accountLike:
            if userManager.isLogin {
                return self.viewModel.accountLike.count
            }else{
                return self.viewModel.dataArray.count
            }
        case .spot:
            return self.viewModel.coinGroups.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(NSStringFromClass(MarketsChildCell.self))\(indexPath.row)"
        var cell : MarketsChildCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MarketsChildCell
        if cell == nil {
            cell = MarketsChildCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.delegate = self
        cell?.type = self.type
        switch self.type {
        case .accountLike:
            if userManager.isLogin {
                cell?.model = self.viewModel.accountLike.safeObject(index: indexPath.row) ?? CoinModel()
            }else{
                cell?.realmCoinModel = self.viewModel.dataArray.safeObject(index: indexPath.row) ?? RealmCoinModel()
            }
        case .spot:
            cell?.model = self.viewModel.coinGroups.safeObject(index: indexPath.row) ?? CoinModel()
        default:
            break
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        switch self.type {
        case .accountLike:
            if userManager.isLogin {
                controller.model = self.viewModel.accountLike[indexPath.row]
            }else{
                let model = self.viewModel.dataArray.safeObject(index: indexPath.row) ?? RealmCoinModel()
                let coinModel = CoinModel()
                coinModel.coin = model.coin
                coinModel.currency = model.currency
                controller.model = coinModel
            }
        case .spot:
            controller.model = self.viewModel.coinGroups[indexPath.row]
        default:
            break
        }
        let currentVC = getTopVC()
        currentVC?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
//MARK: MarketsCellDelegate
extension MarketsChildListView : MarketsChildCellDelegate{
    ///添加自选
    func clickAddWithModel(model: CoinModel) {
        if userManager.isLogin {
            let rModel = ReqCoinModel()
            rModel.currency = model.currency
            rModel.coin = model.coin
            self.viewModel.requestAccountLikeAdd(reqModel: rModel){[weak self] in
                HudManager.showOnlyText("添加成功")
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }
        }else{
            let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(model.coin)' AND currency = '\(model.currency)'")
            guard let model1 = result.first else {
                let realmModel = RealmCoinModel()
                realmModel.coin = model.coin
                realmModel.currency = model.currency
                realmModel.price = model.new_price
                realmModel.ratio_str = model.ratio_str
                realmModel.deal_num = model.deal_num
                realmModel.isFall = model.isFall
                realmModel.id = model.coin + "/" + model.currency
                realmModel.isSelected = model.isSelected
                realmModel.price_digit = model.price_digit
                realmModel.priceColor = model.priceColor
                RealmHelper.addModel(model: realmModel)
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
                return
            }
            let updateModel = RealmCoinModel()
            updateModel.coin = model.coin
            updateModel.currency = model.currency
            updateModel.deal_num = model.deal_num
            updateModel.isFall = model.isFall
            updateModel.price = model.new_price
            updateModel.ratio_str = model.ratio_str
            updateModel.id = model.coin + "/" + model.currency
            updateModel.isSelected = model.isSelected
            updateModel.price_digit = model.price_digit
            updateModel.priceColor = model.priceColor
            RealmHelper.updateModel(model: updateModel)
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        }
    }
    ///置顶
    func clickTopWithModel(model : CoinModel){
        self.viewModel.requestAccountLikemovetop(coin: model.coin, currency: model.currency) {
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        }
    }
    func clickNoLoginTopWithModel(model: RealmCoinModel) {
        self.viewModel.dataArray.removeAll(where: {$0 == model})
        self.viewModel.dataArray.insert(model, at: 0)
        var temMs : [RealmCoinModel] = []
        for aModel in self.viewModel.dataArray {
            let tem = RealmCoinModel()
            tem.id = aModel.id
            tem.coin = aModel.coin
            tem.currency = aModel.currency
            tem.price = aModel.price
            tem.deal_num = aModel.deal_num
            tem.isFall = aModel.isFall
            tem.ratio_str = aModel.ratio_str
            tem.isSelected = aModel.isSelected
            tem.priceColor = aModel.priceColor
            temMs.append(tem)
        }

        RealmHelper.deleteModelList(model: RealmCoinModel())
        for tModel in temMs {
            
            RealmHelper.addModel(model: tModel)
        }
        NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
    }
    
    ///删除
    func clickDeleteWithModel(model : CoinModel){
        let rModel = ReqCoinModel()
        rModel.currency = model.currency
        rModel.coin = model.coin
        self.viewModel.requestAccountLikeAdd(reqModel: rModel){[weak self] in
            HudManager.showOnlyText("删除成功")
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        }
    }
    func clickNoLoginDeleteWithModel(model : RealmCoinModel){
        RealmHelper.deleteModel(model: model)
        NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
    }
    ///编辑
    func clickEditWithModel(){
        let vc = OptionalEditVC()
        vc.dataArray = self.viewModel.accountLike
//        vc.backClosure = {[weak self] in
//            self?.viewModel.requestCurrencyLike()
//                .subscribe(onNext: {value in
//                }).disposed(by: self!.disposeBag)
//        }
        let currentVC = getTopVC()
        currentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension MarketsChildListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}

