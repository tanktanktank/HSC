//
//  TransferNumView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/18.
//

import UIKit

class TransferNumView: UIView {
    lazy var maxBtn : ZQButton = {
        let v = ZQButton()
        v.setTitle("最大".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        v.titleLabel?.font = FONTR(size: 14)
        return v
    }()
    lazy var coinName : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTR(size: 14)
        v.text = "--"
        return v
    }()
    lazy var textV : QMUITextField = {
        let v = QMUITextField()
        v.font = FONTDIN(size: 14)
        v.placeholderColor = UIColor.hexColor("989898")
        v.placeholder = "最少0.00000001".localized()
        v.textColor = .hexColor("FFFFFF")
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.keyboardType = .decimalPad
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
extension TransferNumView{
    func setUI(){
        self.addSubview(maxBtn)
        self.addSubview(coinName)
        self.addSubview(textV)
    }
    func initSubViewsConstraints(){
        maxBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalToSuperview()
        }
        coinName.setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.required.rawValue), for: .horizontal)
        coinName.snp.makeConstraints { make in
            make.right.equalTo(maxBtn.snp.left)
            make.centerY.equalToSuperview()
        }
        textV.snp.makeConstraints { make in
            make.right.equalTo(coinName.snp.left).offset(-10)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}
