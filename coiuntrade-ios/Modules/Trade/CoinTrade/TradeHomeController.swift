//
//  TradeHomeController.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/6/6.
//

import Foundation
import UIKit

class TradeHomeController: BaseViewController {
    
    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: CGRectFlatMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-1))

    var titles : [String] = ["tv_trade_quick_exchange".localized(),
                             "tv_market_spot".localized(),
                             "tv_trade_lever".localized(),
                             "tv_trade_legal_currency".localized()]
    var vcs = [NotDoneYetController(),
               CoinTraderController(),
               NotDoneYetController(),
               NotDoneYetController()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)

        setUI()

//        self.title = "现货"
//        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pagerView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    @objc func changeLangage(notify : Notification){

        titles = ["tv_trade_quick_exchange".localized(),
                                 "tv_market_spot".localized(),
                                 "tv_trade_lever".localized(),
                                 "tv_trade_legal_currency".localized()]
        segmentedViewDataSource.titles = titles
        segmentedView.reloadData()
        pagerView.reloadData()
    }
}

//MARK: ui
extension TradeHomeController{
    func setUI() {
        lineView.indicatorColor = .hexColor("FCD283")
        lineView.verticalOffset = 1
        
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 31)
        segmentedView.backgroundColor = .hexColor("1E1E1E")
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 1
        segmentedView.delegate = self
        segmentedView.dataSource = self.segmentedViewDataSource
        segmentedView.collectionView.contentOffset = CGPoint(x: 0, y: 10)
        segmentedView.contentScrollView?.isScrollEnabled = false

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
        
        let bottonLineView = UIView()
        bottonLineView.backgroundColor = UIColor.black
        segmentedView.addSubview(bottonLineView)
        
        bottonLineView.snp.makeConstraints { make in
            
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
//        bottonLineView.backgroundColor =
        
    }
}

extension TradeHomeController : JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return  Int(STATUSBAR_HIGH)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let headerView = UIView()
        return headerView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 40
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return self.segmentedView
    }
    
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segmentedViewDataSource.titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let vc = vcs[index]
        return vc as! JXPagingViewListViewDelegate
    }
    
    @objc func mainTableViewDidScroll(_ scrollView: UIScrollView){
        
//        print("\(scrollView.contentOffset)")
        self.segmentedView.alpha = 1 - (scrollView.contentOffset.y/Double(STATUSBAR_HIGH))
    }
}


// MARK: - JXPagingMainTableViewGestureDelegate
extension TradeHomeController : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedViewDelegate
extension TradeHomeController : JXSegmentedViewDelegate{

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



