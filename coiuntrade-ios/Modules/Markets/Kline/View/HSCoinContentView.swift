//
//  HSCoinContentView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/12.
//

import UIKit

typealias CoinContentVPass = ([String:String])->()

class HSCoinContentView: UIView {

    var depthBuys = [Any]()
    var depthSells = [Any]()
    /// 主图显示 默认MA (MA、BOLL、隐藏)
    var mainString = KLINEMA
    /// 副图显示 默认VOL (VOL、MACD、KDJ、RSI)
    var secondString = KLINEVOL
    var trendType: XLKLineType = .candleLineType
    /// 日期显示类型 日K以内是MM/DD HH:mm  日K以外是YY/MM/DD
    var dateType: XLKLineDateType = .min
    var kLineList: [XLKLineModel] = Array(){
        didSet{
            if(!isShowDepth){
                if(noOffset){
                    kLineView.configureViewNoOffset(data: kLineList, isNew: true, mainDrawString: mainString, secondDrawString: secondString, dateType: dateType, lineType: trendType)
                }else{
                    kLineView.configureView(data: kLineList, isNew: true, mainDrawString: mainString, secondDrawString: secondString, dateType: dateType, lineType: trendType)
                }
            }
        }
    }
    var noOffset: Bool = false
    var isShowDepth: Bool = false
    var passKline:CoinContentVPass?
    private var disposeBag = DisposeBag()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupEvent()
    }
    
    
    func setupEvent(){
        
        toolBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                
                self?.passKline?(["type":"KlineTool"])
            }).disposed(by: disposeBag)
        
        //更多
        moreBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                
                self?.passKline?(["type":"MoreTime"])
            }).disposed(by: disposeBag)
        
        deepthBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                
                self?.updateDepthState(isSelect: true)
                self?.moreBtn.setTitle("更多", for: .normal)
                self?.moreBtn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
                self?.updateTimeBtnState()
                self?.updateDeppth()

            }).disposed(by: disposeBag)
        
        
        //时间
        let buttonTimes = self.timeBtnArray.map { $0 }
        let choTimeButton = Observable.from(
            buttonTimes.map { button in button.rx.tap.map {button} }
        ).merge()
        choTimeButton.map {[weak self] value in
            
            for button in buttonTimes {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
            
            if(value.titleLabel?.text == "分时"){
                self?.trendType = XLKLineType.minLineType
            }else{
                self?.trendType = XLKLineType.candleLineType
            }
            let klineType = self!.timeMap[value.titleLabel?.text ?? "15分钟"]
            self?.passKline?(["type":"time","time":klineType ?? ""])
            
            self?.moreBtn.setTitle("更多", for: .normal)
            self?.moreBtn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
            
            self?.updateDepthState(isSelect: false)
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
        
        ///主图指标事件
        let buttonIndexs = self.indexBtnArray.map { $0 }
        let choIndexButton = Observable.from(
            buttonIndexs.map { button in button.rx.tap.map {button} }
        ).merge()
        choIndexButton.map {[weak self] value in
            
            for button in buttonIndexs {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
            if(self != nil){
                self!.mainString = (value.tag < 1 ? KLINEMA : KLINEBOLL)
                self!.kLineView.configureView(data: self!.kLineList, isNew: true, mainDrawString: self!.mainString, secondDrawString: self!.secondString, dateType: self!.dateType, lineType: self!.trendType)
            }
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
        
        ///幅图指标事件
        let btnSecondIndexs = self.indexSecondBtns.map { $0 }
        let selSecIndexBtn = Observable.from(
            btnSecondIndexs.map { button in button.rx.tap.map {button} }
        ).merge()
        selSecIndexBtn.map {[weak self] value in
            
            if(value.tag > 5){
                self?.passKline?(["type":"Horizon"])
            }else{
                for button in btnSecondIndexs {
                    if button.tag == value.tag{
                        button.isSelected = true
                    } else{
                        button.isSelected = false
                    }
                }
                if(self != nil){
                    let seconds = [KLINEVOL,KLINEMACD,KLINEKDJ,KLINERSI]
                    self!.secondString = seconds[value.tag - 2]
                    self!.kLineView.configureView(data: self!.kLineList, isNew: true, mainDrawString: self!.mainString, secondDrawString: self!.secondString, dateType: self!.dateType, lineType: self!.trendType)
                }
            }
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
    }
    
    func updateDeppth(){
        
        kLineDepthView.updateShow(coinBuyDatas: depthBuys, coinSellDatas: depthSells)
    }
    
    func updateTimeBtnState(){
        
        for button in self.timeBtnArray {
            button.isSelected = false
        }
    }
    func updateDepthState(isSelect: Bool){
        
        self.isShowDepth = isSelect
        self.deepthBtn.isSelected = isSelect
        self.kLineDepthView.isHidden = !isSelect
    }

    func setupUI(){
        
        addSubview(klineTopV)
        addSubview(kLineView)
        addSubview(klineBottomV)
        klineTopV.addSubview(timeView)
        klineTopV.addSubview(moreBtn)
        klineTopV.addSubview(deepthBtn)
        klineTopV.addSubview(lineView)
        klineTopV.addSubview(toolBtn)
        kLineView.addSubview(kLineDepthView)
    }
    func setupConstraints(){
        
        klineTopV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
        kLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(timeView.snp.bottom)
            make.height.equalTo(355)
        }
        klineBottomV.snp.makeConstraints { make in
            make.top.equalTo(kLineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        kLineDepthView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        let moreW = (SCREEN_WIDTH - timeView.width)/3
        moreBtn.frame = CGRect(x: timeView.maxX, y: 0, width: moreW, height: timeView.height)
        deepthBtn.frame = CGRect(x: moreBtn.maxX, y: 0, width: moreW, height: timeView.height)
        toolBtn.frame = CGRect(x: deepthBtn.maxX, y: 0, width: moreW, height: timeView.height)
        lineView.frame = CGRect(x: deepthBtn.maxX - 0.5, y: 12, width: 0.5, height: timeView.height - 24)
    }
    
    
    lazy var kLineDepthView: KDepthView = {

        let kLineDepthV = KDepthView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 355))
        kLineDepthV.isHidden = true
        return kLineDepthV
    }()
    
    lazy var timeMap:[String:String] = {
        let map = [KLINETIMEMinLine:"1m", KLINETIME15Min:"15m", KLINETIME1Hour:"1h",
                     KLINETIME4Hour:"4h", KLINETIME1Day:"1d", KLINETIME1Week:"1w"]
        return map
    }()
    
    lazy var klineTopV: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var kLineView: XLKLineView = {
        
        let defaults = UserDefaults.standard
        let klineShowHeight = defaults.float(forKey: "KLineShowHeightKey")
        var vshowLineH = 355//HSWindowAdapter.calculateHeight(input: 355)
//        if(klineShowHeight > 0 && klineShowHeight != nil){
//            vshowLineH =  HSWindowAdapter.calculateHeight(input: CGFloat(((klineShowHeight + 0.5)/1.0) * 355))
//        }
        let kLineView = XLKLineView(frame: CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH), height: vshowLineH))
        kLineView.backgroundColor = UIColor.xlChart.color(rgba: "#1E1E1E")
        kLineView.kLineViewDelegate = self
        return kLineView
    }()

    lazy var klineBottomV: UIView = {
        
        let view = UIView()
        let indexs = [KLINE_MA, KLINE_BOLL, KLINE_VOL,
                     KLINE_MACD, KLINE_KDJ, KLINE_RSI,"CoinDetailExpand"]
        let btnW = SCREEN_WIDTH / CGFloat(indexs.count)
        let btnH = 25
        var idx: Int = 0
        
        for str in indexs {
            let btn = UIButton()
            if(idx < 6){
                btn.setTitle(str, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
                btn.setTitleColor(UIColor.hexColor("ffffff"), for: .selected)
            }else{
                btn.setImage(UIImage.init(named: str), for: .normal)
            }
            btn.frame = CGRect(x: (idx * Int(btnW)), y: 0, width: Int(btnW), height: btnH)
            btn.tag = idx
            view.addSubview(btn)
            if(idx < 2){
                self.indexBtnArray.append(btn)
            }else{
                self.indexSecondBtns.append(btn)
            }
            if(idx == 0 || idx == 2){
                btn.isSelected = true
            }
            idx += 1
        }
        return view
    }()
    
    lazy var timeView: UIView = {
        
        let btnH = 40
        let timeW = SCREEN_WIDTH * 0.6
        let timeView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(timeW), height: btnH))
        let times = [KLINETIMEMinLine, KLINETIME15Min, KLINETIME1Hour,
                     KLINETIME4Hour, KLINETIME1Day]
        let btnW: CGFloat = timeView.width / CGFloat(times.count)
        
        var idx: Int = 0
        for str in times {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
            btn.setTitleColor(UIColor.hexColor("ffffff"), for: .selected)
            btn.frame = CGRect(x: CGFloat(idx) * btnW, y: 0, width: btnW, height: CGFloat(btnH))
            btn.tag = idx
            timeView.addSubview(btn)
            self.timeBtnArray.append(btn)
            if(idx == 1){
                btn.isSelected = true
            }
            idx += 1
        }
        return timeView
    }()
    
    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("更多", for: .normal)
//        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    lazy var deepthBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("深度", for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.hexColor("979797"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    lazy var toolBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "klinemore"), for: .normal)
        return btn
    }()
    
    lazy var lineView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.hexColor("979797")
        return view
    }()
    
    lazy var indexBtnArray = [UIButton]()
    lazy var indexSecondBtns = [UIButton]()
    lazy var timeBtnArray = [UIButton]()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HSCoinContentView: XLKLineViewProtocol {
    func XLKLineViewLoadMore() {
        //print("加载更多....")
    }
    
    func XLKLineViewHideCrossDetail() {
        //print("隐藏十字线")
        //TODO1
//        self.setupCrossDetailHide(hide: true)
    }
    
    func XLKLineViewLongPress(model: XLKLineModel, preClose: CGFloat) {
//        print("长按显示")
        //TODO2
//        self.detailView.bind(model: model, preClose: preClose)
//        self.setupCrossDetailHide(hide: false)
    }
    
    func XLKLineViewLongPress(model: XLKLineModel, preClose: CGFloat, point: CGPoint) {
        //TODO3
//        if(detailView.y > vShowLine.y){
//            //vertical
//            let updateX = (point.x > (SCREEN_WIDTH*0.5)) ? 10 : (SCREEN_WIDTH - detailView.width - 10)
//            detailView.x = updateX
//        }else{
//            detailView.x = 0
//        }
    }
}



