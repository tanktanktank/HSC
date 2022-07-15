//
//  NormalConstant.swift
//  test
//
//  Created by tfr on 2022/4/18.
//
import UIKit
import Foundation

typealias NormalBlock = (()->())
let BTN_W :CGFloat = 200
// 屏幕宽度
let SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.size.width;
// 屏幕高度
let SCREEN_HEIGHT: CGFloat  = UIScreen.main.bounds.size.height;
 
// 状态栏高度
let STATUSBAR_HIGH : CGFloat = is_iPhoneXSeries() ? 44.0 : 20.0;
 
let SafeAreaTop : CGFloat = is_iPhoneXSeries() ? 24.0 : 0.0;
let SafeAreaBottom : CGFloat = is_iPhoneXSeries() ? 34.0 : 0.0;


// 导航栏高度
let NAV_HIGH : CGFloat = 44.0;
//  TOp高度
let TOP_HEIGHT : CGFloat = (STATUSBAR_HIGH + NAV_HIGH);
// 左右间距
let LR_Margin : CGFloat = 15.0
// tabbar高度
let TABBAR_HEIGHT : CGFloat = is_iPhoneXSeries() ? 83.0 : 49.0;
 
// tabbar 安全区域的高度
let TABBAR_HEIGHT_SAFE : CGFloat = is_iPhoneXSeries() ? 34.0 : 0.0;
// AppDelegate
let APPDELEGATE = UIApplication.shared.delegate;
// Window
let KWINDOW : UIWindow = (UIApplication.shared.delegate?.window ?? UIWindow()) ?? UIWindow()
 
// Default
let USER_DEFAULTS = UserDefaults.standard;
 
// 沙盒路径
let DOCUMENT_PATH = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
// 字符串是否为空
func is_URLString(ref: String) -> (Bool) {
    var result = false;
    if (!ref.isEmpty && (ref.hasPrefix("https://") || ref.hasPrefix("http://"))) {
        result = true;
    }
    return result;
}
func is_Blank(ref: String) -> (Bool) {
    let _blank = ref.allSatisfy{
        let _blank = $0.isWhitespace
        return _blank
    }
    return _blank
}
 
// 字符串中是否包含某字符串
func StringContainsSubString(string: String, subString: String) -> (Bool) {
    let range = string.range(of: subString);
    if (range == nil) {
        return false;
    }
    return true;
}
 
// 十进制颜色
func RGBCOLOR(r: CGFloat, g: CGFloat, b: CGFloat) -> (UIColor) {
    return RGBACOLOR(r: r, g: g, b: b, a: 1.0);
}
 
func RGBACOLOR(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> (UIColor) {
    return UIColor(red: r, green: g, blue: b, alpha: a);
}
// 16进制颜色转UIColor
func HEXCOLOR(c: UInt64) -> (UIColor) {
    let redValue = CGFloat((c & 0xFF0000) >> 16)/255.0
    let greenValue = CGFloat((c & 0xFF00) >> 8)/255.0
    let blueValue = CGFloat(c & 0xFF)/255.0
    return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0);
}

//创建一个错误
func error(_ message: String, code: Int = 0, domain: String = "com.example.error", function: String = #function, file: String = #file, line: Int = #line) -> NSError {

    let functionKey = "\(domain).function"
    let fileKey = "\(domain).file"
    let lineKey = "\(domain).line"

    let error = NSError(domain: domain, code: code, userInfo: [
        NSLocalizedDescriptionKey: message,
        functionKey: function,
        fileKey: file,
        lineKey: line
    ])

    // Crashlytics.sharedInstance().recordError(error)

    return error
}


 
// 字体
func FONTSIZE(size: CGFloat) -> (UIFont) {
    return UIFont.systemFont(ofSize: CGFloat(size));
}
func SEMIBOLDFONT(size: CGFloat) -> (UIFont) {
    return UIFont.systemFont(ofSize: size, weight: .semibold)
}
func FONTR(size: CGFloat) -> (UIFont) {
    return UIFont.systemFont(ofSize: size, weight: .regular)
}
func FONTM(size: CGFloat) -> (UIFont) {
    return UIFont.systemFont(ofSize: size, weight: .medium)
}
func FONTB(size: CGFloat) -> (UIFont){
    return UIFont.systemFont(ofSize: size, weight: .bold)
}
///交易对字体
func FONTBINCE(size: CGFloat) -> (UIFont){
    return UIFont.init(name: "binance_plex_medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
}

//[UIFont fontWithName:@"DIN-Bold" size:20.0];
func FONTDIN(size: CGFloat) -> (UIFont){
    return UIFont.init(name: "DINAlternate-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
}

func PlaceholderImg() -> (UIImage){
    return UIImage(named:"icon_placeholder") ?? UIImage()
}
func PlaceholderGroupImg() -> (UIImage){
    return UIImage(named:"group_icon_default") ?? UIImage()
}

/// 获取同比例下的高度
/// - Parameters:
///   - image: <#image description#>
///   - newWidth: <#newWidth description#>
/// - Returns: <#description#>
func getImgSameScaleHeight(image: UIImage, newWidth: CGFloat) -> CGFloat {
      
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
 
      
    return newHeight
}

/// 获取图片总比例下的宽度
/// - Parameters:
///   - image: <#image description#>
///   - newHeight: <#newHeight description#>
/// - Returns: <#description#>
func getImgSameScaleHeight(image: UIImage, newHeight: CGFloat) -> CGFloat {
      
    let scale = newHeight / image.size.height
    let newWidth = image.size.width * scale
 
      
    return newWidth
}
// 适配 判断系统版本
func AdaptiveiOSSystem(version: Float) -> (Bool) {
    let sysVer = Float(UIDevice.current.systemVersion) ?? 0.0;
    if (sysVer >= version) {
        return true;
    }
    return false;
}
 
// 判断是否设备是iphoneX系列
func is_iPhoneXSeries() -> (Bool) {
    let boundsSize = UIScreen.main.bounds.size;
    // iPhoneX,XS
   
    if boundsSize.width >= 375 && boundsSize.height >= 812 {
        return true;
    }
    
   
    return false;
}




//MARK: - 查找顶层控制器、
/// 获取顶层控制器 根据window
func getTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.keyWindow
   
    //是否为当前显示的window
    if window?.windowLevel != UIWindow.Level.normal{
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal{
                window = windowTemp
                break
            }
        }
    }

    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}

///根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    
    if VC == nil {
        print("🌶： 找不到顶层控制器")
        return nil
    }
    
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    }
    else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    }
    else {
        // 返回顶控制器
        return VC
    }
}
func getViewController(name: String,identifier: String) -> UIViewController {
    let viewController = UIStoryboard(name: name, bundle: nil)
        .instantiateViewController(withIdentifier: identifier) as UIViewController
      return viewController;
}

///判断是否是邮箱
func checkEmail(email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let isValid = predicate.evaluate(with: email)
    print(isValid ? "正确的邮箱地址" : "错误的邮箱地址")
    return isValid
}

///判断密码格式
func checkPwd(pwd: String) -> Bool {
    let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
//    let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}\$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let isValid = predicate.evaluate(with: pwd)
    print(isValid ? "正确的密码格式" : "错误的密码格式")
    return isValid
}

//MARK: 极验
let API1 = "https://www.geetest.com/demo/gt/register-test"
let API2 = "https://www.geetest.com/demo/gt/validate-test"
