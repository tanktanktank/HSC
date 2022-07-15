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
    
    let disposeBag = DisposeBag()
    
    @objc lazy var wkWebView : WKWebView = {
        let webView = WKWebView()
        webView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: SafeAreaTop, right: 0)
        return webView
    }()
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
