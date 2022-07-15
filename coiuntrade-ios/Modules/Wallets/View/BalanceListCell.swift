//
//  BalanceListCell.swift
//  test
//
//  Created by tfr on 2022/4/18.
//

import UIKit

class BalanceListCell: BaseTableViewCell {
    
    static let CELLID = "BalanceListCell"
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    ///货币名称
    lazy var balanceName : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 16)
        lab.text = "-"
        return lab
    }()
    lazy var balanceDetailName : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "-"
        return lab
    }()
    ///货币数量
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTDIN(size: 16)
        lab.text = "-"
        return lab
    }()
    ///货币价值
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTDIN(size: 12)
        lab.text = "-"
        return lab
    }()
    func setModelValueIsHidden(model : AllbalanceModel,ishidden : Bool){
        self.model = model
        iconView.kf.setImage(with: URL(string: model.coin_code_image), placeholder: PlaceholderImg())
        balanceName.text = model.coin_code
        balanceDetailName.text = model.detail_code
        if ishidden {
            totalLab.text = "******"
            moneyLab.text = "******"
        }else{
            totalLab.text = self.addMicrometerLevel(valueSwift: model.total_num)
            moneyLab.text = "≈" + self.addRateTwoDecimalsSymbol(value: model.total_num_rate)
        }
    }
    var model : AllbalanceModel = AllbalanceModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            bgView.backgroundColor = .hexColor("434343")
        }else{
            bgView.backgroundColor = .hexColor("1E1E1E")
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - UI
extension BalanceListCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        bgView.backgroundColor = .hexColor("1E1E1E")
        self.contentView.addSubview(bgView)
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(balanceName)
        self.contentView.addSubview(balanceDetailName)
        self.contentView.addSubview(totalLab)
        self.contentView.addSubview(moneyLab)
    }
    func initSubViewsConstraints() {
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(20)
        }
        balanceName.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.top.height.equalTo(iconView)
        }
        balanceDetailName.snp.makeConstraints { make in
            make.left.equalTo(balanceName)
            make.top.equalTo(balanceName.snp.bottom).offset(2)
            make.height.equalTo(15)
        }
        totalLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.height.equalTo(balanceName)
        }
        moneyLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.height.equalTo(balanceDetailName)
        }
    }
}
