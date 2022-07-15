//
//  FlowingWaterVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/20.
//

import UIKit
enum FlowingWaterType : Int{
    case recharge = 1 //充值
    case withdraw = 2 //提现
    case transferred = 3 //划转
    case distribute = 4 //分发
}
class FlowingWaterVC: BaseViewController {
    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    var titles : [String] = ["tv_home_desposit".localized(),
                             "tv_fund_withdraw".localized(),
                             "tv_fund_tran".localized(),
                             "tv_fund_dispath".localized()]
    
    var listTypes : [FlowingWaterType] = [.recharge, .withdraw, .transferred, .distribute]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "flowing_water".localized()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //处于第一个item的时候，才允许屏幕边缘手势返回
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pagerView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
}
//MARK: ui
extension FlowingWaterVC{
    func setUI() {
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
}

extension FlowingWaterVC : JXPagingViewDelegate {
    
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
        let vc = FlowingWaterChildVC()
        vc.type = listTypes[index]
        return vc
    }

}


// MARK: - JXPagingMainTableViewGestureDelegate
extension FlowingWaterVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedViewDelegate
extension FlowingWaterVC : JXSegmentedViewDelegate{

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


