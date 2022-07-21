//
//  FuturesHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/14.
//

import UIKit

class FuturesHeadView: UIView {
    private let itemH = 69.0
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
    ///保证金
    lazy var earnestmoneyV : FuturesHeadItemView = {
        let v = FuturesHeadItemView()
        v.title = "保证金金额(BTC)"
        return v
    }()
    ///钱包余额
    lazy var walletmoneyV : FuturesHeadItemView = {
        let v = FuturesHeadItemView()
        v.title = "钱包余额(BTC)"
        return v
    }()
    ///未实现盈亏
    lazy var profitmoneyV : FuturesHeadItemView = {
        let v = FuturesHeadItemView()
        v.title = "未实现盈亏(BTC)"
        return v
    }()
    ///全部借款
    lazy var borrowmoneyV : FuturesHeadItemView = {
        let v = FuturesHeadItemView()
        v.title = "全部借款(BTC)"
        v.isShowArrow = true
        return v
    }()
    lazy var bottomLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var resetV : FuturesButtonView = {
        let v = FuturesButtonView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        v.titleStr = "转换".localized()
        return v
    }()
    lazy var transferV : FuturesButtonView = {
        let v = FuturesButtonView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        v.titleStr = "tv_fund_tran".localized()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(taptransferV))
        v.addGestureRecognizer(tap)
        return v
    }()
//    lazy var activiV : FuturesActivityView = {
//        let v = FuturesActivityView()
//        v.corner(cornerRadius: 4)
//        v.backgroundColor = .hexColor("2D2D2D")
//        v.titleStr = "使用BNB抵扣(10%折扣）".localized()
//        return v
//    }()
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
    //MARK: 划转
    @objc func taptransferV() {
        print("划转")
        let vc = TransferVC()
        getTopVC()?.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func tapEarnestmoneyTitle(){
        let title = "保证金余额".localized()
        let message = "保证金余额=钱包余额+未实现盈亏单币种保证金模式下，保证金余额包含U本位合约账户里USDT和BUSD资产的保证金余额的USD总估值。\n联合保证金模式下，保证金余额包含U本位合约账户里所有资产的保证金余额的USD总估值。".localized()
        tipManager.showSingleAlert(title: title, message: message)
    }
    @objc func tapWalletmoneyTitle(){
        let title = "钱包余额".localized()
        let message = "钱包余额=总共净划入+总共已实现盈亏+总共净资金费用-总共手续费单币种保证金模式下，钱包余额包含U本位合约账户下USDT估值。\n联合保证金模式下，钱包余额包含U本位合约账户下所有资产的钱包余额USD估值。".localized()
        tipManager.showSingleAlert(title: title, message: message)
    }
    @objc func tapProfitmoneyTitle(){
        let title = "未实现盈亏".localized()
        let message = "采用标记价格计算得出的末实现盈亏，以及回报率。".localized()
        tipManager.showSingleAlert(title: title, message: message)
    }
    @objc func tapBorrowmoneyTitle(){
        let title = "全部借款".localized()
        let message = "您使用混合保证金模式的总借款数量".localized()
        tipManager.showSingleAlert(title: title, message: message)
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
        self.addSubview(horizontalLine1)
        self.addSubview(earnestmoneyV)
        self.addSubview(walletmoneyV)
        self.addSubview(profitmoneyV)
        self.addSubview(borrowmoneyV)
        self.addSubview(horizontalLine2)
        self.addSubview(horizontalLine3)
        self.addSubview(verticalLine)
        self.addSubview(resetV)
        self.addSubview(transferV)
        self.addSubview(bottomLine)
//        self.addSubview(activiV)
        let earnestmoneyTap = UITapGestureRecognizer(target: self, action: #selector(tapEarnestmoneyTitle))
        self.earnestmoneyV.titleLab.addGestureRecognizer(earnestmoneyTap)
        let walletmoneyTap = UITapGestureRecognizer(target: self, action: #selector(tapWalletmoneyTitle))
        self.walletmoneyV.titleLab.addGestureRecognizer(walletmoneyTap)
        let profitmoneyTap = UITapGestureRecognizer(target: self, action: #selector(tapProfitmoneyTitle))
        self.profitmoneyV.titleLab.addGestureRecognizer(profitmoneyTap)
        let borrowmoneyTap = UITapGestureRecognizer(target: self, action: #selector(tapBorrowmoneyTitle))
        self.borrowmoneyV.titleLab.addGestureRecognizer(borrowmoneyTap)
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
        }
        horizontalLine1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(profitDay.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        earnestmoneyV.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine1.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(itemH)
            make.width.equalTo(SCREEN_WIDTH/2.0)
        }
        walletmoneyV.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine1.snp.bottom)
            make.left.equalTo(earnestmoneyV.snp.right)
            make.height.equalTo(itemH)
            make.width.equalTo(SCREEN_WIDTH/2.0)
        }
        horizontalLine2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(earnestmoneyV.snp.bottom)
            make.height.equalTo(1)
        }
        profitmoneyV.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine2.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(itemH)
            make.width.equalTo(SCREEN_WIDTH/2.0)
        }
        borrowmoneyV.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine2.snp.bottom)
            make.left.equalTo(profitmoneyV.snp.right)
            make.height.equalTo(itemH)
            make.width.equalTo(SCREEN_WIDTH/2.0)
        }
        horizontalLine3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(profitmoneyV.snp.bottom)
            make.height.equalTo(1)
        }
        verticalLine.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine1.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(horizontalLine3.snp.top)
            make.width.equalTo(1)
        }
        resetV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(horizontalLine3.snp.bottom).offset(12)
            make.right.equalTo(self.snp.centerX).offset(-6)
            make.height.equalTo(31)
        }
        transferV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(horizontalLine3.snp.bottom).offset(12)
            make.left.equalTo(self.snp.centerX).offset(6)
            make.height.equalTo(31)
        }
        bottomLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(transferV.snp.bottom).offset(12)
            make.height.equalTo(5)
            make.bottom.equalToSuperview().offset(-1)
        }
//        activiV.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(LR_Margin)
//            make.right.equalToSuperview().offset(-LR_Margin)
//            make.top.equalTo(bottomLine.snp.bottom).offset(12)
//            make.height.equalTo(35)
//            make.bottom.equalToSuperview().offset(-10)
//        }
    }
}
