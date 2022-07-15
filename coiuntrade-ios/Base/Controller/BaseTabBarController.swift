//
//  BaseTabBarController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/30.
//

import UIKit

class BaseTabBarController: QMUITabBarViewController {
    
    let tabbarNormalArray = ["Home-no","Markets-no","Trade-no","Futures-no","Wallets-no"]
    let tabbarSeletedArray = ["Home-yes","Markets-yes","Trade-yes","Futures-yes","Wallets-yes"]
//    let titles = ["Home","Markets","Trade","Futures","Wallets"]
//    let tabbarNormalArray = ["Home-no","Markets-no","Trade-no","Wallets-no"]
//    let tabbarSeletedArray = ["Home-yes","Markets-yes","Trade-yes","Wallets-yes"]
    var titles = ["main_bottom_navigation_home".localized(),"main_bottom_navigation_market".localized(),"main_bottom_navigation_exchange".localized(),"tv_market_fetures".localized(),"main_bottom_navigation_wallet".localized()]
    
    var tmpViewControllers : [BaseNavigationController] = []
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showChangeNotify), name: NSNotification.Name(rawValue: "yTabBarChangeNotify"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
    }
    @objc private func showChangeNotify(_ notify: NSNotification) {
            let userInfo = notify.userInfo
        self.selectedIndex = 2
        print("收到通知：\(userInfo)")
    }
    ///更换语言
    @objc func changeLangage(){
        self.titles = ["main_bottom_navigation_home".localized(),"main_bottom_navigation_market".localized(),"main_bottom_navigation_exchange".localized(),"tv_market_fetures".localized(),"main_bottom_navigation_wallet".localized()]
        for index in 0..<tmpViewControllers.count {
            let nav = tmpViewControllers[index]
            if let vc = nav.viewControllers.last {
                vc.tabBarItem.title = self.titles[index]
            }
        }
        tabBar.selectedItem?.title = "main_bottom_navigation_home".localized()
    }

    var selectButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        initControllers()
        configyrationLatestVersion()
    }
    
    
    func initControllers() {
        let homeVC = HomeVC()
        homeVC.view.backgroundColor = .hexColor("1E1E1E")
        let tradeVC = TradeHomeController()
        tradeVC.view.backgroundColor = .hexColor("1E1E1E")
        let contractVC = ContracrHomeController()
        contractVC.view.backgroundColor = .hexColor("1E1E1E")
        let walletsVC = WalletViewController()
        walletsVC.view.backgroundColor = .hexColor("1E1E1E")
        let marketsVC = MarketsVC()
        marketsVC.view.backgroundColor = .hexColor("000000")
        
        let baseHomeNav = BaseNavigationController.init(rootViewController: homeVC)
        let baseMarketsNav = BaseNavigationController.init(rootViewController: marketsVC)
        let baseTradeNav = BaseNavigationController.init(rootViewController: tradeVC)
        let baseContractNav = BaseNavigationController.init(rootViewController: contractVC)
        let baseWalletsNav = BaseNavigationController.init(rootViewController: walletsVC)
        
//        self.tabBar.isTranslucent = false // tabbar不透明
        // 直接用颜色
        self.tabBar.barTintColor = UIColor.hexColor("2D2D2D")
        self.tabBar.backgroundColor = .hexColor("2D2D2D")
        
        tmpViewControllers = [baseHomeNav,baseMarketsNav,baseTradeNav,baseContractNav,baseWalletsNav]
        
        for index in 0..<tmpViewControllers.count {
            let nav = tmpViewControllers[index]
            if let vc = nav.viewControllers.last {
                vc.hidesBottomBarWhenPushed = false
                vc.tabBarItem.image = UIImage.init(named:self.tabbarNormalArray[index])?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.selectedImage = UIImage.init(named:self.tabbarSeletedArray[index])?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.title = self.titles[index]
                vc.tabBarItem.tag = index
            }
            
        }
        
        self.setViewControllers(tmpViewControllers, animated: true)
    
        //选中和非选中字体颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.hexColor("989898")], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.hexColor("FCD283")], for: .selected)
        
    }

}
extension BaseTabBarController {
    override func qmui_themeDidChange(by manager: QMUIThemeManager, identifier: NSCopying & NSObjectProtocol, theme: NSObject) {
        super.qmui_themeDidChange(by: manager, identifier: identifier, theme: theme)
        
        guard let items = self.tabBar.items else {
            return
        }
        
        for i in 0..<items.count {
//            UITabBarItem *item = items[i];
            let item = items[i]
            item.image = UIImage.init(named:self.tabbarNormalArray[i])?.withRenderingMode(.alwaysOriginal)
            item.selectedImage = UIImage.init(named:self.tabbarSeletedArray[i])?.withRenderingMode(.alwaysOriginal)
            item.title = self.titles[i]
        }
    }
}


// MARK: - 版本适配
extension BaseTabBarController {
    /// 版本适配
    func configyrationLatestVersion() {
        if #available(iOS 13.0, *) {
            self.tabBar.tintColor = UIColor.hexColor("FCD283")
            self.tabBar.unselectedItemTintColor = UIColor.hexColor("989898")
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension BaseTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if !userManager.isLogin &&
            (self.viewControllers?.index(of: viewController) ?? 0) > 3  {
            if let vc = self.selectedViewController {
                userManager.logoutWithVC(currentVC: vc)
            }
            return false
        }
        return true
    }
    
}


