//
//  FuturesActivityView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/15.
//

import UIKit

class FuturesActivityView: UIView {
    lazy var titleLab : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("FFFFFF")
        return v
    }()
    lazy var iconV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "wallets_instructions")
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    public var titleStr = ""{
        didSet{
            titleLab.text = titleStr
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FuturesActivityView{
    func setUI(){
        self.addSubview(titleLab)
        self.addSubview(iconV)
    }
    func initSubViewsConstraints(){
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        iconV.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(8)
            make.centerY.equalTo(titleLab)
            make.width.height.equalTo(11)
        }
    }
}
