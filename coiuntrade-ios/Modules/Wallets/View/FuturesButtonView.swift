//
//  FuturesButtonView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/15.
//

import UIKit

class FuturesButtonView: UIView {
    lazy var leftImageV : UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "triangle_right")
        return v
    }()
    lazy var rightImageV : UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "triangle_left")
        return v
    }()
    let titleLab : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 14)
        v.textColor = .hexColor("989898")
        v.textAlignment = .center
        v.text = ""
        return v
    }()
    var titleStr : String = ""{
        didSet{
            titleLab.text = titleStr
        }
    }
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
extension FuturesButtonView{
    func setUI(){
        self.addSubview(leftImageV)
        self.addSubview(rightImageV)
        self.addSubview(titleLab)
    }
    func initSubViewsConstraints(){
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        leftImageV.snp.makeConstraints { make in
            make.right.equalTo(titleLab.snp.left).offset(-13)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(5)
            make.height.equalTo(8)
        }
        rightImageV.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(13)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(5)
            make.height.equalTo(8)
        }
    }
}
