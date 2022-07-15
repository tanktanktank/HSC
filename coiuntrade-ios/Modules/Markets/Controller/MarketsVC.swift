//
//  MarketsVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/31.
//

import UIKit
import JXSegmentedView

class MarketsVC: BaseViewController {
    lazy var searchView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1C1C1C")
        v.corner(cornerRadius: 15)
        return v
    }()
    lazy var searchTF : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTR(size: 12)
        v.text = "tv_rate_search_coin".localized()
        return v
    }()
    lazy var searchImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "search-icon")
        return v
    }()
    lazy var spcesV : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var lineView = MySegmentedIndicatorLineView()
    lazy var segmentedTitleImageDataSource = MySegmentedTitleImageDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    var titles :[String] = ["","tv_market_spot".localized(),"tv_market_fetures".localized(),"tv_market_zones".localized()]
    
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .hexColor("000000")
        setUI()
        initSubViewsConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
        //MARK: 搜索
        let tapSearch = UITapGestureRecognizer()
        self.searchView.addGestureRecognizer(tapSearch)
        tapSearch.rx.event
            .subscribe(onNext: { recognizer in
                
                let vc = HomeSearchVC()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: 更换语言
    @objc func changeLangage(){
        print("MarketsVC====收到changeLangage")
        searchTF.text = "tv_rate_search_coin".localized()
        self.titles = ["","tv_market_spot".localized(),"tv_market_fetures".localized(),"tv_market_zones".localized()]
        segmentedTitleImageDataSource.titles = self.titles
        self.segmentedView.reloadData()
        self.listContainerView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
// MARK: - UI
extension MarketsVC{
    func setUI(){
        view.addSubview(searchView)
        searchView.addSubview(searchTF)
        searchView.addSubview(searchImage)
        view.addSubview(spcesV)
        
        lineView.indicatorColor = .hexColor("FCD283")
        lineView.isIndicatorWidthSameAsItemContent = true
        lineView.indicatorHeight = 3
        
        segmentedTitleImageDataSource.titles = titles
        segmentedTitleImageDataSource.normalImageInfos = ["mstartgay_no","","",""]
        segmentedTitleImageDataSource.selectedImageInfos = ["mstartgay","","",""]
        segmentedTitleImageDataSource.titleNormalColor = .hexColor("989898")
        segmentedTitleImageDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedTitleImageDataSource.titleNormalFont = FONTM(size: 16)
        segmentedTitleImageDataSource.titleNormalFont = FONTM(size: 16)
        segmentedTitleImageDataSource.isTitleColorGradientEnabled = true

        segmentedView.backgroundColor = .hexColor("000000")
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 0
        segmentedView.delegate = self
        segmentedView.dataSource = self.segmentedTitleImageDataSource
        view.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }
    func initSubViewsConstraints(){
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview().offset(6 + STATUSBAR_HIGH)
            make.height.equalTo(30)
        }
        searchImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        searchTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(searchImage.snp.left).offset(-12)
        }
        self.segmentedView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        spcesV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
            make.height.equalTo(10)
        }
        self.listContainerView.snp.makeConstraints { make in
            make.top.equalTo(spcesV.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - JXSegmentedListContainerViewDataSource
extension MarketsVC: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = MarketsAccountLikeVC()
            return vc
        }else if index == 1{
            let vc = MarketsSpotVC()
            return vc
        }else{
            let v = MarketsChildListView()
            v.type = .other
            return v
        }
    }
}


// MARK: - JXSegmentedViewDelegate
extension MarketsVC : JXSegmentedViewDelegate{

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

