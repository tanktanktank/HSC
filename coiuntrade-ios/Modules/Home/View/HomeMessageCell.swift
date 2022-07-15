//
//  HomeMessageCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/6.
//

import UIKit

class HomeMessageCell: BaseTableViewCell {
    
    static let CELLID = "HomeMessageCell"
    
    lazy var timeLab : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var contentLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        v.numberOfLines = 2
        return v
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898",alpha:0.2)
        return v
    }()
    lazy var detailLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 12)
        v.text = "home_msg_list_detail".localized()
        return v
    }()
    lazy var statusV : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("FCD283")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .center
        return v
    }()
    var model : MessageModel = MessageModel(){
        didSet{
            self.contentLab.text = model.little_title
            self.timeLab.text = model.create_time
            if model.is_read == 1{
                self.statusV.isHidden = false
            }else{
                self.statusV.isHidden = true
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
//MARK: ui
extension HomeMessageCell{
    func setUI(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        bgView.corner(cornerRadius: 4)
        self.contentView.addSubview(timeLab)
        self.contentView.addSubview(bgView)
        bgView.addSubview(contentLab)
        bgView.addSubview(line)
        bgView.addSubview(detailLab)
        bgView.addSubview(statusV)
        bgView.addSubview(arrow)
    }

    func initSubViewsConstraints(){
        timeLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(47)
        }
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(timeLab.snp.bottom)
            make.height.equalTo(102)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(detailLab)
            make.width.height.equalTo(15)
        }
        statusV.snp.makeConstraints { make in
            make.centerY.equalTo(detailLab)
            make.right.equalTo(arrow.snp.left).offset(-10)
            make.width.height.equalTo(8)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalTo(detailLab.snp.top)
            make.height.equalTo(0.5)
        }
        contentLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalTo(line.snp.top).offset(-15)
        }
    }
    
}
