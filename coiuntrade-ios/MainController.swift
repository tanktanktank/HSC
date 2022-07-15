//
//  MainController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/19.
//

import Foundation
import UIKit

class MainController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(showChangeNotify), name: NSNotification.Name(rawValue: "yTabBarChangeNotify"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTabBar()
    }
    @objc private func showChangeNotify(_ notify: NSNotification) {
            let userInfo = notify.userInfo
        self.selectedIndex = 2
        print("收到通知：\(userInfo)")
    }
    
    //MARk: 加载工具栏
    func initTabBar() {
        self.view.backgroundColor = UIColor.HexColor(0x222222)
        self.tabBar.tintColor = UIColor.HexColor(0xFCD283)
        self.tabBar.barTintColor = UIColor.HexColor(0x222222)
        let homeBar = self.viewControllers?[0].tabBarItem
        homeBar?.image =  UIImage(named: "Home-no")?.withRenderingMode(.alwaysOriginal)
        homeBar?.selectedImage =  UIImage(named: "Home-yes")?.withRenderingMode(.alwaysOriginal)
        homeBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0x7D7D7D)], for: .normal)
        homeBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0xFCD283)], for: .selected)
        
        let marketsBar = self.viewControllers?[1].tabBarItem
        marketsBar?.image =  UIImage(named: "Markets-no")?.withRenderingMode(.alwaysOriginal)
        marketsBar?.selectedImage =  UIImage(named: "Markets-yes")?.withRenderingMode(.alwaysOriginal)
        marketsBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0x7D7D7D)], for: .normal)
        marketsBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0xFCD283)], for: .selected)
        
        
        let tradeBar = self.viewControllers?[2].tabBarItem
        tradeBar?.image =  UIImage(named: "Trade-no")?.withRenderingMode(.alwaysOriginal)
        tradeBar?.selectedImage =  UIImage(named: "Trade-yes")?.withRenderingMode(.alwaysOriginal)
        tradeBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0x7D7D7D)], for: .normal)
        tradeBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0xFCD283)], for: .selected)
        
        let futuresBar = self.viewControllers?[3].tabBarItem
        futuresBar?.image =  UIImage(named: "Futures-no")?.withRenderingMode(.alwaysOriginal)
        futuresBar?.selectedImage =  UIImage(named: "Futures-yes")?.withRenderingMode(.alwaysOriginal)
        futuresBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0x7D7D7D)], for: .normal)
        futuresBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0xFCD283)], for: .selected)
        
        let walletsBar = self.viewControllers?[4].tabBarItem
        walletsBar?.image =  UIImage(named: "Wallets-no")?.withRenderingMode(.alwaysOriginal)
        walletsBar?.selectedImage =  UIImage(named: "Wallets-yes")?.withRenderingMode(.alwaysOriginal)
        walletsBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0x7D7D7D)], for: .normal)
        walletsBar?.setTitleTextAttributes([.foregroundColor:UIColor.HexColor(0xFCD283)], for: .selected)

    }
    
}
