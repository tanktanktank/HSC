//
//  CoinSelectedCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/18.
//

import UIKit

class CoinSelectedCellView: UIView {
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.text = "--"
        return v
    }()
    lazy var imageV : UIImageView = {
        let v = UIImageView()
        
        return v
    }()
    lazy var arrowV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .scaleAspectFit
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
extension CoinSelectedCellView{
    func setUI(){
        self.addSubview(titleV)
        self.addSubview(imageV)
        self.addSubview(arrowV)
    }
    func initSubViewsConstraints(){
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        arrowV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalToSuperview()
        }
        imageV.snp.makeConstraints { make in
            make.right.equalTo(arrowV.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }
}
