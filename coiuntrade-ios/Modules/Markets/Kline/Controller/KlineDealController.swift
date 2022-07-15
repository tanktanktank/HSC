//
//  KlineDealController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/27.
//

import UIKit
import Starscream
import RxSwift

class KlineDealController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var model : CoinModel!
    
    @IBOutlet weak var tableBuy: UITableView!
    @IBOutlet weak var tableNew: UITableView!
    @IBOutlet weak var tableSell: UITableView!
    
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnleave: UIButton!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblUnitPrice: UILabel!
    
    @IBOutlet weak var lblVolCoin: UILabel!
    @IBOutlet weak var lblVolUnit: UILabel!
    
    @IBOutlet weak var lblHight: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblVolCoinNum: UILabel!
    @IBOutlet weak var lblVolUnitNum: UILabel!
    
    @IBOutlet weak var btnLine: UIButton!
    @IBOutlet weak var btn15m: UIButton!
    @IBOutlet weak var btn1h: UIButton!
    @IBOutlet weak var btn4h: UIButton!
    @IBOutlet weak var btn1d: UIButton!
    
    @IBOutlet weak var vMore: UIView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var btnDepth: UIButton!
    @IBOutlet weak var vTarget: UIView!
    
    
    @IBOutlet weak var btnOrderBook: UIButton!
    @IBOutlet weak var btMarketHistory: UIButton!
    @IBOutlet weak var btnMarginData: UIButton!
    
    @IBOutlet weak var scView: UIScrollView!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var vWard: UIView!
    
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var vShowLine: UIView!
    @IBOutlet weak var showHeight: NSLayoutConstraint!
    @IBOutlet weak var vShowLineHConstrait: NSLayoutConstraint!
    
    @IBOutlet weak var gearLabel: UILabel!
    
    @IBOutlet weak var indicateView: UIView!

    var isSelectLine : Bool = false //是否选择分时图
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    private var disposeBag = DisposeBag()
    private var rxModel = PublishSubject<CoinModel>()
    var viewModel: MarketsViewModel!
    var rModel : ReqCoinModel!
    var isSelectNewdeal:Bool = false //是否点击最新成交
    
    /// 日期显示类型 日K以内是MM/DD HH:mm  日K以外是YY/MM/DD
    var dateType: XLKLineDateType = .min
    
    /// 主图显示 默认MA (MA、BOLL、隐藏)
    var mainString = KLINEMA
    
    /// 副图显示 默认VOL (VOL、MACD、KDJ、RSI)
    var secondString = KLINEVOL
    
    /// 十字线是否在动画
    var isCrossAnimation = false
    
    var dataArray = [XLKLineModel]()
    var curSells = [Any]()
    
    //记录当前价格
    var currentPrice : String = ""
    
    var result : Ticker24Model = Ticker24Model()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatas()//网络数据也在这发生了
        setupUI()
        setupEvent()
        setupIndexDatas()
        setupTimeDatas()

        //MARK: K线设置
        let tapTarget = UITapGestureRecognizer()
        self.vTarget.addGestureRecognizer(tapTarget)
        tapTarget.rx.event
            .subscribe(onNext: { recognizer in
                //-->翻译
                let items: [String] = ["index".localized(),"chart_height".localized(),"line_drawing_tool".localized(),"tv_home_moudle_more".localized()]
                let imgSource: [String] = ["kshowtaget","kshowheight","kshowreactl","kshowmore"]
                NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: 114, height: 164, point: CGPoint(x: ScreenInfo.Width - 30, y: 150), item: items, imgSource: imgSource) { (index) in
                    switch index {
                    case 0:
                        self.navigationController?.pushViewController(KlineTargetController(), animated: true)
                    case 1:do{
                        let changeHeightVC:KlineHeightController = KlineHeightController()
                        changeHeightVC.pass = { [weak self] update in
                            
                            let updateHeight = update * 355
                            self?.vShowLineHConstrait.constant = HSWindowAdapter.calculateHeight(input: updateHeight)
                            self?.kLineDepthView.height = HSWindowAdapter.calculateHeight(input: updateHeight)
                            self?.kLineView.height = updateHeight
                            self?.kLineDepthView.updateLineViewFrame()
                            self?.kLineView.scrollView.frame = (self!.kLineView.bounds)
                        }
                        self.navigationController?.pushViewController(changeHeightVC, animated: true)
                    }
                        break
                    case 2:
                        print("ssss1")
                    case 3:
                        self.navigationController?.pushViewController(KlineSetController(), animated: true)
                    default:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if(viewModel != nil){
            viewModel.deal24Data.disposed(by: disposeBag)
            viewModel.fiveData.disposed(by: disposeBag)
            viewModel.newdealData.disposed(by: disposeBag)
            viewModel.kLineData.disposed(by: disposeBag)
//            viewModel = nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        subscribeCoin()
    }
    
    func setupCrossDetailHide(hide: Bool) {
        if isCrossAnimation {
            return
        }
        
        isCrossAnimation = true
        if hide {
            UIView.animate(withDuration: 0.25, animations: {
                self.detailView.alpha = 0
            }) { (_) in
                self.isCrossAnimation = false
            }
        }else {
            UIView.animate(withDuration: 0.25, animations: {
                self.detailView.alpha = 1
            }) { (_) in
                self.isCrossAnimation = false
            }
        }
    }
    // MARK: - Action
    @objc func clickDetail() {
        self.kLineView.hideCross()
    }
    
    @objc func moreTimeClick() {
        if(moreTimeView.height > 10){
            moreTimeView.hide()
        }else{
            moreTimeView.show(showy: vShowLine.y)
        }
    }
    
    @objc func gearClick() {
        
        self.showBottomAlert(self.viewModel.gears)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Delegate - TableView 买卖盘
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return self.viewModel.buys.count
        case 1:
            return self.curSells.count
            //return self.viewModel.sells.count
        case 2:
            return self.viewModel.newdeals.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0
        {
            let cell: BuyShowCell = tableView.dequeueReusableCell(withIdentifier: "BuyShowCell") as! BuyShowCell
            cell.datas = (self.viewModel.buys[indexPath.row] as! Array<String>)
            return cell
        }
        else if tableView.tag == 1{
            let cell: SellShowCell = tableView.dequeueReusableCell(withIdentifier: "SellShowCell") as! SellShowCell
//            cell.datas = (self.viewModel.sells[indexPath.row] as! Array<String>)
            cell.datas = (self.curSells[indexPath.row] as! Array<String>)
            return cell
        }
        else{
            //最新成交
            let cell: NewdealCell = tableView.dequeueReusableCell(withIdentifier: "NewdealCell") as! NewdealCell
            var news = [Any]()
            if(self.viewModel.newdeals.count > indexPath.row){
                news = (self.viewModel.newdeals[indexPath.row] as! Array<Any>)
            }
            cell.datas = news
            return cell
        }
    }
    
    //MARK: - NOTI
    @objc func onIndexUpdateNotifition(noti: Notification){
        
        let notis = noti.userInfo
        if(notis != nil){
            let type = notis!["KLineType"] as! String
            if(type == "KLineBoll"){
                setupBollIndexDatas()
            }else if(type == "KLineMacd"){
                setupMACDIndexDatas()
            }else if(type == "KLineKDJ"){
                setupKDJIndexDatas()
            }else if(type == "KLineRSI"){
                setupRSIIndexDatas()
            }
        }else{
            setupMaIndexDatas()
        }
    }
    
    @objc func updateDetailViewNotifition(noti: Notification){
        
        let notis = noti.userInfo
        let type = notis!["type"] as! String
        var detailViewY = self.vShowLine.y - 70
        if(type == "0"){
            detailViewY = self.vShowLine.y + 20
        }
        detailView.y = detailViewY
        detailView.updateShow(isVerticl: (detailViewY < self.vShowLine.y) ? false:true)
        detailView.addCorner(conrners: .allCorners, radius: 6)
    }
    
    func showBottomAlert(_ datas : Array<Any>){
       let alertController=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancel=UIAlertAction(title:"common_cancel".localized(), style: .cancel, handler: nil)
        alertController.addAction(cancel)
        for str in datas {
            let action = UIAlertAction(title:str  as? String, style: .default){
                action in
                let updateGear = str as? String
                self.viewModel.gear = updateGear
                self.gearLabel.text = updateGear
            }
            alertController.addAction(action)
        }
        self.present(alertController, animated:true, completion:nil)
    }
    
    // MARK: - Event
    func setupEvent() {
        
        let gearTap = UITapGestureRecognizer(target: self, action: #selector(gearClick))
        gearLabel.addGestureRecognizer(gearTap)
        self.viewModel.gearChange.subscribe { gear in
            self.gearLabel.text = gear
        }.disposed(by: self.disposeBag)

        //幅图指标按钮
        let buttonSeconds = [self.btnVOL, self.btnMACD, self.btnKDJ, self.btnRSI].map { $0! }
        let choSecondButton = Observable.from(
            buttonSeconds.map { button in button.rx.tap.map {button} }
        ).merge()
        choSecondButton.map{ value in
            
            let secondIndexs = [KLINEVOL,KLINEMACD,KLINEKDJ,KLINERSI]
            self.secondString = secondIndexs[value.tag - 1024]
            for button in buttonSeconds {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
            self.kLineView.configureView(data: self.viewModel.kLineList, isNew: true, mainDrawString: self.mainString, secondDrawString: self.secondString, dateType: self.dateType, lineType: self.isSelectLine ? .minLineType : .candleLineType)
        }.subscribe(onNext: {value in
        }).disposed(by: disposeBag)
        
        //MARK: 分时按钮
        let buttonTimes = [self.btnLine, self.btn15m, self.btn1h, self.btn4h, self.btn1d].map { $0! }
        let choTimeButton = Observable.from(
            buttonTimes.map { button in button.rx.tap.map {button} }
        ).merge()
        choTimeButton.map { value in
            
            self.moreLabel.textColor = UIColor.hexColor("979797")
            self.moreLabel.text = "更多"
            self.btnDepth.isSelected = false
            self.kLineDepthView.isHidden = true
            for button in buttonTimes {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
            self.dateType = .min
            self.isSelectLine = false
            
            let curM = self.defaultWeeks[value.tag]
            self.viewModel.reqModel.kline_type = curM["time"]!
            if(curM["title"] == "分时"){
                self.isSelectLine = true
            }else{
                self.isSelectLine = false
            }
        }
        .flatMap({ value -> Observable<Any>  in
            self.vShowLine.isUserInteractionEnabled = false
            return self.viewModel.requestMarketKline().catch { error in
                return Observable.empty()
            }
        })
        .subscribe(onNext: {value in
            
            self.vShowLine.isUserInteractionEnabled = true
            self.kLineView.configureView(data: self.viewModel.kLineList, isNew: true, mainDrawString: self.mainString, secondDrawString: self.secondString, dateType: self.dateType, lineType: self.isSelectLine ? .minLineType : .candleLineType)
        }).disposed(by: disposeBag)
        
        //MARK: 按钮
        let buttons = [self.btnOrderBook, self.btMarketHistory, self.btnMarginData].map { $0! }
        let selectedButton = Observable.from(
            buttons.map { button in button.rx.tap.map {button} }
        ).merge()
        selectedButton
            .flatMap({ value -> Observable<Any> in
                for button in buttons {
                    if button.tag == value.tag{
                        button.isSelected = true
                    } else{
                        button.isSelected = false
                    }
                }
                UIView.animate(withDuration: 0.5, animations: {
                    self.vLine.center.x = value.center.x
                })
                self.scView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(value.tag - 100), y: 0), animated: true)
                if value.tag - 100 == 1 {
                    self.isSelectNewdeal = true
                    return self.viewModel.requestNewdeal().catch { error in
                        return Observable.empty()
                    }
                }
                self.isSelectNewdeal = false
                return Observable.empty()
            })
            .subscribe(onNext: {value in
                if self.isSelectNewdeal == true {
                    self.viewModel.websocketNewdeal()
                    let h = CGFloat(self.viewModel.newdeals.count) * 20.0
                    if h < SCREEN_HEIGHT {
                        self.showHeight.constant = SCREEN_HEIGHT
                    } else{
                        self.showHeight.constant = h + 60
                    }
                    self.tableNew.reloadData()
                }
            }).disposed(by: disposeBag)
        
        //MARK: 行情
        self.btnTitle.rx.tap
            .flatMap({ value -> Observable<CoinModel> in
                let lodaView = TradeQuotesView.loadTradeQuotesView(view: self.view.window!)
                return lodaView.dataSubject.catch { error in
                    return Observable.empty()
                }
            })
            .flatMap({ value -> Observable<CoinModel> in
                self.rModel.coin = value.coin
                self.rModel.currency = value.currency
                self.viewModel.reqModel = self.rModel
                self.model.coin = value.coin
                self.model.currency = value.currency
                return self.viewModel.requestCoinDetails().catch { error in
                    return Observable.empty()
                }
            })
            .subscribe(onNext: {value in
                self.rxModel.onNext(value)
            }).disposed(by: disposeBag)
        
        //MARK: 添加/取消自选
        self.btnStart.rx.tap
            .flatMap({[weak self] value -> Observable<Any> in
                if(userManager.isLogin){
                    self!.rModel.kline_type = self!.viewModel.reqModel.kline_type
                    self!.viewModel.reqModel = self!.rModel
                    return self!.viewModel.requestAccountLike().catch { error in
                        return Observable.empty()
                    }
                }else{
                    self!.btnStart.isSelected = !self!.btnStart.isSelected
                    self!.updateLike()
                    return Observable.empty()
                }

            })
            .subscribe(onNext: {value in
                self.btnStart.isSelected = !self.btnStart.isSelected
                if(self.btnStart.isSelected){
                    
                    HSToast.showToast(message: "添加自选成功" as NSString, aLocationStr: "bottom", aShowTime: 1.5)
                }else{
                    HSToast.showToast(message: "取消自选成功" as NSString, aLocationStr: "bottom", aShowTime: 1.5)
                }
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }).disposed(by: disposeBag)
        
        //MARK: 买/卖
        self.btnBuy.rx.tap
            .subscribe(onNext: {
                let userInfo = ["tradeDerection": "buy", "coin" : self.model.coin ,"currency" : self.model.currency]
                USER_DEFAULTS.setValue(userInfo, forKey: "klineToTrade")
                USER_DEFAULTS.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "yTabBarChangeNotify"), object: nil, userInfo: userInfo)
                self.navigationController?.popViewController(animated: true)

            }).disposed(by: disposeBag)
        
        self.btnSell.rx.tap
            .subscribe(onNext: {
                let userInfo = ["tradeDerection": "sell", "coin" : self.model.coin ,"currency" : self.model.currency]
                USER_DEFAULTS.setValue(userInfo, forKey: "klineToTrade")
                USER_DEFAULTS.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "yTabBarChangeNotify"), object: nil, userInfo: userInfo)
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        self.btnMA.rx.tap
            .subscribe(onNext: {
                //todo 切换指标
                self.mainString = KLINEMA
                self.kLineView.configureView(data: self.viewModel.kLineList, isNew: true, mainDrawString: self.mainString, secondDrawString: self.secondString, dateType: self.dateType, lineType: self.isSelectLine ? .minLineType : .candleLineType)
                self.btnMA.isSelected = true;
                self.btnBOLL.isSelected = false
            }).disposed(by: disposeBag)
        
        self.btnBOLL.rx.tap
            .subscribe(onNext: {
                //todo 切换指标
                self.mainString = KLINEBOLL
                self.kLineView.configureView(data: self.viewModel.kLineList, isNew: true, mainDrawString: self.mainString, secondDrawString: self.secondString, dateType: self.dateType, lineType: self.isSelectLine ? .minLineType : .candleLineType)
                self.btnBOLL.isSelected = true
                self.btnMA.isSelected = false
            }).disposed(by: disposeBag)
        
        self.btnDepth.rx.tap
            .subscribe(onNext: {
                self.btnDepth.isSelected = true
                self.kLineDepthView.isHidden = false
                for button in buttonTimes {
                    button.isSelected = false
                }
            }).disposed(by: disposeBag)
        
        self.btnHorizon.rx.tap
            .subscribe(onNext: {
                
                UIView.animate(withDuration: 0.18, delay: 0.0) {
                    self.horiKline.frame = CGRect(x: 0, y: 0, width: self.horiKline.width, height: self.horiKline.height)
                }
            }).disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(moreTimeClick))
        vMore.addGestureRecognizer(tap)
    }
    
    func updateLike(){
        
        if self.btnStart.isSelected {
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
        }else{
            let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(model.coin)' AND currency = '\(model.currency)'")
            guard let aModel = result.first else {
                return
            }
            RealmHelper.deleteModel(model: aModel)
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        }
    }
    
    func setupDatas() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onIndexUpdateNotifition), name: Notification.Name("KLineIndexUpdateNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDetailViewNotifition), name: Notification.Name("KLineUpdatePositionNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupTimeDatas), name: Notification.Name("KLineLocalTimeNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateKlineShock), name: Notification.Name("KLineSetShockNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateKlineLighter), name: Notification.Name("KLineSetLighterNoti"), object: nil)

        viewModel = MarketsViewModel()
        viewModel.amountDigit = Int(model.amount_digit) ?? 0
        //MARK: 币种详情
        rModel = ReqCoinModel()
        rModel.coin = self.model.coin
        rModel.currency = self.model.currency
        viewModel.reqModel = rModel
        viewModel.requestCoinDetails()
            .subscribe(onNext: {[weak self] model in
                self?.rxModel.onNext(model)
        }).disposed(by: disposeBag)
        
        //获取一次最新的 24ticker
        viewModel.requestTicker24(coin: self.model.coin, currency: self.model.currency).subscribe(onNext: {resp in
            self.result = resp as! Ticker24Model
            self.lblPrice.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: self.result.new_price, digit: self.result.price_digit))
            self.lblPercentage.text = self.addPriceDecimals(value: self.result.ratio, digit: self.result.price_digit) + "%"
            self.lblLow.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: self.result.low_price, digit: self.result.price_digit))
            self.lblHight.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: self.result.high_price, digit: self.result.price_digit))
            let temBtcStr = self.result.deal_num
            let temDou = Double(temBtcStr)
            let temBteResult = String(format: "%.2f", temDou!)
            self.lblVolCoinNum.text = self.addMicrometerLevel(valueSwift: temBteResult) //temBteResult
            self.lblVolUnitNum.text = HSCoinCalculate.calculateCoin(coin:self.result.deal_amt)  //(result[6]))
            self.lblUnitPrice.text = self.addRateSymbol(value: self.result.new_price)
            
            self.currentPrice = self.result.new_price
            if (self.result.ratio_str.hasPrefix("-")) == true {
                self.lblPrice.textColor = UIColor.hexColor(0xF03851)
                self.lblPercentage.textColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblPrice.textColor = UIColor.hexColor(0x02C078)
                self.lblPercentage.textColor = UIColor.hexColor(0x02C078)
            }
            print("获取第一次数据")
        }).disposed(by: disposeBag)
        
        //MARK: 接收推送
//        subscribeCoin()

        //MARK: model变化
        self.rxModel
            .map({ model in
                let rModel = ReqCoinModel()
                rModel.coin = model.coin
                rModel.currency = model.currency
                self.viewModel.reqModel = rModel
                self.lblTitle.text = model.coin + "/" + model.currency
                self.firstLike()
            })
            .flatMap({ value -> Observable<Any> in
                return self.viewModel.requestCoinBuySelllist().catch { error in
                    return Observable.empty()
                }
            })
            .map({ value in
                self.tableBuy.reloadData()
                self.tableSell.reloadData()
            })
            .flatMap({ value -> Observable<Any>  in
                self.dateType = .min
                self.viewModel.reqModel.kline_type = "15m" //读取数据库
                self.btn15m.isSelected = true
                self.vShowLine.isUserInteractionEnabled = false
                return self.viewModel.requestMarketKline().catch { error in
                    return Observable.empty()
                }
            })
            .flatMap({ value -> Observable<Any>  in
                self.vShowLine.isUserInteractionEnabled = true
                self.kLineView.configureView(data: self.viewModel.kLineList, isNew: true, mainDrawString: self.mainString, secondDrawString: self.secondString, dateType: self.dateType, lineType: .candleLineType)
                if self.isSelectNewdeal == true {
                    return self.viewModel.requestNewdeal().catch { error in
                        return Observable.empty()
                    }
                } else{
                    return Observable.just(value)
                }
            })
            .map({ value in
                if self.isSelectNewdeal == true {
                    self.tableNew.reloadData()
                    let h = CGFloat(self.viewModel.newdeals.count) * 20.0
                    if h < SCREEN_HEIGHT {
                        self.showHeight.constant = SCREEN_HEIGHT
                    } else{
                        self.showHeight.constant = h + 60
                    }
                } else{
                    self.tableBuy.reloadData()
                    self.tableSell.reloadData()
                    let h = CGFloat(self.viewModel.buys.count) * 20.0
                    if h < SCREEN_HEIGHT {
                        self.showHeight.constant = SCREEN_HEIGHT
                    } else{
                        self.showHeight.constant = h + 50
                    }
                }
            })
            .subscribe(onNext: { model in
                self.viewModel.websocketKline()
                self.viewModel.websocketBuySell()
                self.viewModel.websocketNewdeal()
            }).disposed(by: disposeBag)
    }
    
    func firstLike(){
        
        if userManager.isLogin {
            viewModel.requestCurrencyLike()
                .subscribe(onNext: { [weak self] model in
                    self!.btnStart.isSelected = false
                    for coinModel in self!.viewModel.accountLike {
                        if(coinModel.coin == self!.model.coin && coinModel.currency == self!.model.currency){
                            self!.btnStart.isSelected = true
                            break
                        }
                    }
                }).disposed(by: disposeBag)
            //首页进来的值有误,行情进来有值判断
//            if model.user_like == 1 {
//                self.btnStart.isSelected = true
//            }else{
//                self.btnStart.isSelected = false
//            }
        }else{
            self.btnStart.isSelected = false
            let array = RealmHelper.queryModel(model: RealmCoinModel())
            for tmp in array {
                if tmp.coin == model.coin && tmp.currency == model.currency {
                    self.btnStart.isSelected = true
                    break
                }
            }
        }
    }
    
    func subscribeCoin(){
        
        viewModel.fiveData.subscribe(onNext: { value in
            self.curSells = self.viewModel.sells
            self.tableBuy.reloadData()
            self.tableSell.reloadData()
            if(!self.kLineDepthView.isHidden){
                self.kLineDepthView.updateShow(coinBuyDatas: self.viewModel.originBuys, coinSellDatas: self.viewModel.originSells)
            }
        }).disposed(by: disposeBag)
        viewModel.newdealData.subscribe(onNext: { value in
            self.tableNew.reloadData()
        }).disposed(by: disposeBag)
        viewModel.kLineData.subscribe(onNext: { value in
//            print("更新KLine图")
            self.kLineView.configureViewNoOffset(data: self.viewModel.kLineList, isNew: true, mainDrawString: self.mainString, secondDrawString: self.secondString, dateType: self.dateType, lineType: self.isSelectLine ? .minLineType : .candleLineType)
        }).disposed(by: disposeBag)
        viewModel.deal24Data.subscribe(onNext: { value in
            let datas = value.data
            
            let lowPrice = self.addPriceDecimals(value: datas[2] as? String ?? "", digit: self.result.price_digit)
            let hightPrice = self.addPriceDecimals(value: datas[3] as? String ?? "", digit: self.result.price_digit)
            self.lblLow.text =  self.addMicrometerLevel(valueSwift: lowPrice)
            self.lblHight.text = self.addMicrometerLevel(valueSwift: hightPrice)
            self.lblVolCoin.text = "24h Vol(" + self.model.coin + ")"
            self.lblVolUnit.text = "24h Vol(" + self.model.currency + ")"
            let temBtcStr = datas[0] as? String
            let temDou = Double(temBtcStr!)
            let temBteResult = String(format: "%.2f", temDou!)
            self.lblVolCoinNum.text = self.addMicrometerLevel(valueSwift: temBteResult)
            self.lblVolUnitNum.text = HSCoinCalculate.calculateCoin(coin: (datas[6] as? String)!)
            self.lblPercentage.text = self.addPriceDecimals(value: datas[5] as? String ?? "", digit: self.result.price_digit) + "%"
            self.lblUnitPrice.text = self.addRateSymbol(value: datas[1] as? String ?? "0")
            if ((datas[5] as? String)?.hasPrefix("-")) == true {
                self.lblPercentage.textColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblPercentage.textColor = UIColor.hexColor(0x02C078)
            }
            
            self.lblPrice.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: datas[1] as? String ?? "0", digit: self.result.price_digit))
            let tmp : Double = Double(self.currentPrice) ?? 0.0
            let tmp1 : Double = Double(datas[1] as? String ?? "") ?? 0.0
            
            
            if tmp > tmp1{
                self.lblPrice.textColor = UIColor.hexColor("F03851",alpha: 0.9)
            }else if tmp < tmp1{
                self.lblPrice.textColor = UIColor.hexColor("02C078",alpha: 0.9)
            }else{
                self.lblPrice.textColor = UIColor.hexColor("FFFFFF",alpha: 0.9)
            }
            self.currentPrice = (datas[1] as? String) ?? ""
        }).disposed(by: disposeBag)
    }
    
    func setupIndexDatas(){
        
        setupMaIndexDatas()
        setupBollIndexDatas()
        setupMACDIndexDatas()
        setupKDJIndexDatas()
        setupRSIIndexDatas()
        updateKlineLighter()
        updateKlineShock()
    }
    @objc func setupTimeDatas(){
        
        let time = UserDefaults.standard.string(forKey: "KLineLocalTimeKey")
        if((time) != nil){
            let times:[String] = (time?.components(separatedBy: ","))!
            let index = Int(times[0])
            let firstMap = self.weekTimes[index!]
            let index2 = Int(times[1])
            let firstMap2 = self.weekTimes[index2!]
            let index3 = Int(times[2])
            let firstMap3 = self.weekTimes[index3!]
            let index4 = Int(times[3])
            let firstMap4 = self.weekTimes[index4!]
            let index5 = Int(times[4])
            let firstMap5 = self.weekTimes[index5!]
            self.btnLine.setTitle(firstMap["title"], for: .normal)
            self.btn15m.setTitle(firstMap2["title"], for: .normal)
            self.btn1h.setTitle(firstMap3["title"], for: .normal)
            self.btn4h.setTitle(firstMap4["title"], for: .normal)
            self.btn1d.setTitle(firstMap5["title"], for: .normal)
            self.defaultWeeks = [firstMap,firstMap2,firstMap3,firstMap4,firstMap5]
        }
    }
    
    @objc func updateKlineShock(){
        
        let defaults = UserDefaults.standard
        guard let shock = defaults.string(forKey: "KLineSetShockKey") else{
            return
        }
        kLineView.isShockShow = (shock == "1") ? true : false
    }
    @objc func updateKlineLighter(){
        
        let defaults = UserDefaults.standard
        guard let lighter = defaults.string(forKey: "KLineSetLighterKey") else{
            return
        }
        kLineView.isLighterShow = (lighter == "1") ? true : false
    }
    func setupMaIndexDatas(){
        
        guard let one = UserDefaults.standard.getItem(MainMAItem.self, forKey: "ma50") else {
                return
        }
        guard let two = UserDefaults.standard.getItem(MainMAItem.self, forKey: "ma51") else {
                return
        }
        guard let three = UserDefaults.standard.getItem(MainMAItem.self, forKey: "ma52") else {
                return
        }
        kLineView.topChartTextLayer.ma5Str = one.maDay
        kLineView.topChartTextLayer.ma10Str = two.maDay
        kLineView.topChartTextLayer.ma30Str = three.maDay
        IndexCalculation.shared.updateIndexValue(index: "MA", maMap: ["one":one.maDay, "two": two.maDay, "three": three.maDay])
        
        kLineView.theme.topTextOneColor = one.dealColor()
        kLineView.theme.topTextTwoColor = two.dealColor()
        kLineView.theme.topTextThreeColor = three.dealColor()
        kLineView.updateKlineColor(newColors: [one.dealColor(), two.dealColor(), three.dealColor()])
        
        let oneLineW:Float = Float(one.maLineWidth)!
        let twoLineW:Float = Float(two.maLineWidth)!
        let threeLineW:Float = Float(three.maLineWidth)!
        kLineView.updateKlineWidth(newLineWidths: [oneLineW, twoLineW, threeLineW])
    }
    func setupBollIndexDatas(){
        
        guard let one = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexBoll0") else {
                return
        }
        guard let two = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexBoll1") else {
                return
        }
        guard let three = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexBoll2") else {
                return
        }
        guard let bollSetting = UserDefaults.standard.getItem(MainBoolItem.self, forKey: "KLineIndexBoll3") else {
                return
        }
        IndexCalculation.shared.updateIndexValue(index: "BOLL", maMap: ["one":bollSetting.cauculateWeek, "two": bollSetting.cauculateWidth])
        kLineView.updateBollKLineColor(newColors: [one.dealColor(), two.dealColor(), three.dealColor()])
        let oneLineW:Float = Float(one.maLineWidth)!
        let twoLineW:Float = Float(two.maLineWidth)!
        let threeLineW:Float = Float(three.maLineWidth)!
        kLineView.updateBollKLineWidth(newLineWidths: [oneLineW, twoLineW, threeLineW])
    }
    func setupMACDIndexDatas(){
        
        guard let one = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexMacd0") else {
                return
        }
        guard let two = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexMacd1") else {
                return
        }
        guard let MACDSetting = UserDefaults.standard.getItem(SecondMACDItem.self, forKey: "KLineIndexMacd2") else {
                return
        }
        kLineView.bottomChartTextLayer.theme.bottomMACDDif = MACDSetting.fastWeek
        kLineView.bottomChartTextLayer.theme.bottomMACDDea = MACDSetting.slowWeek
        kLineView.bottomChartTextLayer.theme.bottomMACDAvg = MACDSetting.avgWeek
        IndexCalculation.shared.updateIndexValue(index: "MACD", maMap: ["one":MACDSetting.fastWeek, "two":MACDSetting.slowWeek, "three":MACDSetting.avgWeek])
        kLineView.updateMACDKLineColor(newColors: [one.dealColor(), two.dealColor()])
        let oneLineW:Float = Float(one.maLineWidth)!
        let twoLineW:Float = Float(two.maLineWidth)!
        kLineView.updateMACDKLineWidth(newLineWidths: [oneLineW,twoLineW])
    }
    func setupKDJIndexDatas(){
        
        guard let one = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexKDJ0") else {
                return
        }
        guard let two = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexKDJ1") else {
                return
        }
        guard let three = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexKDJ2") else {
                return
        }
        guard let KDJSetting = UserDefaults.standard.getItem(SecondKDJItem.self, forKey: "KLineIndexKDJ3") else {
                return
        }
        kLineView.bottomChartTextLayer.theme.bottomKDJk = KDJSetting.calWeek
        kLineView.bottomChartTextLayer.theme.bottomKDJd = KDJSetting.avg1
        kLineView.bottomChartTextLayer.theme.bottomKDJj = KDJSetting.avg2
        IndexCalculation.shared.updateIndexValue(index: "KDJ", maMap: ["one":KDJSetting.calWeek, "two":KDJSetting.avg1, "three":KDJSetting.avg2])
        
        kLineView.updateKDJKLineColor(newColors: [one.dealColor(), two.dealColor(), three.dealColor()])
        let oneLineW:Float = Float(one.maLineWidth)!
        let twoLineW:Float = Float(two.maLineWidth)!
        let threeLineW:Float = Float(three.maLineWidth)!
        kLineView.updateKDJKLineWidth(newLineWidths: [oneLineW,twoLineW,threeLineW])
    }
    func setupRSIIndexDatas(){
        
        guard let one = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexRSI0") else {
                return
        }
        guard let two = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexRSI1") else {
                return
        }
        guard let three = UserDefaults.standard.getItem(MainMAItem.self, forKey: "KLineIndexRSI2") else {
                return
        }
//        kLineView.topChartTextLayer.ma5Str = one.maDay
//        kLineView.topChartTextLayer.ma10Str = two.maDay
//        kLineView.topChartTextLayer.ma30Str = three.maDay
//        IndexCalculation.shared.updateIndexValue(index: "MA", maMap: ["one":one.maDay, "two": two.maDay, "three": three.maDay])
        kLineView.bottomChartTextLayer.theme.bottomRSIR = one.maDay
//        kLineView.theme.topTextTwoColor = two.dealColor()
//        kLineView.theme.topTextThreeColor = three.dealColor()
        kLineView.updateRSIKLineColor(newColors: [one.dealColor()])
//
        let oneLineW:Float = Float(one.maLineWidth)!
//        let twoLineW:Float = Float(two.maLineWidth)!
//        let threeLineW:Float = Float(three.maLineWidth)!
        kLineView.updateRSIKLineWidth(newLineWidths: [oneLineW])
    }
    
    // MARK: - SetupSubviews
    func setupUI() {
        self.lblPrice.font = FONTDIN(size: 32)
        self.indicateView.addSubview(btnMA)
        self.indicateView.addSubview(btnBOLL)
        self.indicateView.addSubview(btnVOL)
        self.indicateView.addSubview(btnMACD)
        self.indicateView.addSubview(btnKDJ)
        self.indicateView.addSubview(btnRSI)
        self.indicateView.addSubview(btnHorizon)
        setupIndicateBtnUI()

        //MARK: 注册cell
        self.tableBuy?.register(UINib(nibName: "BuyShowCell",bundle: nil), forCellReuseIdentifier: "BuyShowCell")
        self.tableSell?.register(UINib(nibName: "SellShowCell",bundle: nil), forCellReuseIdentifier: "SellShowCell")
        self.tableNew?.register(UINib(nibName: "NewdealCell",bundle: nil), forCellReuseIdentifier: "NewdealCell")
        
        self.vShowLine.addSubview(kLineView)
        self.vShowLine.addSubview(kLineDepthView)
        self.vShowLine.superview?.addSubview(detailView)
        self.vShowLine.superview?.addSubview(moreTimeView)
        
        let defaults = UserDefaults.standard
        let klineShowHeight = defaults.float(forKey: "KLineShowHeightKey")
        var vshowLineH = HSWindowAdapter.calculateHeight(input: 355)
        if(klineShowHeight > 0){
            vshowLineH =  HSWindowAdapter.calculateHeight(input: CGFloat(((klineShowHeight + 0.5)/1.0) * 355))
        }
        self.vShowLineHConstrait.constant = vshowLineH
        self.view.addSubview(horiKline)
    }
    func setupIndicateBtnUI(){
        
        let btns = [btnMA,btnBOLL,btnVOL,btnMACD,btnKDJ,btnRSI,btnHorizon]
        let btnw = CGFloat(SCREEN_WIDTH/CGFloat(btns.count))
        var index = 0
        for btn in btns {
            btn.frame = CGRect(x: CGFloat(index) * btnw, y: 0, width: btnw, height: self.indicateView.height)
            if(index > 1){
                btn.tag = 1024+(index-2)
            }
            index += 1
        }
        let lineV = UIView()
        lineV.frame = CGRect(x: btnw * 2, y: 2, width: 1, height: self.indicateView.height - 4)
        lineV.backgroundColor = UIColor.hexColor("2b2b2b")
        self.indicateView.addSubview(lineV)
    }
    
    func updateBtnColor(moreText: String){
        
        self.moreLabel.text = moreText
        self.moreLabel.textColor = .white
        let btns = [self.btnLine, self.btn15m, self.btn1h, self.btn4h, self.btn1d]
        for btn in btns {
            btn?.isSelected = false
        }
    }
    
    lazy var timeWeeks: [[String:String]] = {
        
       let allTimes = [["time":"3分","value":"3m"],["time":"5分","value":"5m"],["time":"30分","value":"30m"],["time":"2小时","value":"2h"],
                        ["time":"6小时","value":"6h"],["time":"8小时","value":"8h"],["time":"12小时","value":"12h"],["time":"3日","value":"3d"],
                        ["time":"周线","value":"1w"],["time":"月线","value":"1M"]]
        return allTimes
    }()
        
    // MARK: - Lazy
    lazy var moreTimeView: KLineMoreTimeV = {
        
        let moreTimeView = KLineMoreTimeV(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        moreTimeView.oriy = Int(self.vShowLine.y)
        moreTimeView.clipsToBounds = true
        moreTimeView.pass = { [weak self] updateValue in
            
            let tipStr = updateValue["time"] as! String
            let klineType = updateValue["value"] as! String
            self!.viewModel.reqModel.kline_type = klineType
            let result: PublishSubject<Any> = self!.viewModel.requestMarketKline()
            result.subscribe(onNext: { model in
                self!.kLineView.configureView(data: self!.viewModel.kLineList, isNew: true, mainDrawString: self!.mainString, secondDrawString: self?.secondString ?? KLINEVOL, dateType: self!.dateType, lineType: self!.isSelectLine ? .minLineType : .candleLineType)
            }).disposed(by: self!.disposeBag)
            self!.updateBtnColor(moreText: tipStr)
        }
        moreTimeView.passW = { [weak self] in
            
            var temWeeks = [String]()
            for tem in self!.defaultWeeks{
                temWeeks.append(tem["time"]!)
            }
            let weekVC = getViewController(name: "KlineTargetStoryboard", identifier: "KlineWeekDayController") as! KlineWeekDayController
            weekVC.viewModel.curWeeks = temWeeks
            self?.navigationController?.pushViewController(weekVC, animated: true)
        }
        return moreTimeView
    }()
    
    lazy var kLineView: XLKLineView = {
        
        let defaults = UserDefaults.standard
        let klineShowHeight = defaults.float(forKey: "KLineShowHeightKey")
        var vshowLineH = HSWindowAdapter.calculateHeight(input: 355)
        if(klineShowHeight > 0 && klineShowHeight != nil){
            vshowLineH =  HSWindowAdapter.calculateHeight(input: CGFloat(((klineShowHeight + 0.5)/1.0) * 355))
        }
        let kLineView = XLKLineView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: vshowLineH))
        kLineView.backgroundColor = UIColor.xlChart.color(rgba: "#1E1E1E")
        kLineView.kLineViewDelegate = self
        return kLineView
    }()
    lazy var detailView: XLCrossDetailView = {
        
        let klinePosition = UserDefaults.standard.string(forKey: "KLineIndexPosition")
        var detailViewY = self.vShowLine.y - 70
        if(klinePosition == "0"){
            detailViewY = self.vShowLine.y + 20
        }
        let detailView = XLCrossDetailView(frame: CGRect(x: 0, y: detailViewY, width: SCREEN_WIDTH, height: 70))
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickDetail))
        detailView.addGestureRecognizer(tap)
        detailView.alpha = 0
        detailView.updateShow(isVerticl: (detailViewY < self.vShowLine.y) ? false:true)
        detailView.addCorner(conrners: .allCorners, radius: 6)
        return detailView
    }()
    lazy var kLineDepthView: KDepthView = {
        let defaults = UserDefaults.standard
        let klineShowHeight = defaults.float(forKey: "KLineShowHeightKey")
        var vshowLineH = HSWindowAdapter.calculateHeight(input: 355)
        if(klineShowHeight > 0){
            vshowLineH =  HSWindowAdapter.calculateHeight(input: CGFloat(((klineShowHeight + 0.5)/1.0) * 355))
        }
        let kLineDepthV = KDepthView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: vshowLineH))
        kLineDepthV.isHidden = true
        return kLineDepthV
    }()
    
    lazy var horiKline: KLineHoriView = {
        let horiV = KLineHoriView()
        horiV.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: self.view.width, height: self.view.height)
        horiV.clipsToBounds = true
        horiV.updateWebFrame()
        return horiV
    }()
    
    lazy var btnMA: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("MA", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.isSelected = true
        return btn
    }()
    
    lazy var btnBOLL: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("BOLL", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        return btn
    }()
    
    lazy var btnVOL: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("VOL", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.isSelected = true
        return btn
    }()
    
    lazy var btnMACD: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("MACD", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        return btn
    }()
    
    lazy var btnKDJ: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("KDJ", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        return btn
    }()
    
    lazy var btnRSI: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("RSI", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        return btn
    }()
    
    lazy var btnHorizon: UIButton = {
        let btn = UIButton(type: .custom)
//        btn.setTitle("横", for: .normal)
        btn.setImage(UIImage.init(named: "CoinDetailExpand"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        return btn
    }()
    
    lazy var weekTimes: [[String: String]] = {
        let items: [[String: String]] = [["title":"分时", "time":"1m"],
                                         ["title":"3分", "time":"3m"],
                                         ["title":"5分", "time":"5m"],
                                         ["title":"15分", "time":"15m"],
                                         ["title":"30分", "time":"30m"],
                                         ["title":"1小时", "time":"1h"],
                                         ["title":"2小时", "time":"2h"],
                                         ["title":"4小时", "time":"4h"],
                                         ["title":"6小时", "time":"6h"],
                                         ["title":"8小时", "time":"8h"],
                                         ["title":"12小时", "time":"12h"],
                                         ["title":"1日", "time":"1d"],
                                         ["title":"3日", "time":"3d"],
                                         ["title":"1周", "time":"1w"],
                                         ["title":"1月", "time":"1M"]]
        return items
    }()
    lazy var defaultWeeks: [[String: String]] = {
        let defaultTimes: [[String: String]] = [["title":"分时", "time":"1m"],
                                         ["title":"15分", "time":"15m"],
                                         ["title":"1小时", "time":"1h"],
                                         ["title":"4小时", "time":"4h"],
                                         ["title":"1d", "time":"1d"]]
        return defaultTimes
    }()
}
extension KlineDealController: XLKLineViewProtocol {
    func XLKLineViewLoadMore() {
        //print("加载更多....")
    }
    
    func XLKLineViewHideCrossDetail() {
        //print("隐藏十字线")
        self.setupCrossDetailHide(hide: true)
    }
    
    func XLKLineViewLongPress(model: XLKLineModel, preClose: CGFloat) {
//        print("长按显示")
        self.detailView.bind(model: model, preClose: preClose)
        self.setupCrossDetailHide(hide: false)
    }
    
    func XLKLineViewLongPress(model: XLKLineModel, preClose: CGFloat, point: CGPoint) {
        
        if(detailView.y > vShowLine.y){
            //vertical
            let updateX = (point.x > (SCREEN_WIDTH*0.5)) ? 10 : (SCREEN_WIDTH - detailView.width - 10)
            detailView.x = updateX
        }else{
            detailView.x = 0
        }
    }
}
