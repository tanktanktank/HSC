//
//  CoinTradeOperationView.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/6/7.
//

import UIKit
import RxSwift

let TradeViewLeftMargin = 8

class CoinTradeOperationView: UIView {
    
    enum CalculateBtnType {
    
        case price
        case amount
        case total
        case market
    }
    
    enum OrderType : Int {
    
        case limit = 0 //限价
        case market = 1//市场
        case StopLossTakeProfit = 2 // 止盈止损
    }
    let rowHeight = 21
    var rowNumber = 5 {
        
        didSet{
            
            self.marketsViewModel.numberOfRow = rowNumber
        }
    }
    
    private var disposeBag = DisposeBag()
    var reqModel = ReqTradeModel() // 下单model
    var coinModel = CoinModel()
    var marketsViewModel = MarketsViewModel() // 市场model 包括买卖盘等
    var tradeModel = TradeViewModel()

//    private var balancePushModel = PublishSubject<SymbolAssetModel>()
    var coinPushModel = PublishSubject<CoinModel>()
    var updateUnit = PublishSubject<String>()
    var selectCurrentPrice = PublishSubject<String>()
    var updateCurrentPrice = PublishSubject<PushCoinModel>()
    var updatePercentage = PublishSubject<(type: Int, num: String)>()

    var pushClosure: (()->())?  // 跳转
    var placeOrder : (()->())? // 下单 closure
    var showSheet : ((Array<Any>)->())? // 显示档位closure
    var changeOrderType : ((OrderType)->())? // 显示档位closure

    @objc func loginSuccess(notify : Notification){

        self.updateView()
    }
    @objc func changeLangage(notify : Notification){

        let isBuy = self.isBuy
        self.isBuy = isBuy
        self.updateUnit.onNext("update")
        buyBtn.setTitle("tv_trade_buy".localized(), for: .normal)
        sellBtn.setTitle("tv_trade_sell".localized(), for: .normal)
        self.avaiLabel.titleStr = "tv_trade_avail".localized()
        let index = self.orderBtn.selectIndex
        self.orderBtn.dataSource = ["tv_trade_limit_order".localized(),"tv_market_order".localized(),"tv_stop_profit_stop_loss".localized()]
        self.orderBtn.title = self.orderBtn.dataSource[index]
        priceInputView.maskLabel.text =  "Trade_MarketPirce".localized()
        marketAmountInputView.changeLanguage()
    }

    
    var balanceModel : SymbolAssetModel? {
        
        didSet{
            calculateMaxBuy()
        }
    }
    
    lazy var orderType : OrderType = .limit {
        
        didSet{
            
            changeOrderType?(orderType)
            clearAmount()
            clearMarket()
            textFieldResignFirstResponder()
            switch orderType {
            case .limit:
                self.rowNumber = 5
                self.triggerPriceInputView.isHidden = true
                self.totalInputView.isHidden = false
                self.priceInputView.inputType = .nomal
                self.reqModel.order_type = "1"
                self.marketAmountInputView.isHidden = true
                self.amountInputView.isHidden = false
                setNewPrice()

                self.priceInputView.snp.remakeConstraints { make in

                    make.left.right.equalTo(selectView)
                    make.height.equalTo(36)
                    make.top.equalTo(selectView.snp.bottom).offset(10)
                }
                self.amountInputView.snp.remakeConstraints { make in

                    make.left.height.right.equalTo(priceInputView)
                    make.top.equalTo(self.priceInputView.snp.bottom).offset(10)
                }
                self.selectPercentView.snp.remakeConstraints { make in

                    make.left.right.equalTo(selectView)
                    make.top.equalTo(amountInputView.snp.bottom)
                    make.height.equalTo(50)
                }
                self.avaiLabel.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-20)
                    make.left.equalToSuperview()
                    make.top.equalTo(totalInputView.snp.bottom).offset(5)
                    make.height.equalTo(30)
                }
            case .market:
                self.rowNumber = 5
                self.triggerPriceInputView.isHidden = true
                self.totalInputView.isHidden = true
                self.priceInputView.inputType = .marketPrice
                self.reqModel.order_type = "3"
                self.marketAmountInputView.isHidden = false
                self.amountInputView.isHidden = true
                setNewPrice()
                
                marketAmountInputView.snp.makeConstraints { make in
                    
                    make.left.right.equalTo(selectView)
                    make.height.equalTo(36)
                    make.top.equalTo(priceInputView.snp.bottom).offset(10)
                }

                
                self.priceInputView.snp.remakeConstraints { make in

                    make.left.right.equalTo(selectView)
                    make.height.equalTo(36)
                    make.top.equalTo(selectView.snp.bottom).offset(10)
                }
                self.marketAmountInputView.snp.remakeConstraints { make in

                    make.left.right.equalTo(priceInputView)
                    make.height.equalTo(61)
                    make.top.equalTo(priceInputView.snp.bottom).offset(10)
                }
                self.selectPercentView.snp.remakeConstraints { make in

                    make.left.right.equalTo(priceInputView)
                    make.top.equalTo(marketAmountInputView.snp.bottom)
                    make.height.equalTo(50)
                }
                self.avaiLabel.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-20)
                    make.left.equalToSuperview()
                    make.top.equalTo(selectPercentView.snp.bottom).offset(5)
                    make.height.equalTo(30)
                }
                print("market")
            case .StopLossTakeProfit:
                self.rowNumber = 6
                self.triggerPriceInputView.isHidden = false
                self.totalInputView.isHidden = false
                self.priceInputView.inputType = .nomal
                self.reqModel.order_type = "2"
                clearPrice()
                self.marketAmountInputView.isHidden = true
                self.amountInputView.isHidden = false

                self.triggerPriceInputView.snp.remakeConstraints { make in

                    make.left.right.equalTo(selectView)
                    make.height.equalTo(36)
                    make.top.equalTo(selectView.snp.bottom).offset(10)
                }
                self.priceInputView.snp.remakeConstraints { make in

                    make.left.height.right.equalTo(triggerPriceInputView)
                    make.top.equalTo(triggerPriceInputView.snp.bottom).offset(10)
                }
                self.amountInputView.snp.remakeConstraints { make in

                    make.left.height.right.equalTo(triggerPriceInputView)
                    make.top.equalTo(priceInputView.snp.bottom).offset(10)
                }

                self.selectPercentView.snp.remakeConstraints { make in

                    make.left.right.equalTo(selectView)
                    make.top.equalTo(amountInputView.snp.bottom)
                    make.height.equalTo(50)
                }
                self.avaiLabel.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-20)
                    make.left.equalToSuperview()
                    make.top.equalTo(totalInputView.snp.bottom).offset(8)
                    make.height.equalTo(30)
                }
                print("StopLossTakeProfit")
            }
            topTableView.snp.updateConstraints { make in
                
                make.height.equalTo(rowHeight * rowNumber)
            }

            bottomTableView.snp.updateConstraints { make in
                
                make.height.equalTo(rowHeight * rowNumber)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: LoginSuccessNotification, object: nil)

        setLeftView()
        setLeftConstraints()
        setRightView()
        setRightConstraints()
        
        if !userManager.isLogin {
                        
            self.calculateMaxBuy()
            self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
        }
        //MARK: model变化
        self.coinPushModel
            .subscribe(onNext: { aModel in
                print("币种：\(aModel.coin) 市场：\(aModel.currency)")
                
                self.coinModel = aModel
                self.updateUnit.onNext("update")
                self.selectCurrentPrice.onNext(aModel.new_price)
                let priceModel = PushCoinModel()
                priceModel.currency = aModel.currency
                priceModel.coin = aModel.coin
                priceModel.new_price = aModel.new_price
                priceModel.isFall = aModel.isFall
                priceModel.ratio_str = aModel.ratio_str
                self.marketsViewModel.amountDigit = Int(aModel.amount_digit) ?? 0
                
                self.triggerPriceInputView.digit = Int(aModel.price_digit) ?? 0
                self.priceInputView.digit = Int(aModel.price_digit) ?? 0
                self.amountInputView.digit = Int(aModel.amount_digit) ?? 0
                self.marketAmountInputView.coin_digit = Int(aModel.amount_digit) ?? 0
                self.marketAmountInputView.currency_digit = Int(aModel.price_digit) ?? 0
                self.totalInputView.digit = Int(aModel.price_digit) ?? 0
                
                self.reqModel.coin = aModel.coin
                self.reqModel.currency = aModel.currency
                self.reqModel.poundage = aModel.buy_commission

                self.updateCurrentPrice.onNext(priceModel)
                self.marketsViewModel.isTrade = true
                self.marketsViewModel.reqModel.coin = aModel.coin
                self.marketsViewModel.reqModel.currency  = aModel.currency
                self.marketsViewModel.websocketBuySell()
                
                //更新买卖盘
                self.marketsViewModel.requestCoinBuySelllist()
                    .subscribe(onNext: { model in

                        self.topTableView.reloadData()
                        self.bottomTableView.reloadData()

                    }).disposed(by: self.disposeBag)
                
            }).disposed(by: disposeBag)
        
        marketsViewModel.isTrade = true
        //MARK: 推送
        marketsViewModel.fiveData.subscribe(onNext: { value in
            
            self.topTableView.reloadData()
            self.bottomTableView.reloadData()
            if let theValue : (type: Int, num: String) = value as? (type: Int, num: String) {
                
                self.updatePercentage.onNext( theValue)
            }
        }).disposed(by: disposeBag)

        WSCoinPushSing.sharedInstance().tradeDatas
            .subscribe(onNext: { value in
                if self.coinModel.coin == value.coin &&
                    self.coinModel.currency == value.currency {
                    
                    self.updateCurrentPrice.onNext(value)
                }
        })
        .disposed(by: disposeBag)
        
        self.selectPercentView.percentChangedClosure = {
            [weak self] value  in
            
            self?.calculatePercent(value)
        }
    }
    
    func updateView()  {
        
        if userManager.isLogin {
                    
            if self.buyBtn.isSelected {
                
                self.buyBtn.sendActions(for: .touchUpInside)
            }else{
                
                self.sellBtn.sendActions(for: .touchUpInside)
            }
            
        }else{
            
            self.calculateMaxBuy()
            self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
        }
    }
        
     // MARK:  左边
    let leftView = UIView()

    //  精度按钮
    lazy var gearBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("--", for: .normal)
        btn.titleLabel?.font = FONTR(size: 14)
        btn.setTitleColor(UIColor.hexColor("999999"), for: .normal)
        
        btn.titleLabel?.snp.makeConstraints({ make in
            
            make.right.greaterThanOrEqualTo(-30)
        })
        
        btn.rx.tap.subscribe { _ in
            
            self.showSheet?(self.marketsViewModel.gears)
        } onError: { Error in
            
        }.disposed(by: self.disposeBag)

        self.marketsViewModel.gearChange.subscribe { gear in
            
            btn.setTitle(gear ?? "--", for: .normal)
        }.disposed(by: self.disposeBag)

        return btn
    }()
        
    //分割线
    lazy var separateLineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .hexColor("363636")
        return lineView
    }()
    //头部titleview
    lazy var addTableHeaderView : UIView = {
        let headerView = UIView()

        let priceLabel = UILabel()
        priceLabel.text = String(format: "%@\n(--)", "Trade_Pirce".localized())
        priceLabel.textColor = .hexColor("989898")
        priceLabel.numberOfLines = 2
        priceLabel.font = FONTR(size: 12)
        headerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            
            make.left.bottom.equalTo(headerView)
            make.top.equalToSuperview().offset(10)
        }
        let amountLabel = UILabel()
        amountLabel.text = String(format: "%@\n(--)", "Trade_Amount".localized())
        amountLabel.textColor = .hexColor("989898")
        amountLabel.numberOfLines = 2
        amountLabel.font = FONTR(size: 12)
        amountLabel.textAlignment = .right
        headerView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            
            make.right.bottom.equalTo(headerView)
            make.top.equalToSuperview().offset(10)
        }
        
        self.updateUnit.subscribe { _ in
            
            priceLabel.text = String(format: "%@\n(%@)", "Trade_Pirce".localized(),self.coinModel.currency)
            amountLabel.text = String(format: "%@\n(%@)", "Trade_Amount".localized(),self.coinModel.coin)
//            priceLabel.text = "Pirce\n(\(self.coinModel.currency))"
//            amountLabel.text = "Amount\n(\(self.coinModel.coin))"
        }.disposed(by: disposeBag)
        
        return headerView
    }()
    //卖盘table
    lazy var topTableView : BaseTableView = {
        
        let tableView = BaseTableView()
        tableView.backgroundColor = .hexColor("1E1E1E")
        tableView.register(UINib(nibName: "TradeShowCell",bundle: nil), forCellReuseIdentifier: "TradeShowCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 21
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tag = 1
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1);
        return tableView
    }()
    
    var prePrice = "0"
    //中间marketPrice
    lazy var centerView: UIButton = {
        
        let view = UIButton()
        let priceLabel = UILabel()
        priceLabel.text = "--"
        priceLabel.font = FONTDIN(size: 16)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .hexColor("02C078")
        view.addSubview(priceLabel)
        
        let approximateLabel = UILabel()
        approximateLabel.text = "≈ $ --"
        approximateLabel.textAlignment = .center
        approximateLabel.font = FONTDIN(size: 12)
        approximateLabel.textColor = .hexColor("989898")
        view.addSubview(approximateLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        approximateLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        //MARK: 当前推送价格
        
        var currentPrice = ""
        
        
        view.rx.tap.subscribe { [weak self] _ in
         
            if self?.reqModel.order_type != "3" {

                self?.selectCurrentPrice.onNext(currentPrice)
            }
        }.disposed(by: disposeBag)
        
        
        self.updateCurrentPrice.subscribe {[self] model in
            
            
            if self.prePrice.toDouble() > model.new_price.toDouble(){
                
                priceLabel.textColor = .hexColor("F03851" , alpha: 0.9)
            }else if  self.prePrice.toDouble() < model.new_price.toDouble(){
                
                priceLabel.textColor = .hexColor("02C078" , alpha: 0.9)

            }else{
                
                priceLabel.textColor = .hexColor("ffffff" , alpha:0.9)
            }
            
            let price = preciseDecimal(x: "\(model.new_price)", p: (Int(self.coinModel.price_digit) ?? 0))
            currentPrice = price
            priceLabel.text = self.addMicrometerLevel(valueSwift: price)

            let ratePrice = self.addRateTwoDecimalsSymbol(value: model.new_price)
            approximateLabel.text = "≈\( ratePrice)"
            
            self.prePrice = model.new_price

        } onError: { Error in
            
        }.disposed(by: self.disposeBag)

        return view
    }()
    //买盘table
    lazy var bottomTableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .hexColor("1E1E1E")
        tableView.register(UINib(nibName: "TradeShowCell",bundle: nil), forCellReuseIdentifier: "TradeShowCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 20
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tag = 2
        return tableView

    }()
    //分割线
    lazy var separateLineView2 : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .hexColor("363636")
        return lineView
    }()
    //买卖百分比
    lazy var percentageView : UIView = {
        let view = UIView()
        
        let leftView = UIView()
        leftView.backgroundColor = .hexColor("2EBC88", alpha: 0.2)
        view.addSubview(leftView)
        
        let rightView = UIView()
        rightView.backgroundColor = .hexColor("FF4E4F", alpha: 0.2)
        view.addSubview(rightView)

        leftView.snp.makeConstraints { make in
            
            make.left.top.bottom.equalToSuperview()
        }

        rightView.snp.makeConstraints { make in
            
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(leftView.snp.right)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        leftLabel.textColor = .hexColor("2EBC88")
        rightLabel.textColor = .hexColor("FF4E4F")
        leftLabel.font = FONTDIN(size: 12)
        rightLabel.font = FONTDIN(size: 12)
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        rightLabel.textAlignment = .right
        
        var buyNumber = "50"
        var sellNumber = "50"
        leftLabel.text = "--%"
        rightLabel.text = "--%"
        
        leftLabel.snp.makeConstraints { make in
            
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
        }

        rightLabel.snp.makeConstraints { make in
            
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
        }
        view.corner(cornerRadius: 14)
        
        
        
        self.updatePercentage.subscribe { value in
            
            if value.type == 9 {
                
                buyNumber = value.num
            }else{
                
                sellNumber = value.num
                
                let buyDouble = Double(buyNumber) ?? 1
                let sellDouble = Double(sellNumber) ?? 1
                
                let sellPercent = sellDouble / (buyDouble + sellDouble)
                
                leftLabel.text = String(format: "%.2f%@",(1-sellPercent)*100,"%")
                rightLabel.text = String(format: "%.2f%@", sellPercent*100,"%")

                rightView.snp.remakeConstraints{ make in
                    
                    make.right.top.bottom.equalToSuperview()
                    make.left.equalTo(leftView.snp.right)
                    make.width.equalToSuperview().multipliedBy(sellPercent)
                }

            }

        } onError: { Error in
            
        } onCompleted: {
            
        }.disposed(by: self.disposeBag)

        return view
    }()
    
    // MARK: 右边
    let rightView = UIView()

    var isBuy = true {
        
        didSet{
            
            if isBuy{
                
                self.reqModel.buy_type = "1"
                self.reqModel.poundage = self.coinModel.buy_commission
                self.comfirmBtn.setBackgroundImage(UIImage.getImageWithColor(color: .hexColor("02C078")), for: .normal)
                self.maxLabel.titleStr = "Trade_Max_Buy".localized()
                if userManager.isLogin {
                            
                    self.comfirmBtn.setTitle("tv_trade_buy".localized(), for: .normal)
                }else{
                    self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
                }
            }else{
                
                self.reqModel.buy_type = "2"
                self.reqModel.poundage = self.coinModel.sell_commission
                self.comfirmBtn.setBackgroundImage(UIImage.getImageWithColor(color: .hexColor("F03851")), for: .normal)
                self.maxLabel.titleStr = "Trade_Max_Sell".localized()
                if userManager.isLogin {
                            
                    self.comfirmBtn.setTitle("tv_trade_sell".localized(), for: .normal)
                }else{
                    self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
                }

            }
            
            if self.orderType == .StopLossTakeProfit{
                
                clearPrice()
                clearTriggerPrice()
            }else{
                
                setNewPrice()
            }
            
            self.selectPercentView.isBuy = isBuy
            self.buyBtn.isSelected = isBuy
            self.sellBtn.isSelected = !isBuy
            self.clearSelectPercent()
            self.calculateMaxBuy()
            self.clearAmount()
            self.clearMarket()
        }
    }

    lazy var buyBtn : UIButton = {
        
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "leftbuy1"), for: .normal)
        button.setBackgroundImage(UIImage(named: "leftbuy2"), for: .selected)
        button.setTitle("tv_trade_buy".localized(), for: .normal)
        button.setTitleColor(UIColor.hexColor("989898"), for:.normal)
        button.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for:.selected)
        button.rx.tap.subscribe { _ in
            
            if userManager.isLogin {
                        
                self.comfirmBtn.setTitle("tv_trade_buy".localized(), for: .normal)
            }else{
                self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
            }
            
            if !button.isSelected{

                self.isBuy = true
            }
        } .disposed(by: disposeBag)
        return button
    }()
    
    lazy var sellBtn : UIButton = {
        
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "rightsell1"), for: .normal)
        button.setBackgroundImage(UIImage(named: "rightsell2"), for: .selected)
        button.setTitleColor(UIColor.hexColor("989898"), for:.normal)
        button.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for:.selected)
        button.setTitle("tv_trade_sell".localized(), for: .normal)
        button.rx.tap.subscribe { _ in
            
            if userManager.isLogin {
                        
                self.comfirmBtn.setTitle("tv_trade_sell".localized(), for: .normal)
            }else{
                self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
            }

            if !button.isSelected{
                
                self.isBuy = false
            }
        } .disposed(by: disposeBag)
        return button
    }()
    
    //选择交易类型
    var orderBtn  = WLOptionView(frame: .zero, type: .normal)

    lazy var selectView : TradeInputBaseView = {
        
        let view = TradeInputBaseView()

        orderBtn.isHaveDistance = true
        orderBtn.dataSource = ["tv_trade_limit_order".localized(),"tv_market_order".localized(),"tv_stop_profit_stop_loss".localized()]
        orderBtn.title = "tv_trade_limit_order".localized()
        orderBtn.cornerRadius = 4
        orderBtn.cellHeight = 40
        orderBtn.textAligment = .left
        orderBtn.titleLabel.font = FONTR(size: 12)
        orderBtn.animationTime = 0.1
        orderBtn.selectedCallBack {[weak self] (viewTemp, index) in
            self?.orderBtn.selectIndex = index

            switch index {
            case 0: self?.orderType = .limit
            case 1: self?.orderType = .market
            case 2: self?.orderType = .StopLossTakeProfit
            default:
                break
            }
            
            print("\(index)")
        }

        view.addSubview(orderBtn)
        orderBtn.snp.makeConstraints { make in
            
            make.right.left.top.bottom.equalToSuperview()
        }
        
        let infoBtn = UIButton()
        infoBtn.setImage(UIImage(named: "about"), for: .normal)
        orderBtn.addSubview(infoBtn)
        infoBtn.snp.makeConstraints { make in
            
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(25)
        }
        
        infoBtn.imageView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.width.equalTo(11)
        })

        orderBtn.rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
            make.width.equalTo(10)
        }


        return view
    }()
    
    lazy var triggerPriceInputView : TradeInputView = {
        
        let placeholder = "tv_trigger_price".localized()
        let view = TradeInputView()
        view.inputTextField.placeholder = placeholder
        view.inputTextField.text = ""
        view.inputTextField.tag = 0
        self.updateUnit.subscribe { _ in
            
            view.placeholder = "tv_trigger_price".localized() + "(\(self.coinModel.currency))"
        }.disposed(by: disposeBag)
        

        return view
    }()

    lazy var priceInputView : TradeInputView = {
        
        let placeholder = "tv_entrust_price".localized()
        let view = TradeInputView()
        view.inputTextField.placeholder = placeholder
        view.inputTextField.text = ""
        view.inputTextField.tag = 1

        self.updateUnit.subscribe { _ in
            
            view.placeholder = "tv_entrust_price".localized() + "(\(self.coinModel.currency))"
        }.disposed(by: disposeBag)
        
        self.selectCurrentPrice.subscribe { value in
            
            view.text = value
            view.inputTextField.sendActions(for: .allEditingEvents)
        } onError: { Error in
            
        } onCompleted: {
            
        }.disposed(by: disposeBag)

        return view
    }()

    lazy var amountInputView : TradeInputView = {
        
        let placeholder = "tv_trade_amount".localized()
        let view = TradeInputView()
        view.inputTextField.placeholder = placeholder
        view.inputTextField.tag = 2

        self.updateUnit.subscribe { _ in
            
            view.placeholder = "tv_trade_amount".localized() + "(\(self.coinModel.coin))"

        }.disposed(by: disposeBag)

        return view
    }()
    
    lazy var marketAmountInputView : TradeMarketAmountInputView = {
        
        let view = TradeMarketAmountInputView()
        view.inputTextField.tag = 2

        self.updateUnit.subscribe { _ in
            
            view.placeHolderCoin =  (self.coinModel.coin)
            view.placeHolderCurrency =  (self.coinModel.currency)

        }.disposed(by: disposeBag)

        return view
    }()

    
    lazy var totalInputView : TradeInputView = {
        let placeholder = "tv_trade_order_total".localized()
        let view = TradeInputView()
        view.inputTextField.placeholder = "Total"
        view.inputTextField.tag = 3
        self.updateUnit.subscribe { _ in
            view.placeholder = "tv_trade_order_total".localized() + "(\(self.coinModel.currency))"
        }.disposed(by: disposeBag)

        return view
    }()

    var selectPercentView = SelectPercentView()
    
    let avaiLabel : InfoLabel = {
        
        let label = InfoLabel()
        label.titleStr = "tv_trade_avail".localized()
        label.valueStr = "-- --"
        return label
    }()
    
    let maxLabel : InfoLabel = {
        
        let label = InfoLabel()
        label.titleStr = "tv_trade_max_buy".localized()
        label.valueStr = "-- --"
        return label
    }()

    let addBtn : UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "buyadd"), for: .normal)
        return button

    }()
    
    lazy var comfirmBtn : UIButton = {
        
        let  button = UIButton()
        button.corner(cornerRadius: 3)
        button.rx.tap.subscribe { [weak self] _ in
            
            if userManager.isLogin {
                 
                self?.placeOrder?()
            }else{
                
                self?.pushClosure?()
            }
        } .disposed(by: disposeBag)
        
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CoinTradeOperationView{
    
    func setLeftView(){
        
        self.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            
            make.left.top.bottom.equalToSuperview()
            
//            if let width = superview?.snp.width 
            
            make.width.equalTo(175)
        }

        leftView.addSubview(gearBtn)
        leftView.addSubview(separateLineView)
        leftView.addSubview(addTableHeaderView)
        leftView.addSubview(topTableView)
        leftView.addSubview(centerView)
        leftView.addSubview(bottomTableView)
        leftView.addSubview(separateLineView2)
        leftView.addSubview(percentageView)

    }
        
    func setLeftConstraints(){
        
        gearBtn.snp.makeConstraints { make in
            
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(LR_Margin)
            make.height.equalTo(35)
            make.width.greaterThanOrEqualTo(35)
        }
        
//        gearBtn.backgroundColor = .red
        
        let iconImage = UIImageView(image: UIImage(named: "mdown"))
//        btn.addSubview(iconImage)
        leftView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.left.equalTo(gearBtn.snp.right).offset(2)
            make.centerY.equalTo(gearBtn)
            make.width.height.equalTo(10)
        }

        
        separateLineView.snp.makeConstraints { make in
            
            make.left.equalTo(10)
            make.right.equalTo(-15)
            make.height.equalTo(1)
            make.top.equalTo(gearBtn.snp.bottom)
        }
        
        addTableHeaderView.snp.makeConstraints { make in
            
            make.left.right.equalTo(separateLineView)
            make.top.equalTo(separateLineView.snp.bottom)
            make.height.equalTo(42)
        }
        
        topTableView.snp.makeConstraints { make in
            
            make.top.equalTo(addTableHeaderView.snp.bottom)
            make.left.right.equalTo(separateLineView)
            make.height.equalTo(rowHeight * rowNumber)
        }
        
        centerView.snp.makeConstraints { make in
            
            make.top.equalTo(topTableView.snp.bottom)
            make.left.right.equalTo(separateLineView)
            make.height.equalTo(40)
        }

        bottomTableView.snp.makeConstraints { make in
            
            make.top.equalTo(centerView.snp.bottom)
            make.left.right.equalTo(separateLineView)
            make.height.equalTo(rowHeight * rowNumber)
        }
        
        separateLineView2.snp.makeConstraints { make in
            
            make.left.width.height.equalTo(separateLineView)
            make.top.equalTo(bottomTableView.snp.bottom).offset(10)
        }
        
        percentageView.snp.makeConstraints { make in
            
            make.top.equalTo(separateLineView2.snp.bottom).offset(10)
            make.left.right.equalTo(separateLineView)
            make.height.equalTo(28)
        }
    }
}

extension CoinTradeOperationView{
    
    func setRightView(){
        
        self.addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.left.equalTo(leftView.snp.right)
            make.right.equalToSuperview().offset(-14)
            make.top.bottom.equalToSuperview()
        }

        rightView.addSubview(buyBtn)
        rightView.addSubview(sellBtn)
        rightView.addSubview(selectView)
        addInputView()
        rightView.addSubview(selectPercentView)

        rightView.addSubview(avaiLabel)
        rightView.addSubview(maxLabel)
        rightView.addSubview(addBtn)
        rightView.addSubview(comfirmBtn)
        
        self.buyBtn.sendActions(for: .touchUpInside)
    }
    
    func addInputView()  {
        
        rightView.addSubview(triggerPriceInputView)
        rightView.addSubview(priceInputView)
        rightView.addSubview(amountInputView)
        rightView.addSubview(marketAmountInputView)
        rightView.addSubview(totalInputView)
        
        triggerPriceInputView.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext: {

                print("triggerPriceInputView 输入的是：\(self.triggerPriceInputView.text)")
                
                self.reqModel.trigger_price = self.triggerPriceInputView.text.count > 0 ? self.triggerPriceInputView.text : "0"
            })
            .disposed(by: disposeBag)

        
        priceInputView.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext: {

                print("priceInputView 输入的是：\(self.priceInputView.text)")
                self.calculatePriceAndTotal(type: .price , value: self.priceInputView.text)
            })
            .disposed(by: disposeBag)
        
        amountInputView.inputTextField.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: {
                
//                if $0 == ""{
//                    return
//                }
                print("amountInputView 输入的是：")
            self.clearSelectPercent()
            self.calculatePriceAndTotal(type: .amount , value: self.amountInputView.text)
            })
            .disposed(by: disposeBag)
        
        marketAmountInputView.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext: {
                self.clearSelectPercent()
                print("marketAmountInputView 输入的是：\(self.marketAmountInputView.text)")
                self.calculatePriceAndTotal(type: .market , value: self.marketAmountInputView.text)
            })
            .disposed(by: disposeBag)

        totalInputView.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext: {
                      
                print("totalInputView 输入的是：\(self.totalInputView.text)")
                self.calculatePriceAndTotal(type: .total , value: self.totalInputView.text)
            })
            .disposed(by: disposeBag)
    }
    
    func setRightConstraints(){

        buyBtn.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.5).offset(4)
        }
        sellBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.top.height.width.equalTo(buyBtn)
        }
        selectView.snp.makeConstraints { make in

            make.left.right.equalToSuperview()
            make.top.equalTo(buyBtn.snp.bottom).offset(14)
            make.height.equalTo(25)
        }
        triggerPriceInputView.isHidden = true
        triggerPriceInputView.snp.makeConstraints { make in
         
            make.left.right.equalTo(selectView)
            make.height.equalTo(36)
            make.top.equalTo(selectView.snp.bottom).offset(10)
        }

        priceInputView.snp.makeConstraints { make in
         
            make.left.right.equalTo(selectView)
            make.height.equalTo(36)
            make.top.equalTo(selectView.snp.bottom).offset(10)
        }
        amountInputView.snp.makeConstraints { make in
            
            make.left.right.equalTo(selectView)
            make.height.equalTo(36)
            make.top.equalTo(priceInputView.snp.bottom).offset(10)
        }
        
        marketAmountInputView.snp.makeConstraints { make in
            
            make.left.right.equalTo(selectView)
            make.height.equalTo(36)
            make.top.equalTo(priceInputView.snp.bottom).offset(10)
        }
        marketAmountInputView.isHidden = true
        
        selectPercentView.snp.makeConstraints { make in
            
            make.left.right.equalTo(selectView)
            make.top.equalTo(amountInputView.snp.bottom)
            make.height.equalTo(50)
        }

        totalInputView.snp.makeConstraints { make in
            
            make.left.right.equalTo(selectView)
            make.height.equalTo(36)
            make.top.equalTo(selectPercentView.snp.bottom)
        }
        
        avaiLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview()
            make.top.equalTo(totalInputView.snp.bottom).offset(4)
            make.height.equalTo(30)
        }
        addBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalTo(avaiLabel)
        }

        maxLabel.snp.makeConstraints { make in
         
            make.left.right.equalToSuperview()
            make.top.equalTo(avaiLabel.snp.bottom)
            make.height.equalTo(30)
        }
        comfirmBtn.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}


extension CoinTradeOperationView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableView.tag {
        case 1:
            return  self.marketsViewModel.sells.count 
        case 2:
            return self.marketsViewModel.buys.count
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TradeShowCell = tableView.dequeueReusableCell(withIdentifier: "TradeShowCell") as! TradeShowCell
        
        if tableView.tag == 1 {
            cell.type = false
            cell.datas = (self.marketsViewModel.sells[indexPath.row] as! Array<String>)
            cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        } else{
            cell.type = true
//            if(indexPath.row < self.marketsViewModel.buys.count ){
                cell.datas = (self.marketsViewModel.buys[indexPath.row] as! Array<String>)
//            }else{
//                cell.datas = (self.marketsViewModel.originBuys[indexPath.row] as! Array<String>)
//            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textFieldResignFirstResponder()

        if self.reqModel.order_type != "3" {
            
            switch tableView.tag {
            case 1:
                let datas = (self.marketsViewModel.sells[indexPath.row] as! Array<String>)
                selectCurrentPrice.onNext(datas[0] )
                
            case 2:
                let datas = (self.marketsViewModel.buys[indexPath.row] as! Array<String>)
                selectCurrentPrice.onNext(datas[0])
            default:
                print("点击")
            }
        }
    }
}
    
//TextField操作
extension CoinTradeOperationView {
   
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        if textField.tag != 0 {
//
//            self.clearSelectPercent()
//        }
//        return true
//    }
//
    
    func textFieldResignFirstResponder() {
        priceInputView.inputTextField.resignFirstResponder()
        amountInputView.inputTextField.resignFirstResponder()
        totalInputView.inputTextField.resignFirstResponder()
        triggerPriceInputView.inputTextField.resignFirstResponder()
        marketAmountInputView.inputTextField.resignFirstResponder()
    }
}

//TextField操作
extension CoinTradeOperationView  {
   
    //MARK: 计算可买数量
    func calculateMaxBuy(){
        
        if buyBtn.isSelected {

//            self.maxLabel.isHidden = false
//
            if let model = self.balanceModel {
                
                self.avaiLabel.valueStr =  model.currency_num + " " + "USDT"

                if  let priceDecimal = Decimal(string: self.priceInputView.text)  ,  let availDecimal = Decimal(string: model.currency_num) {
                        
                    let maxDecimal : Decimal = availDecimal / priceDecimal
                    let formatter = NumberFormatter()
                    formatter.roundingMode = .down

                    formatter.maximumFractionDigits = Int(self.coinModel.amount_digit) ?? 0
                    self.maxLabel.valueStr = formatter.string(from: maxDecimal as NSNumber)! + " " + self.coinModel.coin
                }else{
                    
                    self.maxLabel.valueStr = "--"
                }

            }else {
                self.avaiLabel.valueStr = ""
                self.maxLabel.valueStr = ""
            }
            
        }else{
            
//            self.maxLabel.isHidden = true

            if let model = self.balanceModel {
                
                self.avaiLabel.valueStr = model.coin_num + " " + self.coinModel.coin
                
                if  let priceDecimal = Decimal(string: self.priceInputView.text)  ,  let availDecimal = Decimal(string: model.coin_num) {
                    
                    let maxDecimal : Decimal = availDecimal * priceDecimal
                    let formatter = NumberFormatter()
                    formatter.roundingMode = .down
//                        formatter.maximumFractionDigits = 6
                    formatter.maximumFractionDigits = Int(self.coinModel.price_digit) ?? 0
                    self.maxLabel.valueStr = formatter.string(from: maxDecimal as NSNumber)! + " " + self.coinModel.currency
                }else{
                    
                    self.maxLabel.valueStr = "--"
                }

                
            }else{
                
                self.avaiLabel.valueStr = ""
                self.maxLabel.valueStr = "--"
            }
        }
    }
    
    //MARK: 修改数量
    func calculatePriceAndTotal(type : CalculateBtnType , value : String){
           //buy
        switch type {
        case .price:
            print("")
            
            if let amountDecimal = Decimal(string: self.amountInputView.text) , let priceDecimal = Decimal(string: value){
                
                let totalDecimal : Decimal = priceDecimal * amountDecimal
                let formatter = NumberFormatter()
                formatter.roundingMode = .down
                formatter.maximumFractionDigits = Int(coinModel.price_digit) ?? 0

                self.totalInputView.text = formatter.string(from: totalDecimal as NSNumber) ?? ""
            }else{
               
                self.totalInputView.text = ""
            }
            self.calculateMaxBuy()

        case .amount:
            
                if let priceDecimal = Decimal(string: self.priceInputView.text) , let amountDecimal = Decimal(string: value){
                    
                    let totalDecimal : Decimal = priceDecimal * amountDecimal
                    
                    let formatter = NumberFormatter()
                    formatter.roundingMode = .down
                    formatter.maximumFractionDigits = Int(coinModel.price_digit) ?? 0

                    self.totalInputView.text = formatter.string(from: totalDecimal as NSNumber) ?? ""
                  
                    if isBuy {
                        
                        if self.totalInputView.text.toDouble() > self.balanceModel?.currency_num.toDouble() ?? 0 {
                            
                            HudManager.showOnlyText("超出可用余额".localized())
                        }
                    }else{
                        
                        if self.amountInputView.text.toDouble() > self.balanceModel?.coin_num.toDouble() ?? 0 {
                            
                            HudManager.showOnlyText("超出可用余额".localized())
                        }
                    }

                    
                }else{
                    
                    self.totalInputView.text = ""
                }
        case .total:

            if let priceDecimal = Decimal(string: self.priceInputView.text) , let totalDecimal = Decimal(string: value){
                
                let amoutDecimal : Decimal = totalDecimal / priceDecimal

                let formatter = NumberFormatter()
                formatter.roundingMode = .down
                formatter.maximumFractionDigits = Int(coinModel.amount_digit) ?? 0

                self.amountInputView.text = formatter.string(from: amoutDecimal as NSNumber) ?? ""
                
                if isBuy {
                    
                    if self.totalInputView.text.toDouble() > self.balanceModel?.currency_num.toDouble() ?? 0 {
                        
                        HudManager.showOnlyText("超出可用余额".localized())
                    }
                }else{
                    
                    if self.amountInputView.text.toDouble() > self.balanceModel?.coin_num.toDouble() ?? 0 {
                        
                        HudManager.showOnlyText("超出可用余额".localized())
                    }
                }
            }else{
                
                self.amountInputView.text = ""
            }
        case .market:
            
            if self.marketAmountInputView.isAmountSelected {
                
                if let priceDecimal = Decimal(string: self.priceInputView.text) , let amountDecimal = Decimal(string: value){
                    
                    let totalDecimal : Decimal = priceDecimal * amountDecimal
                    
                    let formatter = NumberFormatter()
                    formatter.roundingMode = .down
                    formatter.maximumFractionDigits =  self.marketAmountInputView.currency_digit

                    self.marketAmountInputView.amountStr = value
                    self.marketAmountInputView.totalStr = formatter.string(from: totalDecimal as NSNumber) ?? ""
                    
                    
                    if isBuy {
                        self.reqModel.num = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"
                        self.reqModel.total = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"

                        if self.marketAmountInputView.totalStr.toDouble() > self.balanceModel?.currency_num.toDouble() ?? 0{
                            
                            HudManager.showOnlyText("超出可用余额".localized())
                        }
                    }else{
                        
                        self.reqModel.num = self.marketAmountInputView.amountStr.count > 0 ? self.marketAmountInputView.amountStr : "0"
                        self.reqModel.total = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"

                        if self.marketAmountInputView.amountStr.toDouble() > self.balanceModel?.coin_num.toDouble() ?? 0 {
                            
                            HudManager.showOnlyText("超出可用余额".localized())
                        }
                    }
                }else{
                    
                    self.totalInputView.text = ""
                    self.reqModel.num = "0"
                    self.reqModel.total = "0"
                }
            }else{
                
                if let priceDecimal = Decimal(string: self.priceInputView.text) , let totalDecimal = Decimal(string: value){
                    
                    let amoutDecimal : Decimal = totalDecimal / priceDecimal

                    let formatter = NumberFormatter()
                    formatter.roundingMode = .down
                    formatter.maximumFractionDigits =  self.marketAmountInputView.coin_digit

                    self.marketAmountInputView.amountStr = formatter.string(from: amoutDecimal as NSNumber) ?? ""
                    self.marketAmountInputView.totalStr = value
                    
                    
                    if isBuy {
                        
                        self.reqModel.num = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"
                        self.reqModel.total = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"

                        if self.marketAmountInputView.totalStr.toDouble() > self.balanceModel?.currency_num.toDouble() ?? 0{
                            
                            HudManager.showOnlyText("超出可用余额".localized())
                        }
                    }else{
                        self.reqModel.num = self.marketAmountInputView.amountStr.count > 0 ? self.marketAmountInputView.amountStr : "0"
                        self.reqModel.total = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"

                        if self.marketAmountInputView.amountStr.toDouble() > self.balanceModel?.coin_num.toDouble() ?? 0 {
                            
                            HudManager.showOnlyText("超出可用余额".localized())
                        }
                    }

                }else{
                    
                    self.amountInputView.text = ""
                    self.reqModel.num = "0"
                    self.reqModel.total = "0"

                }
            }
        }
        if orderType != .market {
            
            self.reqModel.price = self.priceInputView.text.count > 0 ? self.priceInputView.text : "0"
            self.reqModel.num = self.amountInputView.text.count > 0 ? self.amountInputView.text : "0"
            self.reqModel.total = self.totalInputView.text.count  > 0 ? self.totalInputView.text : "0"

        }
    }
    //MARK: 计算百分比点击处理
    func calculatePercent(_ selectedPercent : Int){
        
        textFieldResignFirstResponder()
        if buyBtn.isSelected  {
            
            if self.orderType == .market{ //市场计算
                
                if (self.balanceModel != nil), let balanceDecimal = Decimal(string: self.balanceModel?.currency_num ?? "0") , selectedPercent > 0 , let balance = Double(self.balanceModel?.currency_num ?? "0"), balance > 0{

                    
                    let priceDecimal = Decimal(string: self.priceInputView.text) ?? Decimal(1)
                    
                    let percentDecimal = Decimal(selectedPercent)
                    let totalDecimal : Decimal = balanceDecimal * percentDecimal / Decimal(100.0)
                    let amoutDecimal : Decimal = totalDecimal / priceDecimal
                    
                    let formatter1 = NumberFormatter()
                    formatter1.roundingMode = .down
                    formatter1.maximumFractionDigits =  self.marketAmountInputView.coin_digit
                   
                    let formatter2 = NumberFormatter()
                    formatter2.roundingMode = .down
                    formatter2.maximumFractionDigits =  self.marketAmountInputView.currency_digit

                    self.marketAmountInputView.amountStr = formatter1.string(from: amoutDecimal as NSNumber) ?? ""
                    self.marketAmountInputView.totalStr =  formatter2.string(from: totalDecimal as NSNumber) ?? ""
                    self.reqModel.num = self.marketAmountInputView.totalStr.count > 0 ? self.marketAmountInputView.totalStr : "0"
                    self.reqModel.total = self.marketAmountInputView.totalStr.count  > 0 ? self.marketAmountInputView.totalStr : "0"

                }else {
                    
                    clearMarket()
                }

            }else{
                
                if (self.balanceModel != nil), let balanceDecimal = Decimal(string: self.balanceModel?.currency_num ?? "0") , selectedPercent > 0 , let balance = Double(self.balanceModel?.currency_num  ?? "0"), balance > 0{

                    let percentDecimal = Decimal(selectedPercent)
                    let totalDecimal : Decimal = balanceDecimal * percentDecimal / Decimal(100.0)
                     
                    
                    let formatter1 = NumberFormatter()
                    formatter1.roundingMode = .down
                    formatter1.maximumFractionDigits =  Int(self.coinModel.price_digit) ?? 0
                    let total  = formatter1.string(from: totalDecimal as NSNumber) ?? ""

                    self.totalInputView.text = "\(total)"
                    self.totalInputView.inputTextField.sendActions(for: .allEditingEvents)
                }else {
                    
                    clearTotal()
                }
            }
        }else{
            if self.orderType == .market{ //市场计算
                
                if (self.balanceModel != nil), let balanceDecimal = Decimal(string: self.balanceModel?.coin_num ?? "0") , selectedPercent > 0 ,let balance = Double(self.balanceModel?.currency_num ?? "0") , balance > 0{

                    let priceDecimal = Decimal(string: self.priceInputView.text) ?? Decimal(1)
                    
                    let percentDecimal = Decimal(selectedPercent)
                    let amoutDecimal : Decimal = balanceDecimal * percentDecimal / Decimal(100.0)
                    let totalDecimal : Decimal = amoutDecimal * priceDecimal
                    
                    let formatter1 = NumberFormatter()
                    formatter1.roundingMode = .down
                    formatter1.maximumFractionDigits =  self.marketAmountInputView.coin_digit
                   
                    let formatter2 = NumberFormatter()
                    formatter2.roundingMode = .down
                    formatter2.maximumFractionDigits =  self.marketAmountInputView.currency_digit

                    self.marketAmountInputView.amountStr = formatter1.string(from: amoutDecimal as NSNumber) ?? ""
                    self.marketAmountInputView.totalStr =  formatter1.string(from: totalDecimal as NSNumber) ?? ""
                    self.reqModel.num = self.marketAmountInputView.amountStr.count > 0 ? self.marketAmountInputView.amountStr : "0"
                    self.reqModel.total = self.marketAmountInputView.totalStr.count  > 0 ? self.marketAmountInputView.totalStr : "0"

                } else {
                    
                    clearMarket()
                }

            }else{

                if (self.balanceModel != nil), let balanceDecimal = Decimal(string: self.balanceModel?.coin_num ?? "0") , selectedPercent > 0 ,let balance = Double(self.balanceModel?.currency_num ?? "0") , balance > 0{

                    let percentDecimal = Decimal(selectedPercent)
                    let amountDecimal : Decimal = balanceDecimal * percentDecimal / Decimal(100.0)
                             
                    let formatter1 = NumberFormatter()
                    formatter1.roundingMode = .down

                    formatter1.maximumFractionDigits =  Int(self.coinModel.amount_digit) ?? 0
                    let amount  = formatter1.string(from: amountDecimal as NSNumber) ?? ""

                    
                    self.amountInputView.text = "\(amount)"
                    self.amountInputView.inputTextField.sendActions(for: .allEditingEvents)
                } else {
                    
                    clearAmount()
                }
            }
        }
    }
    
    func clearSelectPercent()  {
        
        self.selectPercentView.isClearSelect = true
    }
    
    func clearTotal()  {
        
        self.totalInputView.text = ""
        self.totalInputView.inputTextField.sendActions(for: .allEditingEvents)
    }
    
    func clearAmount()  {
        
        self.amountInputView.text = ""
        self.reqModel.num = ""
        self.amountInputView.inputTextField.sendActions(for: .allEditingEvents)
    }
    
    func clearMarket()  {
        
        self.marketAmountInputView.amountStr = ""
        self.marketAmountInputView.totalStr = ""
        self.marketAmountInputView.inputTextField.sendActions(for: .allEditingEvents)
        self.reqModel.num = ""
    }
    
    //设置最新价
    func setNewPrice() {
        
        self.centerView.sendActions(for: .touchUpInside)
    }

    func clearPrice() {
        
        self.priceInputView.text = ""
        self.reqModel.price = ""
    }

    func clearTriggerPrice() {
        
        self.triggerPriceInputView.text = ""
        self.reqModel.trigger_price = ""
    }

}

