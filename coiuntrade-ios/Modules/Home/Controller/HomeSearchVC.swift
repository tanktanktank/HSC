//
//  HomeSearchVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/17.
//

import UIKit
import JXSegmentedView

class HomeSearchVC: BaseViewController {
    
    lazy var navView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var searchView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 15)
        
        return v
    }()
    lazy var searchImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "search-icon")
        return v
    }()
    lazy var cancelBtn : ZQButton = {
        let btn = ZQButton()
        btn.setTitle("common_cancel".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        return btn
    }()
    lazy var searchT : QMUITextField = {
        let v = QMUITextField()
        v.placeholder = "tv_market_search_tips".localized()
        v.font = FONTR(size: 12)
        v.placeholderColor = UIColor.hexColor("989898")
        v.textColor = .hexColor("989898")
        v.clearButtonMode = .whileEditing
        v.setModifyClearButton()
        v.addTarget(self, action: #selector(tapSearchT), for: .editingChanged)
        return v
    }()
    lazy var noSearchV : HomeNoSearchView = {
        let v = HomeNoSearchView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    
    lazy var pagerView = JXPagingView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
//    var titles :[String] = ["现货".localized(),"合约".localized()]
    var titles :[String] = ["现货".localized()]
    
    private var disposeBag = DisposeBag()
//    var viewModel = HomeViewModel()
//    var viewModel1 = MarketsViewModel()
    
    var vc : HomeSearchChildVC = {
        let vc = HomeSearchChildVC()
        return vc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
extension HomeSearchVC{
    @objc func tapSearchT(sender : QMUITextField){
        //限制输入长度
        let searchStr = self.searchT.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        print("您输入的是：\(searchStr)")
        self.vc.searchStr = searchStr
        if searchStr.count > 0 {
            self.noSearchV.isHidden = true
        } else{
            self.noSearchV.isHidden = false
        }
    }
    @objc func tapCancelBtn(){
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - UI
extension HomeSearchVC{
    func setUI() {
        view.addSubview(navView)
        navView.addSubview(searchView)
        navView.addSubview(cancelBtn)
        searchView.addSubview(searchImage)
        searchView.addSubview(searchT)
        
        lineView.indicatorColor = .hexColor("FCD283")
        
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 14)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 14)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isItemSpacingAverageEnabled = false
        segmentedViewDataSource.itemSpacing = 34

        segmentedView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        segmentedView.backgroundColor = .hexColor("1E1E1E")
        segmentedView.contentEdgeInsetLeft = LR_Margin+10
        segmentedView.contentEdgeInsetRight = LR_Margin+10
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 0
        segmentedView.delegate = self
        segmentedView.dataSource = self.segmentedViewDataSource
        
        ///ios15 分组悬停默认22高度改为0
        if #available(iOS 15.0, *) {
            pagerView.mainTableView.sectionHeaderTopPadding = 0
        }
        pagerView.mainTableView.backgroundColor = .hexColor("1E1E1E")
        pagerView.defaultSelectedIndex = 0
        pagerView.automaticallyDisplayListVerticalScrollIndicator = false
        pagerView.mainTableView.gestureDelegate = self
//        pagerView.pinSectionHeaderVerticalOffset = Int(SafeAreaTop)
        

        segmentedView.listContainer = pagerView.listContainerView
        view.addSubview(self.pagerView)
        
        view.addSubview(noSearchV)
    }
    func initSubViewsConstraints() {
        navView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(48)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.right.equalTo(cancelBtn.snp.left)
        }
        searchImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        searchT.snp.makeConstraints { make in
            make.right.equalTo(searchImage.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        noSearchV.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navView.snp.bottom)
        }
    }
}
// MARK: - JXPagingViewDelegate
extension HomeSearchVC : JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 0
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return UIView()
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
        return self.vc
    }


}


// MARK: - JXPagingMainTableViewGestureDelegate
extension HomeSearchVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer
    }
}

// MARK: - JXSegmentedViewDelegate
extension HomeSearchVC : JXSegmentedViewDelegate{

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
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
