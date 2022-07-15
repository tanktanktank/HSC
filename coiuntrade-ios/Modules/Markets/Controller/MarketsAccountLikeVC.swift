//
//  MarketsAccountLikeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/31.
//

import UIKit

class MarketsAccountLikeVC: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var lineView = JXSegmentedIndicatorGradientView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    lazy var listV = MarketsChildListView()
    
    lazy var editBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "medit"), for: .normal)
        btn.addTarget(self, action: #selector(tapEditBtn), for: .touchUpInside)
        return btn
    }()
//    var titles :[String] = ["tv_market_spot".localized(),"tv_market_fetures".localized()]
    var titles :[String] = ["tv_market_spot".localized()]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
    }
}
//MARK: 点击事件
extension MarketsAccountLikeVC{
    ///点击编辑
    @objc func tapEditBtn(){
        if segmentedView.selectedIndex == 0 {
            listV.clickEditWithModel()
        }else{
            
        }
    }
}
// MARK: - UI
extension MarketsAccountLikeVC{
    func setUI(){
        lineView.gradientColors = [UIColor.hexColor("989898").cgColor,UIColor.hexColor("989898").cgColor]
        lineView.indicatorCornerRadius = 2
        
        segmentedViewDataSource.titles = titles
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
        
        view.addSubview(self.editBtn)
    }
    func initSubViewsConstraints(){
        self.editBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.width.height.equalTo(44)
        }
        self.segmentedView.snp.makeConstraints { make in
            make.right.equalTo(editBtn.snp.left).offset(-10)
            make.left.top.equalTo(self.view)
            make.height.equalTo(44)
        }
        self.listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(segmentedView.snp.bottom)
        }
    }
}



extension MarketsAccountLikeVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension MarketsAccountLikeVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
             
        if index == 0 {
            listV.type = .accountLike
            listV.getDataSource()
            return listV
        }else{
            let v = MarketsChildListView()
            v.type = .other
            return v
        }
    }
}

// MARK: - JXSegmentedViewDelegate
extension MarketsAccountLikeVC : JXSegmentedViewDelegate{

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

