//
//  AssumeCell.swift
//  test
//
//  Created by tfr on 2022/4/19.
//

import UIKit

class AssumeCell: UITableViewCell {
    
    static let CELLID = "AssumeCell"
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 16)
        lab.text = "tv_fund_portfolio".localized()
        return lab
    }()
    lazy var bgView : BaseTableView = {
        let table = BaseTableView(frame: .zero, style: .plain)
        table.backgroundColor = .hexColor("2D2D2D")
        table.layer.cornerRadius = 4
        table.clipsToBounds = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(AccountBCell.self, forCellReuseIdentifier:  AccountBCell.CELLID)
        table.rowHeight = 56
        table.bounces = false
        return table
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
extension AssumeCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(bgView)
    }
    func initSubViewsConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(20)
        }
        bgView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(402)
            make.bottom.equalToSuperview()
        }
    }
}
extension AssumeCell : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountBCell.CELLID, for: indexPath) as! AccountBCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


class AccountBCell : UITableViewCell{
    
    static let CELLID = "AccountBCell"
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("989898")
        lab.text = "现货账户"
        return lab
    }()
    lazy var totalBLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 14)
        lab.textColor = .hexColor("FFFFFF")
        lab.text = "0.00000419 BTC"
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 12)
        lab.textColor = .hexColor("989898")
        lab.text = "≈$98562.35"
        return lab
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
extension AccountBCell{
    func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(totalBLab)
        self.contentView.addSubview(detailLab)
    }
    func initSubViewsConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        totalBLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
        }
        detailLab.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-11)
        }
    }
}
