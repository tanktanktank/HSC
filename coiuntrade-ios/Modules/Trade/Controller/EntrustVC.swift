//
//  EntrustVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/2.
//

import UIKit

class EntrustVC: BaseViewController {
    
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    var titles : [String] = ["tv_trade_record_current_entrust".localized(),
                             "tv_trade_record_history_entrust".localized(),
                             "tv_trade_record_history_deal".localized()]
    lazy var navRightBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "enf"), for: .normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(tapNavRightBtn), for: .touchUpInside)
        return btn
    }()
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "tv_market_spot".localized()
        setUI()
        initSubViewsConstraints()
        
        let item = UIBarButtonItem(customView: navRightBtn)
        self.navigationItem.rightBarButtonItem = item
    }



}
extension EntrustVC : EntrustCondtionViewDelegate{
    func clickStartBtn(btn: UIButton, endStr: String) {
        let dataPicker = EWDatePickerViewController()
        self.definesPresentationContext = true
        /// 回调显示方法
        dataPicker.backDate = { [weak btn] date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateString: String = dateFormatter.string(from: date)
            
            let tempStart = dateFormatter.date(from: dateString)
            let tempStop = dateFormatter.date(from: endStr)
            let intervalStart = tempStart!.timeIntervalSince1970
            let intervalStop = tempStop!.timeIntervalSince1970
            if intervalStart >  intervalStop {
                HudManager.showOnlyText("开始时间不能晚于结束时间")
                print("开始时间不能晚于结束时间")
                return
            }

            btn?.setTitle(dateString, for: .normal)
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
    
    func clickEndBtn(btn: UIButton, startStr: String) {
        let dataPicker = EWDatePickerViewController()
        self.definesPresentationContext = true
        /// 回调显示方法
        dataPicker.backDate = { [weak btn] date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateString: String = dateFormatter.string(from: date)
            
            let tempStart = dateFormatter.date(from: startStr)
            let tempStop = dateFormatter.date(from: dateString)
            let intervalStart = tempStart!.timeIntervalSince1970
            let intervalStop = tempStop!.timeIntervalSince1970
            if intervalStart >  intervalStop {
                HudManager.showOnlyText("结束时间不能早于开始时间")
                print("结束时间不能早于开始时间")
                return
            }
            btn?.setTitle(dateString, for: .normal)
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
    
}
extension EntrustVC{
    @objc func tapNavRightBtn(){
        let view = EntrustCondtionView()
        view.delegate = self
        view.show()
        
    }
}
extension EntrustVC{
    func setUI(){
        lineView.indicatorColor = .hexColor("FCD283")
        
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)
        segmentedView.backgroundColor = .hexColor("1E1E1E")
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 0
        segmentedView.delegate = self
        segmentedView.dataSource = self.segmentedViewDataSource
        
        ///ios15 分组悬停默认22高度改为0
        if #available(iOS 15.0, *) {
            pagerView.mainTableView.sectionHeaderTopPadding = 0
        }
        pagerView.frame = self.view.bounds
        pagerView.mainTableView.backgroundColor = .clear
        pagerView.defaultSelectedIndex = 0
        pagerView.automaticallyDisplayListVerticalScrollIndicator = false
        pagerView.mainTableView.gestureDelegate = self
        
        segmentedView.listContainer = pagerView.listContainerView
        self.view.addSubview(pagerView)
    }
    
    func initSubViewsConstraints() {
        self.pagerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
extension EntrustVC : JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 0
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let headerView = UIView()
        return headerView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 30
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return self.segmentedView
    }
    
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segmentedViewDataSource.titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            let vc = EntrustChildAllVC()
            return vc
        }else if index == 1{
            let vc = EntrustChildHistoryVC()
            return vc
        }else{
            let vc = EntrustChildMakeVC()
            return vc
        }
    }

}


// MARK: - JXPagingMainTableViewGestureDelegate
extension EntrustVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedViewDelegate
extension EntrustVC : JXSegmentedViewDelegate{

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
        if index == 1 {
            navRightBtn.isHidden = false
        }else{
            navRightBtn.isHidden = true
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
        return true
    }
    
}


