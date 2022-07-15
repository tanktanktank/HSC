//
//  UserCerPermissionView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/27.
//

import UIKit

class UserCerPermissionView: UIView {

    var tabDataSources:[[String:String]] = [["title":"无限额","content":"数字货币充值"],["title":"无限额","content":"数字货币充值"],["title":"无限额","content":"数字货币充值"]]
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.hexColor("1e1e1e")
        setUI()
        setupContraints()
        setupEvent()
        self.addCorner(conrners: [.topLeft,.topRight], radius: 10)
    }
    
    
    @objc func bgClick(){
        hide()
    }
    
    func hide(){
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            let bgView = self.superview?.viewWithTag(1024+100)
            bgView?.alpha = 0.0
            self.y = SCREEN_HEIGHT
        }
    }
    
    func show(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            let bgView = self.superview?.viewWithTag(1024+100)
            bgView?.alpha = 1.0
            self.y = (SCREEN_HEIGHT - 349 - (is_iPhoneXSeries() ? 84 : 0) )
        }
    }
    
    func setupEvent(){
        
        closeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hide()
            }).disposed(by: disposeBag)
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hide()
            }).disposed(by: disposeBag)
    }
    
    func addBG(){
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.tag = 1024+100
        view.alpha = 0.0
        self.superview?.insertSubview(view, belowSubview: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        view.addGestureRecognizer(tap)
    }
    
    func setUI(){
        
        self.addSubview(tipLab)
        self.addSubview(closeBtn)
        self.addSubview(curTableView)
        self.addSubview(confirmBtn)
    }
    
    func setupContraints(){
        tipLab.snp.makeConstraints { make in
            make.leftMargin.equalTo(15)
            make.topMargin.equalTo(15)
            make.width.equalTo(180)
            make.height.equalTo(20)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.rightMargin.equalTo(-16)
            make.topMargin.equalTo(15)
            make.width.height.equalTo(24)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.leftMargin.equalTo(15)
            make.rightMargin.equalTo(-15)
            make.bottomMargin.equalTo(-15)
            make.height.equalTo(46)
        }
        
        curTableView.snp.makeConstraints { make in
            make.topMargin.equalTo(tipLab.snp.bottom).offset(20)
//            make.left.right.equalToSuperview()
            make.leftMargin.equalTo(22)
            make.rightMargin.equalTo(-22)
            //56*3 + 12 * 2 = 168+24 = 192
            make.height.equalTo(192)
        }
    }
    
    lazy var curTableView : BaseTableView = {
        let tableView = BaseTableView(frame: CGRect.zero, style: .plain)
        tableView.register(UserPermissionCell.self, forCellReuseIdentifier: UserPermissionCell.UserPermissionCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    lazy var tipLab: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "您当前拥有的功能"
        return lab
    }()
    lazy var closeBtn: UIButton = {
       
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "UserCerPopClose"), for: .normal)
//        btn.setBackgroundImage(UIImage.init(named: "UserCerPopClose"), for: .normal)
        return btn
    }()
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("tv_confirm".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("FCD283")
        btn.layer.cornerRadius = 4
        return btn
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UserCerPermissionView: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tabDataSources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UserPermissionCell = tableView.dequeueReusableCell(withIdentifier: UserPermissionCell.UserPermissionCellID) as! UserPermissionCell
        let tipMap = tabDataSources[indexPath.section]
        cell.item = tipMap
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
}



class UserPermissionCell: UITableViewCell {
    
    static let UserPermissionCellID = "UserPermissionCellID"
    var item = [String:String](){
        
        didSet{
            self.nameLabel.text = item["title"]
            self.contentLab.text = item["content"]
        }
    }
    
    lazy var nameLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor("ffffff")
        lab.font = FONTR(size: HSWindowAdapter.calculateFontSize(input: 13))
        return lab
    }()
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor("989898")
        lab.font = FONTR(size: HSWindowAdapter.calculateFontSize(input: 13))
        return lab
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setupConstraints()
    }
    
    func setUI(){
    
        self.backgroundColor = .clear
        contentView.backgroundColor = UIColor.hexColor("2d2d2d")
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLab)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
    
    func setupConstraints(){
        
        nameLabel.snp.makeConstraints { make in
            make.leftMargin.equalTo(10)
            make.topMargin.equalTo(9)
            make.rightMargin.equalTo(-10)
            make.height.equalTo(21)
        }
        
        contentLab.snp.makeConstraints { make in
            make.leftMargin.equalTo(10)
            make.topMargin.equalTo(nameLabel.snp.bottom).offset(4)
            make.rightMargin.equalTo(-10)
            make.height.equalTo(17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
