//
//  WalletViewController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/19.
//

import UIKit

class WalletViewController: BaseViewController {
//    lazy var pagerView = JXPagingView(delegate: self)
    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    //    var titles :[String] = ["tv_fund_total_privew".localized(),"tv_market_spot".localized(),"tv_assets_account".localized(),"margin".localized(),"tv_market_fetures".localized()]
    var titles :[String] = ["tv_market_spot".localized(),"tv_assets_account".localized(),"margin".localized(),"tv_market_fetures".localized()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
    }
    //MARK: 更换语言
    @objc func changeLangage(){
        print("WalletViewController====收到changeLangage")
        self.titles = ["tv_market_spot".localized(),"tv_assets_account".localized(),"margin".localized(),"tv_market_fetures".localized()]
        segmentedViewDataSource.titles = self.titles
        self.segmentedView.reloadData()
        self.pagerView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
//MARK: ui
extension WalletViewController{
    func setUI() {
        lineView.indicatorColor = .hexColor("FCD283")
        
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.isTitleColorGradientEnabled = true

        segmentedView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44 )
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
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}
// MARK: - JXPagingViewDelegate
extension WalletViewController : JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 0
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let headerView = UIView()
        return headerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 44
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return self.segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segmentedViewDataSource.titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
//            let vc = AssumeVC()
//            return vc
            
            let vc = StockVC()
            return vc
        }else if index == 3 {
            let vc = FuturesVC()
            return vc
        }else{
            let vc = MarketsChildVC()
            return vc
        }
    }


}


// MARK: - JXPagingMainTableViewGestureDelegate
extension WalletViewController : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer
    }
}


// MARK: - JXSegmentedViewDelegate
extension WalletViewController : JXSegmentedViewDelegate{

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
//        self.pagerView.reloadData()
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

