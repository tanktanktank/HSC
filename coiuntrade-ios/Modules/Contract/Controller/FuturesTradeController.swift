//
//  FuturesTradeController.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/12.
//

import UIKit

class FuturesTradeController: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    private var disposeBag = DisposeBag()
    var coinSocket: HSSocketManager!
    var curSelectTime = "15m"

    var scrollClosure : scrollCallback = nil

    let tableHeader = ContractHeader()
    // MARK: - mainScrollView
    lazy var mainScrollView : BaseScrollView = {
        let scrollview = BaseScrollView.init(frame: .zero)
        scrollview.backgroundColor = .hexColor("1E1E1E")
        scrollview.showsVerticalScrollIndicator = false
        return scrollview
    }()
    let moreBtn = UIButton(frame: CGRect.zero)
    let calculateBtn = UIButton(frame: CGRect.zero)
    let klineBtn = UIButton(frame: CGRect.zero)
    let littleKBtn = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUI()
        addConstraints()
        addEvent()
        setupData()
        reqData()
    }
    
    func setupData(){
        
        coinSocket = HSSocketManager()
    }
    
    func reqData(){
        
        let reqCoinM = ReqCoinModel()
        reqCoinM.coin = "BTC"
        reqCoinM.currency = "USDT"
        reqCoinM.kline_type = self.curSelectTime
        coinSocket.requestMarketKline(reqM: reqCoinM).subscribe(onNext: {[weak self] resp in
            self!.headerView.updateSecondHeight()
            self!.headerView.littleKLineList = self!.coinSocket.kLineList
        }).disposed(by: disposeBag)
    }
    
    //内容
    lazy var tradeTableView : BaseTableView = {
        let tableView = BaseTableView(frame: CGRect.zero, style: .plain)
        tableView.register(FuturesEntrustCell.self, forCellReuseIdentifier: "FuturesEntrustCell")
        tableView.register(UINib(nibName: "FuturesHoldingCell", bundle: nil), forCellReuseIdentifier: "FuturesHoldingCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView  = headerView
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView?.height = CGFloat(436)
        tableView.backgroundColor = .hexColor("1E1E1E")
//        tableView.tableFooterView = footerView
        tableView.tableHeaderView?.backgroundColor = .hexColor("1E1E1E")
        tableView.separatorStyle = .none
        tableView.tableFooterView?.height = CGFloat(kScreenHeight - TOP_HEIGHT - TABBAR_HEIGHT - 39)
        return tableView
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
        
//        //MARK: 行情
//        button.rx.tap
//            .flatMap({ value -> Observable<CoinModel> in
//                let lodaView = TradeQuotesView.loadTradeQuotesView(view: self.view.window!)
//                return lodaView.dataSubject.catch { error in
//                    return Observable.empty()
//                }
//            })
//            .flatMap({ value -> Observable<CoinModel>  in
//
//                self.rModel.coin = value.coin
//                self.rModel.currency = value.currency
//                self.marketsViewModel.reqModel = self.rModel
//                self.marketsViewModel.reqModel.kline_type = "1m"
//                self.tradeModel.reqModel = self.rModel
//
//                self.coinModel = value
//                self.coinSymbolBtn.setTitle("\(value.coin)/\(value.currency)", for: .normal)
//
//                _ =  self.tradeModel.requestSymbolAsset()
//                return self.marketsViewModel.requestCoinDetails().catch { error in
//                    return Observable.empty()
//                }
//            })
//            .subscribe(onNext: {value in
//
//                self.coinModel = value
//                self.ratioLabel.text = value.ratio_str
//                self.operationView.coinPushModel.onNext(value)
//            }).disposed(by: disposeBag)

        
        return button
    }()

    // topView
    let ratioLabel = RatioLabel()
    lazy var topView : UIView = {
        let view = UIView()
        
        coinSymbolBtn.setImage(UIImage(named: "trelist"), for: .normal)
        coinSymbolBtn.setTitle("BTC/USDT", for: .normal)
        view.addSubview(coinSymbolBtn)

        ratioLabel.text = "0"
        ratioLabel.font = FONTDIN(size: 12)
        view.addSubview(ratioLabel)
        
        view.addSubview(moreBtn)
        moreBtn.setImage(UIImage(named: "futures_more"), for: .normal)

        view.addSubview(calculateBtn)
        calculateBtn.setImage(UIImage(named: "futures_calculate"), for: .normal)

        view.addSubview(klineBtn)
        klineBtn.setImage(UIImage(named: "tradekline"), for: .normal)
        
        view.addSubview(littleKBtn)
        littleKBtn.setImage(UIImage(named: "tradedown"), for: .normal)
        littleKBtn.setImage(UIImage(named: "tradeUp"), for: .selected)
        
        //MARK: K线
//        klineBtn.rx.tap.subscribe(onNext: {
//            let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
//            controller.model = self.coinModel
//            getTopVC()?.navigationController?.pushViewController(controller, animated: true)
//        }).disposed(by: disposeBag)

        //点击展开K线

//        moreBtn.rx.tap
//            .flatMap({ value -> Observable<Any>  in
//                print("请求k线数据")
//                self.marketsViewModel.reqModel.kline_type = "15m" //读取数据库
//                return self.marketsViewModel.requestMarketKline().catch { error in
//                    return Observable.empty()
//                }
//            })
//            .subscribe(onNext: { [self]value in
//                self.isShowKline = !self.isShowKline
//                moreBtn.isSelected = self.isShowKline
//                //加载k线
//                self.kLineView.theme.bottomChartHeight = 0
//                self.kLineView.topChartTextLayer.theme.bottomChartHeight = 0
//                self.kLineView.bottomChartTextLayer.theme.bottomChartHeight = 0
//                self.kLineView.kLine.theme.bottomChartHeight = 0
//                self.kLineView.configureView(data: self.marketsViewModel.kLineList, isNew: true, mainDrawString: KLINEMA, secondDrawString: KLINEHIDE, dateType: .min, lineType: .candleLineType)
//            }).disposed(by: disposeBag)

        let bottonLineView = UIView()
        bottonLineView.backgroundColor = .hexColor("0D0D0D")
        view.addSubview(bottonLineView)
        
        //MARK: 当前推送价格
        WSCoinPushSing.sharedInstance().tradeDatas
            .subscribe(onNext: { value in
//                if self.coinModel.coin == value.coin &&
//                    self.coinModel.currency == value.currency {
                    
                    self.ratioLabel.text = value.ratio_str
//                }
        })
        .disposed(by: disposeBag)

        
        coinSymbolBtn.snp.makeConstraints({ make in
            
            make.left.top.equalToSuperview()
            make.height.equalTo(38)
        })
        
        ratioLabel.snp.makeConstraints { make in
         
            make.left.equalTo(coinSymbolBtn.snp.right)
            make.centerY.equalTo(coinSymbolBtn)
        }

        moreBtn.snp.makeConstraints { make in
            
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        calculateBtn .snp.makeConstraints { make in
            
            make.right.equalTo(moreBtn.snp.left)
            make.top.bottom.width.equalTo(moreBtn)
        }

        klineBtn.snp.makeConstraints { make in
         
            make.right.equalTo(calculateBtn.snp.left)
            make.top.bottom.width.equalTo(calculateBtn)
        }
        
        littleKBtn.snp.makeConstraints { make in
         
            make.right.equalTo(klineBtn.snp.left)
            make.top.bottom.width.equalTo(calculateBtn)
        }
        
        bottonLineView.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let alwayLabel = UILabel()
        alwayLabel.text = "永续"
        alwayLabel.textColor = .white
        alwayLabel.font = FONTM(size: 12)
        
        view.addSubview(alwayLabel)
        alwayLabel.snp.makeConstraints { make in
            
            make.left.equalTo(34)
            make.bottom.equalTo(-8)
            make.height.equalTo(17)
        }

        return view
    }()
    
    var isEntrust = true {
        
        didSet{
            
            self.scrollLine.snp.remakeConstraints{ make in

                make.bottom.equalToSuperview()
                make.centerX.equalTo((isEntrust ? currentBtn : assetBtn))
                make.width.equalTo(88)
                make.height.equalTo(3)
            }

            self.tradeTableView.reloadData()
        }
    }
    
    let scrollLine = UIView()
    let currentBtn = UIButton()
    let assetBtn = UIButton()

    lazy var sectionHeaderView : UIView = {
        
        let view = UIView()
        view.backgroundColor = .hexColor("1E1E1E")
        let bottomLine = UIView()
        bottomLine.backgroundColor = .hexColor("000000")
        scrollLine.backgroundColor = .hexColor("FCD283")
        
//        let currentBtn = UIButton()
//        let assetBtn = UIButton()
        let historyBtn = UIButton()

        currentBtn.setTitle("当前委托".localized(), for: .normal)
        currentBtn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        currentBtn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        currentBtn.titleLabel?.font = FONTR(size: 16)
        currentBtn.isSelected = true
        currentBtn.rx.tap.subscribe({ _ in
            
            self.isEntrust = true
//            if !currentBtn.isSelected {
//                currentBtn.isSelected =  !currentBtn.isSelected
//                assetBtn.isSelected =  !currentBtn.isSelected
//
//                scrollLine.snp.remakeConstraints { make in
//
//                    make.bottom.equalToSuperview()
//                    make.centerX.equalTo(currentBtn)
//                    make.width.equalTo(88)
//                    make.height.equalTo(3)
//                }
//            }
        }).disposed(by: disposeBag)
    
//        self.updateEntrusts.subscribe{ num in
//
//            if num > 0 {
//
//                currentBtn.setTitle("tv_trade_record_current_entrust".localized() + "(\(num))", for: .normal)
//            }else{
//
//                currentBtn.setTitle("tv_trade_record_current_entrust".localized(), for: .normal)
//            }
//
//        } onError: { Error in
//
//        }.disposed(by: self.disposeBag)
//        self.entrustViewModel.allEntrust.subne
        
        
        assetBtn.setTitle("持有仓位(2)".localized(), for: .normal)
        assetBtn.titleLabel?.font = FONTR(size: 16)
        assetBtn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        assetBtn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)

        assetBtn.rx.tap.subscribe({ _ in
            self.isEntrust = false
        }).disposed(by: disposeBag)

        
        historyBtn.setImage(UIImage(named: "redolist"), for: .normal)
        historyBtn.rx.tap.subscribe({ _ in
            
            if userManager.isLogin {
                 
                let vc = FuturesEntrustVC()
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

    lazy var headerView : ContractHeader = {
        
        let view = ContractHeader()
        return view
    }()

    
    func setUI() {
 
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(topView)
        mainScrollView.addSubview(tradeTableView)
    }

    //snp布局
    func addConstraints() {
        
        mainScrollView.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        topView.snp.makeConstraints { make in
            
            make.width.equalTo(SCREEN_WIDTH)
            make.left.top.right.equalToSuperview()
            make.height.equalTo(55)
        }

        tradeTableView.snp.makeConstraints { make in
            
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(mainScrollView.snp.height).offset(-55)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func addEvent() {
        
        coinSymbolBtn.rx.tap
                    .subscribe(onNext: {
                        HSQuotesView.show()
            }).disposed(by: disposeBag)
        
        littleKBtn.rx.tap
                    .subscribe(onNext: {[weak self] in
                    
                        self!.littleKBtn.isSelected = !self!.littleKBtn.isSelected
                        if(self!.littleKBtn.isSelected){
                            self!.tradeTableView.tableHeaderView?.height =  670.0//436+234 =
                        }else{
                            self!.tradeTableView.tableHeaderView?.height =  436.0//436+234 =
                        }
                        self!.headerView.updateConstraint(isShow: self!.littleKBtn.isSelected)
                        self!.tradeTableView.reloadData()

                    }).disposed(by: disposeBag)

        klineBtn.rx.tap.subscribe(onNext: {[weak self] in

            //TODO: coin,currency  需要动态化
            let coinM = CoinModel()
            coinM.coin = "BTC"
            coinM.currency = "USDT"
            let coinDetailVC = HSCoinDetailVC()
            coinDetailVC.model = coinM
            coinDetailVC.isAgreement = true
            self?.navigationController?.pushViewController(coinDetailVC, animated: true)

        }).disposed(by: disposeBag)

        calculateBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                self?.navigationController?.pushViewController(FuturesCalculateController(), animated: true)
            }).disposed(by: disposeBag)
    }
}


extension FuturesTradeController : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isEntrust ? 10 : 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.isEntrust ? (indexPath.row  == 3 ? 136 : 114 ): 242
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isEntrust{
            
            let cell: FuturesEntrustCell = tableView.dequeueReusableCell(withIdentifier: "FuturesEntrustCell") as! FuturesEntrustCell
            cell.isTrigger = indexPath.row  == 3
            cell.progressV.setProgress(10, progressColor: .hexColor("02C078"),text: "50%")
            return cell

        }else{
            
            let cell: FuturesHoldingCell = tableView.dequeueReusableCell(withIdentifier: "FuturesHoldingCell") as! FuturesHoldingCell

            cell.adjustClick = {
    
                let actionSheet = FuturesLeverSheet()
    
    //            actionSheet.clickCellAtion = { index in
    //                print("\(index)")
    //            }
                actionSheet.show()
            }
    
            cell.stopPLClick = {
                let actionSheet = FuturesSetStopPLSheet()
    
                actionSheet.show()
            }
    
            cell.closePositionClick = {
    
                let actionSheet = FuturesCLosePositionSheet()
    
                actionSheet.show()
            }

            return cell

        }
        
//        }
        
//        let model = self.entrustViewModel.allEntrust[indexPath.row]
//        cell.model = model
//        //MARK: 取消
//        cell.cancelBtn.rx.tap
//            .flatMap({ value -> Observable<Any> in
//                HudManager.show()
//                self.entrustViewModel.orderno = model.order_no
//                return self.entrustViewModel.requestCancelorder().catch { error in
//                    HudManager.dismissHUD()
//                    HudManager.showError(error.localizedDescription)
//                    return Observable.empty()
//                }
//            }).subscribe(onNext: {value in
//                HudManager.dismissHUD()
//
//                self.reloadEntrust()
////
////                self.updateEntrusts.onNext(self.entrustViewModel.allEntrust.count)
////                self.reloadTradeTable()
//
//            }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 45 ;//CGFloat(headerHeight)
    }
    
    
}

//MARK: JXPagingViewListViewDelegate
extension FuturesTradeController : JXPagingViewListViewDelegate{
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

