//
//  FuturesChildCurrentEntusVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/20.
//

import UIKit

class FuturesChildCurrentEntusVC: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    lazy var repealAllBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 4)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.setTitle("撤销全部".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.addTarget(self, action: #selector(tapRepealAllBtn), for: .touchUpInside)
        return btn
    }()
    lazy var line : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    
    lazy var typeV1 : QMUIButton = {
        let v = QMUIButton()
        v.setImage(UIImage(named: "index_top_down"), for: .normal)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.titleLabel?.font = FONTR(size: 13)
        v.imagePosition = QMUIButtonImagePosition.right
        v.spacingBetweenImageAndTitle = 4
        v.setTitle("合约:".localized()+"tv_all".localized(), for: .normal)
        v.addTarget(self, action: #selector(tapTypeV), for: .touchUpInside)
        return v
    }()
    lazy var typeV2 : QMUIButton = {
        let v = QMUIButton()
        v.setImage(UIImage(named: "index_top_down"), for: .normal)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.titleLabel?.font = FONTR(size: 13)
        v.imagePosition = QMUIButtonImagePosition.right
        v.spacingBetweenImageAndTitle = 4
        v.setTitle("类型:".localized()+"tv_all".localized(), for: .normal)
        v.addTarget(self, action: #selector(tapTypeV2), for: .touchUpInside)
        return v
    }()
    lazy var headView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        v.addSubview(self.line)
        v.addSubview(self.repealAllBtn)
        self.repealAllBtn.frame = CGRect(x: SCREEN_WIDTH-68-12, y: 12, width: 68, height: 23)
        return v
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(FuturesHisEntrusCell.self, forCellReuseIdentifier:  FuturesHisEntrusCell.CELLID)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        
        tableView.emptyData = setupEmptyDataView(type:.noData)
        configurationTabelViewRefresh()
    }

}

// MARK: - 事件交互
extension FuturesChildCurrentEntusVC {
    @objc func tapTypeV(){
        tipManager.showActionSheetNormal(title: "选择合约", datas: [], selectedIndex: 1) { index in
            
        }
    }
    @objc func tapTypeV2(){
        let datas = ["全部","限价","市价","止盈止损"]
        
        tipManager.showSingleActionSheet(datas: datas) { index in
            
        }
    }
    @objc func tapRepealAllBtn(){
    }
}
// MARK: - UI
extension FuturesChildCurrentEntusVC {
    func setUI() {
        view.addSubview(headView)
        headView.addSubview(typeV1)
        headView.addSubview(typeV2)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(43)
        }
        typeV1.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(12)
            make.height.equalTo(23)
        }
        
        typeV2.snp.makeConstraints { make in
            make.left.equalTo(typeV1.snp.right).offset(20)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(23)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    func configurationTabelViewRefresh() {
//        self.tableView.nomalMJHeaderRefresh { [weak self] in
//            self?.loadDataRequest()
//        }
//
//        self.tableView.nomalMJFooterRefresh { [weak self] in
//            self?.loadMoreDataRequest()
//        }
//
//        self.tableView.beginMJPullRefresh()
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension FuturesChildCurrentEntusVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 43
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.headView
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FuturesHisEntrusCell.CELLID, for: indexPath) as! FuturesHisEntrusCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FuturesOrderDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension FuturesChildCurrentEntusVC : JXPagingViewListViewDelegate{
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
