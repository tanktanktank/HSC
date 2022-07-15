//
//  HomeItemView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/7.
//

import UIKit

class HomeItemView: UIView {
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 15)
        return lab
    }()
    
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 11)
        lab.numberOfLines = 0
        return lab
    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .center
        return v
    }()
    public var name : String = ""{
        didSet{
            self.nameLab.text = name
        }
    }
    public var massgae : String = ""{
        didSet{
            self.detailLab.text = massgae
        }
    }
    public var image : String = ""{
        didSet{
            self.iconView.image = UIImage(named: image)
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
extension HomeItemView{
    func setUI(){
        self.backgroundColor = .hexColor("2D2D2D")
        self.addSubview(nameLab)
        self.addSubview(detailLab)
        self.addSubview(iconView)
    }
    func initSubViewsConstraints(){
        nameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(35)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalTo(nameLab)
            make.right.equalTo(iconView.snp.left).offset(-10)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
        }
    }
}
