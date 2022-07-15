//
//  FuturesVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/14.
//

import UIKit

class FuturesVC: BaseViewController {
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    lazy var headView : FuturesHeadView = FuturesHeadView()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(BalanceListCell.self, forCellReuseIdentifier:  BalanceListCell.CELLID)
        table.rowHeight = 56
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .hexColor("000000")
        setUI()
        initSubViewsConstraints()
    }
    
}
//MARK: ui
extension FuturesVC{
    func setUI(){
        let size = headView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let rect = CGRect(x: 0, y: 0, width: 0, height: size.height)
        headView.frame = rect
        tableView.tableHeaderView = headView
        self.view.addSubview(tableView)
    }
    func initSubViewsConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource
extension FuturesVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BalanceListCell.CELLID, for: indexPath) as! BalanceListCell
//        let model : AllbalanceModel = dataArray.safeObject(index: indexPath.row) ?? AllbalanceModel()
//        cell.setModelValueIsHidden(model: model, ishidden: ishideValue)
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let h = self.headView.getHeadViewHeight()
//        print("h======\(h)")
//        return h
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.headView
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
// MARK: - UIScrollViewDelegate
extension FuturesVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension FuturesVC : JXPagingViewListViewDelegate{
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
