//
//  FuturesHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/14.
//

import UIKit

class FuturesHeadView: UIView {
    lazy var UBtn : UIButton = {
        let v = UIButton()
        v.backgroundColor = .hexColor("2D2D2D")
        v.setTitle("U本位合约".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        v.titleLabel?.font = FONTR(size: 13)
        v.addTarget(self, action: #selector(tapUBtn), for: .touchUpInside)
        return v
    }()
    lazy var BBtn : UIButton = {
        let v = UIButton()
        v.backgroundColor = .clear
        v.setTitle("币本位合约".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.titleLabel?.font = FONTR(size: 13)
        v.addTarget(self, action: #selector(tapBBtn), for: .touchUpInside)
        return v
    }()
    lazy var hisBtn : ZQButton = {
        let v = ZQButton()
        v.setImage(UIImage(named: "wallets_history"), for: .normal)
        v.addTarget(self, action: #selector(tapHisBtn), for: .touchUpInside)
        return v
    }()
    lazy var totalTitle : UILabel = {
        let v = UILabel()
        v.font = FONTB(size: 10)
        v.textColor = .hexColor("989898")
        v.text = String(format: "资产估值(%@)".localized(), "--")
        return v
    }()
    lazy var seeBtn : ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "wallets_see"), for: .normal)
        btn.setImage(UIImage(named: "wallets_nosee"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn), for: .touchUpInside)
        btn.isSelected = false
        return btn
    }()
    lazy var totalValue : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("EBEBEB")
        v.font = FONTDIN(size: 26)
        v.text = "--"
        return v
    }()
    lazy var rateValue : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTDIN(size: 12)
        v.text = "≈--"
        return v
    }()
    lazy var analeTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FCD283")
        v.backgroundColor = .hexColor("2D2D2D")
        v.font = FONTR(size: 9)
        v.text = "盈亏分析".localized()
        v.textAlignment = .center
        return v
    }()
    lazy var profitDay : QMUIButton = {
        let v = QMUIButton()
        v.setTitle(String(format: "%@天盈利", "-"), for: .normal)
        v.setTitleColor(UIColor.hexColor("02C078"), for: .normal)
        v.titleLabel?.font = FONTR(size: 9)
        v.setImage(UIImage(named: "profitday_arrow"), for: .normal)
        v.imagePosition = QMUIButtonImagePosition.right
        v.spacingBetweenImageAndTitle = 6
        v.backgroundColor = .hexColor("02C078",alpha: 0.2)
        return v
    }()
    lazy var horizontalLine1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var horizontalLine2 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var horizontalLine3 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var verticalLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        analeTitle.addCorner(conrners: [.topLeft,.bottomLeft], radius: 4)
        profitDay.addCorner(conrners: [.topRight,.bottomRight], radius: 4)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: 事件交互
extension FuturesHeadView{
    //MARK: 点击历史记录
    @objc func tapHisBtn(){
        let vc = FuturesEntrustVC()
        getTopVC()?.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapUBtn(sender : UIButton){
        
    }
    @objc func tapBBtn(sender : UIButton){
        
    }
    
    //MARK: 点击隐藏和显示
    @objc func tapSeeBtn(sender : ZQButton){
        sender.isSelected = !sender.isSelected
    }
}
//MARK: ui
extension FuturesHeadView{
    func setUI(){
        self.addSubview(UBtn)
        self.addSubview(BBtn)
        self.addSubview(hisBtn)
        self.addSubview(totalTitle)
        self.addSubview(seeBtn)
        self.addSubview(totalValue)
        self.addSubview(rateValue)
        self.addSubview(analeTitle)
        self.addSubview(profitDay)
    }
    func initSubViewsConstraints(){
        UBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(77)
            make.height.equalTo(22)
        }
        BBtn.snp.makeConstraints { make in
            make.left.equalTo(UBtn.snp.right).offset(10)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(77)
            make.height.equalTo(22)
        }
        hisBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(UBtn)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        totalTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(UBtn.snp.bottom).offset(15)
        }
        seeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(totalTitle)
            make.left.equalTo(totalTitle.snp.right).offset(10)
        }
        totalValue.snp.makeConstraints { make in
            make.left.equalTo(totalTitle)
            make.top.equalTo(totalTitle.snp.bottom).offset(7)
            make.height.equalTo(35)
        }
        rateValue.snp.makeConstraints { make in
            make.left.equalTo(totalTitle)
            make.top.equalTo(totalValue.snp.bottom).offset(1)
            make.height.equalTo(16)
        }
        analeTitle.snp.makeConstraints { make in
            make.left.equalTo(totalTitle)
            make.top.equalTo(rateValue.snp.bottom).offset(8)
            make.height.equalTo(19)
            make.width.equalTo(51)
        }
        profitDay.snp.makeConstraints { make in
            make.left.equalTo(analeTitle.snp.right)
            make.top.equalTo(rateValue.snp.bottom).offset(8)
            make.height.equalTo(19)
            make.width.equalTo(60)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
