//
//  KLineHorizon.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/15.
//

import UIKit
import WebKit

class KLineHoriView: UIView {

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .hexColor("1E1E1E")
        self.addSubview(self.webView)
        self.addSubview(self.backBtn)
        self.addSubview(self.coinView)
        self.addSubview(self.timeView)
        self.addSubview(self.indexView)
        let path = "http://8.218.110.85:6225/#/announcement/kline"
        let url = URL.init(string: path)
        let request = URLRequest.init(url: url!)
        webView.load(request)
        
        setupEvent()
    }

    func setupEvent(){
        
        self.backBtn.rx.tap
            .subscribe(onNext: { [weak self] in

                UIView.animate(withDuration: 0.18, delay: 0.0) {
                    self!.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: self!.width, height: self!.height)
                }
            }).disposed(by: disposeBag)
        
        
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
//            switch value.tag {
//                case 1:
//                    self.marketsViewModel.reqModel.kline_type = "3m"
//                default:
//                    self.marketsViewModel.reqModel.kline_type = "1m"
//            }
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
        
        let buttonIndexs = self.indexBtnArray.map { $0 }
        let choIndexButton = Observable.from(
            buttonIndexs.map { button in button.rx.tap.map {button} }
        ).merge()
        choIndexButton.map { value in
            
            for button in buttonIndexs {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func dealwithKline() {

        var newJS = [String: String].init()
        newJS["coin"] = "BTC"
        newJS["currency"] = "USDT"
        newJS["kline_type"] = "30m"
        guard let data = try? JSONSerialization.data(withJSONObject: newJS, options: []) else { return }
        let jsonString:String = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)! as String
        let jsStr = "upShowKline" + "(" + jsonString + ")"
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
        view.backgroundColor = .lightGray
        
        let nameLab = UILabel()
        nameLab.font = UIFont.systemFont(ofSize: 15)
        nameLab.textColor = UIColor.hexColor("ffffff")
        nameLab.text = "BTC/USDT"
        
        let priceLab = UILabel()
        priceLab.font = UIFont.systemFont(ofSize: 13)
        priceLab.textColor = UIColor.hexColor("db354c")
        priceLab.text = "2600"
        
        let amplitudeLab = UILabel()
        amplitudeLab.font = UIFont.systemFont(ofSize: 13)
        amplitudeLab.textColor = UIColor.hexColor("db354c")
        amplitudeLab.text = "+8.88%"
        
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
            if(idx == 2){
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
            self.indexBtnArray.append(btn)
            if(idx == 2){
                btn.isSelected = true
            }
            idx += 1
        }
        return scView
    }()
    
    lazy var timeBtnArray = [UIButton]()
    lazy var indexBtnArray = [UIButton]()
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
            dealwithKline()
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
