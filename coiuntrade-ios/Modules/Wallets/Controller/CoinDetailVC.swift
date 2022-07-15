//
//  CoinDetailVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/20.
//

import UIKit

class CoinDetailVC: BaseViewController {

    var model : AllbalanceModel = AllbalanceModel(){
        didSet{
            self.headView.model = model
        }
    }
    var viewModel: MarketsViewModel!
    let walletCoinVM = WalletCoinViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.model.coin_code == "USDT"){
            self.model.coin_code = "BTC"
        }
        walletCoinVM.delegate = self
        setUI()
        initSubViewsConstraints()
        tableView.emptyData = setupEmptyDataView(type:.noData)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        destroyCoinNews()
    }
    override func viewDidAppear(_ animated: Bool) {
        reqCoinUnit()
    }
    
    func reqCoinUnit(){
        
        walletCoinVM.getCoinUnit(coin: self.model.coin_code)
    }
    func destroyCoinNews(){
        
        print("取消通知")
        if(viewModel != nil){
            viewModel.deal24Data.disposed(by: disposeBag)
            viewModel.websocketNewdealClose()
            viewModel = nil
        }
    }
    
    func setupDatas(coinUnit: String){
        viewModel = MarketsViewModel()
        let rModel = ReqCoinModel()
        rModel.coin = self.model.coin_code
        rModel.currency = coinUnit //"USDT"//self.model.currency
        viewModel.reqModel = rModel
        self.viewModel.websocketNewdeal()
        onSubscribe()
    }
    func onSubscribe(){
        
        if(viewModel != nil){
            viewModel.deal24Data.subscribe(onNext: { [self] value in
                let datas = value.data
                let price = datas[1] as? String
                let percent = (datas[5] as? String ?? "") + "%"
                let headerM = model
                var preName = self.viewModel.reqModel.coin
                if(preName == "USDT"){
                    preName = "BTC"
                }
                headerM.tradeName = preName+"/"+self.viewModel.reqModel.currency
                headerM.tradePrice = price!
                headerM.tradeWidth = percent
                model = headerM
            }).disposed(by: disposeBag)
        }
    }
    
    
    lazy var backBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(tapBackBtn), for: .touchUpInside)
        return btn
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(FlowingWaterCell.self, forCellReuseIdentifier:  FlowingWaterCell.CELLID)
        return table
    }()
    lazy var headView : CoinDetailheadView = {
        let v = CoinDetailheadView()
        v.backgroundColor = .hexColor("1E1E1E")
        v.clipsToBounds = true
        v.passW = { [weak self] in
            
            NotificationCenter.default.post(name: Notification.Name("CoinAssetsUpdateKey"), object: nil, userInfo: ["currency":self!.viewModel.reqModel.currency, "coin":self!.viewModel.reqModel.coin])
            self?.navigationController?.popToRootViewController(animated: false)
            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
            let mainTabbarVC = appDelegate.window?.rootViewController as! BaseTabBarController
            mainTabbarVC.selectedIndex = 2
            self?.destroyCoinNews()
        }
        return v
    }()
    lazy var bottomView : UIView = {
        let v = UIView()
        return v
    }()
    lazy var depositBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.setTitle("tv_fund_withdraw".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 14)
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(clickWithdraw), for: .touchUpInside)
        return btn
    }()
    lazy var rechargeBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("FCD283")
        btn.setTitle("tv_home_desposit".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 14)
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(clickRecharge), for: .touchUpInside)
        return btn
    }()
}
// MARK: - 点击事件
extension CoinDetailVC{
    @objc func tapBackBtn(){
        navigationController?.popViewController(animated: true)
    }
    ///充值
    @objc func clickRecharge() {
        
        //MARK: 充值页面
        let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSearchController") as! TransferSearchController
        controller.type = .receive
        self.navigationController?.pushViewController(controller, animated: true)
    }
    ///提现
    @objc func clickWithdraw() {
        //MARK: 提现页面
        let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSearchController") as! TransferSearchController
        controller.type = .send
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UI
extension CoinDetailVC {
    func setUI() {
//        self.tableView.tableHeaderView = self.headView
        view.addSubview(headView)
        view.addSubview(bottomView)
        view.addSubview(self.tableView)
        view.addSubview(backBtn)
        bottomView.addSubview(depositBtn)
        bottomView.addSubview(rechargeBtn)
        
    }
    func initSubViewsConstraints() {
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(362 + STATUSBAR_HIGH)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(bottomView.snp.top)
            make.top.equalTo(headView.snp.bottom)
        }
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        let btnW : CGFloat = (SCREEN_WIDTH - 14*3)/2.0
        depositBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(14)
            make.width.equalTo(btnW)
            make.height.equalTo(40)
        }
        rechargeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-14)
            make.width.equalTo(btnW)
            make.height.equalTo(40)
        }
    }
}

extension CoinDetailVC : WalletCoinRequestDelegate{

    ///获取币对成功回调
    func getCoinUnitSuccess(model: CoinAssetsModel) {
        
        let headerM = self.model
        if(model.currency_code.count > 0){
            print("更新实时币价格数据")
            var preName = self.model.coin_code
            if(preName == "USDT"){
                preName = "BTC"
            }
            headerM.tradeName = preName+"/"+model.currency_code
            headerM.tradePrice = model.new_price
            headerM.tradeWidth = model.change_rate+"%"
            self.model = headerM
            setupDatas(coinUnit: model.currency_code)
        
        }else{
            headView.snp.updateConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(306 + STATUSBAR_HIGH)
            }
            headView.updateConstraint()
//            setupDatas(coinUnit: "USDT")
        }
    }
}

// MARK: - UITableViewDelegate  UITableViewDataSource
extension CoinDetailVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlowingWaterCell.CELLID, for: indexPath) as! FlowingWaterCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
