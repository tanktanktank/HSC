//
//  KLineHorizon.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/15.
//

import UIKit
import WebKit

typealias KLineHoriViewPass = (Int)->()

class KLineHoriView: UIView {

    var curMain = "MA"
    var curTime = "15m"
    weak var model : CoinModel!
    var pass:KLineHoriViewPass?
    private var isShowDraw = false
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .hexColor("1E1E1E")
        self.addSubview(self.webView)
        self.addSubview(self.backBtn)
        self.addSubview(self.coinView)
        self.addSubview(self.timeView)
        self.addSubview(self.indexView)
    
        let path = "http://8.218.110.85:6225/#/"
//        let path = "http://192.168.3.44:8080/#/announcement/kline"
        let url = URL.init(string: path)
        let request = URLRequest.init(url: url!)
        webView.load(request)
        setupEvent()
    }

    func setupEvent(){
        
        self.backBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                self?.pass?(1)
//                UIView.animate(withDuration: 0.18, delay: 0.0) {
//                    self!.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: self!.width, height: self!.height)
//                }
            }).disposed(by: disposeBag)
        
        
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
            
            let klineType = self!.timeMap[value.titleLabel?.text ?? "15分钟"]
            self?.curTime = klineType!
            self!.dealwithKline(coin: self!.model.coin, currency: self!.model.currency, kline_type: klineType!, mainName: self!.indexMap[self!.curMain]!, secondName: self!.indexMap["VOL"]!, isMain: "1", isTime: "1", isFirst: "0")
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
            let mainIndex = self!.indexMap[value.titleLabel?.text ?? "MA"]!
            self!.curMain = value.titleLabel?.text ?? "MA"
            self!.dealwithKline(coin: self!.model.coin, currency: self!.model.currency, kline_type: self!.curTime, mainName: mainIndex, secondName: self!.indexMap["VOL"]!, isMain: "1", isTime: "0", isFirst: "0")
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
        
        
        ///幅图指标事件
        let btnSecondIndexs = self.indexSecondBtns.map { $0 }
        let selSecIndexBtn = Observable.from(
            btnSecondIndexs.map { button in button.rx.tap.map {button} }
        ).merge()
        selSecIndexBtn.map {[weak self] value in
            
            let tapIndex = value.titleLabel?.text ?? "VOL"
            
            if(tapIndex == "画"){
                
                self?.dealWithDraw()
            }else{
                var idx = 0
                var isExist = false
                for secondIndex in self!.selectSeconds{
                    
                    if(secondIndex == tapIndex){
                        self!.selectSeconds.remove(at: idx)
                        isExist = true
                        break
                    }
                    idx += 1
                }
                if(!isExist){
                    self?.selectSeconds.append(tapIndex)
                }
                for button in btnSecondIndexs {
                    button.isSelected = false
                    if(self!.selectSeconds.contains((button.titleLabel?.text)!)){
                        button.isSelected = true
                    }
                }
                 
                self!.dealwithKline(coin: self!.model.coin, currency: self!.model.currency, kline_type: self!.curTime, mainName: self!.indexMap[self!.curMain]!, secondName: self!.indexMap[tapIndex]!, isMain: "0", isTime: "0", isFirst: "0")
            }

        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
    }

    func updateCoin(coinName: String, price: String , percent: String , isUp: Bool){
        
        let nameLab = coinView.viewWithTag(1024) as! UILabel
        let priceLab = coinView.viewWithTag(1025) as! UILabel
        let percentLab = coinView.viewWithTag(1026) as! UILabel
        nameLab.text = coinName
        priceLab.text = price
        percentLab.text = percent
        
        if(isUp){
            priceLab.textColor = UIColor.hexColor("F03851",alpha: 0.9)
            percentLab.textColor = UIColor.hexColor("F03851",alpha: 0.9)
        }else{
            priceLab.textColor = UIColor.hexColor("02C078",alpha: 0.9)
            percentLab.textColor = UIColor.hexColor("02C078",alpha: 0.9)
        }
    }
    
    func updateWebFrame(){
        let trans = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2.0))
        webView.transform = trans
        webView.center = CGPoint(x: self.centerX - self.width, y: self.centerY)
        webView.frame = CGRect(x: webView.frame.origin.x, y: webView.frame.origin.y + 44, width: webView.frame.size.width - 54, height: webView.frame.size.height - 64 - 44)
    
        backBtn.frame = CGRect(x: webView.maxX, y: webView.maxY, width: 54, height: 44)
        
        timeView.transform = trans
        timeView.frame = CGRect(x: webView.maxX, y: webView.y, width: timeView.height, height: timeView.width)
        
        coinView.transform = trans
        coinView.frame = CGRect(x: timeView.maxX, y: webView.y, width: coinView.height, height: coinView.width)
        
        indexView.transform = trans
        indexView.frame = CGRect(x: webView.x, y: webView.maxY, width: webView.width, height: 40)
        
        timeView.addCorner(conrners: [.topLeft,.topRight], radius: 4)
        indexView.addCorner(conrners: .topRight, radius: 4)
    }
    
    func dealwithKline(coin: String, currency: String, kline_type: String, mainName: String, secondName: String, isMain: String, isTime: String, isFirst: String) {

        //分钟:m  小时:h  天:d  周:w
        //第一次进来 isFirst = 1取所有指标出来展示 secondName=“vol,macd” secondName="vol"这里传单个
        // 先判断 isFirst,isTime, isMain这个最后 判断更新主幅图
        /*
         // 先判断 isFirst,isTime, isMain这个最后 判断更新主幅图
         isFirst = 1 代表 第一次进来，，取所有数据出来 展示，就不判断 isTime,isMain了
         isTime = 1 事件交互，，，就不用判断 isMain了，直接取时间 出来更新
         isMain = 1 最后判断，，到了这里，，isMain = 1 取主图指标 出来操作，，= 0 取幅图 指标出来操作
         */
        //{  "mainName": "MA" ,  "secondName":"VOL" , "kline_type":"15m" , "isFirst":"1" ,"isMain":"1","isTime":"1" , "coin":"BTC","currency":"USDT"}
        var newJS = [String: String]()
        newJS["coin"] = coin//"BTC"
        newJS["currency"] = currency//"USDT"
        newJS["kline_type"] = kline_type//"1h"
        newJS["mainName"] = mainName//self.indexMap[KLINEBOLL]
        newJS["secondName"] = secondName//self.indexMap[KLINEKDJ]
        newJS["isMain"] = isMain//"1"
        newJS["isTime"] = isTime//"1"
        newJS["isFirst"] = isFirst//"1"

        guard let data = try? JSONSerialization.data(withJSONObject: newJS, options: []) else { return }
        let jsonString:String = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)! as String
        let jsStr = "upShowKline" + "(" + jsonString + ")"
        webView.evaluateJavaScript(jsStr, completionHandler: nil)
    }
    
    func dealWithDraw(){
        
        self.isShowDraw = !self.isShowDraw
        let show = self.isShowDraw ? "1" : "0"
        let jsStr = "showDraw" + "(" + show + ")"
        webView.evaluateJavaScript(jsStr, completionHandler: nil)
    }
    

    lazy var webView: WKWebView = {

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "getDataFromNativeIos")

        var webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: SCREEN_HEIGHT ,
                                              height: SCREEN_WIDTH ),
                                configuration: configuration)
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        return webView
    }()
    
    lazy var backBtn: UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "CoinDetailShrink"), for: .normal)
        return btn
    }()
    
    lazy var coinView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: SCREEN_HEIGHT - 44 - 64))
//        view.backgroundColor = .lightGray
        
        let nameLab = UILabel()
        nameLab.font = UIFont.systemFont(ofSize: 15)
        nameLab.textColor = UIColor.hexColor("ffffff")
        nameLab.text = "BTC/USDT"
        nameLab.tag = 1024
        
        let priceLab = UILabel()
        priceLab.font = UIFont.systemFont(ofSize: 13)
        priceLab.textColor = UIColor.hexColor("db354c")
        priceLab.text = "2600"
        priceLab.tag = 1025
        
        let amplitudeLab = UILabel()
        amplitudeLab.font = UIFont.systemFont(ofSize: 13)
        amplitudeLab.textColor = UIColor.hexColor("db354c")
        amplitudeLab.text = "+8.88%"
        amplitudeLab.tag = 1026
        
        view.addSubview(nameLab)
        view.addSubview(priceLab)
        view.addSubview(amplitudeLab)
        
        nameLab.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        priceLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(nameLab.snp.right).offset(16)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        amplitudeLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(priceLab.snp.right).offset(16)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var timeView: UIScrollView = {
        
        let btnH = 24.0
        let timeView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: btnH, height: SCREEN_HEIGHT - 44 - 64))
        timeView.backgroundColor = UIColor.hexColor("282828") //.black.withAlphaComponent(0.88)
        
        let times = [KLINETIMEMinLine, KLINETIME15Min, KLINETIME1Hour,
                     KLINETIME4Hour, KLINETIME1Day,KLINETIME1Week]
        let btnW: CGFloat = timeView.height / 6
        timeView.contentSize = CGSize(width: Int(btnW) * times.count, height: 1)
        
        var idx: Int = 0
        for str in times {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            btn.setTitleColor(UIColor.hexColor("ebebeb"), for: .normal)
            btn.setTitleColor(UIColor.hexColor("fcd283"), for: .selected)
            btn.frame = CGRect(x: CGFloat(idx) * btnW, y: 0, width: btnW, height: btnH)
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
    
    lazy var indexView: UIScrollView = {
        
        let scView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 34))
        scView.backgroundColor = UIColor.hexColor("282828") //.orange
        let indexs = [KLINE_MA, KLINE_BOLL, KLINE_VOL,
                     KLINE_MACD, KLINE_KDJ, KLINE_RSI,"画"]
        let btnW: Int = 40
        let btnH = (Int(SCREEN_WIDTH) - 54)/indexs.count // 54 = 30 + 24
        scView.contentSize = CGSize(width: Int(btnW) * indexs.count, height: 1)
        var idx: Int = 0
        
        for str in indexs {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.setTitleColor(UIColor.hexColor("ebebeb"), for: .normal)
            btn.setTitleColor(UIColor.hexColor("fcd283"), for: .selected)
            btn.frame = CGRect(x: 0, y: idx * btnH, width: btnW, height: btnH)
            btn.tag = idx
            scView.addSubview(btn)
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
        return scView
    }()
    
    
    lazy var timeBtnArray = [UIButton]()
    lazy var indexBtnArray = [UIButton]() //主图集合
    lazy var indexSecondBtns = [UIButton]() //幅图集合

    lazy var selectSeconds = [String]()
    
    lazy var indexMap:[String:String] = {
       
        let map = [KLINE_MA:"Moving Average", KLINE_BOLL:"Bollinger Bands", KLINE_VOL:"Volume",
                 KLINE_MACD:"MACD", KLINE_KDJ:"Stochastic", KLINE_RSI:"Relative Strength Index"]
        
        return map
    }()
    lazy var timeMap:[String:String] = {
       
        let map = [KLINETIMEMinLine:"1m", KLINETIME15Min:"15m", KLINETIME1Hour:"1h",
                     KLINETIME4Hour:"4h", KLINETIME1Day:"1d", KLINETIME1Week:"1w"]
        
        return map
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KLineHoriView: WKNavigationDelegate {
    ///在网页加载完成时调用js方法
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("upShowKline('js你好,我是从Swift传来的')", completionHandler: nil)
    }
}

extension KLineHoriView: WKScriptMessageHandler {
    ///接收js调用方法
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        let body = message.body
        if message.name == "logger" {
            print("JS log:\(body)")
            return
        }
        ///message.name是约定好的方法名,message.body是携带的参数
        switch message.name {
        case "getDataFromNativeIos":
            //TODO: 传进来的数据要动态
            dealwithKline(coin: self.model.coin, currency: self.model.currency, kline_type: self.curTime, mainName: self.indexMap[self.curMain]!, secondName: self.indexMap["VOL"]!, isMain: "1", isTime: "1", isFirst: "1")
        default:
            break
        }
    }
}

///内存管理,使用delegate类防止不释放
class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?
    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
    deinit {
        print("WeakScriptMessageDelegate is deinit")
    }
}
