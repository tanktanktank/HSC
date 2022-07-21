//
//  WebViewController.swift
//  
//
//  Created by AMYZ0345 on 2021/11/17.
//

import UIKit
import WebKit

import RxSwift

class WebViewController: BaseViewController {
    
    
    
    /* 忽略标题 */
    var ignoreTitle : Bool = true
    
    ///进度条
    lazy var progressView : UIProgressView = {
        let view = UIProgressView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1)
        view.backgroundColor = .hexColor("FCD283")
        return view
    }()
    ///返回按钮
    lazy var backButton : UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(backButtonClick))

        return btn
    }()
    
    var urlStr : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .hexColor("1E1E1E")
        setUI()
        self.wkWebView.load(URLRequest(url: URL(string: urlStr) ?? URL(fileURLWithPath: "")))
    }
    

    func dealwithToken() {
        
//        let token =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjUzLCJuaWNrbmFtZSI6ImJuNTIyMjgzIiwicGhvbmUiOiIxNzY4ODkxMjg0OSIsImVtYWlsIjoiIiwiZXhwIjoxNjU4MzA2Njk1LCJpc3MiOiJydWllY2Jhc3MifQ.ynsQFl-qiaEmorR-iHLstXsZdb-Z1I9cifEoe83APRw"
        let token = Archive.getToken()
        let jsStr = "setCIOSToken" + "('" + token + "')"
        wkWebView.evaluateJavaScript(jsStr) { any, error in
//            print("调用完成")
        }
    }
    
    func webConfiguration() -> WKWebViewConfiguration{
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(WeakScriptMessageDelegate(self), name: "getCToken")
        return configuration
    }
    
    
    private let disposeBag = DisposeBag()
    
    @objc lazy var wkWebView : WKWebView = {
        let webFrame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration())
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: SafeAreaTop, right: 0)
        return webView
    }()
}


extension WebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        switch message.name {
            case "getCToken":
                dealwithToken()
        default:
            break
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.navigationItem.leftBarButtonItem = self.backButton
    }
    //（获取页面返回的cookie，然后设置更新）
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let str = "document.cookie"
        webView.evaluateJavaScript(str) { result, error in
            /* 保存cookie */
        }
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        if webView.url?.absoluteString.hasPrefix("http://callback/") {//腾讯地图web组件选取地址
//            let dict = webView.url?.absoluteString
//        }
    }
}
extension WebViewController{
    func setUI(){
        
        self.configartionRxKVO()
        self.view.addSubview(self.wkWebView)
        self.view.addSubview(self.progressView)
        
    }
    @objc func backButtonClick(){
        
    }
}

// MARK: - rx
extension WebViewController {
    
    func configartionRxKVO() {
        

        self.wkWebView.rx.observe(\WKWebView.estimatedProgress).subscribe { [weak self] progress in
            
            if progress == 1 {
                self?.progressView.isHidden = true
                self?.progressView.setProgress(0, animated: false)
            }else{
                self?.progressView.isHidden = false
                self?.progressView.setProgress(Float(progress), animated: true)
            }

        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
        self.wkWebView.rx.observe(\WKWebView.title).subscribe { [weak self] webTitle in
            
            if let newTitle = webTitle {
                if self?.ignoreTitle ?? false {
                    return
                }
                if newTitle.count > 0 {
                    self?.title = newTitle
                }
            }

        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
    
    }
}
