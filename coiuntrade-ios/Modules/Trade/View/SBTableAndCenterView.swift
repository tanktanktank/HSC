//
//  SBTableAndCenterView.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/12.
//

import UIKit
import RxSwift

class SBTableAndCenterView: UIView {

    
    enum TradeVCType {
    case contractTrade // 合约
    case coinTrade    // 现货
    }
    
    var percentVale : (type: Int, num: String)?  {
        didSet{
            
            if  percentVale?.type == 9 {
                
                buyNumber = percentVale?.num ?? "0"
            }else{
                
                sellNumber = percentVale?.num ?? "0"
            }
        }
    }
    
    lazy var type : TradeVCType = .coinTrade {  didSet{  if type == .contractTrade{ centerView.snp.updateConstraints { make in  make.height.equalTo(60) } }  } }
    
    let rowHeight = 21
    var rowNumber = 6 {
        
        didSet{
            
//            self.marketsViewModel.numberOfRow = rowNumber
        }
    }

    func reloadData() {
        self.topTableView.reloadData()
        self.bottomTableView.reloadData()
    }
    
    let disposeBag = DisposeBag()
    var sells = [Any]() {
        
        didSet{
            self.topTableView.reloadData()
        }
    } // sell盘的数据源
    var buys = [Any](){
        
        didSet{
            self.bottomTableView.reloadData()
        }
    } //  buy盘的数据源

    //头部titleview
    lazy var headerView : UIView = {
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
                
        return headerView
    }()

    //卖盘table
    private lazy var topTableView : BaseTableView = {
        
        let tableView = BaseTableView()
//        tableView.backgroundColor = .hexColor("1E1E1E")
        tableView.register(UINib(nibName: "TradeShowCell",bundle: nil), forCellReuseIdentifier: "TradeShowCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = CGFloat(rowHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tag = 1
        tableView.transform = CGAffineTransform (scaleX: 1,y: -1);
        return tableView
    }()
    
//    var prePrice = "0"
    //中间marketPrice
    private  lazy var centerView: UIButton = {
        
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
        
        
//        view.rx.tap.subscribe { [weak self] _ in
//
//            if self?.reqModel.order_type != "3" {
//
//                self?.selectCurrentPrice.onNext(currentPrice)
//            }
//        }.disposed(by: disposeBag)
        
        
//        self.updateCurrentPrice.subscribe {[self] model in
//
//
//            if self.prePrice.toDouble() > model.new_price.toDouble(){
//
//                priceLabel.textColor = .hexColor("F03851" , alpha: 0.9)
//            }else if  self.prePrice.toDouble() < model.new_price.toDouble(){
//
//                priceLabel.textColor = .hexColor("02C078" , alpha: 0.9)
//
//            }else{
//
//                priceLabel.textColor = .hexColor("ffffff" , alpha:0.9)
//            }
//
//            let price = preciseDecimal(x: "\(model.new_price)", p: (Int(self.coinModel.price_digit) ?? 0))
//            currentPrice = price
//            priceLabel.text = self.addMicrometerLevel(valueSwift: price)
//
//            let ratePrice = self.addRateTwoDecimalsSymbol(value: model.new_price)
//            approximateLabel.text = "≈\( ratePrice)"
//
//            self.prePrice = model.new_price
//
//        } onError: { Error in
//
//        }.disposed(by: self.disposeBag)

        return view
    }()
    //买盘table
    private lazy var bottomTableView: BaseTableView = {
        let tableView = BaseTableView()
        tableView.backgroundColor = .hexColor("1E1E1E")
        tableView.register(UINib(nibName: "TradeShowCell",bundle: nil), forCellReuseIdentifier: "TradeShowCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = CGFloat(rowHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tag = 2
        return tableView
    }()
    
    //买卖百分比
    var buyNumber = "50"
    var sellNumber = "50" {
        
        didSet{
            
            let buyDouble = Double(buyNumber) ?? 1
            let sellDouble = Double(sellNumber) ?? 1
            let sellPercent = sellDouble / (buyDouble + sellDouble)

            leftLabel.text = String(format: "%.2f%@",(1-sellPercent)*100,"%")
            rightLabel.text = String(format: "%.2f%@", sellPercent*100,"%")

            percentageRightView.snp.remakeConstraints{ make in

                make.right.top.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(sellPercent)
            }
        }
    }
    
    let percentageRightView = UIView()
    let leftLabel = UILabel()
    let rightLabel = UILabel()

    lazy var percentageView : UIView = {
        let view = UIView()
        
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        view.addSubview(percentageRightView)

        view.backgroundColor = .hexColor("2EBC88", alpha: 0.2)
        percentageRightView.backgroundColor = .hexColor("FF4E4F", alpha: 0.2)

        percentageRightView.snp.makeConstraints { make in
            
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        leftLabel.textColor = .hexColor("2EBC88")
        rightLabel.textColor = .hexColor("FF4E4F")
        leftLabel.font = FONTDIN(size: 12)
        rightLabel.font = FONTDIN(size: 12)
        rightLabel.textAlignment = .right
        
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
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    
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

extension SBTableAndCenterView {
    
    func setUI(){
        

        let topLine: UIView = {
            let lineView = UIView()
            lineView.backgroundColor = .hexColor("363636")
            return lineView
        }()

        let bottomLine : UIView = {
            let lineView = UIView()
            lineView.backgroundColor = .hexColor("363636")
            return lineView
        }()
        
        self.addSubview(topLine)
        self.addSubview(bottomLine)
        self.addSubview(topTableView)
        self.addSubview(centerView)
        self.addSubview(bottomTableView)
        self.addSubview(headerView)
        self.addSubview(percentageView)

        

        topLine.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            
            make.left.right.equalTo(topLine)
            make.top.equalTo(topLine.snp.bottom)
            make.height.equalTo(42)
        }
        
        topTableView.snp.makeConstraints { make in
            
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalTo(topLine)
            make.height.equalTo(rowHeight * rowNumber)
        }
        
        centerView.snp.makeConstraints { make in
            
            make.top.equalTo(topTableView.snp.bottom)
            make.left.right.equalTo(topLine)
            make.height.equalTo(40)
        }

        bottomTableView.snp.makeConstraints { make in
            
            make.top.equalTo(centerView.snp.bottom)
            make.left.right.equalTo(topLine)
            make.height.equalTo(rowHeight * rowNumber)
        }
        
        bottomLine.snp.makeConstraints { make in
            
            make.left.width.height.equalTo(topLine)
            make.top.equalTo(bottomTableView.snp.bottom).offset(10)
        }
        
        percentageView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
            make.height.equalTo(28)
        }

        
    }
}

extension SBTableAndCenterView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch tableView.tag {
        case 1:
            return  sells.count
        case 2:
            return  buys.count
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TradeShowCell = tableView.dequeueReusableCell(withIdentifier: "TradeShowCell") as! TradeShowCell
        
        if tableView.tag == 1 {
            
            cell.type = false
            cell.datas = (sells[indexPath.row] as! Array<String>)
            cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        } else{
            cell.type = true
            cell.datas = (buys[indexPath.row] as! Array<String>)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.textFieldResignFirstResponder()
//
//        if self.reqModel.order_type != "3" {
//
//            switch tableView.tag {
//            case 1:
//                let datas = (self.marketsViewModel.sells[indexPath.row] as! Array<String>)
//                selectCurrentPrice.onNext(datas[0] )
//
//            case 2:
//                let datas = (self.marketsViewModel.buys[indexPath.row] as! Array<String>)
//                selectCurrentPrice.onNext(datas[0])
//            default:
//                print("点击")
//            }
//        }
    }
}
    
