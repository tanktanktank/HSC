//
//  AppDelegate.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/19.
//

import UIKit


//1111

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
//        let mainStoryboad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = mainStoryboad.instantiateInitialViewController() as! UITabBarController
        
        self.window?.rootViewController = BaseTabBarController()
        window?.backgroundColor = UIColor.hexColor("1E1E1E");
        
//        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        setIQKeyboardManager()
        ///配置数据库
        RealmHelper.configRealm()
        ///初始化指标设置
        loadKlineIndicate()
        configureBugly()
        return true
    }
    
    /// 当应用终止的时候起作用
    func applicationWillTerminate(_ application: UIApplication) {
      // 调用保存数据的方法
        let token = Archive.getToken()
        if Archive.getFaceID() && token.count>0{
            Archive.saveFaceIDtoken(token)
            Archive.saveToken("")
        }
    }
}

extension AppDelegate : BuglyDelegate{
    func attachmentForException(exception : NSException) -> String{
        return "exceptionInfo:\nname:\(exception.name)\nreason:\(String(describing: exception.reason))"
    }
}
extension AppDelegate {
    //MARK: - Bugly
    func configureBugly(){
        let config = BuglyConfig()
        config.unexpectedTerminatingDetectionEnable = true//非正常退出事件记录开关，默认关闭
        config.reportLogLevel = BuglyLogLevel.warn //报告级别
        config.blockMonitorEnable = true//开启卡顿监控
        config.blockMonitorTimeout = 1; //卡顿监控判断间隔，单位为秒
        config.delegate = self
        Bugly.start(withAppId: "6a38af8ce4", developmentDevice: true, config: config)
//        Bugly.start(withAppId: "6a38af8ce4")
    }
    //MARK: - IQKeyboardManager
    func setIQKeyboardManager(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func loadKlineIndicate(){
        
        let defaults = UserDefaults.standard
        var klineShowHeight = defaults.float(forKey: "KLineShowHeightKey")
        if(klineShowHeight > 0){
        }else{
            klineShowHeight = 0.5
            defaults.set(klineShowHeight, forKey: "KLineShowHeightKey")
        }
    }
    
    func setupRootViewController(){
        self.window?.rootViewController = nil
        self.window?.rootViewController = BaseTabBarController()
    }
}
