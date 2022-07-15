//
//  StockSectionHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/9.
//

import UIKit
protocol StockSectionHeadViewDelegate : NSObjectProtocol {
    ///点击hide0
    func clickHidden0(isHide0 : Bool)
    ///search
    func searchWithText(text : String)
}
class StockSectionHeadView: UIView {
    
    public weak var delegate: StockSectionHeadViewDelegate? = nil

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
    lazy var searchView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 15)
        return v
    }()
    lazy var textF : QMUITextField = {
        let v = QMUITextField()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("989898")
        v.placeholderColor = UIColor.hexColor("989898")
        v.placeholder = "home_search".localized()
        v.addTarget(self, action: #selector(tapTextF), for: .editingChanged)
        return v
    }()
    lazy var searchImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "wallets_search")
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
extension StockSectionHeadView{
    ///点击hide0
    @objc func tapHideBBtn(sender : QMUIButton){
        sender.isSelected = !sender.isSelected
        self.delegate?.clickHidden0(isHide0: sender.isSelected)
    }
    @objc func tapTextF(sender : QMUITextField){
        self.delegate?.searchWithText(text: sender.text ?? "")
    }
}

extension StockSectionHeadView{
    func setUI() {
        self.addSubview(hideBBtn)
        self.addSubview(searchView)
        searchView.addSubview(textF)
        searchView.addSubview(searchImage)
    }
    func initSubViewsConstraints() {
        
        hideBBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        searchView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(hideBBtn)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        searchImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(13)
        }
        textF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(searchImage.snp.left).offset(-3)
        }
    }
}
