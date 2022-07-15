//
//  RechageDetaillVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit

class RechageDetaillVC: BaseViewController {
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "tradsuc")
        return v
    }()
    lazy var amountLab : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 26)
        v.textColor = .hexColor("EBEBEB")
        v.text = "2.355868"
        return v
    }()
    lazy var unitLab : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 16)
        v.textColor = .hexColor("FFFFFF")
        v.text = "USDT"
        return v
    }()
    lazy var detailLab : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "数字币已经充值成功，您可以在现货钱包中查看详情。".localized()
        return v
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var sureV : RechageDetailCellView = {
        let v = RechageDetailCellView()
        v.titleV.text = "tv_confirm".localized()
        v.contentV.text = "50/1"
        v.type = .normal
        return v
    }()
    lazy var mainNetV : RechageDetailCellView = {
        let v = RechageDetailCellView()
        v.titleV.text = "tv_recharge_mian_net".localized()
        v.contentV.text = "TPX"
        v.type = .normal
        return v
    }()
    lazy var addressV : RechageDetailCellView = {
        let v = RechageDetailCellView()
        v.titleV.text = "tv_cash_flow_address".localized()
        v.contentV.text = "TShGbh2rzwCg6BhkyEzDmrUUTShGbh2rzwCg6BhkyEzDmrUU"
        v.type = .copy
        return v
    }()
    lazy var xihaV : RechageDetailCellView = {
        let v = RechageDetailCellView()
        v.titleV.text = "tv_flow_trade_hash".localized()
        v.contentV.text = "TShGbh2rzwC6BhkEzDmrUUTShGbh2rzwC6BhkEzDmrUUTShGbh2rzwC6BhkEzDmrUU"
        v.type = .copy
        return v
    }()
    lazy var dateV : RechageDetailCellView = {
        let v = RechageDetailCellView()
        v.titleV.text = "tv_trade_date".localized()
        v.contentV.text = "2022-03-28 16:21:10"
        v.type = .normal
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLab.text = "充值详情".localized()
        
        setUI()
        initSubViewsConstraints()
    }
    


}
//MARK: ui
extension RechageDetaillVC{
    func setUI(){
        view.addSubview(iconView)
        view.addSubview(amountLab)
        view.addSubview(unitLab)
        view.addSubview(detailLab)
        view.addSubview(line)
        view.addSubview(sureV)
        view.addSubview(mainNetV)
        view.addSubview(addressV)
        view.addSubview(xihaV)
        view.addSubview(dateV)
    }
    func initSubViewsConstraints(){
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(7)
            make.width.height.equalTo(90)
        }
        amountLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(30)
        }
        unitLab.snp.makeConstraints { make in
            make.left.equalTo(amountLab.snp.right).offset(8)
            make.bottom.equalTo(amountLab.snp.bottom).offset(-3)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalTo(amountLab)
            make.top.equalTo(amountLab.snp.bottom).offset(12)
        }
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(detailLab.snp.bottom).offset(30)
            make.height.equalTo(1)
        }
        sureV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line.snp.bottom).offset(10)
        }
        mainNetV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sureV.snp.bottom)
        }
        addressV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainNetV.snp.bottom).offset(5)
        }
        xihaV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(addressV.snp.bottom).offset(15)
        }
        dateV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(xihaV.snp.bottom).offset(20)
        }
    }
}
