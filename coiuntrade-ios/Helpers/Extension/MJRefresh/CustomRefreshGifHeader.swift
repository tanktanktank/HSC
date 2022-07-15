//
//  CustomRefreshGifHeader.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/22.
//

import UIKit

class CustomRefreshGifHeader: MJRefreshGifHeader {
    
    let customGifViewHeight = 50.0
    let customImageSize = CGSize(width: 50, height: 50)
    
    lazy var smartGorImageView : UIImageView = UIImageView()
    override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
        self.addSubview(smartGorImageView)
        
        self.smartGorImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        guard let path = Bundle.main.path(forResource: "refresh_loading.gif", ofType: nil) else { return }
        smartGorImageView.kf.setImage(with:ImageResource(downloadURL:URL(fileURLWithPath: path)))
    }
    override func prepare() {
        super.prepare()
        self.mj_h = customGifViewHeight
    }
}
