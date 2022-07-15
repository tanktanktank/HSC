//
//  EntrustAllCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/2.
//

import UIKit
protocol EntrustAllCellDelegate: NSObjectProtocol{
    /// 撤单
    func cancelorder(model : EntrustModel)
}
class EntrustAllCell: UITableViewCell {
    weak var delegate: EntrustAllCellDelegate?
    static let CELLID = "EntrustAllCell"
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var coinLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 14)
        lab.text = "-"
        return lab
    }()
    lazy var currencyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTDIN(size: 14)
        lab.text = "/-"
        return lab
    }()
    lazy var statusLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 9)
        lab.textColor = .hexColor("02C078")
        lab.textAlignment = .center
        lab.text = "--"
        lab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("02C078"),borderWidth: 1)
        return lab
    }()
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var amountTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_amount".localized()
        return lab
    }()
    lazy var priceTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("999999")
        lab.font = FONTM(size: 11)
        lab.text = "tv_trade_price".localized()
        return lab
    }()
    lazy var deal_numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var numLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF", alpha: 0.9)
        lab.font = FONTM(size: 11)
        return lab
    }()
    lazy var progressV : CircleProgressView = {
        let v = CircleProgressView()
        return v
    }()
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("common_cancel".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for: .normal)
        btn.backgroundColor = .hexColor("989898")
        btn.titleLabel?.font = FONTR(size: 10)
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        return btn
    }()
    var model : EntrustModel = EntrustModel(){
        didSet{
            self.coinLab.text = model.coin
            self.currencyLab.text = "/\(model.currency)"
            self.statusLab.text = model.buy_type_title
            let foat = (model.buy_rate_num as NSString).floatValue * 0.01*1000.0
            
            let tmp : Int = NSNumber(value: foat).intValue
            if model.buy_type == 1{
                self.statusLab.textColor = .hexColor("02C078")
                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("02C078"),borderWidth: 1)
                self.progressV.setProgress(tmp, progressColor: .hexColor("02C078"),text: "\(model.buy_rate_num)%")
            }else{
                self.statusLab.textColor = .hexColor("F03851")
                self.statusLab.corner(cornerRadius: 3,toBounds: true,borderColor: UIColor.hexColor("F03851"),borderWidth: 1)
                self.progressV.setProgress(tmp, progressColor: .hexColor("F03851"),text: "\(model.buy_rate_num)%")
            }
            self.timeLab.text = DateManager.getDateByMdStamp(model.create_time)
            self.deal_numLab.text = model.deal_num
            self.numLab.text = "/\(model.total_num)"
            self.priceLab.text = model.price
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
extension EntrustAllCell{
    @objc func tapCancelBtn(){
        self.delegate?.cancelorder(model: self.model)
    }
}
// MARK: - UI
extension EntrustAllCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(bgView)
        bgView.addSubview(coinLab)
        bgView.addSubview(currencyLab)
        bgView.addSubview(statusLab)
        bgView.addSubview(timeLab)
        bgView.addSubview(amountTitle)
        bgView.addSubview(priceTitle)
        bgView.addSubview(deal_numLab)
        bgView.addSubview(numLab)
        bgView.addSubview(priceLab)
        bgView.addSubview(progressV)
        bgView.addSubview(cancelBtn)
    }
    func initSubViewsConstraints() {
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(94)
        }
        coinLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(13)
        }
        currencyLab.snp.makeConstraints { make in
            make.left.equalTo(coinLab.snp.right)
            make.centerY.equalTo(coinLab)
        }
        statusLab.snp.makeConstraints { make in
            make.left.equalTo(currencyLab.snp.right).offset(10)
            make.centerY.equalTo(coinLab)
            make.width.equalTo(34)
            make.height.equalTo(15)
        }
        timeLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(statusLab.snp.bottom).offset(2)
        }
        amountTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(timeLab.snp.bottom).offset(6)
        }
        priceTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.centerY.equalTo(amountTitle)
        }
        deal_numLab.snp.makeConstraints { make in
            make.left.equalTo(amountTitle)
            make.top.equalTo(amountTitle.snp.bottom).offset(6)
        }
        numLab.snp.makeConstraints { make in
            make.left.equalTo(deal_numLab.snp.right)
            make.centerY.equalTo(deal_numLab)
        }
        priceLab.snp.makeConstraints { make in
            make.left.equalTo(priceTitle)
            make.centerY.equalTo(deal_numLab)
        }
        progressV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(35)
        }
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(deal_numLab)
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
    }
}
