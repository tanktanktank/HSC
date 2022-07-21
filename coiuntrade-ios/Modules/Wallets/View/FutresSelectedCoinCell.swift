//
//  FutresSelectedCoinCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/21.
//

import UIKit

class FutresSelectedCoinCell: UITableViewCell {
    static let CELLID = "FutresSelectedCoinCell"
    lazy var iconV : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 9)
        return v
    }()
    lazy var nameV : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 14)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var detailV : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 12)
        v.textColor = .hexColor("989898")
        v.text = "--"
        return v
    }()
    lazy var numV : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 14)
        v.textColor = .hexColor("FFFFFF")
        v.text = "--"
        return v
    }()
    lazy var priceV : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 12)
        v.textColor = .hexColor("989898")
        v.text = "--"
        return v
    }()
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
extension FutresSelectedCoinCell{
    func setUI(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        contentView.addSubview(iconV)
        contentView.addSubview(nameV)
        contentView.addSubview(detailV)
        contentView.addSubview(numV)
        contentView.addSubview(priceV)
    }
    func initSubViewsConstraints(){
        iconV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.height.equalTo(18)
        }
        nameV.snp.makeConstraints { make in
            make.left.equalTo(iconV.snp.right).offset(9)
            make.bottom.equalTo(iconV.snp.centerY).offset(-0.5)
            make.height.equalTo(19)
        }
        detailV.snp.makeConstraints { make in
            make.left.equalTo(nameV)
            make.top.equalTo(iconV.snp.centerY).offset(0.5)
            make.height.equalTo(16)
        }
        numV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.height.equalTo(nameV)
        }
        priceV.snp.makeConstraints { make in
            make.right.equalTo(numV)
            make.centerY.height.equalTo(detailV)
        }
    }
}
