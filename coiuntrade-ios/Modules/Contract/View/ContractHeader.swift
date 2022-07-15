//
//  ContractHeader.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/12.
//

import UIKit
import RxSwift
private let margin = 15
class ContractHeader: UIView {

    let disposeBag = DisposeBag()
    let tables = SBTableAndCenterView()
    let countDownView = CountdownView()
    var marketsViewModel = MarketsViewModel() // 市场model 包括买卖盘等
    var rowNumber = 5 {
        
        didSet{
            
            self.marketsViewModel.numberOfRow = rowNumber
        }
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        setUI()
        addEvent()
        subscribSocket()
        rowNumber = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let warehouseBtn = DinOptionView(type: .btnType)
    fileprivate let marginBtn = DinOptionView(type: .normal)
    fileprivate let typeBtn = DinOptionView(type: .normal)

    let leftView = UIView()
    let rightView = UIView()

    lazy var buyBtn : UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = FONTM(size: 14)
        button.setBackgroundImage(UIImage(named: "leftbuy1"), for: .normal)
        button.setBackgroundImage(UIImage(named: "leftbuy2"), for: .selected)
        button.setTitle("tv_trade_buy".localized(), for: .normal)
        button.setTitleColor(UIColor.hexColor("989898"), for:.normal)
        button.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for:.selected)
        button.rx.tap.subscribe { _ in
            
//            if userManager.isLogin {
//
//                self.comfirmBtn.setTitle("tv_trade_buy".localized(), for: .normal)
//            }else{
//                self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
//            }
//
//            if !button.isSelected{
//
//                self.isBuy = true
//            }
        } .disposed(by: disposeBag)
        return button
    }()
    
    lazy var sellBtn : UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = FONTM(size: 14)
        button.setBackgroundImage(UIImage(named: "rightsell1"), for: .normal)
        button.setBackgroundImage(UIImage(named: "rightsell2"), for: .selected)
        button.setTitleColor(UIColor.hexColor("989898"), for:.normal)
        button.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for:.selected)
        button.setTitle("tv_trade_sell".localized(), for: .normal)
        button.rx.tap.subscribe { _ in
            
//            if userManager.isLogin {
//
//                self.comfirmBtn.setTitle("tv_trade_sell".localized(), for: .normal)
//            }else{
//                self.comfirmBtn.setTitle("tv_login".localized(), for: .normal)
//            }
//
//            if !button.isSelected{
//
//                self.isBuy = false
//            }
        } .disposed(by: disposeBag)
        return button
    }()
    
    lazy var priceInputView : TradeInputView = {
        
        let placeholder = "tv_trigger_price".localized()
        let view = TradeInputView()
        view.isHasButtons = true
        view.inputTextField.placeholder = placeholder
        view.inputTextField.text = ""
        view.inputTextField.tag = 0
//        self.updateUnit.subscribe { _ in
//
//            view.placeholder = "tv_trigger_price".localized() + "(\(self.coinModel.currency))"
//        }.disposed(by: disposeBag)
        return view
    }()

    let amountView = FuturesAmountInputView()
    lazy var slider : UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "futures_slider"), for: .normal)
//        slider.minimumTrackTintColor = .red
//        slider.maximumTrackTintColor = .blue
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        slider.setMinimumTrackImage(UIImage(named: "futures_slider_selected"), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "futures_slider_unselected"), for: .normal)
        return slider
    }()
    
    private let tpslBtn : LeftImgRightTitleButton = {
        let tpslBtn = LeftImgRightTitleButton()
        tpslBtn.setImage(UIImage(named: "futures_check"), for: .normal)
        tpslBtn.setImage(UIImage(named: "futures_checked"), for: .selected)
        tpslBtn.title = "TP/SL"
        tpslBtn.imageWidth = 14
        tpslBtn.margin = 6
        return tpslBtn
    }()
    
    private let reduceBtn : LeftImgRightTitleButton = {
        let reduceBtn = LeftImgRightTitleButton()
        reduceBtn.setImage(UIImage(named: "futures_check"), for: .normal)
//        reduceBtn.setImage(UIImage(named: "futures_checked"), for: .selected)
        reduceBtn.title = "Reduce Only"
        reduceBtn.imageWidth = 14
        reduceBtn.margin = 6
        return reduceBtn
    }()
    private let exchangeBtn : ZQButton = {
        let exchangeBtn = ZQButton()
        exchangeBtn.setImage(UIImage(named: "futures_exchange"), for: .normal)
        exchangeBtn.contentVerticalAlignment = .top
        return exchangeBtn
    }()

    private let availabelCoin : InfoLabel = {
        let availabelCoin = InfoLabel()
        availabelCoin.titleStr = "Available BTC"
        availabelCoin.valueStr = "7.75"
        availabelCoin.valueLabel.textAlignment = .right
        return availabelCoin
    }()
    private let availabelCurrency: InfoLabel = {
        let availabelCurrency = InfoLabel()
        availabelCurrency.titleStr = "Available USDT"
        availabelCurrency.valueStr = "881d2323727.75"
        availabelCurrency.valueLabel.textAlignment = .right
        return availabelCurrency
    }()
    
    private let comfirmBtn: ZQButton = {
        let comfirmBtn = ZQButton()
        comfirmBtn.corner(cornerRadius: 3)
        comfirmBtn.backgroundColor = .hexColor("02C078")
        comfirmBtn.setTitleColor(.white, for: .normal)
        comfirmBtn.titleLabel?.font = FONTM(size: 14)
        comfirmBtn.setTitle("登录", for:  .normal)
        return comfirmBtn
    }()

}
//UI
extension ContractHeader{
    
    func setUI()  {
        setLeftUI()
        setRightUI()
        
    }
    
    
    func setLeftUI() {
        
        self.addSubview(leftView)
        leftView.addSubview(countDownView)
        leftView.addSubview(tables)
        addLeftConstraint()
    }
 
    func setRightUI(){
        
        self.addSubview(rightView)
        rightView.addSubview(warehouseBtn)
        rightView.addSubview(marginBtn)
        rightView.addSubview(buyBtn)
        rightView.addSubview(sellBtn)
        rightView.addSubview(typeBtn)
        rightView.addSubview(priceInputView)
        rightView.addSubview(amountView)
        rightView.addSubview(slider)
        rightView.addSubview(tpslBtn)
        rightView.addSubview(reduceBtn)
        rightView.addSubview(exchangeBtn)
        rightView.addSubview(availabelCoin)
        rightView.addSubview(availabelCurrency)
        rightView.addSubview(comfirmBtn)
        
        warehouseBtn.title = "全仓"
        marginBtn.dataSource = ["5x","10x","50x","75x","100x"]
        typeBtn.textAligment = .center
        typeBtn.dataSource = ["限价单","市价单","限价止盈止损","市价止盈止损"]
        amountView.leftBtnStr = "BTC"
        amountView.rightBtnStr = "USDT"
        amountView.leftplaceholder = "Amount(BTC)"
        amountView.rightPlaceholder = "Amount(USDT)"

        addRightConstraint()
    }
    func addLeftConstraint(){
        
//        tables.backgroundColor = .red
//        leftView.backgroundColor = .yellow
        leftView.snp.makeConstraints { make in
            
            make.left.equalTo(margin)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().multipliedBy(136.0/(375-40))
        }
        countDownView.snp.makeConstraints { make in
            
            make.top.equalTo(7)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        tables.snp.makeConstraints { make in
            
            
            make.top.equalTo(countDownView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    func addRightConstraint(){
        rightView.snp.makeConstraints { make in
            
            make.left.equalTo(countDownView.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-margin)
        }
        warehouseBtn.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.top.equalTo(14)
            make.height.equalTo(24)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-5)
        }
        marginBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.top.equalTo(14)
            make.height.equalTo(24)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-5)
        }
        buyBtn.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.top.equalTo(warehouseBtn.snp.bottom).offset(margin)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.5).offset(4)
        }
        sellBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.top.height.width.equalTo(buyBtn)
        }
        
        typeBtn.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(buyBtn.snp.bottom).offset(margin)
            make.height.equalTo(24)
        }
        
        priceInputView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(typeBtn.snp.bottom).offset(margin)
            make.height.equalTo(36)
        }
        
        amountView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(priceInputView.snp.bottom).offset(margin)
            make.height.equalTo(64)
        }
        
        slider.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(amountView.snp.bottom)
            make.height.equalTo(36)
        }
        tpslBtn.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(-5)
            make.height.equalTo(26)
        }
        
        reduceBtn.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.top.equalTo(tpslBtn.snp.bottom)
            make.height.equalTo(26)
        }

        exchangeBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(4)
            make.width.equalTo(24)
            make.height.equalTo(16)
            make.top.equalTo(reduceBtn.snp.bottom).offset(5)
        }
        availabelCoin.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.right.equalTo(exchangeBtn.snp.left)
            make.height.equalTo(28)
            make.top.equalTo(reduceBtn.snp.bottom).offset(5)
        }

        availabelCurrency.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.height.equalTo(availabelCoin)
            make.top.equalTo(availabelCoin.snp.bottom)
        }
        
        comfirmBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
            make.height.equalTo(36)
        }

    }
}
// 事件
extension ContractHeader{
    
    func addEvent() {
        
        warehouseBtn.clickBlock { isDirectionUp in
            
            self.tapTypeV()
            print("\(isDirectionUp)")
        }
        
    }
    ///slider滑动事件
    @objc private func sliderChange(_ slider: UISlider) {
        let value = slider.value
        print(value)
    }
    
    @objc func tapTypeV(){
        let actionSheet = SelectFuturesSheet()

        actionSheet.clickCellAtion = { index in
            print("\(index)")
        }
        actionSheet.show()
    }


    func subscribSocket()  {
        self.marketsViewModel.reqModel.coin = "BTC"
        self.marketsViewModel.reqModel.currency  = "USDT"
        self.marketsViewModel.amountDigit = 5
        self.marketsViewModel.websocketBuySell()

        //更新买卖盘
        self.marketsViewModel.requestCoinBuySelllist()
            .subscribe(onNext: { model in
                
                self.tables.sells = self.marketsViewModel.sells as! Array<Array<String>>
                self.tables.buys = self.marketsViewModel.buys as! Array<Array<String>>
//                self.tables.reloadData()
            }).disposed(by: self.disposeBag)

        //MARK: 推送
        self.marketsViewModel.fiveData.subscribe(onNext: { value in
            
            self.tables.sells = self.marketsViewModel.sells  as! Array<Array<String>>
            self.tables.buys = self.marketsViewModel.buys  as! Array<Array<String>>

            if let theValue : (type: Int, num: String) = value as? (type: Int, num: String) {

                self.tables.percentVale = theValue
            }
        }).disposed(by: disposeBag)

//        WSCoinPushSing.sharedInstance().tradeDatas
//            .subscribe(onNext: { value in
//                if self.coinModel.coin == value.coin &&
//                    self.coinModel.currency == value.currency {
//
//                    self.updateCurrentPrice.onNext(value)
//                }
//        })
//        .disposed(by: disposeBag)

    }
    
}


class CountdownView : UIView{
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let countdownLabel = DinLabel()
    fileprivate let fundinglabel = DinLabel()
    
    func setUI()  {
     
        let titleLabel = DinLabel()
        titleLabel.text = "Countdown / funding".localized()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.top.left.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.addSubview(countdownLabel)
        self.addSubview(fundinglabel)
        countdownLabel.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.height.equalTo(14)
        }
        
        fundinglabel.snp.makeConstraints { make in
            
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.height.equalTo(14)
        }
        
        countdownLabel.text = "02:18:37"
        fundinglabel.text = "0.01%"

    }
}

fileprivate class DinLabel : UILabel{
     
    convenience init(font : UIFont = FONTDIN(size: 11) , color : UIColor = .hexColor("999999")) {
         self.init(frame: CGRect.zero)
         self.font = font
         self.textColor = color
     }
     override init(frame: CGRect) {
         super.init(frame: frame)
         self.font = FONTDIN(size: 11)
         self.textColor = .hexColor("999999")

     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
//用于合约界面的点击弹出框
fileprivate class DinOptionView : WLOptionView{
    
    convenience init(type:InputType = .normal) {
        
        self.init(frame: .zero, type: type)
    }
    
   override var dataSource:[String] {
        
        didSet {
            
            if type == .normal  {
                if rowheight != 0 {
                    self.tableViewHeight = CGFloat(CGFloat(self.dataSource.count) * rowheight)
                }else{
                    self.tableViewHeight = CGFloat(self.dataSource.count * cellHeight)
                }
            }else{
                tableViewHeight = 210
            }
            self.title = dataSource.first
        }
    }

    var selectAt : (((Int)->()))?
    
    override init(frame: CGRect, type: InputType) {
        super.init(frame: frame, type: type)
        
        self.isHaveDistance = true
        self.titleColor = .white
        self.backgroundColor = .hexColor("2D2D2D")
        self.cornerRadius = 4
        self.cellHeight = 40
        self.rightImgWidth = 7
        self.textAligment = .left
        self.titleLabel.font = FONTR(size: 12)
        self.animationTime = 0.1
        self.titleFont = FONTDIN(size: 11)
        self.selectedCallBack {[weak self] (viewTemp, index) in

            self?.selectIndex = index
            self?.selectAt?(index)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 class LeftImgRightTitleButton : UIButton{
    
    override var isSelected: Bool {
     
        didSet{
            
            if isSelected {
                
                myImageView.image = selectImg ?? nomalImg ?? image
            }else{
                myImageView.image = nomalImg ?? image
            }
        }
    }
    private var nomalImg : UIImage?
    private var selectImg : UIImage?
    override func setImage(_ image: UIImage?, for state: UIControl.State) {

        if state == .selected {
            selectImg = image
        }else {
            nomalImg = image
            self.image = image
        }
    }
    
    var font : UIFont = FONTDIN(size: 12) {  didSet{  myTitleLabel.font = font }}
    var title : String? { didSet{
            
            myTitleLabel.text = title
            updateContaints() } }
    var margin : Int = 10 { didSet { updateContaints() } }
    var textColor : UIColor = .hexColor("989898") { didSet{ myTitleLabel.textColor = textColor } }
    var image : UIImage? { didSet{
            myImageView.image = image
            updateContaints() } }
    var imageWidth : CGFloat = 20 { didSet{
            updateContaints() } }

    func updateContaints() {
        
        if ( image != nil ||  nomalImg != nil ), let _ = title  {
            myImageView.snp.remakeConstraints({ make in
                make.left.equalToSuperview()
                make.height.width.equalTo(imageWidth)
                make.centerY.equalToSuperview()
            })
            myTitleLabel.snp.remakeConstraints({ make in
                make.left.equalTo(myImageView.snp.right).offset(margin)
                make.right.equalTo(-10)
                make.centerY.equalToSuperview()
            })
        }}
    private let myTitleLabel = UILabel()
    private let myImageView = UIImageView()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
                
        self.addSubview(myTitleLabel)
        self.addSubview(myImageView)
        myTitleLabel.textColor = textColor
        myTitleLabel.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
