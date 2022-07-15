//
//  ChildVC.swift
//  test
//
//  Created by tfr on 2022/4/18.
//

import UIKit

class AssumeVC: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(AssumeCell.self, forCellReuseIdentifier:  AssumeCell.CELLID)
        table.estimatedRowHeight = 454
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    lazy var headView : AssumeheadView = {
        let v = AssumeheadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 106))
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
    }
 
}
//MARK: ui
extension AssumeVC{
    func setUI() {
        self.tableView.tableHeaderView = self.headView
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view)
            
        }
    }
}

extension AssumeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssumeCell.CELLID, for: indexPath) as! AssumeCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate
extension AssumeVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension AssumeVC : JXPagingViewListViewDelegate{
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
