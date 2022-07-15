//
//  BaseNavigationController.swift
//  SaaS
//
//  Created by AMYZ0345 on 2021/10/11.
//

import UIKit

fileprivate var slideEnabledKey = "slideEnabled"

extension UINavigationController {
    /// should slide to back. default is true
    var slideEnabled: Bool {
        set {
            objc_setAssociatedObject(self, &slideEnabledKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &slideEnabledKey) as? Bool {
                return rs
            }
            return true
        }
    }
}

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.configureWithOpaqueBackground()
            barApp.backgroundColor = .hexColor("1E1E1E")//导航条背景色
            //这儿可以设置shadowColor透明或设置shadowImage为透明图片去掉导航栏的黑线
            barApp.shadowColor = UIColor.clear
            barApp.largeTitleTextAttributes = [.foregroundColor:UIColor.hexColor("FFFFFF"),
                                          .font : SEMIBOLDFONT(size: 16)]
            //标题文字颜色
            barApp.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                          NSAttributedString.Key.font:SEMIBOLDFONT(size: 16)]
            navigationBar.scrollEdgeAppearance = barApp;
            navigationBar.standardAppearance = barApp;
            navigationBar.tintColor = .hexColor("FFFFFF")
        }else{
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                 NSAttributedString.Key.font:SEMIBOLDFONT(size: 16)]
            //设置导航栏的背景色
            navigationBar.barTintColor = .hexColor("1E1E1E")
            navigationBar.shadowImage = UIImage()
            // 1.设置导航栏标题属性：设置标题颜色
            navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white,
                .font : SEMIBOLDFONT(size: 16)]
            navigationBar.tintColor = .hexColor("FFFFFF")
            //去除导航栏的下划线
            navigationBar.shadowImage = UIImage(named: "")
        }
        
        //设置状态栏的颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //设置右划手势的代理为自己
        self.interactivePopGestureRecognizer?.delegate = self
//        fullSlide()
    }
    

}

extension BaseNavigationController{
    func fullSlide() {
        guard let recognizer = interactivePopGestureRecognizer else {
            return
        }
        guard let recognizerView = recognizer.view else {
            return
        }

        let targets = recognizer.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else {
            return
        }

        guard let target = targetObjc.value(forKey: "target") else {
            return
        }
        let action = Selector(("handleNavigationTransition:"))
        let fullRecognizer = UIPanGestureRecognizer()
//        fullRecognizer.delegate = self
        recognizerView.addGestureRecognizer(fullRecognizer)
        fullRecognizer.addTarget(target, action: action)
    }
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return slideEnabled && childViewControllers.count > 1
//    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCloseButtonEvent))
            //设置右划返回为true
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func handleCloseButtonEvent(){
        self.popViewController(animated: true)
    }
    
}

extension BaseNavigationController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

//extension BaseNavigationController : UIGestureRecognizerDelegate {
//
//}


//extension BaseNavigationController : QMUICustomNavigationBarTransitionDelegate {
//    func shouldCustomizeNavigationBarTransitionIfHideable() -> Bool {
//        return true
//    }
//
//}



enum NavigationBarStyle {
    ///navbar APP主题
    case theme
    ///navbar 透明
    case clear
    ///navbar 白色的
    case white
}

extension UINavigationController {

func navBarStyle(_ style:NavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            let attrDic = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                 NSAttributedString.Key.font:SEMIBOLDFONT(size: 16)]
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = .hexColor("1E1E1E")
                //基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                //阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                //barApp.shadowColor = nil;
                //标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = barApp
                navigationBar.standardAppearance = barApp
            }else {
                navigationBar.titleTextAttributes = attrDic
                let navBgImg = UIImage.getImageWithColor(color: .hexColor("1E1E1E")).withRenderingMode(.alwaysOriginal)
                
//                let navBgImg = UIImage(named: "nav_back")!.withRenderingMode(.alwaysOriginal)
                
                navigationBar.shadowImage = UIImage()
                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            //透明设置
            navigationBar.isTranslucent = false;
            //navigationItem控件的颜色
            navigationBar.tintColor = .hexColor("1E1E1E")
            
        case .clear:
            navigationBar.barStyle = .black
            let attrDic = [NSAttributedString.Key.foregroundColor: UIColor.white,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = .clear
                //基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                //阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                //barApp.shadowColor = nil;
                //标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = nil
                navigationBar.standardAppearance = barApp
            }else {
                navigationBar.titleTextAttributes = attrDic
                navigationBar.shadowImage = UIImage()
                let navBgImg = UIImage.getImageWithColor(color: UIColor.clear)
//                let navBgImg = UIImage.imgColor(UIColor.clear, CGSize(width: SCREEN_WIDTH, height: NAV_HIGH)).withRenderingMode(.alwaysOriginal)
                
                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            //透明设置
            navigationBar.isTranslucent = true;
            //navigationItem控件的颜色
            //navigationBar.tintColor = .white
            
        case .white:
            
            navigationBar.barStyle = .default
            let attrDic = [NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
 
            if #available(iOS 13.0, *) {
                let barApp = UINavigationBarAppearance()
                barApp.backgroundColor = .white
                //基于backgroundColor或backgroundImage的磨砂效果
                barApp.backgroundEffect = nil
                //阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
                //barApp.shadowColor = nil;
                //标题文字颜色
                barApp.titleTextAttributes = attrDic
                navigationBar.scrollEdgeAppearance = barApp
                navigationBar.standardAppearance = barApp
            }else {
                navigationBar.titleTextAttributes = attrDic
                
                let navBgImg = UIImage.getImageWithColor(color: UIColor.clear)
//                let navBgImg = UIImage.imgColor(UIColor.white, CGSize(width: SCREEN_WIDTH, height: kNav_Height)).withRenderingMode(.alwaysOriginal)
                
                navigationBar.shadowImage = UIImage()
                navigationBar.setBackgroundImage(navBgImg, for: .default)
            }
            //透明设置
            navigationBar.isTranslucent = false;
            //navigationItem控件的颜色
            navigationBar.tintColor = .black
        }
    }
}
