//
//  FuturesDetailHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/13.
//

import UIKit

class FuturesDetailHeadView: UIView {
    lazy var topView : UIView = {
        let v = UIView()
        return v
    }()
    lazy var titleNameV : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.textColor = .hexColor("989898", alpha: 0.9)
        v.font = FONTM(size: 14)
        v.text = "合约".localized()
        return v
    }()
    lazy var coinV : UILabel = {
        let v = UILabel()
        v.font = FONTB(size: 16)
        v.textColor = .hexColor("FFFFFF", alpha: 0.9)
        v.text = "--"
        return v
    }()
    lazy var statusV : UIView = {
        let v = UIView()
        return v
    }()
    lazy var statusImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "futures_status_sel")
        return v
    }()
    lazy var statusLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("02C078", alpha: 0.9)
        v.font = FONTM(size: 16)
        v.text = "全部成交(100%)"
        return v
    }()
    lazy var middleView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
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
//        btn.addTarget(self, action: #selector(tapCopyBtn), for: .touchUpInside)
        return btn
    }()
    lazy var lblOrder : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var typeName : UILabel = {
        let lab = UILabel()
        lab.text = "类型".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lbltype : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("E35461")
        lab.font = FONTDIN(size: 12)
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
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 12)
        return lab
    }()
    lazy var lblAllNumber : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("989898")
        lab.font = FONTDIN(size: 12)
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
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 12)
        return lab
    }()
    lazy var lblAllPrice : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("989898")
        lab.font = FONTDIN(size: 12)
        return lab
    }()
    lazy var flat_priceName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_order_condition".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblflat_price : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 12)
        return lab
    }()
    lazy var line : UIView = {
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
        lab.text = "实现盈亏".localized()
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
    lazy var bottomView : UIView = {
        let v = UIView()
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
extension FuturesDetailHeadView {
    func setUI(){
        self.addSubview(topView)
        self.addSubview(middleView)
        self.addSubview(bottomView)
        topView.addSubview(titleNameV)
        topView.addSubview(coinV)
        topView.addSubview(statusV)
        statusV.addSubview(statusImage)
        statusV.addSubview(statusLab)
        middleView.addSubview(orderName)
        middleView.addSubview(copyBtn)
        middleView.addSubview(lblOrder)
        middleView.addSubview(typeName)
        middleView.addSubview(lbltype)
        middleView.addSubview(numName)
        middleView.addSubview(lblNumber)
        middleView.addSubview(lblAllNumber)
        middleView.addSubview(priceName)
        middleView.addSubview(lblPrice)
        middleView.addSubview(lblAllPrice)
        middleView.addSubview(flat_priceName)
        middleView.addSubview(lblflat_price)
        middleView.addSubview(line)
        middleView.addSubview(feeName)
        middleView.addSubview(lblFee)
        middleView.addSubview(dealPriceName)
        middleView.addSubview(lblDealPrice)
        middleView.addSubview(orderTimeName)
        middleView.addSubview(lblOrderTime)
        middleView.addSubview(updateTimeName)
        middleView.addSubview(lblUpdateTime)
    }
    func initSubViewsConstraints() {
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(106)
        }
        middleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(middleView.snp.bottom)
            make.height.equalTo(5)
        }
        titleNameV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        coinV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleNameV.snp.bottom).offset(6)
        }
        statusV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(coinV.snp.bottom).offset(6)
            make.height.equalTo(22)
        }
        statusImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        statusLab.snp.makeConstraints { make in
            make.left.equalTo(statusImage.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        orderName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(17)
        }
        copyBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(orderName)
            make.width.height.equalTo(25)
        }
        lblOrder.snp.makeConstraints { make in
            make.centerY.equalTo(orderName)
            make.right.equalTo(copyBtn.snp.left)
        }
        typeName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(orderName.snp.bottom).offset(12)
        }
        lbltype.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(typeName)
        }
        numName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(typeName.snp.bottom).offset(12)
        }
        lblAllNumber.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(typeName)
        }
        lblNumber.snp.makeConstraints { make in
            make.centerY.equalTo(typeName)
            make.right.equalTo(lblAllNumber.snp.left)
        }
        priceName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(numName.snp.bottom).offset(12)
        }
        lblAllPrice.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(priceName)
        }
        lblPrice.snp.makeConstraints { make in
            make.centerY.equalTo(priceName)
            make.right.equalTo(lblAllPrice.snp.left)
        }
        flat_priceName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(priceName.snp.bottom).offset(12)
        }
        lblflat_price.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(flat_priceName)
        }
        line.snp.makeConstraints { make in
            make.left.equalTo(orderName)
            make.right.equalTo(copyBtn)
            make.height.equalTo(0.5)
            make.top.equalTo(flat_priceName.snp.bottom).offset(15)
        }
        feeName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(line.snp.bottom).offset(15)
        }
        lblFee.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(feeName)
        }
        dealPriceName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(feeName.snp.bottom).offset(12)
        }
        lblDealPrice.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(dealPriceName)
        }
        orderTimeName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(dealPriceName.snp.bottom).offset(12)
        }
        lblOrderTime.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(orderTimeName)
        }
        updateTimeName.snp.makeConstraints { make in
            make.left.height.equalTo(orderName)
            make.top.equalTo(orderTimeName.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-15)
        }
        lblUpdateTime.snp.makeConstraints { make in
            make.right.equalTo(copyBtn)
            make.centerY.equalTo(updateTimeName)
        }
    }
}
