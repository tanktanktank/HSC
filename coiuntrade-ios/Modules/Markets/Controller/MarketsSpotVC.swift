//
//  MarketsSpotVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/31.
//

import UIKit

class MarketsSpotVC: BaseViewController {
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var lineView = JXSegmentedIndicatorGradientView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    private var disposeBag = DisposeBag()
    var viewModel = MarketsViewModel()
    
    
    var titles :[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        self.viewModel.requestCurrencygroup()
            .subscribe(onNext: {value in
                self.titles = value as! [String]
                self.segmentedViewDataSource.titles = self.titles
                self.segmentedView.reloadData()
                self.listContainerView.reloadData()
            }).disposed(by: disposeBag)
    }
    

}
// MARK: - UI
extension MarketsSpotVC{
    func setUI(){
        lineView.gradientColors = [UIColor.hexColor("989898").cgColor,UIColor.hexColor("989898").cgColor]
        lineView.indicatorCornerRadius = 2
        
        segmentedViewDataSource.titles = self.titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 16)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isItemSpacingAverageEnabled = false
        segmentedViewDataSource.itemSpacing = 34

        segmentedView.backgroundColor = .hexColor("1E1E1E")
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 0
        segmentedView.delegate = self
        segmentedView.dataSource = self.segmentedViewDataSource
        segmentedView.contentEdgeInsetLeft = LR_Margin+10
        segmentedView.contentEdgeInsetRight = LR_Margin+10
        view.addSubview(segmentedView)
        
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        
    }
    func initSubViewsConstraints(){
        self.segmentedView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(44)
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(segmentedView.snp.bottom)
        }
    }
}



// MARK: - JXSegmentedViewDelegate
extension MarketsSpotVC : JXSegmentedViewDelegate{

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
extension MarketsSpotVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension MarketsSpotVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let v = MarketsChildListView()
        v.type = .spot
        v.currency = self.titles.safeObject(index: index) ?? ""
        v.getDataSource()
        return v
    }
}


