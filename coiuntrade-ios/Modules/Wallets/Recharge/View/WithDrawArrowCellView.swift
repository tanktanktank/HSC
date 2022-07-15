//
//  WithDrawArrowCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit

class WithDrawArrowCellView: UIView {
    
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 13)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var iconBtn : ZQButton = {
        let v = ZQButton()
        v.setImage(UIImage(named: "trnetwork"), for: .normal)
        return v
    }()
    
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var arrowV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "cellright")
        v.contentMode = .center
        v.isUserInteractionEnabled = true
        return v
    }()
    lazy var contentLab : QMUITextField = {
        let v = QMUITextField()
        v.placeholderColor = UIColor.hexColor("989898")
        v.placeholder = "tv_select_main_net".localized()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.isUserInteractionEnabled = false
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
//extension WithDrawArrowCellView{
//    @objc func tapView() {
//        print("视图被点击")
//    }
//}

//MARK: ui
extension WithDrawArrowCellView{
    func setUI(){
        self.addSubview(titleV)
        self.addSubview(iconBtn)
        self.addSubview(bgView)
        bgView.addSubview(arrowV)
        bgView.addSubview(contentLab)
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapView))
//        bgView.addGestureRecognizer(tap)
    }
    func initSubViewsConstraints(){
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview()
        }
        iconBtn.snp.makeConstraints { make in
            make.left.equalTo(titleV.snp.right).offset(8)
            make.width.height.equalTo(11)
            make.centerY.equalTo(titleV)
        }
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleV.snp.bottom).offset(5)
            make.height.equalTo(43)
            make.bottom.equalToSuperview()
        }
        arrowV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(12)
            make.centerY.equalToSuperview()
        }
        contentLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(arrowV.snp.left).offset(20)
        }
    }
}
