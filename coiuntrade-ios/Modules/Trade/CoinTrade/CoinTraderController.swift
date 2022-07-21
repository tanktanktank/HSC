//
//  CoinTraderController.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/6/6.
//

import UIKit



class CoinTraderController: BaseViewController {

    var dateType: XLKLineDateType = .min
    var rModel = ReqCoinModel()
    var coinModel = CoinModel()
    var reqModel = ReqTradeModel()
    var marketsViewModel = MarketsViewModel()
    var tradeModel = TradeViewModel()
    var entrustViewModel = EntrustViewModel()
    
    var updateEntrusts  = PublishSubject<Int>()

//    var balanceModel : SymbolAssetModel! // 记录账户余额
//    private var balancePushModel = PublishSubject<SymbolAssetModel>()
    
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    private var disposeBag = DisposeBag()
    
    var scrollClosure : scrollCallback = nil
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        print("初始化 交易 -- 现货")
//        setupInit()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCoinInfo()
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInit()
        
        self.tradeTableView.nomalMJHeaderRefresh {
            print("refresh")
            if userManager.isLogin {
                _ =  self.tradeModel.requestSymbolAsset()
                self.reloadEntrust()
            }else {
                self.tradeTableView.endMJRefresh()
            }
        }
        reqData()
    }
    
    func reqData(){
        
        self.marketsViewModel.requestMarketKline().subscribe(onNext: {[weak self] model in
            self!.kLineView.updateSecondHeight()
            self!.kLineView.configureView(data: self!.marketsViewModel.kLineList, isNew: true, mainDrawString: KLINEMA, secondDrawString: KLINEHIDE, dateType: self!.dateType, lineType:(self!.marketsViewModel.reqModel.kline_type == "1m") ? .minLineType : .candleLineType)
        }).disposed(by: disposeBag)
        marketsViewModel.websocketKline()
    }
    
    func setupInit(){
        rModel.coin = "BTC"
        rModel.currency = "USDT"
        marketsViewModel.reqModel = rModel
        marketsViewModel.reqModel.kline_type = "1m"
        
        setUI()
        setupEvent()
        dealWithSocekt()
        
        tradeModel.reqModel = rModel
        NotificationCenter.default.addObserver(self, selector: #selector (signoutNoti), name: SignoutSuccessNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateShowCoin), name: Notification.Name("CoinAssetsUpdateKey"), object: nil)
    }
    
    // MARK: - mainScrollView
    lazy var mainScrollView : BaseScrollView = {
        let scrollview = BaseScrollView.init(frame: .zero)
        scrollview.backgroundColor = .hexColor("1E1E1E")
        scrollview.showsVerticalScrollIndicator = false
        return scrollview
    }()
    
    // topView
    let ratioLabel = RatioLabel()
    lazy var topView : UIView = {
        let view = UIView()
        
        coinSymbolBtn.setImage(UIImage(named: "trelist"), for: .normal)
        coinSymbolBtn.setTitle("--/--", for: .normal)
        view.addSubview(coinSymbolBtn)
        

        ratioLabel.text = "0"
        ratioLabel.font = FONTDIN(size: 12)
        view.addSubview(ratioLabel)
        
        let coinBtn = UIButton(frame: CGRect.zero)
        view.addSubview(coinBtn)
        coinBtn.setImage(UIImage(named: "trade1"), for: .normal)

        let klineBtn = UIButton(frame: CGRect.zero)
        view.addSubview(klineBtn)
        klineBtn.setImage(UIImage(named: "tradekline"), for: .normal)
        
        //MARK: K线
        klineBtn.rx.tap.subscribe(onNext: {
            let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
            controller.model = self.coinModel
            getTopVC()?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)


        let moreBtn = UIButton(frame: CGRect.zero)
        view.addSubview(moreBtn)
        moreBtn.setImage(UIImage(named: "tradedown"), for: .normal)
        moreBtn.setImage(UIImage(named: "tradeUp"), for: .selected)
        //点击展开K线

        moreBtn.rx.tap
            .subscribe(onNext: {
                self.isShowKline = !self.isShowKline
                moreBtn.isSelected = self.isShowKline
            }).disposed(by: disposeBag)

        let bottonLineView = UIView()
        bottonLineView.backgroundColor = .hexColor("0D0D0D")
        view.addSubview(bottonLineView)
        
        //MARK: 当前推送价格
        WSCoinPushSing.sharedInstance().tradeDatas
            .subscribe(onNext: { value in
                if self.coinModel.coin == value.coin &&
                    self.coinModel.currency == value.currency {
                    
                    self.ratioLabel.text = value.ratio_str
                }
        })
        .disposed(by: disposeBag)

        
        coinSymbolBtn.snp.makeConstraints({ make in
            
            make.left.top.bottom.equalToSuperview()
        })
        
        ratioLabel.snp.makeConstraints { make in
         
            make.left.equalTo(coinSymbolBtn.snp.right)
            make.centerY.equalTo(coinSymbolBtn)
        }

        coinBtn.snp.makeConstraints { make in
            
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        klineBtn.snp.makeConstraints { make in
            
            make.right.equalTo(coinBtn.snp.left)
            make.top.bottom.width.equalTo(coinBtn)
        }

        moreBtn.snp.makeConstraints { make in
         
            make.right.equalTo(klineBtn.snp.left)
            make.top.bottom.width.equalTo(coinBtn)
        }
        
        bottonLineView.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return view
    }()
    
    lazy var coinSymbolBtn : UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = FONTB(size: 16)
        button.imageView?.snp.makeConstraints({ make in
            
            make.left.equalTo(7)
            make.width.height.equalTo(20)
        })
        
        button.titleLabel?.snp.makeConstraints({ make in
           
            make.right.equalTo(-10)
        })
        
        
        //MARK: 行情
        button.rx.tap
            .flatMap({ value -> Observable<CoinModel> in
                let lodaView = TradeQuotesView.loadTradeQuotesView(view: self.view.window!)
                return lodaView.dataSubject.catch { error in
                    return Observable.empty()
                }
            })
            .flatMap({[weak self] value -> Observable<CoinModel>  in
                
                let reqCoinM = ReqCoinModel()
                reqCoinM.coin = value.coin
                reqCoinM.currency = value.currency
                reqCoinM.kline_type = self!.marketsViewModel.reqModel.kline_type
                self!.rModel = reqCoinM
                self!.marketsViewModel.reqModel = reqCoinM
                self!.tradeModel.reqModel = reqCoinM
                self!.reqData()
                
                self!.coinModel = value
                self!.coinSymbolBtn.setTitle("\(value.coin)/\(value.currency)", for: .normal)

                _ =  self!.tradeModel.requestSymbolAsset()
                return self!.marketsViewModel.requestCoinDetails().catch { error in
                    return Observable.empty()
                }
            })
            .subscribe(onNext: {value in
                
                self.coinModel = value
                self.ratioLabel.text = value.ratio_str
                self.operationView.coinPushModel.onNext(value)
            }).disposed(by: disposeBag)

        
        return button
    }()
    
    
    //内容
    lazy var tradeTableView : BaseTableView = {
        let tableView = BaseTableView(frame: CGRect.zero, style: .plain)
        tableView.register(TradeOpenOrdersCell.self, forCellReuseIdentifier: TradeOpenOrdersCell.CELLID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView  = headerView
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView?.height = CGFloat(380)
        tableView.backgroundColor = .hexColor("1E1E1E")
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.height = CGFloat(kScreenHeight - TOP_HEIGHT - TABBAR_HEIGHT - 39)
        return tableView
    }()
    
    
    
    lazy var sectionHeaderView : UIView = {
        
        let view = UIView()
        view.backgroundColor = .hexColor("1E1E1E")
        let bottomLine = UIView()
        bottomLine.backgroundColor = .hexColor("000000")
        let scrollLine = UIView()
        scrollLine.backgroundColor = .hexColor("FCD283")
        
        let currentBtn = UIButton()
        let assetBtn = UIButton()
        let historyBtn = UIButton()

        currentBtn.setTitle("tv_trade_record_current_entrust".localized(), for: .normal)
        currentBtn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        currentBtn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        currentBtn.titleLabel?.font = FONTR(size: 16)
        currentBtn.isSelected = true
        currentBtn.rx.tap.subscribe({ _ in
            
            if !currentBtn.isSelected {
                currentBtn.isSelected =  !currentBtn.isSelected
                assetBtn.isSelected =  !currentBtn.isSelected

                scrollLine.snp.remakeConstraints { make in

                    make.bottom.equalToSuperview()
                    make.centerX.equalTo(currentBtn)
                    make.width.equalTo(88)
                    make.height.equalTo(3)
                }
            }
        }).disposed(by: disposeBag)
    
        self.updateEntrusts.subscribe{ num in
            
            if num > 0 {
                
                currentBtn.setTitle("tv_trade_record_current_entrust".localized() + "(\(num))", for: .normal)
            }else{
                
                currentBtn.setTitle("tv_trade_record_current_entrust".localized(), for: .normal)
            }

        } onError: { Error in
            
        }.disposed(by: self.disposeBag)
//        self.entrustViewModel.allEntrust.subne
        
        
        assetBtn.setTitle("tv_assets".localized(), for: .normal)
        assetBtn.isHidden = true
        assetBtn.isEnabled = false
        assetBtn.titleLabel?.font = FONTR(size: 16)
        assetBtn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        assetBtn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)

        assetBtn.rx.tap.subscribe({ _ in
            
            if !assetBtn.isSelected {
                assetBtn.isSelected =  !assetBtn.isSelected
                currentBtn.isSelected =  !assetBtn.isSelected

                scrollLine.snp.remakeConstraints{ make in

                    make.bottom.equalToSuperview()
                    make.centerX.equalTo(assetBtn)
                    make.width.equalTo(88)
                    make.height.equalTo(3)
                }
            }
        }).disposed(by: disposeBag)

        
        historyBtn.setImage(UIImage(named: "redolist"), for: .normal)
        historyBtn.rx.tap.subscribe({ _ in
            
            if userManager.isLogin {
                 
                let vc = EntrustVC()
                getTopVC()?.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                UserManager.manager.logoutWithVC(currentVC: self)
            }
        }).disposed(by: disposeBag)

        
        view.addSubview(currentBtn)
        view.addSubview(assetBtn)
        view.addSubview(historyBtn)

       currentBtn.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.width.equalTo(110)
        }

        assetBtn.snp.makeConstraints { make in
            
            make.left.equalTo(currentBtn.snp.right)
            make.height.centerY.equalTo(currentBtn)
            make.width.equalTo(100)
        }
        
        view.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        view.addSubview(scrollLine)
        scrollLine.snp.makeConstraints { make in

            make.bottom.equalToSuperview()
            make.centerX.equalTo(currentBtn)
            make.width.equalTo(88)
            make.height.equalTo(3)
        }
        
        historyBtn.snp.makeConstraints { make in
             
            make.right.equalToSuperview().offset(-8)
             make.height.width.equalTo(38)
             make.centerY.equalToSuperview()
         }


        return view
    }()
    
//    var headerHeight = 410
    lazy var operationView : CoinTradeOperationView = {
        
        let view = CoinTradeOperationView()
        
        return view
    }()
    lazy var headerView : UIView = {
        
        let view = UIView()
        view.addSubview(littleKlineView)
        view.addSubview(operationView)
        operationView.pushClosure = {
            
            UserManager.manager.logoutWithVC(currentVC: self)
        }
        
        operationView.placeOrder = {
            
            self.placeOrder()
        }
        
        operationView.showSheet = {
                 datas in
            print("\(datas)")
            self.showBottomAlert(datas as Array<Any>)
        }
        
        operationView.changeOrderType = {

            orderType  in
            self.resetHeaderHeight()
            switch orderType {
                
            case .limit :
                    print("12121")
            case .market , .StopLossTakeProfit :
                print("12121")
            }
            
        }
        
        littleKlineView.snp.makeConstraints { make in

            make.top.left.right.equalToSuperview()
            make.height.equalTo(0)
        }

        operationView.snp.makeConstraints { make in

            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(littleKlineView.snp.bottom)
            make.height.equalTo(410)
        }

        return view
    }()
    lazy var footerView : UIView = {
        
        let view = UIView()
//        view.backgroundColor = .red
        return view
    }()

    
    func placeOrder()  {
        
        self.tradeModel.reqTradeModel = self.operationView.reqModel

        self.tradeModel.requestTradeOrder().catch { error in
            HudManager.dismissHUD()
            switch error.localizedDescription {
                
            case "triggerPrice":
//                self.operationView.triggerPriceInputView.inputTextField.becomeFirstResponder()
                
                HudManager.showOnlyText("触发价不能为空".localized())
                return Observable.never()
            case "price":
//                self.operationView.priceInputView.inputTextField.becomeFirstResponder()
                HudManager.showOnlyText("委托价不能为空".localized())
                return Observable.never()
            case "num":

//                self.operationView.amountInputView.inputTextField.becomeFirstResponder()
                HudManager.showOnlyText("下单总金额不低于10USDT".localized())
                return Observable.never()
            case "market_num":
                HudManager.showOnlyText("下单总金额不低于10USDT".localized())
//                self.operationView.marketAmountInputView.inputTextField.becomeFirstResponder()
                return Observable.never()
            default:
                HudManager.showError(error.localizedDescription)
            }
            return Observable.empty()
        }
        .flatMap{ value -> Observable<Any> in
            
            if self.operationView.reqModel.order_type == "3"{
                
                self.operationView.clearMarket()
            }else{
                self.operationView.clearAmount()
            }
            
            return self.tradeModel.requestSymbolAsset().catch { error in
                HudManager.dismissHUD()
                HudManager.showError(error.localizedDescription)
                return Observable.empty()
            }
            
        }
//        .flatMap{ value -> Observable<Any> in
//            return self.entrustViewModel.requestHistoryEntrust().catch { error in
//                HudManager.dismissHUD()
//                HudManager.showError(error.localizedDescription)
//                return Observable.empty()
//            }
//        }
        .subscribe(onNext: { value in
            HudManager.dismissHUD()
            
             self.reloadEntrust()
        }).disposed(by: self.disposeBag)

    }
    
    lazy var littleKlineView : UIView = {
        let view = UIView()
        view.addSubview(timeView)
        view.addSubview(kLineView)
        view.clipsToBounds = true
        return view
    }()
    
    var isShowKline: Bool = false{
        didSet{
            littleKlineView.snp.updateConstraints { make in
                make.height.equalTo(isShowKline ? 234 : 0)
            }
            resetHeaderHeight()
        }
    }
    
    func resetHeaderHeight() {
        
        tradeTableView.tableHeaderView?.height = CGFloat(380 + (isShowKline ? 230 : 0) + (operationView.orderType == .StopLossTakeProfit ? 40 : 0 ) )
        tradeTableView.reloadData()
    }
    
    func reloadTradeTable() {
        
        let row = self.entrustViewModel.allEntrust.count
        let sumRowHeight : CGFloat = CGFloat(100 * row)
        let footerHeight : CGFloat  = CGFloat(kScreenHeight - TOP_HEIGHT - TABBAR_HEIGHT - 39) - sumRowHeight
        tradeTableView.tableFooterView?.height =  (footerHeight > 0) ? footerHeight : 0
        tradeTableView.reloadData()
    }

    func updateCoinInfo(){
        //MARK: 币种详情

        
        if let userInfo =  USER_DEFAULTS.value(forKey: "klineToTrade") as? Dictionary<String, String>{
            
            print("\(userInfo)")
            marketsViewModel.reqModel = rModel
            
            self.rModel.coin = userInfo["coin"] ?? "BTC"
            self.rModel.currency = userInfo["currency"] ?? "USDT"
            self.marketsViewModel.reqModel = self.rModel
            self.marketsViewModel.reqModel.kline_type = "1m"
            self.tradeModel.reqModel = self.rModel
            self.coinSymbolBtn.setTitle("\(self.rModel.coin)/\(self.rModel.currency)", for: .normal)

            let tradeDerection = userInfo["tradeDerection"] ?? "buy"
            //MARK: 币种详情
            self.marketsViewModel.requestCoinDetails()
                .subscribe(onNext: { model in
                    self.coinModel = model
                    self.coinSymbolBtn.setTitle("\(model.coin)/\(model.currency)", for: .normal)
                    self.ratioLabel.text = model.ratio_str
                    self.operationView.coinPushModel.onNext(model)
                    self.operationView.isBuy = (tradeDerection == "buy")
            }).disposed(by: disposeBag)
            
            
            
            USER_DEFAULTS.setValue(nil, forKey: "klineToTrade")
            USER_DEFAULTS.synchronize()
        }else{
            
            marketsViewModel.requestCoinDetails()
                .subscribe(onNext: { model in
                    self.coinModel = model
                    self.coinSymbolBtn.setTitle("\(model.coin)/\(model.currency)", for: .normal)
                    self.ratioLabel.text = model.ratio_str
                    self.operationView.coinPushModel.onNext(model)
            }).disposed(by: disposeBag)
        }
    }
    
    func updateView(){
        
        if userManager.isLogin {
            
            //MARK: 获取当前币种资产
           let _  =  tradeModel.requestSymbolAsset()
            
            self.tradeModel.balancePublish.subscribe(onNext: { model in
                
                self.operationView.balanceModel = model as? SymbolAssetModel
                self.tradeTableView.endMJRefresh()
            }).disposed(by: disposeBag)
            
            entrustViewModel.websocketUser()
            
            entrustViewModel.personData.subscribe ({ str in
               
                print("订单推送过来 = = = = == = = = = = == 刷新")
                _ =  self.tradeModel.requestSymbolAsset()
                self.reloadEntrust()
           
            }).disposed(by: disposeBag)
            
            entrustViewModel.allEntrustPublish.subscribe ({ _ in
                
                self.tradeTableView.endMJRefresh()
                self.updateEntrusts.onNext(self.entrustViewModel.allEntrust.count)
                self.reloadTradeTable()
                self.tradeTableView.endMJRefresh()
            }).disposed(by: disposeBag)
            
            reloadEntrust()

        }else {
            
            self.operationView.balanceModel = nil
        }
        operationView.updateView()
    }
    
    func reloadEntrust()  {

        entrustViewModel.requestEntrust(get_type: 0, page: 0)

//
//        entrustViewModel.requestHistoryEntrust()
//            .subscribe(onNext: {value in
//                self.tradeTableView.endMJRefresh()
//                self.updateEntrusts.onNext(self.entrustViewModel.allEntrust.count)
//                self.reloadTradeTable()
//            }).disposed(by: disposeBag)
    }
    
    //MARK: - NOTI
    @objc func updateShowCoin(noti: Notification){
        
        let notis = noti.userInfo
        self.rModel.coin = notis?["coin"] as! String
        self.rModel.currency = notis?["currency"] as! String
        self.marketsViewModel.reqModel = self.rModel
        self.marketsViewModel.reqModel.kline_type = "1m"
        self.tradeModel.reqModel = self.rModel
        
        let temM = self.coinModel
        temM.coin = self.rModel.coin
        temM.currency = self.rModel.currency
        self.coinModel = temM
        self.coinSymbolBtn.setTitle("\(self.rModel.coin)/\(self.rModel.currency)", for: .normal)
        print("更新数据"+(self.coinSymbolBtn.titleLabel?.text)!)
    }
    @objc func signoutNoti(noti: Notification){

        updateView()
    }
    
    lazy var kLineView: XLKLineView = {
        
        let kLineView = XLKLineView(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 210))
        kLineView.backgroundColor = UIColor.xlChart.color(rgba: "#1E1E1E")
        return kLineView
    }()
    
    lazy var timeView: UIScrollView = {
        let timeView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 24))
        timeView.backgroundColor = .black.withAlphaComponent(0.88) //UIColor.xlChart.color(rgba: "#243245")
        
        let times = [KLINETIMEMinLine, KLINETIME3Min, KLINETIME5Min, KLINETIME15Min, KLINETIME30Min, KLINETIME1Hour,
                     KLINETIME2Hour, KLINETIME4Hour, KLINETIME6Hour, KLINETIME8Hour, KLINETIME12Hour, KLINETIME1Day,
                     KLINETIME3Day, KLINETIME1Week, KLINETIME1Month]
        let btnW: CGFloat = SCREEN_WIDTH / 6
        timeView.contentSize = CGSize(width: Int(btnW) * times.count, height: 1)
        var idx: Int = 0
        
        for str in times {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.setTitleColor(UIColor.hexColor("ebebeb"), for: .normal)
            btn.setTitleColor(UIColor.hexColor("fcd283"), for: .selected)
            btn.frame = CGRect(x: CGFloat(idx) * btnW, y: 0, width: btnW, height: timeView.bounds.size.height)
            btn.tag = idx
            timeView.addSubview(btn)
            self.timeBtnArray.append(btn)
            if(idx == 0){
                btn.isSelected = true
            }
            idx += 1
        }
        return timeView
    }()
    lazy var timeBtnArray = [UIButton]()
}
//UI
extension CoinTraderController {
    
    func setUI() {
 
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(topView)
        mainScrollView.addSubview(tradeTableView)
        addConstraints()
    }
    //添加topView 包括左侧按钮 k线按钮等
    
    //snp布局
    func addConstraints() {
        
        mainScrollView.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            
            make.left.width.top.right.equalToSuperview()
            make.height.equalTo(39)
        }

        tradeTableView.snp.makeConstraints { make in
            
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(mainScrollView.snp.height).offset(-39)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func showBottomAlert(_ datas : Array<Any>){
        
        let alertController=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            alertController.overrideUserInterfaceStyle = .dark
        }
        
        let cancel=UIAlertAction(title:"common_cancel".localized(), style: .cancel, handler: nil)
        alertController.addAction(cancel)


        for str in datas {
          
            let action = UIAlertAction(title:str  as? String, style: .default){
                action in
                
                self.operationView.marketsViewModel.gear = str as? String
            }
            alertController.addAction(action)
        }
                
        self.present(alertController, animated:true, completion:nil)
        
    }


}
//
extension CoinTraderController{
    
    func dealWithSocekt()  {
        
        marketsViewModel.kLineData.subscribe(onNext: {[weak self] value in
            if(self!.isShowKline){
                self!.kLineView.updateSecondHeight()
                self!.kLineView.configureViewNoOffset(data: self!.marketsViewModel.kLineList, isNew: true, mainDrawString: KLINEMA, secondDrawString: KLINEHIDE, dateType: self!.dateType, lineType: (self!.marketsViewModel.reqModel.kline_type == "1m") ? .minLineType : .candleLineType)
            }
        }).disposed(by: disposeBag)
    }
    func setupEvent(){
        let buttonTimes = self.timeBtnArray.map { $0 }
        let choTimeButton = Observable.from(
            buttonTimes.map { button in button.rx.tap.map {button} }
        ).merge()
        choTimeButton.map { value in
            
            for button in buttonTimes {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
            self.dateType = .min
            switch value.tag {
                case 1:
                    self.marketsViewModel.reqModel.kline_type = "3m"
                case 2:
                    self.marketsViewModel.reqModel.kline_type = "5m"
                case 3:
                    self.marketsViewModel.reqModel.kline_type = "15m"
                case 4:
                    self.marketsViewModel.reqModel.kline_type = "30m"
                case 5:
                    self.marketsViewModel.reqModel.kline_type = "1h"
                case 6:
                    self.marketsViewModel.reqModel.kline_type = "2h"
                case 7:
                    self.marketsViewModel.reqModel.kline_type = "4h"
                case 8:
                    self.marketsViewModel.reqModel.kline_type = "6h"
                case 9:
                    self.marketsViewModel.reqModel.kline_type = "8h"
                case 10:
                    self.marketsViewModel.reqModel.kline_type = "12h"
                case 11:
                    self.dateType = .day
                    self.marketsViewModel.reqModel.kline_type = "1d"
                case 12:
                    self.dateType = .day
                    self.marketsViewModel.reqModel.kline_type = "3d"
                case 13:
                    self.dateType = .day
                    self.marketsViewModel.reqModel.kline_type = "1w"
                case 14:
                    self.dateType = .day
                    self.marketsViewModel.reqModel.kline_type = "1M"
                default:
                    self.marketsViewModel.reqModel.kline_type = "1m"
            }
        }
        .flatMap({[weak self] value -> Observable<Any>  in
            
            self!.marketsViewModel.websocketKline()
            return self!.marketsViewModel.requestMarketKline().catch { error in
                return Observable.empty()
            }
        })
        .subscribe(onNext: {[weak self] value in
            
            self!.kLineView.updateSecondHeight()
            self!.kLineView.configureView(data: self!.marketsViewModel.kLineList, isNew: true, mainDrawString: KLINEMA , secondDrawString: KLINEHIDE, dateType: self!.dateType, lineType: (self!.marketsViewModel.reqModel.kline_type == "1m") ? .minLineType : .candleLineType)
        }).disposed(by: disposeBag)
    }

}

extension CoinTraderController : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.entrustViewModel.allEntrust.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TradeOpenOrdersCell = tableView.dequeueReusableCell(withIdentifier: TradeOpenOrdersCell.CELLID) as! TradeOpenOrdersCell
        let model = self.entrustViewModel.allEntrust[indexPath.row]
        cell.model = model
        //MARK: 取消
        cell.cancelBtn.rx.tap
            .flatMap({ value -> Observable<Any> in
                HudManager.show()
                self.entrustViewModel.orderno = model.order_no
                return self.entrustViewModel.requestCancelorder().catch { error in
                    HudManager.dismissHUD()
                    HudManager.showError(error.localizedDescription)
                    return Observable.empty()
                }
            }).subscribe(onNext: {value in
                HudManager.dismissHUD()
                
                self.reloadEntrust()
//
//                self.updateEntrusts.onNext(self.entrustViewModel.allEntrust.count)
//                self.reloadTradeTable()
                
            }).disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 45 ;//CGFloat(headerHeight)
    }
    
}


// MARK: - UIScrollViewDelegate
extension CoinTraderController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension CoinTraderController : JXPagingViewListViewDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return self.mainScrollView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.scrollClosure = callback
    }

}

class RatioLabel : UILabel {
    
    override var text : String? {
        
        set{
            
            if let newValue = newValue, !newValue.isEmpty {
                
                let str = String(format: "%.2f", newValue.toDouble())
                           
                self.isHidden = false
                if Double(newValue) ?? 0 >= 0{
                    
                    super.text = "+\(str)%"
                    self.textColor = .hexColor("02C078")
                }else{
                    super.text = "\(str)%"
                    self.textColor = .hexColor("F03851")
                }
            } else {
                
                super.text = newValue
                self.isHidden = true
            }
        }
        get{
            
            return super.text
        }
    }
}
