//
//  TradeQuotesView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit


class TradeQuotesView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vNot: UIView!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var vShow: UIView!
    @IBOutlet weak var vLayer: UIView!
    @IBOutlet weak var vButton: UIView!
    @IBOutlet weak var btnMy: UIButton!
    @IBOutlet weak var scView: UIScrollView!
    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableSearch: UITableView!
    @IBOutlet weak var btnWidthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var nameSortView: UIView!
    @IBOutlet weak var priceSortView: UIView!
    @IBOutlet weak var changeSortView: UIView!
    @IBOutlet weak var nameSortImg: UIImageView!
    @IBOutlet weak var priceSortImg: UIImageView!
    @IBOutlet weak var changeSortImg: UIImageView!
    var dataCount   = 0

    
    enum SORTTYPE {
    
        case nomal
//        case SORTTYPEPriceNomal
        case priceUp
        case priceDown
//        case SORTTYPENameNomal
        case nameUp
        case nameDown
//        case SORTTYPEChangeNomal
        case changeUp
        case changeDown
    }
    var isGroupData : Bool = false // true : 非自选的。false 自选的数据
    private var disposeBag = DisposeBag()
    let dataSubject = PublishSubject<CoinModel>()
    var viewModel = MarketsViewModel()
    
    var sortType : SORTTYPE = .nomal {
        
        didSet{
            
            updateSortImg(sortType)
        }
    }

    func reloadTable()  {
        
        self.updateSortImg(sortType)
    }
    
    func updateSortImg(_ sortType : SORTTYPE){
        nameSortImg.image = UIImage(named: "downup0")
        priceSortImg.image = UIImage(named: "downup0")
        changeSortImg.image = UIImage(named: "downup0")

        switch sortType {
        case .nomal:
            
            self.viewModel.accountLike.sort(){
                
                $0.atIndex < $1.atIndex
            }
            self.viewModel.coinGroups.sort(){
                
                $0.atIndex < $1.atIndex
            }
            self.viewModel.dataArray.sort(){
                
                $0.coin < $1.coin
            }

            break
        case .priceUp:
            
            priceSortImg.image = UIImage(named: "downup2")
          
            self.viewModel.accountLike.sort(){
                
                $0.new_price.toDouble() < $1.new_price.toDouble()
            }
            self.viewModel.coinGroups.sort(){
                
                $0.new_price.toDouble() < $1.new_price.toDouble()
            }
            
            self.viewModel.dataArray.sort(){

                $0.price.toDouble() < $1.price.toDouble()
            }

        case .priceDown:
            
            priceSortImg.image = UIImage(named: "downup1")
            self.viewModel.accountLike.sort(){
                
                $0.new_price.toDouble() > $1.new_price.toDouble()
            }
            self.viewModel.coinGroups.sort(){
                
                $0.new_price.toDouble() > $1.new_price.toDouble()
            }

            self.viewModel.dataArray.sort(){
                
                $0.price.toDouble() > $1.price.toDouble()
            }

        case .nameUp:
            
            self.viewModel.accountLike.sort(){
                
                $0.coin < $1.coin
            }
            self.viewModel.coinGroups.sort(){
                
                $0.coin < $1.coin
            }

            self.viewModel.dataArray.sort(){
                
                $0.coin < $1.coin
            }

            nameSortImg.image = UIImage(named: "downup2")
        case .nameDown:
            
            nameSortImg.image = UIImage(named: "downup1")
            self.viewModel.accountLike.sort(){
                
                $0.coin > $1.coin
            }
            self.viewModel.coinGroups.sort(){
                
                $0.coin > $1.coin
            }

            self.viewModel.dataArray.sort(){
                
                $0.coin > $1.coin
            }

        case .changeUp:
            
            changeSortImg.image = UIImage(named: "downup2")
            self.viewModel.accountLike.sort(){
                
                $0.ratio_str.toDouble() < $1.ratio_str.toDouble()
            }
            self.viewModel.coinGroups.sort(){
                
                $0.ratio_str.toDouble() < $1.ratio_str.toDouble()
            }
            self.viewModel.dataArray.sort(){
                
                $0.ratio_str.toDouble() < $1.ratio_str.toDouble()
            }

        case .changeDown:
            
            changeSortImg.image = UIImage(named: "downup1")
            self.viewModel.accountLike.sort(){
                
                $0.ratio_str.toDouble() > $1.ratio_str.toDouble()
            }
            self.viewModel.coinGroups.sort(){
                
                $0.ratio_str.toDouble() > $1.ratio_str.toDouble()
            }
            self.viewModel.dataArray.sort(){
                
                $0.ratio_str.toDouble() > $1.ratio_str.toDouble()
            }

        }
        
        tableView.reloadData()
    }
    
    
    class func loadTradeQuotesView(view:UIWindow) -> TradeQuotesView {
        

        
        var selectIndex = -1
        var isfirst = true

        if let select = USER_DEFAULTS.value(forKey: "TradeQuotesViewSelectindex") , select as! Int != -1 {
            
            selectIndex = select as! Int
        }

        let quotesView = Bundle.main.loadNibNamed("TradeQuotesView", owner: nil, options: nil)?[0] as! TradeQuotesView
        quotesView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        quotesView.tableView?.register(UINib(nibName: "TradeQuotesCell",bundle: nil), forCellReuseIdentifier: "TradeQuotesCell")
        quotesView.tableSearch?.register(UINib(nibName: "TradeQuotesCell",bundle: nil), forCellReuseIdentifier: "TradeQuotesCell")
        //MARK: 文本提示 -->翻译
        quotesView.txfSearch.attributedPlaceholder = NSAttributedString.init(string:"Search", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.HexColor(0x989898)])
        view.addSubview(quotesView)
    
        quotesView.nameSortView.addTapForView().subscribe ({ _ in
            
            if quotesView.sortType == .nameDown{
                
                quotesView.sortType = .nameUp
            }else if quotesView.sortType == .nameUp{
                
                quotesView.sortType = .nomal
            }else{
                
                quotesView.sortType = .nameDown
            }

        }).disposed(by: quotesView.disposeBag)

        quotesView.priceSortView.addTapForView().subscribe ({ _ in
            
            if quotesView.sortType == .priceDown{
                
                quotesView.sortType = .priceUp
            }else if quotesView.sortType == .priceUp{
                
                quotesView.sortType = .nomal
            }else{
                
                quotesView.sortType = .priceDown
            }
        }).disposed(by: quotesView.disposeBag)
        
        quotesView.changeSortView.addTapForView().subscribe ({ _ in
            
            if quotesView.sortType == .changeDown{
                
                quotesView.sortType = .changeUp
            }else if quotesView.sortType == .changeUp{
                
                quotesView.sortType = .nomal
            }else{
                
                quotesView.sortType = .changeDown
            }
        }).disposed(by: quotesView.disposeBag)
        
        
        //MARK: 推送数据
        WSCoinPushSing.sharedInstance().datas
            .subscribe(onNext: { pModel in
//                print("推送数据:\(pModel.coin + pModel.currency)")
                if quotesView.isGroupData {
                    
                    if quotesView.viewModel.coinGroups.count > 0{
                        for aModel in quotesView.viewModel.coinGroups {
                            if aModel.coin ==  pModel.coin
                                && aModel.currency == pModel.currency {
                                aModel.isFall = pModel.isFall
                                aModel.new_price = pModel.coin
                                aModel.ratio_str = pModel.currency
                                aModel.new_price = pModel.new_price
                                aModel.ratio_str = pModel.ratio_str
                                return
                            }
                        }
//                        quotesView.reloadTable()
                        quotesView.tableView.reloadData()
                    }
                } else{
                    
                    if quotesView.viewModel.accountLike.count > 0{
                        for aModel in quotesView.viewModel.accountLike {
                            if aModel.coin ==  pModel.coin
                                && aModel.currency == pModel.currency {
                                aModel.isFall = pModel.isFall
                                aModel.new_price = pModel.coin
                                aModel.ratio_str = pModel.currency
                                aModel.new_price = pModel.new_price
                                aModel.ratio_str = pModel.ratio_str
                                return
                            }
                        }
//                        quotesView.reloadTable()
                        quotesView.tableView.reloadData()
                    }
                }
        }).disposed(by: quotesView.disposeBag)
        
        //MARK: 获取所有交易区
        quotesView.viewModel.requestCurrencygroup()
            .subscribe(onNext: { array in
                if quotesView.viewModel.currencys.count > 0{
                    quotesView.btnWidthLayout.constant = CGFloat(quotesView.viewModel.currencys.count+1) * 52
                    array.enumerateObjects({ (asset, idx, stop) in
                        let btn = UIButton.init()
                        btn.setTitle(asset as? String, for: .normal)
                        btn.setTitle(asset as? String, for: .selected)
                        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                        btn.setTitleColor(UIColor.hexColor(0x989898), for: .normal)
                        btn.setTitleColor(UIColor.white, for: .normal)
                        btn.tag = idx + 1
                        quotesView.vButton.addSubview(btn)
                        btn.snp.makeConstraints { make in
                            make.top.bottom.equalToSuperview().offset(0)
                            make.left.equalToSuperview().offset(CGFloat(idx+1) * 52)
                            make.width.equalTo(52)
                        }
                        btn.rx.tap
                            .flatMap{ value -> Observable<Any> in
                                
                                if !isfirst , selectIndex == btn.tag  {
                                    
                                    return Observable.never()
                                }
                                
                                isfirst = false
                                selectIndex = btn.tag
                                USER_DEFAULTS.setValue(selectIndex, forKey: "TradeQuotesViewSelectindex")
                                USER_DEFAULTS.synchronize()

                                quotesView.isGroupData = true
                                let reqModel = ReqCoinModel()
                                reqModel.currency = quotesView.viewModel.currencys[btn.tag-1]
                                quotesView.viewModel.reqModel = reqModel
                                return quotesView.viewModel.requestCurrencyGroupCoin().catch { error in
                                    quotesView.reloadTable()
//                                    quotesView.tableView.reloadData()
                                    quotesView.vNot.isHidden = false
                                    return Observable.empty()
                                }
                            }
                            .subscribe(onNext: { value in
                                quotesView.vNot.isHidden = quotesView.viewModel.coinGroups.count > 0 ? true : false
//                                quotesView.tableView.reloadData()
                                quotesView.reloadTable()
//                                UIView.animate(withDuration: 0.5, animations: {
//                                    quotesView.vLine.center.x = btn.center.x
//                                })
                                UIView.animate(withDuration: 0.3, animations: {
                                    quotesView.vLine.center.x = btn.center.x
                                })


                            }).disposed(by: quotesView.disposeBag)
                    })
                }
                if selectIndex != -1 , selectIndex <= quotesView.viewModel.currencys.count{
                    
                    selectAt(index: selectIndex)
                }

            }).disposed(by: quotesView.disposeBag)
        
        
        func selectAt(index : Int){
            
            if let btn = quotesView.vButton.viewWithTag(index) {
             
                if btn.isKind(of: UIButton.self) {
                    
                    (btn as! UIButton).sendActions(for: .touchUpInside)
                }
            }
        }
        
        
        //MARK: 用户自选
        quotesView.btnMy.rx.tap
            .flatMap{ value -> Observable<Any> in
                quotesView.isGroupData = false
                
                
                selectIndex = -1
                USER_DEFAULTS.setValue(selectIndex, forKey: "TradeQuotesViewSelectindex")
                USER_DEFAULTS.synchronize()
                quotesView.viewModel.currency = ""
                
                if userManager.isLogin {

                    return quotesView.viewModel.requestCurrencyLike().catch { error in
//                        quotesView.tableView.reloadData()
                        quotesView.reloadTable()

//                        quotesView.vNot.isHidden = false
                        return Observable.empty()
                    }
                }else{
                    quotesView.viewModel.dataArray = RealmHelper.queryModel(model: RealmCoinModel())
//                    quotesView.tableView.reloadData()
                    quotesView.reloadTable()

                    quotesView.vNot.isHidden = quotesView.viewModel.dataArray.count > 0 ? true : false
                    print("result: ", quotesView.viewModel.dataArray)
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        quotesView.vLine.center.x = quotesView.btnMy.center.x
                    })

                    return Observable.never()
                }
            }
            .subscribe(onNext: { value in
                quotesView.vNot.isHidden = quotesView.viewModel.accountLike.count > 0 ? true : false
//                quotesView.tableView.reloadData()
                quotesView.reloadTable()
                UIView.animate(withDuration: 0.3, animations: {
                    quotesView.vLine.center.x = quotesView.btnMy.center.x
                })

            }).disposed(by: quotesView.disposeBag)
        
        //MARK: 获取用户自选
        
        
        if userManager.isLogin {

            quotesView.viewModel.requestCurrencyLike()
                .subscribe(onNext: { array in
                    quotesView.vNot.isHidden = quotesView.viewModel.accountLike.count > 0 ? true : false
//                    quotesView.tableView.reloadData()
                    quotesView.reloadTable()
                }).disposed(by: quotesView.disposeBag)
        }else{
            quotesView.viewModel.dataArray = RealmHelper.queryModel(model: RealmCoinModel())
//            quotesView.tableView.reloadData()
            quotesView.reloadTable()

            quotesView.vNot.isHidden = quotesView.viewModel.dataArray.count > 0 ? true : false
            
            print("result: ", quotesView.viewModel.dataArray)
            
        }

        
        
        //MARK: 取消
        let tapLayer = UITapGestureRecognizer()
        quotesView.vLayer.addGestureRecognizer(tapLayer)
        tapLayer.rx.event.subscribe(onNext: {value in
            quotesView.dataSubject.onError(NSError(domain: "", code: 0))
            quotesView.removeFromSuperview()
        }).disposed(by: quotesView.disposeBag)
        
        //MARK: 搜索输入
        quotesView.txfSearch.rx.text.orEmpty.asObservable()
            .flatMap({ value -> Observable<Any> in
                quotesView.viewModel.search = quotesView.txfSearch.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                if !is_Blank(ref:  quotesView.viewModel.search){
                    return quotesView.viewModel.requestSearchCoin().catch { error in
//                        quotesView.vNot.isHidden = false
                        quotesView.tableSearch.reloadData()
                        return Observable.empty()
                    }
                } else{
                    quotesView.viewModel.searchs.removeAll()
                    return Observable.just(0)
                }
            })
            .subscribe(onNext: {
                print("您输入的是：\($0)")
                if quotesView.viewModel.searchs.count > 0 {
                    quotesView.vNot.isHidden = true
                    quotesView.vShow.isHidden = true
                    quotesView.scView.isHidden = true
                    quotesView.tableSearch.reloadData()
                    quotesView.tableView.isHidden = true
                    quotesView.tableSearch.isHidden = false
                } else{
//                    quotesView.tableView.reloadData()
                    quotesView.reloadTable()

                    quotesView.vShow.isHidden = false
                    quotesView.scView.isHidden = false
                    quotesView.tableView.isHidden = false
                    quotesView.tableSearch.isHidden = true
//                    quotesView.vNot.isHidden = quotesView.viewModel.accountLike.count > 0 ? true : false
                }
            })
            .disposed(by: quotesView.disposeBag)
        
        return quotesView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
            case 1:
                return self.viewModel.searchs.count
            default: do {
                
                dataCount = self.isGroupData ? self.viewModel.coinGroups.count : (userManager.isLogin ? self.viewModel.accountLike.count : self.viewModel.dataArray.count)

                return dataCount
                
            }
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TradeQuotesCell = self.tableView.dequeueReusableCell(withIdentifier: "TradeQuotesCell") as! TradeQuotesCell
        switch tableView.tag {
            case 1:
                cell.model =  self.viewModel.searchs[indexPath.row]
            default: do {
                
                
                if self.isGroupData {
                    
                    if dataCount == self.viewModel.coinGroups.count , indexPath.row <= dataCount {
                        
                        cell.model = self.viewModel.coinGroups[indexPath.row]
                    }
                }else{
                    
                    if userManager.isLogin {
                        
                        cell.model = self.viewModel.accountLike[indexPath.row]

                    }else{
                        
                        cell.realmModel = self.viewModel.dataArray[indexPath.row]
                        
                    }
                }
                
//                cell.model = model   //(userManager.isLogin ? self.viewModel.accountLike[indexPath.row] : self.viewModel.dataArray[indexPath.row])
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
            case 1:
                self.dataSubject.onNext(self.viewModel.searchs[indexPath.row])
            default: do {
                
                if self.isGroupData {
                    
                    let model = self.viewModel.coinGroups[indexPath.row]
                    self.dataSubject.onNext(model)
                }else{

                    if userManager.isLogin {

                        let model = self.viewModel.accountLike[indexPath.row]

                        self.dataSubject.onNext(model)

                    }else{
                        
                        let realmModel = self.viewModel.dataArray[indexPath.row]
                        
                        let model  = CoinModel()
                        model.coin = realmModel.coin
                        model.currency = realmModel.currency
                        self.dataSubject.onNext(model)

                    }
                }
            }
        }
        self.dataSubject.onCompleted()
        self.removeFromSuperview()
    }

}
