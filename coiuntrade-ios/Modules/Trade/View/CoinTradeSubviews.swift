//
//  TradeInputView.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/6/13.
//

import UIKit

//MARK: 输入框
enum InputViewType : Int {
    
    case nomal = 0
    case marketPrice = 1
}

class TradeInputBaseView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .hexColor("2D2D2D")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
class TradeInputView : TradeInputBaseView{
    
    var addClick : NormalBlock?
    var minusClick : NormalBlock?

    private var disposeBag = DisposeBag()
    var digit = 0 //小数位
    var isHasButtons = false {
        
        didSet{
            if isHasButtons{
                
                addBtn.isHidden = false
                minusBtn.isHidden = false
                
                inputTextField.snp.remakeConstraints { make in
                   
                    make.top.bottom.equalToSuperview()
                    make.right.equalTo(addBtn.snp.left)
                    make.left.equalTo(minusBtn.snp.right)
               }
            }
        }
    }
    
    let minusBtn : UIButton = {
        let minusBtn = UIButton()
        minusBtn.setImage(UIImage(named: "futures_minus"), for: .normal)
        return minusBtn
    }()
    let addBtn : UIButton = {
        let addBtn = UIButton()
        addBtn.setImage(UIImage(named: "futures_add"), for: .normal)
        return addBtn
    }()
    
    lazy var maskLabel : UILabel  = {

        let label = UILabel()

        label.text = "Trade_MarketPirce".localized()
        label.textAlignment = .center
        label.font = FONTR(size: 12)
        label.backgroundColor = UIColor.hexColor("434343")
        label.isHidden = true
        label.corner(cornerRadius: 3)
        return label
    }()

   lazy var inputType : InputViewType = .nomal{
        
        didSet{
            
            if inputType == .nomal{
                
                maskLabel.isHidden = true
                self.isUserInteractionEnabled = true
            }else{
                
                maskLabel.isHidden = false
                self.isUserInteractionEnabled = false
            }
        }
    }
    
    lazy var inputTextField : UITextField = {
        
        let tf = UITextField()
        tf.backgroundColor = .hexColor("2D2D2D")
        tf.keyboardType = .decimalPad
        tf.textColor = .white
        tf.font = FONTDIN(size: 16)
        tf.textAlignment = .center
//        tf.borderStyle = .init(rawValue: TradeViewLeftMargin) ?? .none
        tf.leftView = UIView(frame: CGRect(origin: CGPoint.zero , size: CGSize(width: CGFloat(TradeViewLeftMargin), height: tf.frame.size.height)))
        tf.leftViewMode = .always
        tf.attributedPlaceholder = NSAttributedString.init(string:"price", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.hexColor("989898"),NSAttributedString.Key.font: FONTR(size: 12)])
        return tf
    }()
    
    var text : String {
        set {
         
            inputTextField.text = newValue
        }
        get{
           
            inputTextField.text ?? ""
        }
    }
    var placeholder : String = "" {
        
        didSet{
            
            self.inputTextField.placeholder = placeholder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(inputTextField)
        inputTextField.delegate = self
         inputTextField.snp.makeConstraints { make in
            
             make.top.right.left.bottom.equalToSuperview()
        }
        self.addSubview(addBtn)
        self.addSubview(minusBtn)
        addBtn.snp.makeConstraints { make in
            
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(46)
        }
        minusBtn.snp.makeConstraints { make in
            
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(46)
        }
        
        self.addSubview(maskLabel)
        maskLabel.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        
        addBtn.isHidden = true
        minusBtn.isHidden = true
        
        addBtn.rx.tap.subscribe ({[weak self] _ in
            
            self?.addClick?()
        }).disposed(by: disposeBag)
        minusBtn.rx.tap.subscribe ({[weak self] _ in
            
            self?.minusClick?()
        }).disposed(by: disposeBag)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TradeInputView :  UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let scanner = Scanner(string: string)
        let numbers : NSCharacterSet = NSCharacterSet(charactersIn: "0123456789.")
        let pointRange = (textField.text! as NSString).range(of: ".")
                    
        if (textField.text == "" || digit == 0) && string == "." {
            return false
        }
        /// 小数点后8位
        let tempStr = textField.text!.appending(string)
        let strlen = tempStr.count
        if pointRange.length > 0 && pointRange.location > 0{//判断输入框内是否含有“.”。
            if string == "." {
                return false
            }
            
            if strlen > 0 && (strlen - pointRange.location) > digit + 1 {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return false
            }
        }
                    
        let zeroRange = (textField.text! as NSString).range(of: "0")
        if zeroRange.length == 1 && zeroRange.location == 0 { //判断输入框第一个字符是否为“0”
            if !(string == "0") && !(string == ".") && textField.text?.count == 1 {//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string
                return false
            }else {
                if pointRange.length == 0 && pointRange.location > 0 {//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if string == "0" {
                        return false
                    }
                }
            }
        }
        if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
            return false
        }
        
        return true
    }

}

class TradeMarketAmountInputView : TradeInputBaseView{

    func changeLanguage(){
        
        amountBtn.setTitle("tv_trade_amount".localized(), for: .normal)
        priceBtn.setTitle("tv_trade_deal_price".localized(), for: .normal)
    }
    private var disposeBag = DisposeBag()
    private let topView = UIView()
    var placeHolderCoin : String = ""{
        
        didSet{
            
            let isSelect = self.isAmountSelected
            self.isAmountSelected = isSelect
        }
    }
    
    var placeHolderCurrency : String = ""{
        
        didSet{

            let isSelect = self.isAmountSelected
            self.isAmountSelected = isSelect
        }
    }
    ///数量
    var amountStr = ""
    {

        didSet{

            if isAmountSelected {

                self.inputTextField.text = amountStr
            }
        }
    }
    ///成交额
    var totalStr = ""
    {

        didSet{

            if !isAmountSelected {

                self.inputTextField.text = totalStr
            }
        }
    }
    var isAmountSelected = true{
        
        didSet{
            
            self.inputTextField.resignFirstResponder()

            if isAmountSelected{
                
                self.inputTextField.placeholder = placeHolderCoin
                self.inputTextField.text = amountStr
            }else{
                
                self.inputTextField.placeholder = placeHolderCurrency
                self.inputTextField.text = totalStr

            }
        }
    }
    
    var currency_digit = 0 //总额小数位
    var coin_digit = 0 //数量小数位
    var digit : Int {
        
        get {
            
            if self.isAmountSelected {
                
                return coin_digit
            }else{
                
                return currency_digit
            }
        }
    }//小数位

    lazy var inputTextField : UITextField = {
        
        let tf = UITextField()
        tf.backgroundColor = .hexColor("2D2D2D")
        tf.keyboardType = .decimalPad
        tf.textColor = .white
        tf.font = FONTDIN(size: 16)
        tf.textAlignment = .center
//        tf.borderStyle = .init(rawValue: TradeViewLeftMargin) ?? .none
        tf.leftView = UIView(frame: CGRect(origin: CGPoint.zero , size: CGSize(width: CGFloat(TradeViewLeftMargin), height: tf.frame.size.height)))
        tf.leftViewMode = .always
        tf.attributedPlaceholder = NSAttributedString.init(string:"price", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.hexColor("989898"),NSAttributedString.Key.font: FONTR(size: 12)])
        tf.delegate = self
        return tf
    }()
    
    var text : String {
        set {
         
            inputTextField.text = newValue
        }
        get{
           
            inputTextField.text ?? ""
        }
    }

    let amountBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor =  .hexColor("2D2D2D")
        btn.setTitle("tv_trade_amount".localized(), for: .normal)
        btn.setTitleColor( .hexColor("989898"), for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.titleLabel?.font = FONTR(size: 12)
        return btn
    }()
    let priceBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor =  .hexColor("2D2D2D")
        btn.setTitle("成交额".localized(), for: .normal)
        btn.setTitleColor( .hexColor("989898"), for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.titleLabel?.font = FONTR(size: 12)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(topView)
        self.backgroundColor = .hexColor("1E1E1E")

        amountBtn.isSelected = true
        
        amountBtn.rx.tap.subscribe { [weak self]_ in
            
            self?.amountBtn.isSelected = true
            self?.priceBtn.isSelected = false
            self?.isAmountSelected = true
        }
        .disposed(by: disposeBag)
       
        priceBtn.rx.tap.subscribe { [weak self] _ in
            
            self?.amountBtn.isSelected = false
            self?.priceBtn.isSelected = true
            self?.isAmountSelected = false
        }
        .disposed(by: disposeBag)

        
        topView.addSubview(amountBtn)
        topView.addSubview(priceBtn)
        amountBtn.snp.makeConstraints { make in
            
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(-0.5)
            make.bottom.equalToSuperview().offset(-1)
        }
        priceBtn.snp.makeConstraints { make in
            
            make.right.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(-0.5)
            make.bottom.equalToSuperview().offset(-1)
        }

        topView.snp.remakeConstraints { make in
     
            make.left.top.right.equalToSuperview()
            make.height.equalTo(25)
        }
        self.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            
             make.top.equalTo(topView.snp.bottom)
             make.right.left.bottom.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension TradeMarketAmountInputView :  UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let scanner = Scanner(string: string)
        let numbers : NSCharacterSet = NSCharacterSet(charactersIn: "0123456789.")
        let pointRange = (textField.text! as NSString).range(of: ".")
                    
        if (textField.text == "" || digit == 0) && string == "." {
            return false
        }
        /// 小数点后8位
        let tempStr = textField.text!.appending(string)
        let strlen = tempStr.count
        if pointRange.length > 0 && pointRange.location > 0{//判断输入框内是否含有“.”。
            if string == "." {
                return false
            }
            
            if strlen > 0 && (strlen - pointRange.location) > digit + 1 {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return false
            }
        }
                    
        let zeroRange = (textField.text! as NSString).range(of: "0")
        if zeroRange.length == 1 && zeroRange.location == 0 { //判断输入框第一个字符是否为“0”
            if !(string == "0") && !(string == ".") && textField.text?.count == 1 {//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string
                return false
            }else {
                if pointRange.length == 0 && pointRange.location > 0 {//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if string == "0" {
                        return false
                    }
                }
            }
        }
        if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
            return false
        }
        
        return true
    }

}

//MARK: 带title 和value 的label （可用和最大值那用到）
class InfoLabel : UIView {
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
//    var textAlignment = NSTextAlignment? {
//
//        didSet{
//            valueLabel.textAlignment =
//        }
//    }

    var titleStr : String = ""{
       
        didSet{
            
            self.titleLabel.text = titleStr
        }
    }
    var valueStr : String = ""{
        
        didSet{
                
            self.valueLabel.text =  valueStr // "999999999999999999999999999 USDT" //
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
//        titleLabel.sizeToFit()
        titleLabel.font = FONTR(size: 12)
        titleLabel.textColor = .hexColor("999999")
     
        valueLabel.font = FONTR(size: 12)
        valueLabel.numberOfLines = 2
        valueLabel.sizeToFit()
        valueLabel.textColor = .white
//        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.9

        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

        titleLabel.snp.makeConstraints { make in
            
            make.left.top.equalToSuperview()
            make.height.equalTo(16)
        }
        valueLabel.snp.makeConstraints { make in
            
            make.right.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.height.greaterThanOrEqualTo(16)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class SelectPercentView : UIView {
    
    private var disposeBag = DisposeBag()
    var percentChangedClosure: ((Int)->())?  // 点击回调
    var isBuy = true // true ： 买  false ： 卖
    
    var isSqure = false {
        didSet{
          _ =  percentSubviews.compactMap { cell in
                
              cell.isSqure = isSqure
            }
        }
    }
    
    
    let tap25Percent = UITapGestureRecognizer()
    let tap50Percent = UITapGestureRecognizer()
    let tap75Percent = UITapGestureRecognizer()
    let tap100Percent = UITapGestureRecognizer()
    
    let v25Percent : PercentCell = {
        let cell = PercentCell()
        cell.titleLabel.text = "25%"
        cell.tag = 25
        return cell
    }()
    let v50Percent : PercentCell = {
        let cell = PercentCell()
        cell.titleLabel.text = "50%"
        cell.tag = 50
        return cell
    }()
    let v75Percent : PercentCell = {
        let cell = PercentCell()
        cell.titleLabel.text = "75%"
        cell.tag = 75
        return cell
    }()
    let v100Percent : PercentCell = {
        let cell = PercentCell()
        cell.titleLabel.text = "100%"
        cell.tag = 100
        return cell
    }()
    
    /// 返回百分比的整数such as 75% 返回75
    lazy var percent : Int = 0 {
        
       didSet{
        
           self.percentChangedClosure?(self.percent)

           if percent == 0 {
                
                isClearSelect = true
                
            }else{
                
                self.isClearSelect = false
                /// 返回百分比的整数such as 75% 返回75

                for view in percentSubviews {
                    if view.tag < percent  {
                        view.isSelect = true
                        view.isInclue = false
                    }else if view.tag == percent{
                     
                        view.isSelect = true
                        view.isInclue = true

                    }else{
                        view.isSelect = false
                        view.isInclue = false
                    }
                }
            }
        }
    }
    //晴空
    var isClearSelect = false {
        
        didSet{
            
            if isClearSelect {
                for view in percentSubviews {
                    
                    view.isSelect = false
                    view.isInclue = false
                }
            }
        }
    }
    
//    func clearPercent()  {
//
//        for view in percentSubviews {
//
//            view.isSelect = false
//            view.isInclue = false
//        }
//    }
    
    var percentSubviews :Array<PercentCell> = Array()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(v25Percent)
        self.addSubview(v50Percent)
        self.addSubview(v75Percent)
        self.addSubview(v100Percent)
        percentSubviews = [v25Percent,v50Percent,v75Percent,v100Percent]

        percentSubviews.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 5, leadSpacing: 0, tailSpacing: 0)
        percentSubviews.snp.makeConstraints{ make in
            
            make.top.bottom.equalToSuperview()
        }
        
        v25Percent.addGestureRecognizer(tap25Percent)
        v50Percent.addGestureRecognizer(tap50Percent)
        v75Percent.addGestureRecognizer(tap75Percent)
        v100Percent.addGestureRecognizer(tap100Percent)
        
        let percents = [tap25Percent, tap50Percent, tap75Percent, tap100Percent].map { $0! }
        let selectedModules = Observable.from(
            percents.map { view in view.rx.event.map {_ in view} }
        ).merge()
        selectedModules.subscribe(onNext: { [self]value in
            
            let isSameClick = ((self.percent == value.view!.tag) && !self.isClearSelect)

//            self.clickClosure?(self.percent)

            if isSameClick {

                self.percent = 0
//                self.isClearSelect = true
            }else{
             
                self.percent = value.view!.tag
            }
            }).disposed(by: disposeBag)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
//MARK: 百分比view
class PercentCell : UIView {
    var isBuy = true // true ： 买  false ： 卖
    var isSqure = false {
        didSet{
            
            if isSqure{
                barView.corner(cornerRadius: 0)
                barView.snp.remakeConstraints { make in
                    
                    make.right.left.equalToSuperview()
                    make.height.equalTo(12)
                    make.top.equalTo(15)
                }
                
                titleLabel.snp.remakeConstraints { make in
                    
                    make.left.right.equalToSuperview()
                    make.top.equalTo(barView.snp.bottom).offset(3)
                    make.height.equalTo(15)
                }

            }
        }
    }
    let titleLabel : UILabel = {
        
        let label = UILabel()
        label.font = FONTDIN(size: 10)
        label.textColor = .hexColor("989898")
        label.text = "23232323234"
        label.textAlignment = .center
        return label
    }()
    
    private let barView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .hexColor("2D2D2D")
        return view
    }()

    var isSelect = false{
        
        didSet{

            barView.backgroundColor = isSelect ? (isBuy ? .hexColor("02C078") : .hexColor("F03851")) : .hexColor("2D2D2D")
        }
    }
    
    var isInclue = false {
        
        didSet{
            
            titleLabel.textColor =  isInclue ? .white : .hexColor("989898")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(titleLabel)
        self.addSubview(barView)
        
        titleLabel.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.centerY)
            make.height.equalTo(15)
        }

        barView.snp.makeConstraints { make in
            
            make.right.left.equalToSuperview()
            make.height.equalTo(10)
            make.bottom.equalTo(titleLabel.snp.top).offset(-5)
        }
        barView.corner(cornerRadius: 5)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension UIView {
    
    func addTapForView() ->(Observable<UITapGestureRecognizer>){
        let ges = UITapGestureRecognizer()
        self.addGestureRecognizer(ges)

        return ges.rx.event.throttle( .seconds(1), latest: true, scheduler: MainScheduler.instance)
    }
}


class FuturesAmountInputView : TradeInputBaseView{

    func changeLanguage(){
        
//        leftBtn.setTitle("tv_trade_amount".localized(), for: .normal)
//        rightBtn.setTitle("tv_trade_deal_price".localized(), for: .normal)
    }
    
    let minusBtn : UIButton = {
        let minusBtn = UIButton()
        minusBtn.setImage(UIImage(named: "futures_minus"), for: .normal)
        minusBtn.backgroundColor = .hexColor("2D2D2D")
        return minusBtn
    }()
    let addBtn : UIButton = {
        let addBtn = UIButton()
        addBtn.backgroundColor = .hexColor("2D2D2D")
        addBtn.setImage(UIImage(named: "futures_add"), for: .normal)
        return addBtn
    }()

    private var disposeBag = DisposeBag()
    private let topView = UIView()
    var leftplaceholder : String = ""{ didSet {
            let isSelect = self.isLeftSelected
            self.isLeftSelected = isSelect }}
    
    var rightPlaceholder : String = ""{ didSet{
            let isSelect = self.isLeftSelected
            self.isLeftSelected = isSelect }}
    var leftBtnStr = "" { didSet{ leftBtn.setTitle(leftBtnStr, for: .normal) }} // 左边按钮名
    var rightBtnStr = "" { didSet{ rightBtn.setTitle(rightBtnStr, for: .normal) }} // 右边按钮名
    var leftStr = "" {didSet{if isLeftSelected { self.inputTextField.text = leftStr }}} // 左边的输入值
    var rightStr = "" {didSet{ if !isLeftSelected { self.inputTextField.text = rightStr}}} // 右边的输入值
    var rightDigit = 0 //左边的小数位
    var leftDigit = 0 //右边小数位
    var digit : Int { get { if self.isLeftSelected { return leftDigit }else{ return rightDigit}} }//小数位
    var text : String {
        set{inputTextField.text = newValue}
        get{inputTextField.text ?? "" }
    }

    var isLeftSelected = true {didSet{
            self.inputTextField.resignFirstResponder()
            if isLeftSelected{
                self.inputTextField.placeholder = leftplaceholder
                self.inputTextField.text = leftStr
                self.leftBtn.isSelected = true
                self.rightBtn.isSelected = false
            }else{
                self.inputTextField.placeholder = rightPlaceholder
                self.inputTextField.text = rightStr
                self.leftBtn.isSelected = false
                self.rightBtn.isSelected = true
            }}}

    lazy var inputTextField : UITextField = {
        
        let tf = UITextField()
        tf.backgroundColor = .hexColor("2D2D2D")
        tf.keyboardType = .decimalPad
        tf.textColor = .white
        tf.font = FONTDIN(size: 16)
        tf.textAlignment = .center
        tf.leftView = UIView(frame: CGRect(origin: CGPoint.zero , size: CGSize(width: CGFloat(TradeViewLeftMargin), height: tf.frame.size.height)))
        tf.leftViewMode = .always
        tf.attributedPlaceholder = NSAttributedString.init(string:"price", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.hexColor("989898"),NSAttributedString.Key.font: FONTR(size: 12)])
        tf.delegate = self
        return tf
    }()

    private let leftBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor =  .hexColor("2D2D2D")
//        btn.setTitle("tv_trade_amount".localized(), for: .normal)
        btn.setTitleColor( .hexColor("989898"), for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.titleLabel?.font = FONTR(size: 12)
        return btn
    }()
    private let rightBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor =  .hexColor("2D2D2D")
//        btn.setTitle("成交额".localized(), for: .normal)
        btn.setTitleColor( .hexColor("989898"), for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.titleLabel?.font = FONTR(size: 12)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(topView)
        self.backgroundColor = .hexColor("1E1E1E")

        leftBtn.isSelected = true
        leftBtn.rx.tap.subscribe { [weak self]_ in
            
            self?.isLeftSelected = true
        }.disposed(by: disposeBag)
       
        rightBtn.rx.tap.subscribe { [weak self] _ in
            
            self?.isLeftSelected = false
        }.disposed(by: disposeBag)

        topView.addSubview(leftBtn)
        topView.addSubview(rightBtn)
        leftBtn.snp.makeConstraints { make in
            
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(-1.5)
            make.bottom.equalToSuperview().offset(-3)
        }
        rightBtn.snp.makeConstraints { make in
            
            make.right.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(-1.5)
            make.bottom.equalToSuperview().offset(-3)
        }
        topView.snp.remakeConstraints { make in
     
            make.left.top.right.equalToSuperview()
            make.height.equalTo(28)
        }
        
        self.addSubview(addBtn)
        self.addSubview(minusBtn)
        self.addSubview(inputTextField)
        addBtn.snp.makeConstraints { make in
            
            make.top.equalTo(topView.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.width.equalTo(46)
        }
        minusBtn.snp.makeConstraints { make in
            
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(46)
        }
        inputTextField.snp.makeConstraints { make in
            
             make.top.equalTo(topView.snp.bottom)
             make.bottom.equalToSuperview()
            make.left.equalTo(minusBtn.snp.right)
            make.right.equalTo(addBtn.snp.left)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FuturesAmountInputView :  UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let scanner = Scanner(string: string)
        let numbers : NSCharacterSet = NSCharacterSet(charactersIn: "0123456789.")
        let pointRange = (textField.text! as NSString).range(of: ".")
                    
        if (textField.text == "" || digit == 0) && string == "." {
            return false
        }
        /// 小数点后8位
        let tempStr = textField.text!.appending(string)
        let strlen = tempStr.count
        if pointRange.length > 0 && pointRange.location > 0{//判断输入框内是否含有“.”。
            if string == "." {
                return false
            }
            
            if strlen > 0 && (strlen - pointRange.location) > digit + 1 {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return false
            }
        }
                    
        let zeroRange = (textField.text! as NSString).range(of: "0")
        if zeroRange.length == 1 && zeroRange.location == 0 { //判断输入框第一个字符是否为“0”
            if !(string == "0") && !(string == ".") && textField.text?.count == 1 {//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string
                return false
            }else {
                if pointRange.length == 0 && pointRange.location > 0 {//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if string == "0" {
                        return false
                    }
                }
            }
        }
        if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
            return false
        }
        
        return true
    }

}
