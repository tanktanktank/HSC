//
//  RechargeCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/29.
//

import UIKit

class RechargeCellView: UIView {
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var contentV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 14)
        v.textColor = .hexColor("FFFFFF")
        v.numberOfLines = 0
        return v
    }()
    lazy var btn : ZQButton = {
        let v = ZQButton()
        
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: ui
extension RechargeCellView{
    func setUI(){
        self.addSubview(titleV)
        self.addSubview(contentV)
        self.addSubview(btn)
    }
    func initSubViewsConstraints(){
        btn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20)
            make.right.equalTo(btn.snp.left).offset(-90)
        }
        contentV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleV.snp.bottom).offset(4)
            make.right.equalTo(titleV)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
