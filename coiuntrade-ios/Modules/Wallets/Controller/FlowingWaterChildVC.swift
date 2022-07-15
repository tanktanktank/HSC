//
//  FlowingWaterChildVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/20.
//

import UIKit

class FlowingWaterChildVC: BaseViewController {
    var type : FlowingWaterType = .recharge
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
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
        table.register(FlowingWaterCell.self, forCellReuseIdentifier:  FlowingWaterCell.CELLID)
        return table
    }()
    lazy var sectionHeadView : SectionHeadView = {
        let v = SectionHeadView()
//        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40)
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    let viewModel = WalletViewModel()
    var page = 0
    var page_size = 10
    
    
    var dataArray : Array<BaseModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        configurationTabelViewRefresh()
        tableView.emptyData = setupEmptyDataView(type:.noData)
    }

}
//MARK: ViewModel 代理
extension FlowingWaterChildVC : WalletRequestDelegate {
    /// 获取提币记录成功回调
    func getOutrecordSuccess(array : Array<OutrecordModel>){
        self.tableView.endMJRefresh()
        if page == 0 {
            self.dataArray.removeAll()
        }
        self.dataArray.append(contentsOf: array)
        if array.count == page_size{
            page = page + 1
            tableView.resetMoreData(by: true)
        }else{
            tableView.resetMoreData(by: false)
        }
        tableView.reloadData()
    }
    /// 获取充值记录成功回调
    func getRechargerecordSuccess(array : Array<RechargeModel>){
        self.tableView.endMJRefresh()
        if page == 0 {
            self.dataArray.removeAll()
        }
        self.dataArray.append(contentsOf: array)
        if array.count == page_size{
            page = page + 1
            tableView.resetMoreData(by: true)
        }else{
            tableView.resetMoreData(by: false)
        }
        tableView.reloadData()
    }
    
    func getListFailure(){
        self.tableView.endMJRefresh()
    }
}
// MARK: -  网络请求
extension FlowingWaterChildVC {
    func listDataRequest(){
        let startStr : String = (sectionHeadView.starTimeBtn.titleLabel?.text ?? "")
        let start_time = startStr.timeStrChangeTotimeInterval("yyyy-MM-dd")
        let endStr : String = (sectionHeadView.endTimeBtn.titleLabel?.text ?? "")
        let end_time = endStr.timeStrChangeTotimeInterval("yyyy-MM-dd")
        
        viewModel.getOutrecord(coin: "", start_time: start_time, end_time: end_time, page: page, page_size: page_size ,type : type)
    }
    func loadDataRequest() {
        page = 0
        listDataRequest()
    }
    func loadMoreDataRequest() {
        listDataRequest()
    }
}
// MARK: - UI
extension FlowingWaterChildVC {
    func setUI() {
        viewModel.delegate = self
        self.sectionHeadView.delegate = self
        view.addSubview(self.sectionHeadView)
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints() {
        sectionHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    func configurationTabelViewRefresh() {
        self.tableView.nomalMJHeaderRefresh {
            self.loadDataRequest()
        }
        
        self.tableView.nomalMJFooterRefresh {
            self.loadMoreDataRequest()
        }
        
        self.tableView.beginMJPullRefresh()
    }
}
// MARK: - SectionHeadViewDelegate
extension FlowingWaterChildVC : SectionHeadViewDelegate{
    func clickCoin() {
        
        let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSearchController") as! TransferSearchController
        controller.type = .flowWater
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func clickTypeV(status: Int) {
        
    }
    
    ///点击开始时间
    func clickStarTime() {
        let dataPicker = EWDatePickerViewController()
        self.definesPresentationContext = true
        /// 回调显示方法
        dataPicker.backDate = { [weak self] date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateString: String = dateFormatter.string(from: date)
            
            let tempStart = dateFormatter.date(from: dateString)
            let tempStop = dateFormatter.date(from: (self?.sectionHeadView.endTimeBtn.titleLabel?.text)!)
            let intervalStart = tempStart!.timeIntervalSince1970
            let intervalStop = tempStop!.timeIntervalSince1970
            if intervalStart >  intervalStop {
                HudManager.showOnlyText("开始时间不能晚于结束时间")
                print("开始时间不能晚于结束时间")
                return
            }

            self?.sectionHeadView.starTimeBtn.setTitle(dateString, for: .normal)
        }
        dataPicker.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        dataPicker.picker.reloadAllComponents()
        /// 弹出时日期滚动到当前日期效果
        self.present(dataPicker, animated: true) {
            if (self.currentDateCom.day!) - 2 > 0{
                dataPicker.picker.selectRow(1, inComponent: 0, animated: true)
                dataPicker.picker.selectRow((self.currentDateCom.month!) - 1, inComponent: 1, animated:true)
                dataPicker.picker.selectRow((self.currentDateCom.day!) - 2, inComponent: 2, animated: true)
            }else{
                if (self.currentDateCom.month!) - 2 > 0{
                    dataPicker.picker.selectRow(1, inComponent: 0, animated: true)
                    dataPicker.picker.selectRow((self.currentDateCom.month!) - 2, inComponent: 1, animated:true)
                    dataPicker.picker.selectRow(0, inComponent: 2, animated: true)
                }else{
                    dataPicker.picker.selectRow(0, inComponent: 0, animated: true)
                    dataPicker.picker.selectRow(0, inComponent: 1, animated:true)
                    dataPicker.picker.selectRow(0, inComponent: 2, animated: true)
                }
            }
        }
    }
    ///点击结束时间
    func clickEndTime() {
        let dataPicker = EWDatePickerViewController()
        self.definesPresentationContext = true
        /// 回调显示方法
        dataPicker.backDate = { [weak self] date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateString: String = dateFormatter.string(from: date)
            
            let tempStart = dateFormatter.date(from: (self?.sectionHeadView.starTimeBtn.titleLabel?.text)!)
            let tempStop = dateFormatter.date(from: dateString)
            let intervalStart = tempStart!.timeIntervalSince1970
            let intervalStop = tempStop!.timeIntervalSince1970
            if intervalStart >  intervalStop {
                HudManager.showOnlyText("结束时间不能早于开始时间")
                print("结束时间不能早于开始时间")
                return
            }
            self?.sectionHeadView.endTimeBtn.setTitle(dateString, for: .normal)
        }
        dataPicker.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        dataPicker.picker.reloadAllComponents()
        /// 弹出时日期滚动到当前日期效果
        self.present(dataPicker, animated: true) {
            dataPicker.picker.selectRow(0, inComponent: 0, animated: true)
            dataPicker.picker.selectRow((self.currentDateCom.month!) - 1, inComponent: 1, animated:   true)
            dataPicker.picker.selectRow((self.currentDateCom.day!) - 1, inComponent: 2, animated: true)
        }
    }
    ///点击确定
    func clickSure() {
        loadDataRequest()
    }
    
    
}
// MARK: - UITableViewDelegate  UITableViewDataSource
extension FlowingWaterChildVC : UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.sectionHeadView
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlowingWaterCell.CELLID, for: indexPath) as! FlowingWaterCell
        
        switch type {
        case .recharge:
            let model : OutrecordModel = dataArray.safeObject(index: indexPath.row) as! OutrecordModel
            cell.model = model
            cell.totalLab.textColor = .hexColor("02C078")
            break
        case .withdraw:
            let model : RechargeModel = dataArray.safeObject(index: indexPath.row) as! RechargeModel
            cell.rechargeModel = model
            cell.totalLab.textColor = .hexColor("FFFFFF")
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate
extension FlowingWaterChildVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension FlowingWaterChildVC : JXPagingViewListViewDelegate{
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
