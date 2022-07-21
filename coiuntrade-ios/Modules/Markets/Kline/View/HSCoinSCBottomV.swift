//
//  HSCoinSCBottomV.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/13.
//

import UIKit
import SwiftUI

class HSCoinSCBottomV: UIView {

    var buys = [Any]()
    var sells = [Any]()
    var latests = [Any]()
    var isAgreement: Bool = false
    private var curOrderType = 0 //0委托，1最新成交，2交易数据
    private var disposeBag = DisposeBag()
    
    convenience init(agreement:Bool){
        self.init()
        isAgreement = agreement
        setupUI()
        setupConstraints()
        setupEvent()
//        print("This music type is \(musicType)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setupUI()
//        setupConstraints()
//        setupEvent()
    }
    
    func setupEvent(){
        
        let buttonOrders = self.orderBtnArr.map { $0 }
        let orderButton = Observable.from(
            buttonOrders.map { button in button.rx.tap.map {button} }
        ).merge()
        orderButton.map {[weak self] value in
            
            let line = self?.topView.viewWithTag(1024)
            for button in buttonOrders {
                if button.tag == value.tag{
                    button.isSelected = true
                } else{
                    button.isSelected = false
                }
            }
            if(line != nil){
                UIView.animate(withDuration: 0.28, delay: 0.0) {
                    line!.centerX = value.centerX
                }
            }
            
            //点一下的时候，先更新一下数据，避免出于等待过程中，数据还是 比较老的数据
            if(value.tag == 0){
                self?.buyTableView.reloadData()
                self?.sellTableView.reloadData()
            }else if(value.tag == 1){
                self?.latestTableV.reloadData()
            }
            self?.curOrderType = value.tag
            self?.scrollV.setContentOffset(CGPoint(x: value.tag * Int(SCREEN_WIDTH), y: 0), animated: true)
        }
        .subscribe(onNext: {value in
        }).disposed(by: disposeBag)
    }
    
    //0买，1卖，2最新，3买卖
    func update(type: Int){
        
        if(type == 3){
            if(self.curOrderType == 0){
                buyTableView.reloadData()
                sellTableView.reloadData()
            }
        }else if(type == 0){
            if(self.curOrderType == 0){
                buyTableView.reloadData()
            }
        }else if(type == 1){
            if(self.curOrderType == 0){
                sellTableView.reloadData()
            }
        }else if(type == 2){
            if(self.curOrderType == 1){
                latestTableV.reloadData()
            }
        }
    }
    
    func setupUI()
    {
        addSubview(topView)
        addSubview(scrollV)
        scrollV.addSubview(orderView)
        scrollV.addSubview(latestView)
        orderView.addSubview(orderTiltleView)
        orderView.addSubview(orderContentV)
        orderContentV.addSubview(buyTableView)
        orderContentV.addSubview(sellTableView)
        latestView.addSubview(latestTiltleView)
        latestView.addSubview(latestTableV)
    }
    
    func setupConstraints(){
        
        let buyTableW = SCREEN_WIDTH * 0.5
        scrollV.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: 1)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(48)
        }
        scrollV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(444) // 12+12+20 + 16 * 20, 12+12+20 + 20 * 20
        }
        orderView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalToSuperview()
        }
        latestView.snp.makeConstraints { make in
            make.left.equalTo(orderView.snp.right)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalToSuperview()
        }
        orderTiltleView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        orderContentV.snp.makeConstraints { make in
            make.top.equalTo(orderTiltleView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(400) //16 * 20 = 320, 20 * 20 = 400
        }
        buyTableView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(buyTableW)
            make.height.equalToSuperview()
        }
        sellTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(buyTableView.snp.right)
            make.width.equalTo(buyTableW)
            make.height.equalToSuperview()
        }
        latestTiltleView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        latestTableV.snp.makeConstraints { make in
            make.top.equalTo(latestTiltleView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(orderContentV.snp.height)
        }
    }
    
    
    lazy var orderContentV: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var orderTiltleView: UIView = {
        
        let view = UIView()
        
        let bidLab = UILabel()
        bidLab.font = UIFont.systemFont(ofSize: 11)
        bidLab.textColor = UIColor.hexColor("979797")
        bidLab.text = "Bid"
        
        let askLab = UILabel()
        askLab.font = UIFont.systemFont(ofSize: 11)
        askLab.textColor = UIColor.hexColor("979797")
        askLab.text = "Ask"
        askLab.textAlignment = .center
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.hexColor("2d2d2d")
        btn.layer.cornerRadius = 4
        let imageV = UIImageView.init(image: UIImage.init(named: "mdown"))
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("979797")
        lab.text = "0.01"
        btn.addSubview(imageV)
        btn.addSubview(lab)
        
        view.addSubview(bidLab)
        view.addSubview(askLab)
        view.addSubview(btn)
        
        //70
        bidLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.height.equalToSuperview()
            make.width.equalTo(50)
        }
        askLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.top.equalToSuperview()
            make.width.equalTo(50)
        }
        btn.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.top.height.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
        }
        lab.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.height.top.equalToSuperview()
        }
        imageV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.height.width.equalTo(10)
            make.centerY.equalToSuperview()
        }

        return view
    }()
    
    lazy var latestTiltleView: UIView = {
        
        let view = UIView()
//        view.backgroundColor = .gray
        
        let timeLab = UILabel()
        timeLab.font = UIFont.systemFont(ofSize: 11)
        timeLab.textColor = UIColor.hexColor("979797")
        timeLab.text = "时间"
        
        let priceLab = UILabel()
        priceLab.font = UIFont.systemFont(ofSize: 11)
        priceLab.textColor = UIColor.hexColor("979797")
        priceLab.text = "价格"
        
        let aumLab = UILabel()
        aumLab.font = UIFont.systemFont(ofSize: 11)
        aumLab.textColor = UIColor.hexColor("979797")
        aumLab.text = "数量"
        aumLab.textAlignment = .right
        
        view.addSubview(timeLab)
        view.addSubview(priceLab)
        view.addSubview(aumLab)
        
        timeLab.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.height.equalToSuperview()
            make.width.equalTo(50)
        }
        priceLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.top.equalToSuperview()
            make.left.equalTo(125)
        }
        aumLab.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.top.height.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        return view
    }()
    
    
    lazy var buyTableView: UITableView = {
        
        let  tableView = UITableView()
        tableView.register(UINib(nibName: "BuyShowCell",bundle: nil), forCellReuseIdentifier: "BuyShowCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 22
        tableView.backgroundColor = .clear
        tableView.tag = 0
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var sellTableView: UITableView = {
        
        let  tableView = UITableView()
        tableView.register(UINib(nibName: "SellShowCell",bundle: nil), forCellReuseIdentifier: "SellShowCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 22
        tableView.backgroundColor = .clear
        tableView.tag = 1
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var latestTableV: UITableView = {
        
        let  tableView = UITableView()
        tableView.register(UINib(nibName: "NewdealCell",bundle: nil), forCellReuseIdentifier: "NewdealCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 22
        tableView.backgroundColor = .clear
        tableView.tag = 2
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var latestView: UIView = {
        
        let view = UIView()
//        view.backgroundColor = .blue
        return view
    }()
    
    lazy var orderView: UIView = {
        
        let view = UIView()
//        view.backgroundColor = .red
        return view
    }()

    lazy var scrollV: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
//        scrollView.backgroundColor = .yellow
        return scrollView
    }()
    
    lazy var topView: UIView = {
        
        let view = UIView()
//        view.backgroundColor = .lightGray
        
        var titles = ["委托订单", "最新成交", "交易数据"]
        if(self.isAgreement){
            titles = ["委托订单", "最新成交", "交易数据", "信息"]
        }
        let btnW: CGFloat = SCREEN_WIDTH / CGFloat(titles.count)
        let btnH = 48
        
        let line = UIView()
        line.backgroundColor = UIColor.hexColor("fcd283")
        line.frame = CGRect(x: 0, y: 45, width: 70, height: 3)
        line.addCorner(conrners: .allCorners, radius: 1.5)
        line.tag = 1024

        var idx: Int = 0
        for str in titles {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
            btn.setTitleColor(UIColor.hexColor("ffffff"), for: .selected)
            btn.frame = CGRect(x: CGFloat(idx) * btnW, y: 0, width: btnW, height: CGFloat(btnH))
            btn.tag = idx
            view.addSubview(btn)
            self.orderBtnArr.append(btn)
            if(idx < 1){
                btn.isSelected = true
                line.centerX = btn.centerX
            }
            idx += 1
        }
        view.addSubview(line)
        return view
    }()
    
    lazy var orderBtnArr = [UIButton]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HSCoinSCBottomV: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return self.buys.count
        case 1:
            return self.sells.count
        case 2:
            return self.latests.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0
        {
            let cell: BuyShowCell = tableView.dequeueReusableCell(withIdentifier: "BuyShowCell") as! BuyShowCell
            cell.datas = (self.buys[indexPath.row] as! Array<String>)
            return cell
        }
        else if tableView.tag == 1{
            let cell: SellShowCell = tableView.dequeueReusableCell(withIdentifier: "SellShowCell") as! SellShowCell
            cell.datas = (self.sells[indexPath.row] as! Array<String>)
            return cell
        }
        else{
            let cell: NewdealCell = tableView.dequeueReusableCell(withIdentifier: "NewdealCell") as! NewdealCell
            var news = [Any]()
            if(self.latests.count > indexPath.row){
                news = (self.latests[indexPath.row] as! Array<Any>)
            }
            cell.datas = news
            return cell
        }
    }
}
