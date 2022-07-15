//
//  MineSafeHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit

class MineSafeHeadView: UIView {
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_safe_setting_title".localized()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("FFFFFF")
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.text = "tv_safe_setting_tip".localized()
        lab.font = FONTR(size: 11)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        getDataSouce()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: ui
extension MineSafeHeadView{
    func getDataSouce(){
        
        let info : InfoModel = userManager.infoModel ?? InfoModel()
        let imageN = getSafetylevel(model: info)
        imageView.image = UIImage(named: imageN)
    }
    func setUI() {
        self.addSubview(titleLab)
        self.addSubview(detailLab)
        self.addSubview(imageView)
    }
    func initSubViewsConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(30)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(titleLab.snp.bottom).offset(1)
        }
        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(titleLab)
            make.width.equalTo(64)
            make.height.equalTo(4)
        }
    }
}

