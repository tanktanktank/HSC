//
//  FuturesAllWalletHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/21.
//

import UIKit

class FuturesAllWalletHeadView: UIView {
    
    lazy var hideBBtn : QMUIButton = {
        let btn = QMUIButton()
        btn.setImage(UIImage(named: "wallets_check_normal"), for: .normal)
        btn.setImage(UIImage(named: "wallets_check_selscted"), for: .selected)
        btn.setTitle("tv_hide_zero_blace".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 13)
        btn.imagePosition = QMUIButtonImagePosition.left
        btn.spacingBetweenImageAndTitle = 13
        btn.addTarget(self, action: #selector(tapHideBBtn), for: .touchUpInside)
        return btn
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
extension FuturesAllWalletHeadView{
    ///点击hide0
    @objc func tapHideBBtn(sender : QMUIButton){
        sender.isSelected = !sender.isSelected
    }
}
//MARK: ui
extension FuturesAllWalletHeadView{
    func setUI(){
        self.addSubview(hideBBtn)
    }
    func initSubViewsConstraints(){
        hideBBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(30)
        }
    }
}
