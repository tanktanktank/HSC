//
//  EntrustCondtionView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/6.
//

import UIKit
import RxSwift
protocol EntrustCondtionViewDelegate: NSObjectProtocol{
    ///
    func clickStartBtn(btn : UIButton,endStr : String)
    func clickEndBtn(btn : UIButton,startStr : String)
}
class EntrustCondtionView: UIView {
    weak var delegate: EntrustCondtionViewDelegate?
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor("000000", alpha: 0.5)
        return view
    }()
    lazy var contentView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 14)
        lab.text = "tv_filter".localized()
        return lab
    }()
    lazy var btnCancel : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "iconcolse"), for: .normal)
        btn.addTarget(self, action: #selector(tapBtnCancel), for: .touchUpInside)
        return btn
    }()
    lazy var btnConfirm : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.setTitle("tv_confirm".localized(), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.backgroundColor = .hexColor("FCD283")
        btn.corner(cornerRadius: 4)
        return btn
    }()
    lazy var btnRest : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitle("tv_reset".localized(), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        return btn
    }()
    lazy var vCoin : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var vCoinName : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 14)
        lab.text = "tv_all".localized()
        return lab
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "cellright")
        return v
    }()
    lazy var vCoinTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 14)
        lab.text = "tv_coin_class".localized()
        return lab
    }()
    lazy var timeView : UIView = {
        let v = UIView()
        v.clipsToBounds = true
        return v
    }()
    
    lazy var timeTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 14)
        lab.text = "tv_filter_time".localized()
        return lab
    }()
    lazy var startBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.titleLabel?.font = FONTM(size: 13)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapStartBtn), for: .touchUpInside)
        return btn
    }()
    lazy var endBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.titleLabel?.font = FONTM(size: 13)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapEndBtn), for: .touchUpInside)
        return btn
    }()
    lazy var daoLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 13)
        lab.textAlignment = .center
        lab.text = "tv_to".localized()
        return lab
    }()
    lazy var statusTitle : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 14)
        lab.text = "状态:"
        return lab
    }()
    
    private lazy var collectionView : BaseCollectionView = {
        let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DeskNumViewCell.self, forCellWithReuseIdentifier: DeskNumViewCell.CELLID) //注册cell
        //设置流水布局 layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 58 , height: 24)
        layout.minimumLineSpacing = 0  //行间距
        layout.minimumInteritemSpacing = (SCREEN_WIDTH-24-58*5)/4.0  //列间距
        layout.scrollDirection = .vertical //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 17, left: 0, bottom: 25, right: 0)
        collectionView.showsHorizontalScrollIndicator = false  //隐藏水平滚动条
        collectionView.showsVerticalScrollIndicator = false  //隐藏垂直滚动条
        return collectionView
    }()
    lazy var dataArray = ["tv_trade_filter_time_one_day".localized(),"tv_trade_filter_time_one_week".localized(),"tv_trade_filter_time_one_month".localized(),"tv_trade_filter_time_three_month".localized(),"tv_trade_filter_custorm".localized()]
    var selectedIndex = 0
    private var disposeBag = DisposeBag()
    
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setupEvent()
        initSubViewsConstraints()
        
        let dateString = String(format: "%02ld-%02ld-%02ld", (self.currentDateCom.year!),(self.currentDateCom.month!), (self.currentDateCom.day!))
        endBtn.setTitle(dateString, for: .normal)
        var starString = ""
        if ((self.currentDateCom.day!) - 1) > 0 {
            starString = String(format: "%02ld-%02ld-%02ld", (self.currentDateCom.year!),(self.currentDateCom.month!), (self.currentDateCom.day!) - 1)
        }else{
            if ((self.currentDateCom.month!) - 1) > 0 {
                starString = String(format: "%02ld-%02ld-%02ld", (self.currentDateCom.year!),(self.currentDateCom.month!) - 1, 1)
            }else{
                starString = String(format: "%02ld-%02ld-%02ld", (self.currentDateCom.year!)-1, 1, 1)
            }
        }
        startBtn.setTitle(starString, for: .normal)
        
        //MARK: 币种
        let tapCoin = UITapGestureRecognizer()
        vCoin.addGestureRecognizer(tapCoin)
        tapCoin.rx.event.flatMap { value -> Observable<String> in
            let controller = EntrustSearchCoinController()
            controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            getTopVC()?.navigationController?.present(controller, animated: true, completion: nil)
            return controller.dataSubject
        }.subscribe(onNext: {value in
            if !(is_Blank(ref: value)){
                self.vCoinName.text = value
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        UIView.animate(withDuration: 0.3) {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
    }
    public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.removeAllSubViews()
            self.removeFromSuperview()
        }
    }
    @objc func tapBtnCancel(){
        self.dismiss()
    }
    
    /// 移除所有子控件
    func removeAllSubViews(){
        if self.subviews.count>0{
            self.subviews.forEach({$0.removeFromSuperview()})
        }
    }
    
    @objc func tapBack(){
        self.dismiss()
    }
    
    @objc func tapStartBtn(sender : UIButton){
        self.delegate?.clickStartBtn(btn: sender, endStr: (self.endBtn.titleLabel?.text)!)
    }
    @objc func tapEndBtn(sender : UIButton){
        self.delegate?.clickEndBtn(btn: sender, startStr: (self.startBtn.titleLabel?.text)!)
    }
}

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension EntrustCondtionView : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : DeskNumViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DeskNumViewCell.CELLID, for: indexPath) as! DeskNumViewCell
        let str : String = self.dataArray.safeObject(index: indexPath.item) ?? ""
        cell.titleLabel.text = str
        if indexPath.item == self.selectedIndex {
            cell.titleLabel.backgroundColor = .hexColor("989898")
            cell.titleLabel.textColor = .hexColor("FFFFFF")
        }else {
            cell.titleLabel.backgroundColor = .hexColor("2D2D2D")
            cell.titleLabel.textColor = .hexColor("989898")
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        if selectedIndex == 4 {//自定义
            self.timeView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(vCoinTitle.snp.top)
                make.height.equalTo(95)
            }
        }else{
            self.timeView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(vCoinTitle.snp.top)
                make.height.equalTo(0)
            }
        }
        self.collectionView.reloadData()
    }
}
extension EntrustCondtionView{
    func setUI(){
        self.addSubview(bgView)
        self.bgView.addSubview(contentView)
        self.contentView.addSubview(btnConfirm)
        self.contentView.addSubview(btnRest)
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(btnCancel)
        self.contentView.addSubview(vCoin)
        self.vCoin.addSubview(vCoinName)
        self.vCoin.addSubview(arrow)
        self.contentView.addSubview(vCoinTitle)
        self.contentView.addSubview(timeView)
        self.timeView.addSubview(timeTitle)
        self.timeView.addSubview(startBtn)
        self.timeView.addSubview(daoLab)
        self.timeView.addSubview(endBtn)
        self.contentView.addSubview(collectionView)
        self.contentView.addSubview(statusTitle)
    }
    
    func setupEvent(){
        
        btnConfirm.rx.tap
            .subscribe(onNext: {value in
                
                var startTime = 0
                var endTime = 0
                var time_info = ""
                
                let symbol = self.vCoinName.text == "tv_all".localized() ? "" : self.vCoinName.text
                if(self.selectedIndex < 1){
                    //1天
                    let curTimeInterval: TimeInterval = NSDate().timeIntervalSince1970
                    let preTimeDate = NSDate.init(timeInterval: -24 * 60 * 60, since: Date())
                    let preTimeInterval = preTimeDate.timeIntervalSince1970
                    startTime = Int(preTimeInterval)
                    endTime = Int(curTimeInterval)
                    time_info = "1d"
                }else if(self.selectedIndex == 1){
                    //7天
                    let curTimeInterval: TimeInterval = NSDate().timeIntervalSince1970
                    let preTimeDate = NSDate.init(timeInterval: -24 * 60 * 60 * 7, since: Date())
                    let preTimeInterval = preTimeDate.timeIntervalSince1970
                    startTime = Int(preTimeInterval)
                    endTime = Int(curTimeInterval)
                    time_info = "7d"
                }else if(self.selectedIndex == 2){
                    //1个月
                    let curTimeInterval: TimeInterval = NSDate().timeIntervalSince1970
                    let preTimeDate = NSDate.init(timeInterval: -24 * 60 * 60 * 30, since: Date())
                    let preTimeInterval = preTimeDate.timeIntervalSince1970
                    startTime = Int(preTimeInterval)
                    endTime = Int(curTimeInterval)
                    time_info = "1m"
                }else if(self.selectedIndex == 3){
                    //3个月
                    let curTimeInterval: TimeInterval = NSDate().timeIntervalSince1970
                    let preTimeDate = NSDate.init(timeInterval: -24 * 60 * 60 * 90, since: Date())
                    let preTimeInterval = preTimeDate.timeIntervalSince1970
                    startTime = Int(preTimeInterval)
                    endTime = Int(curTimeInterval)
                    time_info = "3m"
                }else{
                    //自定义时间
                    let timeStamp = HSDateTool.timeToTimestamp(timeFormat: .YYYYMMDD, timeString: (self.startBtn.titleLabel?.text)!)
                    let timeStamp2 = HSDateTool.timeToTimestamp(timeFormat: .YYYYMMDD, timeString: (self.endBtn.titleLabel?.text)!)
                    let strNumber = NumberFormatter().number(from: timeStamp )
                    let strNumber2 = NumberFormatter().number(from: timeStamp2 )
                    startTime = strNumber!.intValue //Int(timeStamp)!
                    endTime = strNumber2!.intValue //Int(timeStamp2)!
                    time_info = ""
                }
                let info:[String: Any] = ["startTime":startTime, "endTime":endTime, "symbol":symbol! ,"time_info":time_info]
                NotificationCenter.default.post(name: Notification.Name("TradeUpdateFilterHistoryKey"), object: nil, userInfo: info)
                self.dismiss()
            }).disposed(by: disposeBag)
    }
    
    func initSubViewsConstraints() {
        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        btnRest.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35)
            make.width.equalTo(100)
            make.height.equalTo(47)
        }
        btnConfirm.snp.makeConstraints { make in
            make.left.equalTo(btnRest.snp.right)
            make.right.equalToSuperview().offset(-12)
            make.height.bottom.equalTo(btnRest)
        }
        vCoin.snp.makeConstraints { make in
            make.bottom.equalTo(btnConfirm.snp.top).offset(-25)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(43)
        }
        vCoinName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        vCoinTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalTo(vCoin.snp.top).offset(-18)
        }
        timeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(vCoinTitle.snp.top)
            make.height.equalTo(0)
        }
        timeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        daoLab.snp.makeConstraints { make in
            make.top.equalTo(timeTitle.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.width.equalTo(43)
            make.height.equalTo(31)
        }
        startBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalTo(daoLab)
            make.right.equalTo(daoLab.snp.left)
        }
        endBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalTo(daoLab)
            make.left.equalTo(daoLab.snp.right)
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(timeView.snp.top)
            make.height.equalTo(65)
        }
        statusTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalTo(collectionView.snp.top)
        }
        titleLab.snp.makeConstraints { make in
            make.bottom.equalTo(statusTitle.snp.top).offset(-22)
            make.centerX.equalToSuperview()
        }
        btnCancel.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(titleLab)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}



// MARK: - DeskNumViewCell
class DeskNumViewCell : UICollectionViewCell {
    static let CELLID = "DeskNumViewCell"
     lazy var titleLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("")
        lab.textAlignment = .center
        lab.backgroundColor = .hexColor("2D2D2D")
        lab.font = FONTM(size: 13)
        lab.corner(cornerRadius: 4)
        return lab
    }()
//    var deskItemModel : DeskItemModel?{
//        didSet{
//        }
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
