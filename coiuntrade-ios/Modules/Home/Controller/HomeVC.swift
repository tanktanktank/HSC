//
//  HomeVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/7.
//

import UIKit
import JXPagingView

class HomeVC: BaseViewController {
    lazy var navView : HomeNavView = {
        let v = HomeNavView()
        v.delegate = self
        return v
    }()
    
    lazy var pagerView = JXPagingView(delegate: self)
//    lazy var pagerView = JXPagingListRefreshView(delegate: self)
    lazy var lineView = JXSegmentedIndicatorGradientView()
    lazy var segmentedViewDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView(frame: self.view.frame)
    
    lazy var hotsVC = HomeChildVC()
    lazy var upsVC = HomeChildVC()
    lazy var downsVC = HomeChildVC()
    lazy var maxsVC = HomeChildVC()
    ///当前选中（默认热门）
    var currentIndex = 0
    
    var titles :[String] = ["tv_home_hot".localized(),"tv_home_gainers".localized(),"tv_home_loser".localized(),"tv_home_vol".localized()]
    
    lazy var headView : HomeHeadView = HomeHeadView()
    
    var bannerArray : Array<BannerModel> = []
    
    private var disposeBag = DisposeBag()
    let infoViewModel = InfoViewModel()
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        self.headView.delegate = self
        self.headView.viewModel = self.viewModel
        getBannerDataSource()
        
        getFaceID()
        self.pagerView.mainTableView.nomalMJHeaderRefresh {
            self.getBannerDataSource()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: LoginSuccessNotification, object: nil)
    }
    
    //MARK: 更换语言
    @objc func changeLangage(){
        headView.VDeposit.setTitle("tv_home_desposit".localized(), for: .normal)
        headView.VOTC.setTitle("tv_home_otc".localized(), for: .normal)
        headView.VReferrals.setTitle("tv_home_referrais".localized(), for: .normal)
        headView.VStrategy.setTitle("tv_home_stragety".localized(), for: .normal)
        headView.VMore.setTitle("tv_home_moudle_more".localized(), for: .normal)
        headView.quickBuyV.name = "tv_home_financing".localized()
        headView.quickBuyV.massgae = "tv_home_finance".localized()
        headView.financingV.name = "tv_home_quick_buy".localized()
        headView.financingV.massgae = "tv_home_quick_buy_tips".localized()
        navView.searchLab.text = "home_search".localized()
        
        self.titles.removeAll()
        self.titles = ["tv_home_hot".localized(),"tv_home_gainers".localized(),"tv_home_loser".localized(),"tv_home_vol".localized()]
        segmentedViewDataSource.titles = self.titles
        self.segmentedView.reloadData()
        self.pagerView.reloadData()
    }
    //MARK: 登录成功通知
    @objc func loginSuccess(){
        self.getBannerDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if userManager.isLogin {
            self.setMineBtn(model: userManager.infoModel ?? InfoModel())
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
}
extension HomeVC : HomeHeadViewDelegate{
    //MARK: 点击主流币
    func clickMainCoin(model: CoinModel) {
        
        let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        controller.model = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: 点击用滚动币种
    func clickMarquee(model: CoinModel) {
        let controller = getViewController(name: "KlineStoryboard", identifier: "KlineDealController") as! KlineDealController
        controller.model = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
    //MARK: 点击公告
    func clickNotice(index : Int){
        let model : NoticeShowModel = self.viewModel.notices.safeObject(index: index) ?? NoticeShowModel()
        let vc = WebViewController()
        vc.urlStr = model.url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC : HomeNavViewDelegate{
    //MARK: 点击搜索
    func clickSearchView() {
        let vc = HomeSearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: 点击个人中心
    func clickMineBtn() {
        let vc = MineViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: 点击站内信
    func clickTopNoticeV(){
        if userManager.isLogin {
            let vc = HomeMessageVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            userManager.logoutWithVC(currentVC: self)
        }
    }
    
}
//MARK: 请求
extension HomeVC{
    func getBannerDataSource() {
        self.pagerView.mainTableView.endMJRefresh()
        //MARK: 获取站内信未读数
        viewModel.requestMessageUnread().subscribe { value in
            let a = Int(value) ?? 0
            if a > 0 {
                self.navView.tzLab.isHidden = false
                self.navView.tzLab.text = value
            }else {
                self.navView.tzLab.isHidden = true
            }
        } onError: { error in
            self.navView.tzLab.isHidden = true
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

        //MARK: 滚动广告
        viewModel.requestBanner()
            .subscribe(onNext: {[weak self] value in
                self?.bannerArray = value as! Array<BannerModel>
                self?.headView.bannerArray = self?.bannerArray ?? []
            })
            .disposed(by: disposeBag)
        
        //MARK: 获取主流
        viewModel.requestMainstreamlist()
            .subscribe(onNext: {[weak self] value in
                self?.headView.collectionV.reloadData()
            }).disposed(by: disposeBag)
        
        //MARK: 获取公告
        viewModel.requestAnnouncement()
            .subscribe(onNext: {[weak self] value in
                self?.headView.showNotice.beginScroll(textArray: self?.viewModel.notices ?? [])
            }).disposed(by: disposeBag)
        
        //MARK: 获取热门
        viewModel.requestHeadHotSearch()
            .subscribe(onNext: {[weak self] value in
                self?.headView.vMarquee.reloadData()
            }).disposed(by: disposeBag)
        //MARK: 首页行情
        viewModel.websocketAllpush()
            .subscribe(onNext: { value in
                
            })
            .disposed(by: disposeBag)
        WSCoinPushSing.sharedInstance().datas
            .subscribe(onNext: {[weak self] value in
            self?.headView.collectionV.reloadData()
                if self?.currentIndex == 0 {
                    self?.hotsVC.refreshData()
                }else if self?.currentIndex == 1{
                    self?.upsVC.refreshData()
                }else if self?.currentIndex == 2{
                    self?.downsVC.refreshData()
                }else{
                    self?.maxsVC.refreshData()
                }
        })
        .disposed(by: disposeBag)
    }
    
}
//MARK: ui
extension HomeVC{
    func setUI(){
        self.view.addSubview(navView)
        
        lineView.gradientColors = [UIColor.hexColor("989898").cgColor,UIColor.hexColor("989898").cgColor]
        lineView.indicatorCornerRadius = 2
        
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
//        segmentedView.contentEdgeInsetLeft = 12+10
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
    }
    func initSubViewsConstraints(){
        navView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        self.pagerView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}

extension HomeVC{
    private func setMineBtn(model : InfoModel){
        let infoModel : InfoModel = model
        
        let imageStr : String = infoModel.user_image
        
        if imageStr.count > 0 {
            self.navView.mineBtn.kf.setImage(with: URL(string: imageStr), for: .normal)
        }else{
            let nickName : String = infoModel.nick_name
            if nickName.count > 0 {
                self.navView.mineBtn.setTitle(findFirstLetterFromString(aString: nickName), for: .normal)
            }else{
                self.navView.mineBtn.setTitle("N", for: .normal)
            }
        }
    }
    private func getFaceID(){
        if Archive.getFaceIDtoken().count > 0 {
            if Archive.getFaceID(){
                bioManager.touchID {[weak self] status in
                    if status == .success {
                        let token = Archive.getFaceIDtoken()
                        Archive.saveToken(token)
                        self?.setMineBtn(model: userManager.infoModel ?? InfoModel())
                    }else{
                        self?.navView.mineBtn.setTitle("N", for: .normal)
                    }
                }
            }
        }else{
            if userManager.isLogin {
                setMineBtn(model: userManager.infoModel ?? InfoModel())
                self.infoViewModel.getUserRatecountry()
            }
        }
    }
    ///获取用户数据
    private func getDataSource(){
        infoViewModel.getUserInfo()
    }
}
// MARK: - JXPagingViewDelegate
extension HomeVC : JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return self.headView.getHeadViewHeight()
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headView
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
            self.hotsVC.viewModel = self.viewModel
            self.hotsVC.listType = .Hots
            return self.hotsVC
        }else if index == 1 {
            self.upsVC.viewModel = self.viewModel
            self.upsVC.listType = .Ups
            return self.upsVC
        }else if index == 2 {
            self.downsVC.viewModel = self.viewModel
            self.downsVC.listType = .Downs
            return self.downsVC
        }else{
            self.maxsVC.viewModel = self.viewModel
            self.maxsVC.listType = .Maxs
            return self.maxsVC
        }
    }


}


// MARK: - JXPagingMainTableViewGestureDelegate
extension HomeVC : JXPagingMainTableViewGestureDelegate{
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer
    }
}

// MARK: - JXSegmentedViewDelegate
extension HomeVC : JXSegmentedViewDelegate{

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.currentIndex = index
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

