//
//  SecurityCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit
protocol SecurityCellViewDelegate {
    
    func securityCellSatisfyInput(isCanClick : Bool)
}
class SecurityCellView: UIView {
    var delegate:SecurityCellViewDelegate?
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTM(size: 14)
        lab.textColor = .hexColor("989898")
        return lab
    }()
    lazy var textV : QMUITextField = {
        let v = QMUITextField()
        v.placeholderColor = .hexColor("989898")
        v.font = FONTR(size: 13)
        v.textColor = .hexColor("FFFFFF")
        v.maximumTextLength = 6
        v.keyboardType = .numberPad
        return v
    }()
    lazy var sendBtn : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 13)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
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
extension SecurityCellView{
    @objc func clickTextV(sender : QMUITextField){
        guard let count : Int = sender.text?.count else {
            return
        }
        if count > 0 {
            line.backgroundColor = .hexColor("FCD283")
            self.delegate?.securityCellSatisfyInput(isCanClick: true)
        }else{
            line.backgroundColor = .hexColor("333333")
            self.delegate?.securityCellSatisfyInput(isCanClick: false)
        }
    }
}
extension SecurityCellView{
    func setUI(){
        self.addSubview(titleLab)
        self.addSubview(textV)
        self.addSubview(sendBtn)
        self.addSubview(line)
        textV.addTarget(self, action: #selector(clickTextV), for: .editingChanged)
    }
    func initSubViewsConstraints(){
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview().offset(30)
        }
        sendBtn.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        sendBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        textV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(sendBtn.snp.left).offset(-12)
            make.height.equalTo(sendBtn)
            make.centerY.equalTo(sendBtn)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(textV.snp.bottom)
            make.height.equalTo(1)
        }
    }
}
