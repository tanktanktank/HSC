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
    
    lazy var pagerView = JXPagingView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    var titles :[String] = ["持有仓位".localized(),"全部资产".localized()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
    }
    
}
//MARK: ui
extension FuturesVC{
    func setUI(){
        lineView.indicatorColor = .hexColor("FCD283")
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 13)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 13)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isItemSpacingAverageEnabled = false
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
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
    func initSubViewsConstraints(){
        self.pagerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
extension FuturesVC : JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        let size = headView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return Int(size.height)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return self.headView
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
        if index == 0 {
            let vc = FuturesChildVC()
            return vc
        }else{
            let vc = FuturesChildAllWalletVC()
            return vc
        }
    }
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        print("offsetY ====\(offsetY)")
//        let size = headView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        print("sizeH ====\(size.height)")
//        if offsetY >= size.height {
//            pagingView.mainTableView.isScrollEnabled = true
//        }else{
//            pagingView.mainTableView.isScrollEnabled = false
//        }
    }
}
// MARK: - JXPagingMainTableViewGestureDelegate
extension FuturesVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedViewDelegate
extension FuturesVC : JXSegmentedViewDelegate{

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
        return self.pagerView.mainTableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.scrollClosure = callback
    }

    
}
