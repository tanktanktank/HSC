//
//  FlowingWaterCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/20.
//

import UIKit

class FlowingWaterCell: UITableViewCell {

    static let CELLID = "FlowingWaterCell"
    ///名称
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 14)
        lab.text = "tv_home_desposit".localized()
        return lab
    }()
    ///时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "2022.01.22 15:45:14"
        return lab
    }()
    ///货币数量
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("02C078")
        lab.font = FONTR(size: 14)
        lab.text = "+157.35"
        return lab
    }()
    ///状态
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 12)
        lab.text = "tv_success".localized()
        return lab
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    var model : OutrecordModel = OutrecordModel(){
        didSet{
            titleLab.text = "tv_fund_withdraw".localized()
        }
    }
    var rechargeModel : RechargeModel = RechargeModel(){
        didSet{
            titleLab.text = "tv_home_desposit".localized()
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
extension FlowingWaterCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(totalLab)
        self.contentView.addSubview(moneyLab)
        self.contentView.addSubview(line)
    }
    func initSubViewsConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(20)
        }
        timeLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-20)
        }
        totalLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(titleLab)
        }
        moneyLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(timeLab)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
