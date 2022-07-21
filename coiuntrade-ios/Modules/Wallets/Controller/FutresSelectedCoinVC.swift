//
//  FutresSelectedCoinVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/21.
//

import UIKit

class FutresSelectedCoinVC: BaseViewController {
    
    lazy var navView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var searchView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 15)
        
        return v
    }()
    lazy var searchImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "search-icon")
        v.contentMode = .center
        return v
    }()
    lazy var cancelBtn : ZQButton = {
        let btn = ZQButton()
        btn.setTitle("common_cancel".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        return btn
    }()
    lazy var searchT : QMUITextField = {
        let v = QMUITextField()
        v.placeholder = "tv_market_search_tips".localized()
        v.font = FONTR(size: 12)
        v.placeholderColor = UIColor.hexColor("989898")
        v.textColor = .hexColor("989898")
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.addTarget(self, action: #selector(tapSearchT), for: .editingChanged)
        return v
    }()
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(FutresSelectedCoinCell.self, forCellReuseIdentifier:  FutresSelectedCoinCell.CELLID)
        table.bounces = false
        return table
    }()
    lazy var sectionHeadView : FuturesSelectedCoinHeadView = {
        let v = FuturesSelectedCoinHeadView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}
extension FutresSelectedCoinVC{
    @objc func tapSearchT(sender : QMUITextField){
        //限制输入长度
        let searchStr = self.searchT.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        print("您输入的是：\(searchStr)")
        
    }
    @objc func tapCancelBtn(){
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource
extension FutresSelectedCoinVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let size = sectionHeadView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size.height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeadView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FutresSelectedCoinCell.CELLID, for: indexPath) as! FutresSelectedCoinCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
//MARK: ui
extension FutresSelectedCoinVC{
    func setUI(){
        view.addSubview(navView)
        navView.addSubview(searchView)
        navView.addSubview(cancelBtn)
        searchView.addSubview(searchImage)
        searchView.addSubview(searchT)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints(){
        navView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(48)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.right.equalTo(cancelBtn.snp.left)
        }
        searchImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        searchT.snp.makeConstraints { make in
            make.right.equalTo(searchImage.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
