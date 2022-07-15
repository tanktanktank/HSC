//
//  SearchHotCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/20.
//

import UIKit

class SearchHotCell: BaseTableViewCell {
    
    static let CELLID = "SearchHotCell"
    lazy var iconV : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTDIN(size: 14)
        return v
    }()
    lazy var detailV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTDIN(size: 12)
        return v
    }()
    var model : CoinModel = CoinModel(){
        didSet{
            iconV.kf.setImage(with: model.image_str, placeholder: nil)
            titleV.text = model.coin
            detailV.text = model.currency
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



extension SearchHotCell{
    func setUI(){
        self.contentView.addSubview(bgView)
        bgView.addSubview(iconV)
        bgView.addSubview(titleV)
        bgView.addSubview(detailV)
    }

    func initSubViewsConstraints(){
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        iconV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        titleV.snp.makeConstraints { make in
            make.left.equalTo(iconV.snp.right).offset(12)
            make.centerY.equalTo(iconV)
        }
        detailV.snp.makeConstraints { make in
            make.left.equalTo(titleV.snp.right).offset(6)
            make.bottom.equalTo(titleV)
        }
    }
    
}
