//
//  HomeMassageChildVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/6.
//

import UIKit

class HomeMessageChildVC: BaseViewController {
    
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(HomeMessageCell.self, forCellReuseIdentifier:  HomeMessageCell.CELLID)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    private var disposeBag = DisposeBag()
    var viewModel : HomeViewModel = HomeViewModel()
    
    var page_index = 1
    var is_read = 0{
        didSet{
            self.page_index = 1
            self.dataArray.removeAll()
            loadDataRequest()
        }
    }
    var category_id = 0{
        didSet{
            configurationTabelViewRefresh()
        }
    }
    var dataArray : Array<MessageModel> = Array()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        tableView.emptyData = setupEmptyDataView(type:.noData)
    }
    
}
extension HomeMessageChildVC{
    //MARK: 设置全部已读
    func clearMessageUnread(){
        self.viewModel.requestMessageClearUnread(category_id: self.category_id).subscribe { _result in
            HudManager.showOnlyText(String(format: "home_msg_list_read_tip".localized(), _result))
            self.page_index = 1
            self.dataArray.removeAll()
            self.loadDataRequest()
        } onError: { Error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
    func configurationTabelViewRefresh() {
        self.tableView.nomalMJHeaderRefresh { [weak self] in
            
            self?.page_index = 1
            self?.loadDataRequest()
        }

        self.tableView.nomalMJFooterRefresh { [weak self] in
            self?.loadMoreDataRequest()
        }
        
        self.tableView.beginMJPullRefresh()
    }
    func loadMoreDataRequest() {
        loadDataRequest()
    }
    func loadDataRequest(){
        self.viewModel.requestMessageList(page_index: self.page_index, category_id: self.category_id,is_read: self.is_read).subscribe { _result in
            let data : MessageData = _result
            let array = data.data_list
            if self.page_index == 1{
                self.dataArray.removeAll()
            }
            if array.count > 0{
                for model in array {
                    self.dataArray.append(model)
                }
                self.page_index += 1
            }
            if self.is_read == 1{
                HudManager.showOnlyText("已隐藏全部已读消息".localized())
            }
            self.tableView.endMJRefresh()
            self.tableView.reloadData()
        } onError: { Error in
            self.tableView.endMJRefresh()
            self.tableView.reloadData()
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension HomeMessageChildVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 149
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeMessageCell = tableView.dequeueReusableCell(withIdentifier: HomeMessageCell.CELLID) as! HomeMessageCell
        let model : MessageModel = self.dataArray.safeObject(index: indexPath.row) ?? MessageModel()
        cell.model = model
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model : MessageModel = self.dataArray.safeObject(index: indexPath.row) ?? MessageModel()
        model.is_read = 2
        self.tableView.reloadRows(at: [indexPath], with: .none)
        let vc = HomeMessageDetailVC()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - ui
extension HomeMessageChildVC{
    func setUI(){
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints(){
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-SafeAreaBottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

//MARK: JXPagingViewListViewDelegate
extension HomeMessageChildVC : JXPagingViewListViewDelegate{
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
