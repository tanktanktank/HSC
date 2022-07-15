//
//  OptionalEditVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/26.
//

import UIKit
enum OptionalEditType : Int{
    ///现货
    case cash = 1
    ///合约
    case treaty = 2
}
class OptionalEditVC: BaseViewController {
    var type : OptionalEditType = .cash{
        didSet{
            switch type {
            case .cash:
                cashBtn.isSelected = true
                cashBtn.backgroundColor = .hexColor("2D2D2D")
                treatyBtn.isSelected = false
                treatyBtn.backgroundColor = .clear
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                break
            case .treaty:
                treatyBtn.isSelected = true
                treatyBtn.backgroundColor = .hexColor("2D2D2D")
                cashBtn.isSelected = false
                cashBtn.backgroundColor = .clear
                scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
                break
            }
        }
    }
    lazy var typeView : UIView = {
        let v = UIView()
        v.corner(cornerRadius: 4)
        v.backgroundColor = .hexColor("191818")
        return v
    }()
    lazy var cashBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_market_spot".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapCashBtn), for: .touchUpInside)
        return btn
    }()
    lazy var treatyBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_market_fetures".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .selected)
        btn.titleLabel?.font = FONTM(size: 14)
        btn.backgroundColor = .clear
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapTreatyBtn), for: .touchUpInside)
        return btn
    }()
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.frame = CGRect(x: 0, y: TOP_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TOP_HEIGHT)
        v.contentSize = CGSize(width: SCREEN_WIDTH*2, height: SCREEN_HEIGHT-TOP_HEIGHT)
        v.isScrollEnabled = false
        return v
    }()
    lazy var cashView = CashTreatyView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TOP_HEIGHT))
    lazy var treatyView = CashTreatyView(frame: CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TOP_HEIGHT))
    
    lazy var backBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(tapBackBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var navRightBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("添加", for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 14)
        btn.addTarget(self, action: #selector(tapNavRightBtn), for: .touchUpInside)
        return btn
    }()
    
    var dataArray : Array<CoinModel> = []
    
    var editArray : Array<CoinModel> = []
    
    var noLoginDataArray : Array<RealmCoinModel> = []
    
    var noLoginEditArray : Array<RealmCoinModel> = []
    
    var backClosure:(() -> Void)!
    
    var viewModel = MarketsViewModel()
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        getDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updataAccountLike), name: UpdataAccountlikeNotification, object: nil)
        cashView.closure = {[weak self](array : Array<CoinModel>) in
            
            self?.editArray = array
            var list : Array<String> = []
            for model in array {
                list.append(model.symbol_id)
            }
            self?.viewModel.requestAccountLikeEdit(id_list: list){[weak self] in
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
//                self?.backClosure()
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        if userManager.isLogin {
            var list : Array<String> = []
            for model in self.editArray {
                list.append(model.symbol_id)
            }
            self.viewModel.requestAccountLikeEdit(id_list: list){[weak self] in
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }
        }else{
            let array = RealmHelper.queryModel(model: RealmCoinModel(),filter: "isSelected = 1")
            for model in array {
                
                let updateModel = RealmCoinModel()
                updateModel.coin = model.coin
                updateModel.currency = model.currency
                updateModel.deal_num = model.deal_num
                updateModel.isFall = model.isFall
                updateModel.price = model.price
                updateModel.ratio_str = model.ratio_str
                updateModel.id = model.id
                updateModel.isSelected = false
                updateModel.price_digit = model.price_digit
                updateModel.priceColor = model.priceColor
                RealmHelper.updateModel(model: updateModel)
            }
            NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
        }
    }
}
// MARK: - 点击事件
extension OptionalEditVC{
    ///点击返回
    @objc func tapBackBtn(){
        navigationController?.popViewController(animated: true)
    }
    ///点击添加
    @objc func tapNavRightBtn(){
        
            let vc = HomeSearchVC()
            self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.pushViewController(getViewController(name: "HomeStoryboard", identifier: "HomeSearchController"), animated: true)
    }
    @objc func tapCashBtn(){
        type = .cash
    }
    @objc func tapTreatyBtn(){
        type = .treaty
    }
    @objc func updataAccountLike(){
        if userManager.isLogin {
            //MARK: 获取用户自选
            self.viewModel.requestCurrencyLike()
                .subscribe(onNext: {value in
                    self.dataArray = value as! Array<CoinModel>
                    self.cashView.dataArray = self.dataArray
                    self.editArray = self.dataArray
                    self.cashView.tableView.reloadData()
                }).disposed(by: disposeBag)
        }else{
            self.noLoginDataArray = RealmHelper.queryModel(model: RealmCoinModel())
            self.cashView.noLoginDataArray = self.noLoginDataArray
            self.noLoginEditArray = self.noLoginDataArray
            self.cashView.tableView.reloadData()
            print("result: ", self.noLoginDataArray)
        }
    }
}
// MARK: - UI
extension OptionalEditVC{
    
    func getDataSource(){
        switch type {
        case .cash:
            if userManager.isLogin {
                //MARK: 获取用户自选
                self.viewModel.requestCurrencyLike()
                    .subscribe(onNext: {value in
                        self.dataArray = value as! Array<CoinModel>
                        self.cashView.dataArray = self.dataArray
                        self.editArray = self.dataArray
                        self.cashView.tableView.reloadData()
                    }).disposed(by: disposeBag)
            }else{
                self.noLoginDataArray = RealmHelper.queryModel(model: RealmCoinModel())
                self.cashView.noLoginDataArray = self.noLoginDataArray
                self.noLoginEditArray = self.noLoginDataArray
                self.cashView.tableView.reloadData()
                print("result: ", self.noLoginDataArray)
            }
        default:
            break
        }
    }
    func setUI(){
        view.addSubview(backBtn)
        view.addSubview(typeView)
        view.addSubview(navRightBtn)
        typeView.addSubview(cashBtn)
        typeView.addSubview(treatyBtn)
        view.addSubview(scrollView)
        scrollView.addSubview(cashView)
        scrollView.addSubview(treatyView)
    }
    func initSubViewsConstraints(){
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        typeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backBtn)
            make.height.equalTo(32)
            make.width.equalTo(180)
        }
        cashBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        treatyBtn.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(90)
        }
        navRightBtn.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
}
