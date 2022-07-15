//
//  BaseTableView.swift
//  test
//
//  Created by tfr on 2022/4/18.
//

import UIKit

class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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
extension BaseTableView {
    
    /// 适配新版本
    func configyrationLatestVersion() {
        if #available(iOS 11.0, *)  {
            self.contentInsetAdjustmentBehavior = .never
        }
        
        if #available(iOS 13.0, *) {
            self.automaticallyAdjustsScrollIndicatorInsets = false
        }
        ///ios15 分组悬停默认22高度改为0
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
        
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
    }
}

