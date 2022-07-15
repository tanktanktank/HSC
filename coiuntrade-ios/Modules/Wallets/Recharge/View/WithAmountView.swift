//
//  WithAmountView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit

class WithAmountView: UIView {
    
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
    lazy var allBtn : UIButton = {
        let v = UIButton()
        v.setTitle("全部提现".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        v.contentMode = .center
        v.titleLabel?.font = FONTR(size: 14)
        return v
    }()
    lazy var coinNameV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 14)
        v.textColor = .hexColor("989898")
        v.text = "--"
        return v
    }()
    lazy var textF : QMUITextField = {
        let v = QMUITextField()
        v.placeholderColor = UIColor.hexColor("989898")
        v.placeholder = "最少".localized()
        v.keyboardType = .numberPad
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        return v
    }()
    lazy var leftNameLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTR(size: 14)
        v.text = "可用".localized()
        return v
    }()
    lazy var totalLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTDIN(size: 14)
        v.text = "0.00040028 BNB"
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
extension WithAmountView{
    func setUI(){
        self.addSubview(titleV)
        self.addSubview(bgView)
        bgView.addSubview(allBtn)
        bgView.addSubview(coinNameV)
        bgView.addSubview(textF)
        self.addSubview(leftNameLab)
        self.addSubview(totalLab)
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
        allBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(76)
            make.height.equalTo(40)
        }
        let coinW = coinNameV.sizeWithText(text: "BNB", font: FONTR(size: 14), size: CGSize(width: SCREEN_WIDTH, height: 40)).width
        coinNameV.snp.makeConstraints { make in
            make.right.equalTo(allBtn.snp.left)
            make.width.equalTo(coinW)
            make.centerY.equalToSuperview()
        }
        textF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(coinNameV.snp.left).offset(-5)
            make.top.bottom.equalToSuperview()
        }
        leftNameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(bgView.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
        totalLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(leftNameLab)
        }
    }
}
