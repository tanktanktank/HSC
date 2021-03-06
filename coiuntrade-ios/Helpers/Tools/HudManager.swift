//
//  HudManager.swift
//  coiuntrade-ios
//
//  Created by TFR on 2022/3/18.
//

import Foundation
//import SVProgressHUD
enum HudType {
    case activity
    case success
    case error
    case loading
    case info
    case progress
}



class HudManager: NSObject {
    
    
    class func show() {
        self.showNJWProgressHUD(type: .activity, status: "")
    }
    class func showOnlyText(_ text : String) {
        SVProgressHUD.dismiss()
        LoadingToolView.show(text: text)
    }
    class func showSuccess(_ status: String) {
        self.showNJWProgressHUD(type: .success, status: status)
    }
    class func showError(_ status: String) {
        self.showNJWProgressHUD(type: .error, status: status)
    }
    class func showLoading(_ status: String) {
        self.showNJWProgressHUD(type: .loading, status: status)
    }
    class func showInfo(_ status: String) {
        self.showNJWProgressHUD(type: .info, status: status)
    }
    class func showProgress(_ status: String, _ progress: CGFloat) {
        self.showNJWProgressHUD(type: .success, status: status, progress: progress)
    }
    class func dismissHUD(_ delay: TimeInterval = 0) {
        SVProgressHUD.dismiss(withDelay: delay)
    }
}
extension HudManager{
    
    class func showNJWProgressHUD(type: HudType, status: String, progress: CGFloat = 0) {
        
//        SVProgressHUD.dismiss()
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14));
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.setBackgroundColor(UIColor.hexColor("6d6d6d", alpha: 0.8))
        SVProgressHUD.setForegroundColor(.white)
//        SVProgressHUD.sets
        switch type {
        case .activity:
            SVProgressHUD.show()
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
        case .error:
            SVProgressHUD.showError(withStatus: status)
        case .loading:
            SVProgressHUD.show(withStatus: status)
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
        case .progress:
            SVProgressHUD.showProgress(Float(progress), status: status)
        }
    }
}
enum LoadingPositionType {
    case centerType, bottomType
}
class LoadingToolView: UIView {
    static let initTool: LoadingToolView = LoadingToolView.initView()
    
    // MARK: -?????????????????????
    /// ????????????
    static let singleRowHeight: CGFloat = 30
    /// ??????????????????
    static let minTextWidth: CGFloat = 50.0
    /// ??????????????????
    static let maxTextWidth: CGFloat = SCREEN_WIDTH - 100.0
    /// ?????????????????? ?????????????????? ??????????????????
    static var isAutoHidden: Bool = true
    /// ?????????????????? ?????????????????? ??????1????????? ???????????????isAutoHidden??????
    static var autoHiddenTime: Double = 1.5
    /// ???????????? ?????????????????? ???????????????
    static var positionType: LoadingPositionType = LoadingPositionType.centerType
    /// ????????????????????? ??????5
    static var textCornerRadius: CGFloat = 10.0
    /// ????????????????????? ??????
    static var textViewBgColor: UIColor = UIColor.hexColor("1E1E1E")
    /// ????????????
    static var fontSize: CGFloat = 12.0
    /// ????????????
    static var textColor: UIColor = UIColor.white
    
    // MARK: -?????????????????????
    /// ??????????????????
    static let loadViewWH: CGFloat = 75.0
    /// ?????????????????? ?????????
    static let loadTextViewWH: CGFloat = 100.0
    /// ????????????????????? ??????10.0
    static var loadViewCornerRadius: CGFloat = 10.0

    // MARK: -????????????
    /// ??????tag???
    private let tooltag = 121212
    /// ?????????????????? ?????????NO
    private var isClickHidden: Bool = false
    /// ????????????loading
    private var isShowLoading: Bool = true
    /// ??????????????????????????????
    private var isHiddenBefore: (()->Void)?
    
    /// ???????????????????????????
    lazy var isAleradlyExit: Bool = {
        
        let fatherWindow = UIApplication.shared.keyWindow
        return fatherWindow?.viewWithTag(tooltag) != nil
    }()
    
    /// ?????????
    class func initView() -> LoadingToolView {
        
        let tool = LoadingToolView.init(frame: UIScreen.main.bounds)
        tool.tag = tool.tooltag
        tool.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        tool.alpha = 0.0
        
        return tool
    }
    
    //MARK:- ?????????????????? ???????????????????????? ?????????????????????????????????
    static func showLoading(text: String?, isClickHidden: Bool? = false) {
        
        LoadingToolView.hidden {
            
            let tool = LoadingToolView.initTool
            tool.isShowLoading = true
            if let isClickHidden = isClickHidden {
                tool.isClickHidden = isClickHidden
            }
            
            let fatherWindow = UIApplication.shared.keyWindow
            fatherWindow?.addSubview(tool)
            
            if let text = text {
                
                // ??????
                tool.loadingTool.center = CGPoint.init(x: LoadingToolView.loadTextViewWH / 2.0, y: LoadingToolView.loadTextViewWH / 2.0 - 10.0)
                tool.loadingTextView.addSubview(tool.loadingTool)
                tool.addSubview(tool.loadingTextView)
                
                // ??????
                tool.alertLabel.backgroundColor = UIColor.clear
                tool.updateLabelFrame(text: text, maxSize: CGSize.init(width: LoadingToolView.loadTextViewWH - 10.0, height: LoadingToolView.singleRowHeight))
                
                tool.alertLabel.center = CGPoint.init(x: LoadingToolView.loadTextViewWH / 2.0, y: LoadingToolView.loadTextViewWH / 2.0 + 30.0)
                tool.loadingTextView.addSubview(tool.alertLabel)
            
            } else {
                
                // ??????
                tool.loadingTool.center = CGPoint.init(x: LoadingToolView.loadViewWH / 2.0, y: LoadingToolView.loadViewWH / 2.0)
                tool.loadingView.addSubview(tool.loadingTool)
                
                tool.addSubview(tool.loadingView)
            }
            tool.loadingTool.startAnimating()

            UIView.animate(withDuration: 0.3) {
                
                tool.alpha = 1.0
                
                if let _ = text {
                    
                    tool.loadingTextView.alpha = tool.alpha
                    tool.alertLabel.alpha = tool.alpha

                } else {
                    
                    tool.loadingView.alpha = tool.alpha
                }
            }
        }
    }
    
    //MARK:- ??????????????????
    static func show(text: String?) {
        
        LoadingToolView.hidden {
            
            let tool = LoadingToolView.initTool

            let fatherWindow = UIApplication.shared.keyWindow
            fatherWindow?.addSubview(tool)
            
            // ??????
            tool.alertLabel.backgroundColor = LoadingToolView.textViewBgColor.withAlphaComponent(0.8)
            tool.addSubview(tool.alertLabel)
            tool.updateLabelFrame(text: text, maxSize: CGSize.init(width: LoadingToolView.maxTextWidth, height: SCREEN_HEIGHT))

            if LoadingToolView.positionType == .centerType {
                
                tool.alertLabel.center = CGPoint.init(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT / 2.0)
                
            } else {
                
                tool.alertLabel.center = CGPoint.init(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT - tool.alertLabel.frame.size.height - 60.0)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                
                tool.alpha = 1.0
                tool.alertLabel.alpha = tool.alpha
                
            }) { (isOk) in
                
                if LoadingToolView.isAutoHidden {
                    
                    self.perform(#selector(hidden), with: nil, afterDelay:LoadingToolView.autoHiddenTime)
                }
            }
        }
    }
    
    //MARK:- ????????????
    @objc static func hidden(isCompetion: (()->Void)? = nil) {
        
        let tool = LoadingToolView.initTool
        tool.isHiddenBefore = isCompetion
        
        if tool.isShowLoading {
            tool.loadingTool.stopAnimating()
        }
        UIView.animate(withDuration: 0.3, animations: {
            
            tool.alpha = 0.0
            tool.alertLabel.alpha = tool.alpha
            if tool.isShowLoading {
                
                tool.loadingTextView.alpha = tool.alpha
                tool.loadingView.alpha = tool.alpha
                tool.isShowLoading = false
            }
            
        }) { (isOk) in
            
            tool.removeFromSuperview()
            tool.isHiddenBefore?()
        }
    }

    /// ????????????
    func updateLabelFrame(text: String?, maxSize: CGSize) {

        let tool = LoadingToolView.initTool

        let size = text?.getSize(maxSize: maxSize)
        var newTextFrame = tool.alertLabel.frame
        newTextFrame.size.width = size!.width+10
        newTextFrame.size.height = size!.height
        tool.alertLabel.frame = newTextFrame
        tool.alertLabel.text = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if LoadingToolView.initTool.isClickHidden {
            
            LoadingToolView.hidden()
        }
    }
    
    //MARK: -?????????
    /// ???????????????
    lazy var alertLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: LoadingToolView.fontSize)
        label.textColor = LoadingToolView.textColor
        
        label.layer.cornerRadius = LoadingToolView.textCornerRadius
        label.layer.masksToBounds = true
        
        return label
    }()
    /// ??????????????? ?????????
    lazy var loadingTextView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: LoadingToolView.loadTextViewWH, height: LoadingToolView.loadTextViewWH))
        view.center = CGPoint.init(x: SCREEN_WIDTH / 2.0, y:  SCREEN_HEIGHT / 2.0)
        view.backgroundColor = LoadingToolView.textViewBgColor
        view.layer.cornerRadius = LoadingToolView.loadViewCornerRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    /// ???????????????
    lazy var loadingView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: LoadingToolView.loadViewWH, height: LoadingToolView.loadViewWH))
        view.center = CGPoint.init(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT / 2.0)
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = LoadingToolView.loadViewCornerRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    /// ????????????
    lazy var loadingTool: UIActivityIndicatorView = {
        let tool = UIActivityIndicatorView.init(style: .whiteLarge)
        tool.hidesWhenStopped = true
        
        return tool
    }()
}

extension String {
    
    func getSize(maxSize: CGSize) -> CGSize {
        
        if self.isEmpty {
            return CGSize.init(width: LoadingToolView.minTextWidth, height: LoadingToolView.singleRowHeight)
        }
        let str: NSString = NSString.init(string: self)
        var rect = str.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: LoadingToolView.fontSize)], context: nil)

        rect.size.width < LoadingToolView.minTextWidth ? (rect.size.width = LoadingToolView.minTextWidth) : (rect.size.width += 15.0)
        
        rect.size.height < LoadingToolView.singleRowHeight ? (rect.size.height = LoadingToolView.singleRowHeight) : (rect.size.height += 8.0)

        return rect.size
    }
}
