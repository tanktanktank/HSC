//
//  HomeMessageVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/5.
//

import UIKit

class HomeMessageVC: BaseViewController {
    
    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    var titles : [String] = []
    var viewModel : HomeViewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    var vcs : [HomeMessageChildVC] = []
    
    var msgCategorys:Array<MassageCategoryModel> = Array()
    
    lazy var clearBtn : UIButton = {
        let v = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        v.setImage(UIImage(named: "home_msg_clear"), for: .normal)
        v.addTarget(self, action: #selector(tapClearBtn), for: .touchUpInside)
        return v
    }()
    lazy var statusBtn : UIButton = {
        let v = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        v.setImage(UIImage(named: "home_msg_status_nol"), for: .normal)
        v.setImage(UIImage(named: "home_msg_status_sel"), for: .selected)
        v.addTarget(self, action: #selector(tapStatusBtn), for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "home_msg_title".localized()
        setUI()
        initSubViewsConstraints()
        getDataSource()
        
        let barButtonClear = UIBarButtonItem(customView: self.clearBtn)
        let barButtonStatus = UIBarButtonItem(customView: self.statusBtn)
        
        self.navigationItem.rightBarButtonItems = [barButtonClear,barButtonStatus]
    }

}
//MARK: 请求
extension HomeMessageVC{
    func getDataSource(){
        self.viewModel.requestMessageCategory()
            .subscribe(onNext: {[weak self] value in
                let array : Array<MassageCategoryModel> = value as! Array<MassageCategoryModel>
                
                self?.msgCategorys = array
                self?.titles.removeAll()
                self?.vcs.removeAll()
                for model in array {
                    self?.titles.append(model.name)
                    self?.vcs.append(HomeMessageChildVC())
                }
                self?.segmentedViewDataSource.titles = self?.titles ?? []
                self?.segmentedView.reloadData()
                self?.pagerView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
//MARK: 点击交互
extension HomeMessageVC{
    @objc func tapStatusBtn(sender : UIButton){
        sender.isSelected = !sender.isSelected
        let vc = self.vcs.safeObject(index: self.segmentedView.selectedIndex)
        if sender.isSelected {
            vc?.is_read = 1
        }else{
            vc?.is_read = 0
        }
    }
    @objc func tapClearBtn(){
        tipManager.showOnlyTitleAlert(title: "home_msg_list_cleartip".localized(), actionArray: ["common_cancel".localized(),"tv_continue".localized()]) { isok in
            if isok {
                let vc = self.vcs.safeObject(index: self.segmentedView.selectedIndex)
                vc?.clearMessageUnread()
            }
        }
    }
}
//MARK: ui
extension HomeMessageVC{
    func setUI(){
        lineView.indicatorColor = .hexColor("FCD283")
        
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isItemSpacingAverageEnabled = false
        segmentedViewDataSource.itemSpacing = 28
        
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
//MARK: ui
extension HomeMessageVC : JXPagingViewDelegate {
    
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
        let model: MassageCategoryModel = self.msgCategorys.safeObject(index: index) ?? MassageCategoryModel()
        let vc : HomeMessageChildVC = self.vcs.safeObject(index: index) ?? HomeMessageChildVC()
        vc.category_id = model.id
        return vc
    }

}


// MARK: - JXPagingMainTableViewGestureDelegate
extension HomeMessageVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedViewDelegate
extension HomeMessageVC : JXSegmentedViewDelegate{

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


