//
//  FuturesCalculateController.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/19.
//

import UIKit
import RxSwift

class FuturesCalculateController: BaseViewController {

    let disposebag = DisposeBag()
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    lazy var lineView = JXSegmentedIndicatorLineView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    var titles :[String] = ["收益".localized(),"强平价格".localized()]
    
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .hexColor("1E1E1E")
        setUI()
        initSubViewsConstraints()
        
     }
    lazy var coinSymbolBtn : UIButton = {
        
        let button = UIButton()
        
        button.titleLabel?.font = FONTB(size: 16)
        button.imageView?.snp.makeConstraints({ make in
            
            make.left.equalTo(7)
            make.width.height.equalTo(20)
        })
        
        button.titleLabel?.snp.makeConstraints({ make in
           
            make.right.equalTo(-10)
        })
        return button
    }()

    lazy var topView : UIView = {
        let view = UIView()
        
        coinSymbolBtn.setImage(UIImage(named: "trelist"), for: .normal)
        coinSymbolBtn.setTitle("BTC/USDT", for: .normal)
        view.addSubview(coinSymbolBtn)

        let closeBtn = UIButton()
        view.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "futures_close"), for: .normal)

        let moreBtn = UIButton()
        view.addSubview(moreBtn)
        moreBtn.setImage(UIImage(named: "futures_more"), for: .normal)
        
        
        coinSymbolBtn.snp.makeConstraints({ make in
            
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview()
            make.height.equalTo(28)
        })
        
        closeBtn.snp.makeConstraints { make in
            
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
 
        moreBtn.snp.makeConstraints { make in
         
            make.right.equalTo(closeBtn.snp.left)
            make.top.bottom.width.equalTo(closeBtn)
        }
        
        let alwayLabel = UILabel()
        alwayLabel.text = "永续"
        alwayLabel.textColor = .white
        alwayLabel.font = FONTM(size: 12)
        
        view.addSubview(alwayLabel)
        alwayLabel.snp.makeConstraints { make in
            
            make.left.equalTo(34)
            make.bottom.equalTo(-2)
            make.height.equalTo(17)
        }
        
        closeBtn.rx.tap.subscribe ({[weak self] _ in
            
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposebag)
        

        return view
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
}
// MARK: - UI
extension FuturesCalculateController{
    func setUI(){
 
        view.addSubview(topView)
        
        lineView.indicatorColor = .hexColor("FCD283")
        lineView.verticalOffset = 1
        lineView.indicatorHeight = 3
        lineView.indicatorWidth = 28
        
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.titleNormalColor = .hexColor("989898")
        segmentedViewDataSource.titleSelectedColor = .hexColor("FFFFFF")
        segmentedViewDataSource.titleNormalFont = FONTM(size: 14)
        segmentedViewDataSource.titleNormalFont = FONTM(size: 14)
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.itemSpacing = 20

        segmentedView.backgroundColor = .hexColor("1E1E1E")
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 0
        segmentedView.delegate = self
        segmentedView.dataSource = self.segmentedViewDataSource
        view.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }
    func initSubViewsConstraints(){
 
        topView.snp.makeConstraints { make in
            make.top.equalTo(STATUSBAR_HIGH)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        self.segmentedView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(42)
        }
        
        let line = UIView()
        line.backgroundColor = .hexColor("000000")
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(self.segmentedView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - JXSegmentedListContainerViewDataSource
extension FuturesCalculateController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = FuturesCalculateProfitController()
            return vc
        }else{
            let vc = FuturesCalculateStrongPticeController()
            return vc
        }
    }
}


// MARK: - JXSegmentedViewDelegate
extension FuturesCalculateController : JXSegmentedViewDelegate{

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
