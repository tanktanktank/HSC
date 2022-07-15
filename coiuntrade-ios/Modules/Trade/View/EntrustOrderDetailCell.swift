//
//  TEntrustOrderDetailCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/10.
//

import UIKit

class EntrustOrderDetailCell: UITableViewCell {

    static let CELLID = "TEntrustOrderDetailCell"
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        return v
    }()
    lazy var titleName : UILabel = {
        let lab = UILabel()
        lab.text = "成交详情".localized()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var dayName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_date".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblDay : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var priceName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_price".localized()
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
    lazy var numName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_amount".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblNum : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
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
    lazy var roleName : UILabel = {
        let lab = UILabel()
        lab.text = "tv_trade_role".localized()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        return lab
    }()
    lazy var lblRole : UILabel = {
        let lab = UILabel()
        lab.text = "-"
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 12)
        return lab
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    var type : RadiusType = .none
    ///修改UI样式
    ///isShowTitleName 是否显示TitleName 控件
    ///isShowLine 是否显示分割线
    ///type 圆角样式
    func changeUI(isShowTitleName : Bool,isShowLine : Bool,type : RadiusType){
        self.line.isHidden = !isShowLine
        self.titleName.isHidden = !isShowTitleName
        self.type = type
        if isShowTitleName {
            dayName.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.top.equalTo(titleName.snp.bottom).offset(12)
            }
        }else{
            dayName.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.top.equalToSuperview().offset(12)
            }
        }
    }
    
    var model : deal_listModel = deal_listModel(){
        didSet{
            self.lblDay.text = DateManager.getDateByYYMdStamp(model.create_date)
            self.lblPrice.text = model.price
            self.lblNum.text = model.num
            self.lblFee.text = model.poundage
            self.lblRole.text = model.is_trigger_str
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: LR_Margin, y: 0, width: SCREEN_WIDTH-LR_Margin*2, height: self.height)
        
            switch type {
            case .none:
                break
            case .top:
                bgView.addCorner(conrners: [.topLeft,.topRight], radius: 4)
                break
            case .bottom:
                bgView.addCorner(conrners: [.bottomLeft,.bottomRight], radius: 4)
                break
            case .all:
                bgView.corner(cornerRadius: 4)
                break
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
// MARK: - UI
extension EntrustOrderDetailCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(bgView)
        bgView.addSubview(titleName)
        bgView.addSubview(dayName)
        bgView.addSubview(lblDay)
        bgView.addSubview(priceName)
        bgView.addSubview(lblPrice)
        bgView.addSubview(numName)
        bgView.addSubview(lblNum)
        bgView.addSubview(feeName)
        bgView.addSubview(lblFee)
        bgView.addSubview(roleName)
        bgView.addSubview(lblRole)
        bgView.addSubview(line)
    }
    func initSubViewsConstraints() {
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        titleName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
        }
        dayName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(titleName.snp.bottom).offset(12)
        }
        lblDay.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(dayName)
        }
        priceName.snp.makeConstraints { make in
            make.left.equalTo(dayName)
            make.top.equalTo(dayName.snp.bottom).offset(12)
        }
        lblPrice.snp.makeConstraints { make in
            make.right.equalTo(lblDay)
            make.centerY.equalTo(priceName)
        }
        numName.snp.makeConstraints { make in
            make.left.equalTo(dayName)
            make.top.equalTo(priceName.snp.bottom).offset(12)
        }
        lblNum.snp.makeConstraints { make in
            make.right.equalTo(lblDay)
            make.centerY.equalTo(numName)
        }
        feeName.snp.makeConstraints { make in
            make.left.equalTo(dayName)
            make.top.equalTo(numName.snp.bottom).offset(12)
        }
        lblFee.snp.makeConstraints { make in
            make.right.equalTo(lblDay)
            make.centerY.equalTo(feeName)
        }
        roleName.snp.makeConstraints { make in
            make.left.equalTo(dayName)
            make.top.equalTo(feeName.snp.bottom).offset(12)
        }
        lblRole.snp.makeConstraints { make in
            make.right.equalTo(lblDay)
            make.centerY.equalTo(roleName)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(roleName.snp.bottom).offset(12)
            make.height.equalTo(0.5)
        }
    }
}
