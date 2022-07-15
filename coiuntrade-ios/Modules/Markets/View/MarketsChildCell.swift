//
//  MarketsChildCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/1.
//

import UIKit
protocol MarketsChildCellDelegate : NSObjectProtocol {
    ///添加
    func clickAddWithModel(model : CoinModel)
    ///置顶
    func clickTopWithModel(model : CoinModel)
    func clickNoLoginTopWithModel(model : RealmCoinModel)
    ///删除
    func clickDeleteWithModel(model : CoinModel)
    func clickNoLoginDeleteWithModel(model : RealmCoinModel)
    ///编辑
    func clickEditWithModel()
}
extension MarketsChildCellDelegate{
    func clickAddWithModel(model : CoinModel){}
    func clickTopWithModel(model : CoinModel){}
    func clickNoLoginTopWithModel(model : RealmCoinModel){}
    func clickDeleteWithModel(model : CoinModel){}
    func clickNoLoginDeleteWithModel(model : RealmCoinModel){}
    func clickEditWithModel(){}
}
class MarketsChildCell: UITableViewCell {
    
    var type : MarketsType = .accountLike
    
    static let CELLID = "MarketsChildCell"
    
    public weak var delegate: MarketsChildCellDelegate? = nil
    
    lazy var pop : PrincekinPopoverView = {
        let options: [PopoverViewOption] = [.type(.up), .showBlackOverlay(true),.showShadowy(true),.arrowPositionRatio(0.5),.arrowSize(CGSize(width: 12, height: 16)),.color(.hexColor("2D2D2D"))]
        var v = PrincekinPopoverView.init(options: options)
        return v
    }()
    
    lazy var addBtn : UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 104, height: 34)
        btn.setTitle("tv_market_add_optional".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.addTarget(self, action: #selector(tapAddBtn), for: .touchUpInside)
        return btn
    }()
    lazy var topBtn : UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 104, height: 34)
        btn.setTitle("tv_market_top_optional".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.addTarget(self, action: #selector(tapTopBtn), for: .touchUpInside)
        return btn
    }()
    lazy var deleteBtn : UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 34, width: 104, height: 34)
        btn.setTitle("tv_market_del_optional".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.addTarget(self, action: #selector(tapDeleteBtn), for: .touchUpInside)
        return btn
    }()
    lazy var editBtn : UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 68, width: 104, height: 34)
        btn.setTitle("tv_market_edit_optional".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.addTarget(self, action: #selector(tapEditBtn), for: .touchUpInside)
        return btn
    }()
    lazy var lblCoin : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTBINCE(size: 15)
        lab.text = "-"
        return lab
    }()
    lazy var lblCurrency : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTBINCE(size: 11)
        lab.text = "/-"
        return lab
    }()
    lazy var lblVol : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "--"
        return lab
    }()
    lazy var lblPrice : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTDIN(size: 16)
        lab.text = "-"
        return lab
    }()
    lazy var ratePriceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTDIN(size: 12)
        lab.text = "-"
        return lab
    }()
    lazy var lblRate : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 14)
        lab.text = "-"
        lab.textAlignment = .center
        lab.corner(cornerRadius: 4)
        return lab
    }()
    var model : CoinModel = CoinModel(){
        didSet{
            
            self.lblCoin.text = model.coin
            self.lblPrice.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: model.new_price, digit: model.price_digit))
            let f : Float = Float(model.ratio_str) ?? 0.0
//            self.lblRate.text = String(format: "%.2f", f) + "%"
            self.lblCurrency.text = "/\(model.currency)"
            self.lblVol.text = "Vol " + HSCoinCalculate.calculateCoin(coin: model.deal_num)
            self.ratePriceLab.text = self.addRateSymbol(value: model.new_price)
            if model.priceColor == 1 {
                self.lblPrice.textColor = .hexColor("02C078", alpha: 0.9)
            }else if model.priceColor == 2 {
                self.lblPrice.textColor = .hexColor("F03851", alpha: 0.9)
            }else{
                self.lblPrice.textColor = .hexColor("FFFFFF", alpha: 0.9)
            }
            if model.isFall {
                self.lblRate.text = self.addTwoDecimalsDownValue(value: model.ratio_str) + "%"
//                self.lblPrice.textColor = UIColor.hexColor(0xFF4E4F)
                self.lblRate.backgroundColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblRate.text = "+" + self.addTwoDecimalsDownValue(value: model.ratio_str) + "%"
//                self.lblPrice.textColor = UIColor.hexColor(0x02C078)
                self.lblRate.backgroundColor = UIColor.hexColor(0x02C078)
            }
        }
    }
    var realmCoinModel : RealmCoinModel = RealmCoinModel(){
        didSet{
            self.lblCoin.text = realmCoinModel.coin
            self.lblPrice.text = self.addMicrometerLevel(valueSwift: self.addPriceDecimals(value: realmCoinModel.price, digit: realmCoinModel.price_digit))
//            let f = Float(realmCoinModel.ratio_str) ?? 0.0
            self.lblCurrency.text = "/\(realmCoinModel.currency)"
            self.lblVol.text = "Vol " + realmCoinModel.deal_num
            self.ratePriceLab.text = self.addRateSymbol(value: realmCoinModel.price)
            if realmCoinModel.priceColor == 1 {
                self.lblPrice.textColor = .hexColor("02C078", alpha: 0.9)
            }else if realmCoinModel.priceColor == 2 {
                self.lblPrice.textColor = .hexColor("F03851", alpha: 0.9)
            }else{
                self.lblPrice.textColor = .hexColor("FFFFFF", alpha: 0.9)
            }
            if realmCoinModel.isFall {
                self.lblRate.text = self.addTwoDecimalsDownValue(value: realmCoinModel.ratio_str) + "%"
//                self.lblPrice.textColor = UIColor.hexColor(0xFF4E4F)
                self.lblRate.backgroundColor = UIColor.hexColor(0xF03851)
            } else{
                self.lblRate.text = "+" + self.addTwoDecimalsDownValue(value: realmCoinModel.ratio_str) + "%"
//                self.lblPrice.textColor = UIColor.hexColor(0x02C078)
                self.lblRate.backgroundColor = UIColor.hexColor(0x02C078)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MarketsChildCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(lblCoin)
        self.contentView.addSubview(lblCurrency)
        self.contentView.addSubview(lblVol)
        self.contentView.addSubview(lblPrice)
        self.contentView.addSubview(ratePriceLab)
        self.contentView.addSubview(lblRate)
        
        //手势
        self.contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action:  #selector(drapCell)))
    }
    func initSubViewsConstraints() {
        lblRate.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
            make.width.equalTo(82)
            make.height.equalTo(36)
        }
        lblPrice.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-(103+LR_Margin))
            make.bottom.equalTo(self.contentView.snp.centerY).offset(-1)
        }
        ratePriceLab.snp.makeConstraints { make in
            make.right.equalTo(lblPrice)
            make.top.equalTo(self.contentView.snp.centerY).offset(1)
        }
        lblCoin.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.bottom.equalTo(lblPrice)
        }
        lblCurrency.snp.makeConstraints { make in
            make.left.equalTo(lblCoin.snp.right)
            make.bottom.equalTo(lblCoin).offset(-3)
            make.height.equalTo(8)
        }
        lblVol.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(ratePriceLab)
        }
    }
    
    @objc func drapCell(longPressGes: UILongPressGestureRecognizer){
        if longPressGes.state == .began {
            if type == .accountLike {
                let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 104, height: 34*3))
                contentView.addSubview(topBtn)
                contentView.addSubview(deleteBtn)
                contentView.addSubview(editBtn)
                pop.contentView = contentView
                pop.show(pop.contentView, fromView: longPressGes.view ?? UIView())
            }else{
                let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 104, height: 34))
                contentView.addSubview(addBtn)
                pop.contentView = contentView
                pop.show(pop.contentView, fromView: longPressGes.view ?? UIView())
            }
            
        }
    }
    @objc func tapAddBtn(){
        pop.dismiss()
        self.delegate?.clickAddWithModel(model: self.model)
    }
    @objc func tapTopBtn(){
        pop.dismiss()
        if userManager.isLogin {
            self.delegate?.clickTopWithModel(model: self.model)
        }else{
            self.delegate?.clickNoLoginTopWithModel(model: self.realmCoinModel)
        }
    }
    @objc func tapDeleteBtn(){
        pop.dismiss()
        if userManager.isLogin {
            self.delegate?.clickDeleteWithModel(model: self.model)
        }else{
            self.delegate?.clickNoLoginDeleteWithModel(model: self.realmCoinModel)
        }
    }
    @objc func tapEditBtn(){
        pop.dismiss()
        self.delegate?.clickEditWithModel()
    }
}
