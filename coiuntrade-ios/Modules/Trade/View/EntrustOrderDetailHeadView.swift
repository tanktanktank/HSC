//
//  EntrustOrderDetailHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/10.
//

import UIKit

class EntrustOrderDetailHeadView: UIView {
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var lblCoin : UILabel = {
        let lab = UILabel()
        lab.text = "-/-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTDIN(size: 14)
        return lab
    }()
    lazy var lblPercentage : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var lblType : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("04B370")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblStatus : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("04B370")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var line1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    
    lazy var orderName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_no".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var copyBtn : ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "decopy"), for: .normal)
        btn.addTarget(self, action: #selector(tapCopyBtn), for: .touchUpInside)
        return btn
    }()
    lazy var lblOrder : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 12)
        return lab
    }()
    
    lazy var numName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_account".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblNumber : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var lblAllNumber : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var priceName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_price".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblPrice : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var lblAllPrice : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var factorName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_condition".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblFactor : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var line2 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    lazy var feeName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_rate".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblFee : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var dealPriceName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_total".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblDealPrice : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var orderTimeName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_create_time".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblOrderTime : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var updateTimeName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_update_time".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblUpdateTime : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    var model : EntrustModel = EntrustModel(){
        didSet{
            self.lblCoin.text = model.coin + "/" + model.currency
            self.lblPercentage.text = model.buy_rate_num + "%"
            self.lblType.text = model.order_type_title + "/" + model.buy_type_title
            self.lblStatus.text = model.status_title
            
            
            if model.status == 1 || model.status == 2 {
                self.lblStatus.textColor = .hexColor("04B370")
            }else{
                self.lblStatus.textColor = .hexColor("989898")
            }
            if model.buy_type == 1 {
                
                self.lblFee.text = "\(model.poundage) \(model.coin)"
                self.lblType.textColor = .hexColor("04B370")
            }else{
                self.lblFee.text = "\(model.poundage) \(model.currency)"
                self.lblType.textColor = .hexColor("F03851")
                self.lblStatus.textColor = .hexColor("F03851")
            }
            self.lblOrder.text = model.order_no
            self.lblNumber.text =  model.deal_num
            self.lblAllNumber.text = "/\(model.total_num)"
            self.lblPrice.text =  model.deal_price
            self.lblAllPrice.text = "/\(model.price)"
            self.lblFactor.text =  model.trigger_price
            
            self.lblDealPrice.text = "\(model.deal_amt) \(model.currency)"

            self.lblOrderTime.text =  DateManager.getDateByYYMdStamp(model.create_time)
            self.lblUpdateTime.text =  DateManager.getDateByYYMdStamp(model.update_time)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension EntrustOrderDetailHeadView{
    @objc func tapCopyBtn(){
        UIPasteboard.general.string = model.order_no
        HudManager.showOnlyText("复制成功".localized())
    }
}
// MARK: - UI
extension EntrustOrderDetailHeadView{
    func setUI() {
        self.addSubview(bgView)
        bgView.addSubview(lblCoin)
        bgView.addSubview(lblPercentage)
        bgView.addSubview(lblType)
        bgView.addSubview(lblStatus)
        bgView.addSubview(line1)
        bgView.addSubview(orderName)
        bgView.addSubview(copyBtn)
        bgView.addSubview(lblOrder)
        bgView.addSubview(numName)
        bgView.addSubview(lblNumber)
        bgView.addSubview(lblAllNumber)
        bgView.addSubview(priceName)
        bgView.addSubview(lblPrice)
        bgView.addSubview(lblAllPrice)
        bgView.addSubview(factorName)
        bgView.addSubview(lblFactor)
        bgView.addSubview(line2)
        bgView.addSubview(feeName)
        bgView.addSubview(lblFee)
        bgView.addSubview(dealPriceName)
        bgView.addSubview(lblDealPrice)
        bgView.addSubview(orderTimeName)
        bgView.addSubview(lblOrderTime)
        bgView.addSubview(updateTimeName)
        bgView.addSubview(lblUpdateTime)
    }
    func initSubViewsConstraints() {
        let topSpace : CGFloat = 13.0
        
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        lblCoin.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(topSpace)
        }
        lblPercentage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(lblCoin)
        }
        lblType.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(lblCoin.snp.bottom).offset(topSpace)
        }
        lblStatus.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(lblType)
        }
        line1.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.right.equalTo(lblPercentage)
            make.top.equalTo(lblType.snp.bottom).offset(topSpace)
            make.height.equalTo(0.5)
        }
        orderName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(line1.snp.bottom).offset(topSpace)
        }
        copyBtn.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(orderName)
            make.width.height.equalTo(25)
        }
        lblOrder.snp.makeConstraints { make in
            make.right.equalTo(copyBtn.snp.left)
            make.centerY.equalTo(orderName)
        }
        numName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(orderName.snp.bottom).offset(topSpace)
        }
        lblAllNumber.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(numName)
        }
        lblNumber.snp.makeConstraints { make in
            make.right.equalTo(lblAllNumber.snp.left)
            make.centerY.equalTo(numName)
        }
        priceName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(numName.snp.bottom).offset(topSpace)
        }
        lblAllPrice.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(priceName)
        }
        lblPrice.snp.makeConstraints { make in
            make.right.equalTo(lblAllPrice.snp.left)
            make.centerY.equalTo(priceName)
        }
        factorName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(priceName.snp.bottom).offset(topSpace)
        }
        lblFactor.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(factorName)
        }
        line2.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.right.equalTo(lblPercentage)
            make.top.equalTo(factorName.snp.bottom).offset(topSpace)
            make.height.equalTo(0.5)
        }
        feeName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(line2.snp.bottom).offset(topSpace)
        }
        lblFee.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(feeName)
        }
        dealPriceName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(feeName.snp.bottom).offset(topSpace)
        }
        lblDealPrice.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(dealPriceName)
        }
        orderTimeName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(dealPriceName.snp.bottom).offset(topSpace)
        }
        lblOrderTime.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(orderTimeName)
        }
        updateTimeName.snp.makeConstraints { make in
            make.left.equalTo(lblCoin)
            make.top.equalTo(orderTimeName.snp.bottom).offset(topSpace)
        }
        lblUpdateTime.snp.makeConstraints { make in
            make.right.equalTo(lblPercentage)
            make.centerY.equalTo(updateTimeName)
        }
    }
}
