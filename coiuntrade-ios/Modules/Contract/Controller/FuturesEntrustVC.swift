//
//  FuturesEntrustVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/12.
//

import UIKit

class FuturesEntrustVC: BaseViewController {
    
    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    var titles : [String] = ["tv_trade_record_current_entrust".localized(),
                             "tv_trade_record_history_entrust".localized(),
                             "tv_trade_record_history_deal".localized(),
                             "资金流水".localized(),
                             "资金费用".localized()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "U本位合约历史".localized()
        setUI()
        initSubViewsConstraints()
    }

}

extension FuturesEntrustVC{
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
extension FuturesEntrustVC : JXPagingViewDelegate {
    
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
            let vc = FuturesChildCurrentEntusVC()
            return vc
        }else if index == 1{
            let vc = FuturesChildHisEntrusVC()
            return vc
        }else if index == 2 {
            let vc = FuturesChildHisMakeVC()
            return vc
        }else if index == 3 {
            let vc = FuturesChildFlowwaterVC()
            return vc
        }else{
            let vc = FuturesChildFlowwaterVC()
            return vc
        }
    }

}


// MARK: - JXPagingMainTableViewGestureDelegate
extension FuturesEntrustVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedViewDelegate
extension FuturesEntrustVC : JXSegmentedViewDelegate{

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
        
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


