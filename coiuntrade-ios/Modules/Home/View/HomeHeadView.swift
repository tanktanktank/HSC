//
//  HomeHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/7.
//

import UIKit
import OYMarqueeView

protocol HomeHeadViewDelegate : NSObjectProtocol {
    ///点击用滚动币种
    func clickMarquee(model : CoinModel)
    ///点击主流币
    func clickMainCoin(model : CoinModel)
    ///点击公告
    func clickNotice(index : Int)
}
class HomeHeadView: UIView {
    
    public weak var delegate: HomeHeadViewDelegate? = nil
    var viewModel: HomeViewModel = HomeViewModel()
    private lazy var cycleView: ZCycleView = {
        let cycleView = ZCycleView()
        cycleView.scrollDirection = .horizontal
        cycleView.delegate = self
        cycleView.itemZoomScale = 1
        cycleView.itemSpacing = 0
        cycleView.initialIndex = 1
        cycleView.placeholderImage = UIImage(named: "banner")
        cycleView.itemSize = CGSize(width: SCREEN_WIDTH-LR_Margin*2, height: 160)
        return cycleView
    }()
    //MARK: 公告
    lazy var showNotice : AdScrollLabelView = {
        let v = AdScrollLabelView()
        v.frame = CGRect(x: 42, y: 0, width: SCREEN_WIDTH - 84, height: 33)
        v.backgroundColor = .clear
        v.isHiiddenAdImage = true
        v.adLabelClick = {index in
            self.delegate?.clickNotice(index: index)
            print(index)
        }
        return v
    }()
    lazy var vNotice : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000", alpha: 0.4)
        return v
    }()
    lazy var noticeImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "gg-icon")
        return v
    }()
    lazy var noticeMoreBtn : ZQButton = {
        let v = ZQButton()
        v.setImage(UIImage(named: "ggmore-icon"), for: .normal)
        v.contentMode = .center
        v.addTarget(self, action: #selector(tapNoticeMoreBtn), for: .touchUpInside)
        return v
    }()
    //MARK: 小K线
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - LR_Margin*2 - 30)/3, height: 130)
        return layout
    }()
    lazy var collectionV : BaseCollectionView = {
        let v = BaseCollectionView(frame: .zero, collectionViewLayout: self.layout)
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = .hexColor("000000")
        v.bounces = false
        v.delegate = self
        v.dataSource = self
        v.decelerationRate = .fast
        v.collectionViewLayout = layout
//        v.register(UINib.init(nibName: "HomeKLineCell", bundle: nil), forCellWithReuseIdentifier: "HomeKLineCell")
//        v.register(HomeMainKLineCell.self, forCellWithReuseIdentifier: HomeMainKLineCell.CELLID)
        return v
    }()
    //MARK: 滚动币种
    var vMarquee : OYMarqueeView = OYMarqueeView(frame: CGRect(x: 15, y: 0, width: SCREEN_WIDTH-30, height:28), scrollDirection: .horizontal)
       
    lazy var vShowScroll : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var VDeposit : QMUIButton = {
        let btn = QMUIButton()
        btn.imagePosition = QMUIButtonImagePosition.top
        btn.setImage(UIImage(named: "deposit"), for: .normal)
        btn.setTitle("tv_home_desposit".localized(), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.spacingBetweenImageAndTitle = 5
        return btn
    }()
    lazy var VOTC : QMUIButton = {
        let btn = QMUIButton()
        btn.imagePosition = QMUIButtonImagePosition.top
        btn.setImage(UIImage(named: "OTC"), for: .normal)
        btn.setTitle("tv_home_otc".localized(), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.spacingBetweenImageAndTitle = 5
        return btn
    }()
    lazy var VReferrals : QMUIButton = {
        let btn = QMUIButton()
        btn.imagePosition = QMUIButtonImagePosition.top
        btn.setImage(UIImage(named: "Referrals"), for: .normal)
        btn.setTitle("tv_home_referrais".localized(), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.spacingBetweenImageAndTitle = 5
        return btn
    }()
    lazy var VStrategy : QMUIButton = {
        let btn = QMUIButton()
        btn.imagePosition = QMUIButtonImagePosition.top
        btn.setImage(UIImage(named: "Strategy"), for: .normal)
        btn.setTitle("tv_home_stragety".localized(), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.spacingBetweenImageAndTitle = 5
        return btn
    }()
    lazy var VMore : QMUIButton = {
        let btn = QMUIButton()
        btn.imagePosition = QMUIButtonImagePosition.top
        btn.setImage(UIImage(named: "More"), for: .normal)
        btn.setTitle("tv_home_moudle_more".localized(), for: .normal)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.spacingBetweenImageAndTitle = 5
        return btn
    }()
    lazy var showBtnV : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var quickBuyV : HomeItemView = {
        let v = HomeItemView()
        v.name = "tv_home_financing".localized()
        v.massgae = "tv_home_finance".localized()
        v.image = "buysell"
        return v
    }()
    lazy var financingV : HomeItemView = {
        let v = HomeItemView()
        v.name = "tv_home_quick_buy".localized()
        v.massgae = "tv_home_quick_buy_tips".localized()
        v.image = "homeotc"
        return v
    }()
    
    
    var bannerArray : Array<BannerModel> = []{
        didSet{
            self.cycleView.reloadItemsCount(bannerArray.count)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 获取headView高度
    func getHeadViewHeight() -> Int{
        self.layoutIfNeeded()
        let a : Int = Int(self.quickBuyV.maxY)
        return a
    }
}
extension HomeHeadView{
    @objc func tapNoticeMoreBtn(){
        let url = "http://8.218.110.85:6225/#/announcement"
        let vc = WebViewController()
        vc.urlStr = url
        getTopVC()?.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: 滚动币种代理
extension HomeHeadView : OYMarqueeViewDataSource{
    func numberOfItems(in marqueeView: OYMarqueeView) -> Int {
        return self.viewModel.hots.count
    }
    func marqueeView(_ marqueeView: OYMarqueeView, itemForIndexAt index: Int) -> OYMarqueeViewItem {
        let item = marqueeView.dequeueReusableItem(withIdentifier: String(describing: HomeScrollTextView.self)) as! HomeScrollTextView
        let model : CoinModel = self.viewModel.hots.safeObject(index: index) ?? CoinModel()
        if index == 0 {
            item.textIndex = String(index+1)
            item.text = model.coin
            item.indexLabel.textColor = .hexColor("FCD283")
            item.textLabel.textColor = .hexColor("FCD283")
        }else{
            item.textIndex = "#" + String(index+1)
            item.text = model.coin
            item.indexLabel.textColor = .hexColor("858D97")
            item.textLabel.textColor = .hexColor("FFFFFF")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        item.tag = index
        item.ups = model.isFall
        item.addGestureRecognizer(tap)
        return item
    }
    
    func marqueeView(_ marqueeView: OYMarqueeView, itemSizeForIndexAt index: Int) -> CGSize {
        let model : CoinModel = self.viewModel.hots.safeObject(index: index) ?? CoinModel()
        var str = "#" + String(index+1)
        if index == 0 {
            str = String(index+1)
        }
        let rect = self.sizeWithText(text: str, font: FONTR(size: 11), size: CGSize(width: SCREEN_WIDTH, height: 20))
        let rect1 = self.sizeWithText(text: model.coin, font: FONTR(size: 11), size: CGSize(width: SCREEN_WIDTH, height: 20))
        let width = rect.width + 2 + rect1.width + 4 + 8 + 6
        return CGSize(width: width, height: 20)
    }
    //MARK: 滚动币种
    @objc func handleTap(tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            let model : CoinModel = self.viewModel.hots.safeObject(index: tap.view!.tag) ?? CoinModel()
            self.delegate?.clickMarquee(model: model)
        }
    }
}
//MARK: collectionView代理
extension HomeHeadView : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.mainstreamlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellid = "\(HomeMainKLineCell.CELLID)\(indexPath.item)"
        
        collectionView.register(HomeMainKLineCell.self, forCellWithReuseIdentifier: cellid)
        
        let itemCell : HomeMainKLineCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! HomeMainKLineCell
        itemCell.delegate = self
        itemCell.model = self.viewModel.mainstreamlist.safeObject(index: indexPath.row)
        return itemCell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model : CoinModel = self.viewModel.mainstreamlist.safeObject(index: indexPath.row) ?? CoinModel()
//        self.delegate?.clickMainCoin(model: model)
    }
}
extension HomeHeadView : HomeMainKLineCellDelegate{
    func clickCell(model: CoinModel) {
        self.delegate?.clickMainCoin(model: model)
    }

}
//MARK: 轮播图代理
extension HomeHeadView : ZCycleViewProtocol{
    func cycleViewRegisterCellClasses() -> [String : AnyClass] {
        return ["CustomCollectionViewCell": CustomCollectionViewCell.self]
    }
    
    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let model : BannerModel = self.bannerArray.safeObject(index: realIndex) ?? BannerModel()
        cell.imageView.kf.setImage(with: model.image_url, placeholder: PlaceholderImg())
        return cell
    }
    func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int) {
//        guard let model = self.homeBannerArray.safeObject(index: index) else { return }
    }
    
    func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl) {
        pageControl.isHidden = false
        pageControl.currentPageIndicatorTintColor = .hexColor("FFFFFF")
        pageControl.pageIndicatorTintColor = .hexColor("989898")
        pageControl.dotSize = CGSize(width: 6, height: 6)
        pageControl.frame = CGRect(x: 0, y: cycleView.bounds.height-45, width: cycleView.bounds.width, height: 25)
        pageControl.center = CGPoint(x: (SCREEN_WIDTH-LR_Margin*2)/2.0, y: cycleView.height-40)
    }
    
}
//MARK: ui
extension HomeHeadView{
    func setUI(){
        self.addSubview(cycleView)
        self.addSubview(vNotice)
        vNotice.addSubview(noticeImage)
        vNotice.addSubview(showNotice)
        vNotice.addSubview(noticeMoreBtn)
        self.addSubview(collectionV)
        self.addSubview(vShowScroll)
        self.vShowScroll.addSubview(vMarquee)
        vMarquee.backgroundColor = .clear
        vMarquee.speed = 0.7
        vMarquee.dataSourse = self
        vMarquee.space = 10
        vMarquee.register(HomeScrollTextView.self, forItemReuseIdentifier: String(describing: HomeScrollTextView.self))
        self.addSubview(showBtnV)
        showBtnV.addSubview(VDeposit)
        showBtnV.addSubview(VOTC)
        showBtnV.addSubview(VReferrals)
        showBtnV.addSubview(VStrategy)
        showBtnV.addSubview(VMore)
        self.addSubview(quickBuyV)
        self.addSubview(financingV)
    }
    func initSubViewsConstraints(){
       
        cycleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalToSuperview()
            make.height.equalTo(172)
        }
        vNotice.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(cycleView.snp.bottom)
            make.height.equalTo(33)
        }
        noticeImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        noticeMoreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
//        showNotice.snp.makeConstraints { make in
//            make.left.equalTo(noticeImage.snp.right)
//            make.top.bottom.equalToSuperview()
//            make.right.equalTo(noticeMoreBtn.snp.left)
//        }
        collectionV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(vNotice.snp.bottom)
        }
        vShowScroll.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(collectionV.snp.bottom)
            make.height.equalTo(28)
        }
        showBtnV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vShowScroll.snp.bottom)
            make.height.equalTo(74)
        }
        let btnW : CGFloat = (SCREEN_WIDTH-LR_Margin*2)/5.0
        
        VDeposit.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(btnW)
        }
        VOTC.snp.makeConstraints { make in
            make.left.equalTo(VDeposit.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(btnW)
        }
        VReferrals.snp.makeConstraints { make in
            make.left.equalTo(VOTC.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(btnW)
        }
        VStrategy.snp.makeConstraints { make in
            make.left.equalTo(VReferrals.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(btnW)
        }
        VMore.snp.makeConstraints { make in
            make.left.equalTo(VStrategy.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(btnW)
        }
        quickBuyV.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(showBtnV.snp.bottom)
            make.height.equalTo(76)
            make.width.equalTo((SCREEN_WIDTH-5)/2.0)
        }
        financingV.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(showBtnV.snp.bottom)
            make.height.equalTo(76)
            make.width.equalTo((SCREEN_WIDTH-5)/2.0)
        }
    }
}



//MARK: 轮播图cell
class CustomCollectionViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.corner(cornerRadius: 5)
        contentView.addSubview(imageView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
