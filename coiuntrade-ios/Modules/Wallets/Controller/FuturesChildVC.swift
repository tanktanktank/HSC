//
//  FuturesChildUVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/18.
//

import UIKit

class FuturesChildVC: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(UINib(nibName: "FuturesHoldingCell", bundle: nil), forCellReuseIdentifier: "FuturesHoldingCell")
//        table.register(FuturesHoldingCell.self, forCellReuseIdentifier:  FuturesHoldingCell.CELLID)
        return table
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var Ubtn : UIButton = {
        let v = UIButton()
        v.setTitle("U本位合约".localized(), for: .normal)
        v.titleLabel?.font = FONTM(size: 13)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        v.setBackgroundImage(UIImage.creatColorImage(.clear), for: .normal)
        v.setBackgroundImage(UIImage.creatColorImage(.hexColor("2D2D2D")), for: .selected)
        v.corner(cornerRadius: 2)
        v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        v.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        v.isSelected = true
        v.tag = 100
        return v
    }()
    lazy var optionbtn : UIButton = {
        let v = UIButton()
        v.setTitle("期权".localized(), for: .normal)
        v.titleLabel?.font = FONTM(size: 13)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        v.setBackgroundImage(UIImage.creatColorImage(.clear), for: .normal)
        v.setBackgroundImage(UIImage.creatColorImage(.hexColor("2D2D2D")), for: .selected)
        v.corner(cornerRadius: 2)
        v.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        v.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        v.tag = 200
        v.isSelected = false
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        
        tableView.emptyData = setupEmptyDataView(type:.noData)
    }

}
//MARK: 点击交换
extension FuturesChildVC {
    @objc func tapBtn(sender : UIButton){
        if sender.tag == 100 {
            self.Ubtn.isSelected = true
            self.optionbtn.isSelected = false
        }else{
            self.Ubtn.isSelected = false
            self.optionbtn.isSelected = true
        }
    }
}
extension FuturesChildVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FuturesHoldingCell = tableView.dequeueReusableCell(withIdentifier: "FuturesHoldingCell") as! FuturesHoldingCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
extension FuturesChildVC{
    func setUI(){
        view.addSubview(line)
        view.addSubview(Ubtn)
        view.addSubview(optionbtn)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints(){
        line.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        Ubtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        optionbtn.snp.makeConstraints { make in
            make.left.equalTo(Ubtn.snp.right).offset(22)
            make.centerY.height.width.equalTo(Ubtn)
        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(Ubtn.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
// MARK: - UIScrollViewDelegate
extension FuturesChildVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension FuturesChildVC : JXPagingViewListViewDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.scrollClosure = callback
    }

    
}
