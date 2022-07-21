//
//  HSCoinDetailVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/5.
//

import UIKit

class HSCoinDetailVC: BaseViewController {

    ///传递进来的币
    var model : CoinModel!
    ///币数据获取
    var viewModel: MarketsViewModel!
    var coinSocket: HSSocketManager!
    var price_digit: String = "2"
    var curSelectTime = "15m"
    var isAgreement = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupContraints()
        setupData()
        reqData()
        subscribeCoin()
        setupEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: 1, height: 1182)
    }
    override func viewDidLayoutSubviews() {
        
        //TODO: 被QMUI  循环调用 了，，，优化,,,scrollView的 contentSize 也被修改了
//        print("viewDidLayoutSubviews")
    }
    
    
    func setupEvent(){
        
    }
    
    func subscribeCoin(){
        
        coinSocket.deal24Data.subscribe(onNext: {[weak self] value in
            let datas = value.data
            let tickerM = Ticker24Model()
            tickerM.new_price = datas[1] as? String ?? "0"
            tickerM.ratio = datas[5] as? String ?? "0"
            tickerM.price_digit = self?.price_digit ?? "0"
            tickerM.coin = self?.model.coin ?? "--"
            tickerM.currency = self?.model.currency ?? "--"
            tickerM.high_price = datas[3] as? String ?? ""
            tickerM.low_price = datas[2] as? String ?? ""
            tickerM.deal_num = datas[0] as? String ?? ""
            tickerM.deal_amt = datas[6] as? String ?? ""
            self?.scHeaderView.tickerM = tickerM
        }).disposed(by: disposeBag)
        coinSocket.newdealData.subscribe(onNext: {[weak self] value in
            
            self!.scBottomView.latests = self!.coinSocket.latestDeals
            self!.scBottomView.update(type: 2)
            print("newdealData update")
        }).disposed(by: disposeBag)
        coinSocket.kLineData.subscribe(onNext: {[weak self] value in
            print("更新KLine图 新版")
            self!.scContentView.noOffset = true
            self!.scContentView.kLineList = self!.coinSocket.kLineList
        }).disposed(by: disposeBag)
        coinSocket.fiveData.subscribe(onNext: {[weak self] value in
            
            let typeStr = value as! String
            if(typeStr.contains(find: "type=9")){
                self!.scBottomView.buys = self!.coinSocket.buys
                self!.scBottomView.update(type: 0)
            }else if(typeStr.contains(find: "type=11")){
                self!.scBottomView.sells = self!.coinSocket.sells
                self!.scBottomView.update(type: 1)
            }
            self!.scContentView.depthBuys = self!.coinSocket.originBuys
            self!.scContentView.depthSells = self!.coinSocket.originSells
            if(self!.scContentView.isShowDepth){
                self!.scContentView.updateDeppth()
            }
            print("fiveDatafiveData")
        }).disposed(by: disposeBag)
    }

    func setupData(){
                
        self.coinTitleView.titleLab.text = self.model.coin + "/" + self.model.currency
    }
    
    func reqData(){
        
        coinSocket = HSSocketManager()
        viewModel = MarketsViewModel()
        viewModel.amountDigit = Int(model.amount_digit) ?? 0
        //获取一次最新的 24ticker
        viewModel.requestTicker24(coin: self.model.coin, currency: self.model.currency).subscribe(onNext: {[weak self] resp in
            let tickerM = resp as! Ticker24Model
            self!.price_digit = tickerM.price_digit
            self!.scHeaderView.tickerM = tickerM
        }).disposed(by: disposeBag)
        
        scContentView.noOffset = false
        //kline_type 进来默认15分钟
        let reqCoinM = ReqCoinModel()
        reqCoinM.coin = self.model.coin
        reqCoinM.currency = self.model.currency
        reqCoinM.kline_type = self.curSelectTime
        coinSocket.requestMarketKline(reqM: reqCoinM).subscribe(onNext: {[weak self] resp in
            self!.scContentView.kLineList = self!.coinSocket.kLineList
        }).disposed(by: disposeBag)
        
        let reqBSCoinM = ReqCoinModel()
        reqBSCoinM.coin = self.model.coin
        reqBSCoinM.currency = self.model.currency
        coinSocket.requestCoinBuySelllist(reqM: reqBSCoinM).subscribe(onNext: {[weak self] resp in
            
            self!.scBottomView.buys = self!.coinSocket.buys
            self!.scBottomView.sells = self!.coinSocket.sells
            self!.scBottomView.update(type: 3)
            
            self!.scContentView.depthBuys = self!.coinSocket.originBuys
            self!.scContentView.depthSells = self!.coinSocket.originSells
            print("requestCoinBuySelllist result")
        }).disposed(by: disposeBag)
        
        let reqLatestCoinM = ReqCoinModel()
        reqLatestCoinM.coin = self.model.coin
        reqLatestCoinM.currency = self.model.currency
        coinSocket.requestNewdeal(reqM: reqLatestCoinM).subscribe(onNext: {[weak self] resp in
            
            self!.scBottomView.latests = self!.coinSocket.latestDeals
            self!.scBottomView.update(type: 2)
            print("requestNewdeal result")
        }).disposed(by: disposeBag)
        
        var coins = [model.coin + "-" + model.currency]
        var coinMap = [String: Any]()
        coinMap["op"] = "sub"
        coinMap["channel"] = coins
        coinSocket.hqSocketActuals()
        coinSocket.reqHQActuals(update: coinMap) //最新成交+24小时成交推送
        coins = ["five" + model.coin + "-" + model.currency]
        coinMap["channel"] = coins
        coinSocket.reqHQActuals(update: coinMap) //买卖5深度推送
        coins = [model.coin + "-" + model.currency + "-" + self.curSelectTime]
        coinMap["channel"] = coins
        coinSocket.reqHQActuals(update: coinMap) //kline推送 {"op":"sub","channel":["TRX-USDT-1m"]}
//        coinSocket.websocketNewdeal(coin: model.coin, currency: model.currency)
//        coinSocket.websocketKline(coin: model.coin, currency: model.currency, kline_type: self.curSelectTime)
//        coinSocket.websocketBuySell(coin: model.coin, currency: model.currency)
        
        firstLike()
    }
    
    func firstLike(){
        
        if userManager.isLogin {
            viewModel.requestCurrencyLike()
                .subscribe(onNext: { [weak self] model in
                    if(self != nil){
                        var isSelected = false
                        for coinModel in self!.viewModel.accountLike {
                            if(coinModel.coin == self!.model.coin && coinModel.currency == self!.model.currency){
                                isSelected = true
                                break
                            }
                        }
                        self!.coinTitleView.collectBtn.isSelected = isSelected
                    }
                }).disposed(by: disposeBag)
        }else{
            
            var isSelected = false
            let array = RealmHelper.queryModel(model: RealmCoinModel())
            for tmp in array {
                if tmp.coin == self.model.coin && tmp.currency == self.model.currency {
                    isSelected = true
                    break
                }
            }
            self.coinTitleView.collectBtn.isSelected = isSelected
            //TODO: 优化确定， realm 查询方式 ，，，异步查询，跨线程查询，不同线程对象共享
//            DispatchQueue.global().async{ [weak self] in
//                var isSelected = false
//                let array = RealmHelper.queryModel(model: RealmCoinModel())
//                for tmp in array {
//                    if tmp.coin == self!.model.coin && tmp.currency == self!.model.currency {
//                        isSelected = true
//                        break
//                    }
//                }
//                DispatchQueue.main.async{ [weak self] in
//                    self!.coinTitleView.collectBtn.isSelected = isSelected
//                }
//            }
        }
    }
    
    
    func showLeft(){
        
        let tradeQuoteView = TradeQuotesView.loadTradeQuotesView(view: self.view.window!)
        tradeQuoteView.dataSubject.subscribe(onNext: {[weak self] value in
            
            self?.model.coin = value.coin
            self?.model.currency = value.currency
            self?.reqData()
            self?.setupData()
            //TODO: 会不会导致重复订阅 测试确定？
            self?.subscribeCoin()
            print("onNext 调用")
        }).disposed(by: disposeBag)
    }
    
    func updateCoinLike(){
        
        if(userManager.isLogin){
            let coinLikeM = ReqCoinModel()
            coinLikeM.coin = self.model.coin
            coinLikeM.currency = self.model.currency
            viewModel.reqUpdateAccountLike(reqM: coinLikeM).subscribe(onNext: { [weak self] model in
                
                self!.coinTitleView.collectBtn.isSelected = !self!.coinTitleView.collectBtn.isSelected
                self!.showLikeTip()
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }).disposed(by: disposeBag)
        }else{
            coinTitleView.collectBtn.isSelected = !coinTitleView.collectBtn.isSelected
            updateLike()
            showLikeTip()
        }
    }
    func updateLike(){
        
        if self.coinTitleView.collectBtn.isSelected {
            let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(model.coin)' AND currency = '\(model.currency)'")
            guard result.first != nil else {
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
    func showLikeTip(){
        if(self.coinTitleView.collectBtn.isSelected){
            HSToast.showToast(message: "添加自选成功" as NSString, aLocationStr: "bottom", aShowTime: 1.5)
        }else{
            HSToast.showToast(message: "取消自选成功" as NSString, aLocationStr: "bottom", aShowTime: 1.5)
        }
    }
    
    
    func updateKlineTime(time: String){
        
        let reqCoinM = ReqCoinModel()
        reqCoinM.coin = self.model.coin
        reqCoinM.currency = self.model.currency
        reqCoinM.kline_type = time
        HudManager.show()
        scContentView.noOffset = false
        coinSocket.requestMarketKline(reqM: reqCoinM).subscribe(onNext: {[weak self] resp in
            HudManager.dismissHUD()
            self!.scContentView.kLineList = self!.coinSocket.kLineList
        }).disposed(by: disposeBag)
        
        var coins = [model.coin + "-" + model.currency + "-" + self.curSelectTime]
        var coinMap = [String: Any]()
        coinMap["op"] = "unsub"
        coinMap["channel"] = coins
        coinSocket.reqHQActuals(update: coinMap)
        coins = [model.coin + "-" + model.currency + "-" + time]
        coinMap["op"] = "sub"
        coinMap["channel"] = coins
        coinSocket.reqHQActuals(update: coinMap)
        self.curSelectTime = time
//        coinSocket.websocketKline(coin: model.coin, currency: model.currency, kline_type: time)
    }
    func updateKlineIndicate(indicate: String){
        
    }
    
    func updateTimeBtnState(moreText: String){
        
        self.scContentView.moreBtn.setTitle(moreText, for: .normal)
        self.scContentView.moreBtn.setTitleColor(.white, for: .normal)
        self.scContentView.updateTimeBtnState()
        self.scContentView.updateDepthState(isSelect: false)
    }
    
    func showKlineHorizon(isShow: Bool){
        
        if(isShow){
            self.horiKline.model = self.model
            self.horiKline.curMain = "MA"
            self.horiKline.selectSeconds = ["VOL"]
            self.horiKline.curTime = "15m"
            UIView.transition(from: backGroundV, to: horiKline, duration: 0.8, options: .transitionFlipFromLeft) {finished in
            }
        }else{
            UIView.transition(from: horiKline, to: backGroundV, duration: 0.8, options: .transitionFlipFromLeft) {[weak self] finished in
                self?.scrollView.contentSize = CGSize(width: 1, height: 1182)
            }
        }
    }
    
    func showKlineTool(){
        
        let top = CGFloat(138 - self.scrollView.contentOffset.y) //(is_iPhoneXSeries() ? 44 : 20) + 44  【NavigationMenuShared 高度从 导航栏底部开始】
        let items: [String] = ["index".localized(),"chart_height".localized(),"line_drawing_tool".localized(),"tv_home_moudle_more".localized()]
        let imgSource: [String] = ["kshowtaget","kshowheight","kshowreactl","kshowmore"]
        NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: 114, height: 164, point: CGPoint(x: ScreenInfo.Width - 30, y: top), item: items, imgSource: imgSource) {[weak self] (index) in
            switch index {
                case 0:do{
                    self?.navigationController?.pushViewController(getViewController(name: "KlineStoryboard", identifier: "KlineTargetController"), animated: true)
                }
                    break
                case 1:do{
                    let changeHeightVC:KlineHeightController = getViewController(name: "KlineStoryboard", identifier: "KlineHeightController") as! KlineHeightController
                    changeHeightVC.pass = { [weak self] update in
                        
//                        let updateHeight = update * 355
//                        self?.vShowLineHConstrait.constant = HSWindowAdapter.calculateHeight(input: updateHeight)
//                        self?.kLineDepthView.height = HSWindowAdapter.calculateHeight(input: updateHeight)
//                        self?.kLineView.height = updateHeight
//                        self?.kLineDepthView.updateLineViewFrame()
//                        self?.kLineView.scrollView.frame = (self!.kLineView.bounds)
                    }
                    self?.navigationController?.pushViewController(changeHeightVC, animated: true)
                }
                    break
                case 2:do{
                    
                }
                    break
                case 3:do{
                    self?.navigationController?.pushViewController(getViewController(name: "KlineStoryboard", identifier: "KlineSetController"), animated: true)
                }
                    break
            default:
                break
            }
        }
    }
    
    func setupUI(){
        view.addSubview(horiKline)
        view.addSubview(backGroundV)
        backGroundV.addSubview(coinTitleView)
        backGroundV.addSubview(scrollView)
        backGroundV.addSubview(bottomView)
        backGroundV.addSubview(coinMoreTimeV)
        scrollView.addSubview(scHeaderView)
        scrollView.addSubview(scContentView)
        scrollView.addSubview(scBottomView)
        scBottomView.isAgreement = self.isAgreement
        scHeaderView.isAgreement = self.isAgreement
    }
    
    func setupContraints(){
        
        coinTitleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(is_iPhoneXSeries() ? 44 : 20)
            make.height.equalTo(44)
        }
        
        scHeaderView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalTo(view.width)
            make.height.equalTo(97)
        }
        scContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scHeaderView.snp.bottom)
            make.height.equalTo(420)//40(时间行)+25(ma指标行)+355(k线)
        }
        scBottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scContentView.snp.bottom)
            make.height.equalTo(492) //48+  364 + 80
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(84)
        }
        
        coinMoreTimeV.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        scrollView.frame = CGRect(x: 0, y: (is_iPhoneXSeries() ? 44 : 20) + 44, width: SCREEN_WIDTH, height: view.height)
        //97+420+412 +84 = 1013 + 84 = 1097
        // 被QMUI 在 didlayout 修改了 contentsize
//        scrollView.contentSize = CGSize(width: 1, height: 1013)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    

    lazy var coinMoreTimeV: HSCoinMoreTimeV = {
        
        let view = HSCoinMoreTimeV()
        view.pass = { [weak self] updateValue in
            
            let tipStr = updateValue["time"]!
            let klineType = updateValue["value"]!
            self?.updateKlineTime(time: klineType )
            self?.updateTimeBtnState(moreText: tipStr)
        }
        view.passW = { [weak self] in
                        
            var temWeeks = [String]()
            for tem in self!.defaultWeeks{
                temWeeks.append(tem["time"]!)
            }
            let weekVC = getViewController(name: "KlineTargetStoryboard", identifier: "KlineWeekDayController") as! KlineWeekDayController
            weekVC.viewModel.curWeeks = temWeeks
            self?.navigationController?.pushViewController(weekVC, animated: true)
        }
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var scHeaderView: HSCoinHeaderView = {
        
        let view = HSCoinHeaderView()
        return view
    }()
    
    lazy var scContentView: HSCoinContentView = {
        
        let view = HSCoinContentView()
        view.passKline = {[weak self] value in
            
            if(value["type"] == "time"){
                self?.updateKlineTime(time: value["time"] ?? "")
            }else if(value["type"] == "MoreTime"){
                if(self!.scContentView.moreBtn.isSelected){
                    self!.coinMoreTimeV.hide()
                    self!.coinMoreTimeV.snp.updateConstraints { make in
                        make.top.equalToSuperview()
                    }
                }else{
                    self!.coinMoreTimeV.snp.updateConstraints { make in
                        make.top.equalToSuperview().offset(-self!.scrollView.contentOffset.y)
                    }
                    self!.coinMoreTimeV.show()
                }
            }else if(value["type"] == "Deepth"){
                
            }else if(value["type"] == "Horizon"){
                self!.showKlineHorizon(isShow: true)
            }else if(value["type"] == "KlineTool"){
                self!.showKlineTool()
            }
        }
        return view
    }()
    
    lazy var scBottomView: HSCoinSCBottomV = {
        
        let view = HSCoinSCBottomV.init(agreement: self.isAgreement)
        return view
    }()
    
    lazy var bottomView: HSCoinBottomView = {
        
        let view = HSCoinBottomView()
        return view
    }()
    
    lazy var coinTitleView: HSCoinTitleView = {
       
        let view = HSCoinTitleView()
        view.pass = {[weak self] value in
            if(value == 0){
                self?.navigationController?.popViewController(animated: true)
            }else if(value == 2){
                self?.updateCoinLike()
            }else if(value == 1){
                self?.showLeft()
            }
        }
        return view
    }()
    
    lazy var horiKline: KLineHoriView = {
        let horiV = KLineHoriView()
        horiV.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: self.view.width, height: self.view.height)
        horiV.clipsToBounds = true
        horiV.model = self.model
        horiV.updateWebFrame()
        horiV.x = 0
        horiV.pass = {[weak self] value in
            self?.showKlineHorizon(isShow: false)
        }
        return horiV
    }()
    
    lazy var backGroundV: UIView = {
        
        let view = UIView()
        view.frame = self.view.bounds
        view.backgroundColor = .hexColor("1E1E1E")
        view.tag = 1024
        return view
    }()
    
    lazy var defaultWeeks: [[String: String]] = {
        let defaultTimes: [[String: String]] = [["title":"分时", "time":"1m"],
                                         ["title":"15分", "time":"15m"],
                                         ["title":"1小时", "time":"1h"],
                                         ["title":"4小时", "time":"4h"],
                                         ["title":"日线", "time":"1d"]]
        return defaultTimes
    }()
    
    private var disposeBag = DisposeBag()
}
