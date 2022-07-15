//
//  ExchangeViewController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/29.
//

import UIKit

class ExchangeViewController: BaseViewController {
    
    lazy var searchView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 19)
        return v
    }()
    lazy var textV : QMUITextField = {
        let v = QMUITextField()
        v.textColor = .hexColor("FFFFFF")
        v.placeholderColor = .hexColor("989898")
        v.placeholder = "tv_market_search_tips".localized()
        v.font = FONTR(size: 12)
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.addTarget(self, action: #selector(tapTextV), for: .editingChanged)
        return v
    }()
    lazy var searchImageView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "register_search")
        return v
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("2D2D2D")
        table.showsVerticalScrollIndicator = false
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.register(MarkeRateCell.self, forCellReuseIdentifier:  MarkeRateCell.CELLID)
        return table
    }()
    
    var selectedCoin : String = userManager.tocoin
    
    var viewModel = InfoViewModel()
    var dataArr = Array<MarketRateModel>()
    //用于存储符合搜索框内关键字的数据
    var searchDataList:Array<MarketRateModel> = Array()
    var collactor:LocalizedCollationResult<MarketRateModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = "tv_setting_rate".localized()
        setUI()
        initSubViewsConstraints()
        getDataSource()
    }
    

}
extension ExchangeViewController{
    @objc func tapTextV(sender : QMUITextField){
        guard let searchContent = sender.text?.components(separatedBy: NSCharacterSet.whitespaces).joined(separator:"") else { return  }
        if searchContent.count > 0 {
            self.searchDataList.removeAll()
            for model in self.dataArr
            {
                if (model.tocoin.containsIgnoringCase(find: searchContent)) {
                    self.searchDataList.append(model)
                }
            }
        }else{
            self.searchDataList = self.dataArr
        }
        self.collactor = self.searchDataList.localizedCollaction();
        self.tableView.reloadData()
    }
    
    
}
extension ExchangeViewController : MineRequestDelegate{
    
    func getMarketRateSuccess(array : [MarketRateModel]){
        self.dataArr = array
        
        self.searchDataList = self.dataArr
        self.collactor = self.dataArr.localizedCollaction();
        self.tableView.reloadData()
    }
    
    ///设置目前用户使用的汇率(基础货币)成功回调
    func setUserRatecountrySuccess(model : MarketRateModel){
        self.selectedCoin = model.tocoin
        userManager.tocoin = model.tocoin
        userManager.rate = Float(model.rate) ?? 1
        userManager.rateSymbol = model.ratesymbol
        self.tableView.reloadData()
    }
}
// MARK: - UI
extension ExchangeViewController{
    ///获取数据
    func getDataSource(){
        viewModel.getMarketRate()
    }
    func setUI() {
        viewModel.delegate = self
        view.addSubview(searchView)
        view.addSubview(tableView)
        searchView.addSubview(textV)
        searchView.addSubview(searchImageView)
    }
    func initSubViewsConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(37)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
        searchImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(15)
        }
        textV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(searchImageView.snp.left).offset(-5)
        }
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension ExchangeViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return collactor?.section.count ?? 0;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collactor?.section[section].count ?? 0;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarkeRateCell.CELLID, for: indexPath) as! MarkeRateCell
        
        let model = collactor?.section[indexPath.section][indexPath.row]
        
        cell.model = model
        if selectedCoin == model?.tocoin {
            cell.selectedView.isHidden = false
        }else{
            cell.selectedView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = collactor?.section[indexPath.section][indexPath.row] else { return  }
        if model.tocoin != self.selectedCoin {
            if userManager.isLogin {
                self.viewModel.setUserRatecountry(model: model)
            }else{
                self.selectedCoin = model.tocoin
                userManager.tocoin = model.tocoin
                userManager.rate = Float(model.rate) ?? 1
                userManager.rateSymbol = model.ratesymbol
                self.tableView.reloadData()
            }
        }
    }
    ///添加右索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return collactor?.sectionTitles;
    }
    ///索引值与列表关联点击事件
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return index
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY : CGFloat = scrollView.contentOffset.y
        if offsetY <= 0 {
            self.title = ""
            self.titleLab.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(LR_Margin)
            }
            return
        }else if offsetY > 0 && offsetY < 70{
            self.title = ""
            self.titleLab.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20-offsetY)
                make.left.equalToSuperview().offset(LR_Margin)
            }
            return
        }else{
            self.title = self.titleLab.text
            return
        }
   }
}
