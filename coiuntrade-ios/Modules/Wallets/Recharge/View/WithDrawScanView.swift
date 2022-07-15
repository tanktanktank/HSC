//
//  WithDrawCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit

class WithDrawScanView: UIView {

    lazy var titleV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 13)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var scanBtn : UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "trscan"), for: .normal)
        v.contentMode = .center
        return v
    }()
    lazy var textF : QMUITextField = {
        let v = QMUITextField()
        v.placeholderColor = UIColor.hexColor("989898")
        v.placeholder = "tv_long_press_paste".localized()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        return v
    }()
    lazy var msgLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("E35461")
        v.font = FONTR(size: 11)
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
extension WithDrawScanView{
    func setUI(){
        self.addSubview(titleV)
        self.addSubview(bgView)
        bgView.addSubview(scanBtn)
        bgView.addSubview(textF)
        self.addSubview(msgLab)
    }
    func initSubViewsConstraints(){
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview()
        }
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleV.snp.bottom).offset(5)
            make.height.equalTo(43)
        }
        scanBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        textF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(scanBtn.snp.left).offset(-5)
            make.top.bottom.equalToSuperview()
        }
        msgLab.snp.makeConstraints { make in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}
