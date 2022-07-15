//
//  EntrustOrderDetailVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/10.
//

import UIKit

class EntrustOrderDetailVC: BaseViewController {
    lazy var headView = EntrustOrderDetailHeadView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 363))
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        table.register(EntrustOrderDetailCell.self, forCellReuseIdentifier:  EntrustOrderDetailCell.CELLID)
        return table
    }()
    
    var order_no = ""
    let viewModel : EntrustViewModel = EntrustViewModel()
    private var disposeBag = DisposeBag()
    var detailModel : EntrustModel = EntrustModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "tv_order_detail".localized()
        
        setUI()
        initSubViewsConstraints()
        
        self.viewModel.requestOrderDetail(order_no: order_no)
            .subscribe(onNext: {[weak self] value in
                self?.detailModel = value as! EntrustModel
                self?.headView.model = self?.detailModel ?? EntrustModel()
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    

}
extension EntrustOrderDetailVC {
    func setUI() {
        self.tableView.tableHeaderView = headView
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension EntrustOrderDetailVC : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailModel.deal_list.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 189
        }
        return 156
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntrustOrderDetailCell.CELLID, for: indexPath) as! EntrustOrderDetailCell
        
        let model : deal_listModel = self.detailModel.deal_list.safeObject(index: indexPath.row) ?? deal_listModel()
        cell.model = model
        if indexPath.row == 0 {
            if self.detailModel.deal_list.count == 1 {
                cell.changeUI(isShowTitleName: true, isShowLine: false, type: .all)
            }else{
                cell.changeUI(isShowTitleName: true, isShowLine: true, type: .top)
            }
        }else{
            if indexPath.row == self.detailModel.deal_list.count-1 {
                cell.changeUI(isShowTitleName: false, isShowLine: false, type: .bottom)
            }else{
                cell.changeUI(isShowTitleName: false, isShowLine: true, type: .none)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
