//
//  BaseScrollView.swift
//  SaaS
//
//  Created by 袁涛 on 2021/12/8.
//

import UIKit

class BaseScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configyrationLatestVersion()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configyrationLatestVersion()
    }

}

// MARK:- 版本适配
extension BaseScrollView {
    
    /// 适配新版本
    func configyrationLatestVersion() {
        if #available(iOS 11.0, *)  {
            self.contentInsetAdjustmentBehavior = .never
        }
        
        if #available(iOS 13.0, *) {
            self.automaticallyAdjustsScrollIndicatorInsets = false
        }
    }
}
