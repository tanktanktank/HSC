//
//  BaseCollectionView.swift
//
//
//  Created by TFR on 2022/3/17.
//

import UIKit

class BaseCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
extension BaseCollectionView {
    
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
