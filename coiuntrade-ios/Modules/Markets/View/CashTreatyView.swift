//
//  CashView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit

class CashTreatyView: UIView {

    private var moveCellImg: UIView?
    private var originIndex: Int = -1   //初始移动下标
    var closure:((_ array:Array<CoinModel>) -> Void)!
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("2D2D2D")
        table.showsVerticalScrollIndicator = false
        table.register(OptionEditCell.self, forCellReuseIdentifier:  OptionEditCell.CELLID)
        table.corner(cornerRadius: 4)
        return table
    }()
    lazy var topView : UIView = {
        let v = UIView()
        return v
    }()
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_market".localized()
        lab.font = FONTR(size: 11)
        lab.textAlignment = .center
        return lab
    }()
    lazy var topLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_market_top_optional".localized()
        lab.font = FONTR(size: 11)
        lab.textAlignment = .center
        return lab
    }()
    lazy var dragLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.text = "tv_drag".localized()
        lab.font = FONTR(size: 11)
        lab.textAlignment = .center
        return lab
    }()
    lazy var bottomView : UIView = {
        let v = UIView()
        return v
    }()
    lazy var allBtn : QMUIButton = {
        let btn = QMUIButton()
        btn.setImage(UIImage(named: "markets_status_nol"), for: .normal)
        btn.setImage(UIImage(named: "markets_status_sel"), for: .selected)
        btn.setTitle("全选", for: .normal)
        btn.setTitleColor(UIColor.hexColor("EAEAEA"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .selected)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.spacingBetweenImageAndTitle = 5
        btn.imagePosition = QMUIButtonImagePosition.left
        btn.addTarget(self, action: #selector(tapAllBtn), for: .touchUpInside)
        return btn
    }()
    lazy var deleteBtn : QMUIButton = {
        let btn = QMUIButton()
        btn.setImage(UIImage(named: "markets_delete_nol"), for: .normal)
        btn.setImage(UIImage(named: "markets_delete_sel"), for: .selected)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.hexColor("EAEAEA"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .selected)
        btn.titleLabel?.font = FONTR(size: 12)
        btn.spacingBetweenImageAndTitle = 5
        btn.imagePosition = QMUIButtonImagePosition.left
        btn.isUserInteractionEnabled = false
        btn.addTarget(self, action: #selector(tapDeleteBtn), for: .touchUpInside)
        return btn
    }()
    var dataArray : Array<CoinModel> = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var noLoginDataArray : Array<RealmCoinModel> = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var selectedArray : Array<CoinModel> = []
    var noLoginSelectedArray : Array<RealmCoinModel> = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: 事件交互
extension CashTreatyView{
    @objc func tapAllBtn(sender : QMUIButton){
        sender.isSelected = !sender.isSelected
        if userManager.isLogin {
            if sender.isSelected {
                for model in self.dataArray {
                    model.isSelected = true
                }
                self.selectedArray = self.dataArray
                self.tableView.reloadData()
                self.deleteBtn.isSelected = true
                self.deleteBtn.isUserInteractionEnabled = true
                
            }else{
                for model in self.dataArray {
                    model.isSelected = false
                }
                self.selectedArray.removeAll()
                self.tableView.reloadData()
                self.deleteBtn.isSelected = false
                self.deleteBtn.isUserInteractionEnabled = false
            }
        }else{
            if sender.isSelected {
                self.noLoginDataArray = RealmHelper.queryModel(model: RealmCoinModel())
                for aModel in self.noLoginDataArray {
                    let tem = RealmCoinModel()
                    tem.id = aModel.id
                    tem.coin = aModel.coin
                    tem.currency = aModel.currency
                    tem.price = aModel.price
                    tem.deal_num = aModel.deal_num
                    tem.isFall = aModel.isFall
                    tem.ratio_str = aModel.ratio_str
                    tem.isSelected = aModel.isSelected
                    tem.price_digit = aModel.price_digit
                    tem.priceColor  = aModel.priceColor
                    tem.isSelected = true
                    RealmHelper.updateModel(model: tem)
                }
                self.noLoginSelectedArray = self.noLoginDataArray
                self.tableView.reloadData()
                self.deleteBtn.isSelected = true
                self.deleteBtn.isUserInteractionEnabled = true
                
            }else{
                for aModel in self.noLoginDataArray {
                    let tem = RealmCoinModel()
                    tem.id = aModel.id
                    tem.coin = aModel.coin
                    tem.currency = aModel.currency
                    tem.price = aModel.price
                    tem.deal_num = aModel.deal_num
                    tem.isFall = aModel.isFall
                    tem.ratio_str = aModel.ratio_str
                    tem.isSelected = aModel.isSelected
                    tem.price_digit = aModel.price_digit
                    tem.priceColor  = aModel.priceColor
                    tem.isSelected = false
                    RealmHelper.updateModel(model: tem)
                }
                self.noLoginSelectedArray.removeAll()
                self.tableView.reloadData()
                self.deleteBtn.isSelected = false
                self.deleteBtn.isUserInteractionEnabled = false
            }
        }
        
    }
    @objc func tapDeleteBtn(){
        
        tipManager.showAlert(icon: "alert_tip", title: "提示", message: "确定要删除自选吗", actionArray: ["common_cancel".localized(),"tv_continue".localized()] ,completion: { isok in
            if isok{
                if userManager.isLogin {
                    for model in self.selectedArray {
                        self.dataArray.removeAll(where: {$0.symbol_id == model.symbol_id})
                    }
                    self.closure(self.dataArray)
                    self.tableView.reloadData()
                    self.deleteBtn.isSelected = false
                    self.deleteBtn.isUserInteractionEnabled = false
                }else{
                    for model in self.noLoginSelectedArray {
                        RealmHelper.deleteModel(model: model)
                    }
                    self.noLoginDataArray = RealmHelper.queryModel(model: RealmCoinModel())
                    self.tableView.reloadData()
                }
            }
        })
    }
}

//MARK: ui
extension CashTreatyView{
    func setUI(){
        self.addSubview(topView)
        topView.addSubview(nameLab)
        topView.addSubview(topLab)
        topView.addSubview(dragLab)
        self.addSubview(bottomView)
        bottomView.addSubview(allBtn)
        bottomView.addSubview(deleteBtn)
        self.addSubview(tableView)
    }
    func initSubViewsConstraints(){
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        nameLab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(40)
        }
        dragLab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-14)
            make.width.equalTo(40)
        }
        topLab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(dragLab.snp.left).offset(-15)
            make.width.equalTo(40)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
            make.height.equalTo(50)
        }
        deleteBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
        allBtn.snp.makeConstraints { make in
            make.right.equalTo(deleteBtn.snp.left).offset(-20)
            make.top.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}
// MARK: - UITableViewDelegate
extension CashTreatyView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userManager.isLogin {
            return self.dataArray.count
        }else{
            return self.noLoginDataArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionEditCell.CELLID, for: indexPath) as! OptionEditCell
        cell.delegate = self
        if userManager.isLogin {
            let model : CoinModel = self.dataArray.safeObject(index: indexPath.row) ?? CoinModel()
            cell.model = model
        }else{
            let model : RealmCoinModel = self.noLoginDataArray.safeObject(index: indexPath.row) ?? RealmCoinModel()
            cell.rModel = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if userManager.isLogin {
            let model : CoinModel = self.dataArray.safeObject(index: indexPath.row) ?? CoinModel()
            model.isSelected = !model.isSelected
            self.tableView.reloadData()
            if model.isSelected {
                self.selectedArray.append(model)
            }else{
                self.selectedArray.removeAll(where: {$0.symbol_id == model.symbol_id})
            }
            if self.selectedArray.count>0 {
                self.deleteBtn.isSelected = true
                self.deleteBtn.isUserInteractionEnabled = true
                if self.selectedArray.count == self.dataArray.count {
                    self.allBtn.isSelected = true
                }else{
                    self.allBtn.isSelected = false
                }
            }else{
                self.deleteBtn.isSelected = false
                self.allBtn.isSelected = false
                self.deleteBtn.isUserInteractionEnabled = false
            }
        }else{
            let model : RealmCoinModel = self.noLoginDataArray.safeObject(index: indexPath.row) ?? RealmCoinModel()
            let result = RealmHelper.queryModel(model: RealmCoinModel(), filter: "coin = '\(model.coin)' AND currency = '\(model.currency)'")
            guard let aModel = result.first else {
                return
            }
            let updateModel = RealmCoinModel()
            updateModel.coin = aModel.coin
            updateModel.currency = aModel.currency
            updateModel.deal_num = aModel.deal_num
            updateModel.isFall = aModel.isFall
            updateModel.price = aModel.price
            updateModel.ratio_str = aModel.ratio_str
            updateModel.id = aModel.id
            updateModel.isSelected = !aModel.isSelected
            updateModel.price_digit = aModel.price_digit
            updateModel.priceColor  = aModel.priceColor
            RealmHelper.updateModel(model: updateModel)
            let result2 = RealmHelper.queryModel(model: RealmCoinModel())
            self.noLoginDataArray = result2
            self.tableView.reloadData()
            if model.isSelected {
                self.noLoginSelectedArray.append(model)
            }else{
                self.noLoginSelectedArray.removeAll(where: {$0 == model})
            }
            if self.noLoginSelectedArray.count>0 {
                self.deleteBtn.isSelected = true
                self.deleteBtn.isUserInteractionEnabled = true
                if self.noLoginSelectedArray.count == self.noLoginDataArray.count {
                    self.allBtn.isSelected = true
                }else{
                    self.allBtn.isSelected = false
                }
            }else{
                self.deleteBtn.isSelected = false
                self.allBtn.isSelected = false
                self.deleteBtn.isUserInteractionEnabled = false
            }
        }
        
    }
    
    
}
extension CashTreatyView : OptionEditCellDelegate{
    ///置顶
    func clickTopBtn(cell: OptionEditCell) {
        if let indexPath = self.tableView.indexPath(for: cell){
            if indexPath.row == 0 {
                return
            }
            if userManager.isLogin {
                let tmp = self.dataArray[indexPath.row]
                self.dataArray.remove(at: indexPath.row)
                self.dataArray.insert(tmp, at: 0)
                
                self.closure(self.dataArray)
                self.tableView.reloadData()
            }else{
                let model : RealmCoinModel = self.noLoginDataArray.safeObject(index: indexPath.row) ?? RealmCoinModel()
                
                self.noLoginDataArray.removeAll(where: {$0 == model})
                self.noLoginDataArray.insert(model, at: 0)
                var temMs : [RealmCoinModel] = []
                for aModel in self.noLoginDataArray {
                    let tem = RealmCoinModel()
                    tem.id = aModel.id
                    tem.coin = aModel.coin
                    tem.currency = aModel.currency
                    tem.price = aModel.price
                    tem.deal_num = aModel.deal_num
                    tem.isFall = aModel.isFall
                    tem.ratio_str = aModel.ratio_str
                    tem.isSelected = aModel.isSelected
                    tem.price_digit = aModel.price_digit
                    tem.priceColor  = aModel.priceColor
                    temMs.append(tem)
                }
                RealmHelper.deleteModelList(model: RealmCoinModel())
                for tModel in temMs {
                    RealmHelper.addModel(model: tModel)
                }
                self.noLoginDataArray = RealmHelper.queryModel(model: RealmCoinModel())
                NotificationCenter.default.post(name: UpdataAccountlikeNotification, object: nil)
            }
        }
    }
    
    func dragView(cell: OptionEditCell, longPressGes: UILongPressGestureRecognizer) {
        switch longPressGes.state {
        case .began:
            let point = longPressGes.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                if indexPath.row != 0 {
                    originIndex = indexPath.row
                    if let cell = tableView.cellForRow(at: indexPath) {
                        moveCellImg = cell.snapshotView(afterScreenUpdates: false)
                        self.addSubview(moveCellImg!)
                        setMoveImgVPoint(longPressGes: longPressGes)
                        //将要拖动的原cell隐藏
                        cell.isHidden = true
                    }
                }
            }
        case .changed:
            let point = longPressGes.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                if indexPath.row != originIndex && originIndex != -1 {
                    let sourceIndex = IndexPath(row: originIndex, section: 0)
                    tableView.moveRow(at: sourceIndex, to: indexPath)
//                    array.exchangeObject(at: originIndex, withObjectAt: indexPath.row)
                    if userManager.isLogin {
                        let tmp = self.dataArray[indexPath.row]
                        self.dataArray[indexPath.row] = self.dataArray[originIndex]
                        self.dataArray[originIndex] = tmp
                    }else{
                        let tmp = self.noLoginDataArray[indexPath.row]
                        self.noLoginDataArray[indexPath.row] = self.noLoginDataArray[originIndex]
                        self.noLoginDataArray[originIndex] = tmp
                    }
                    
                    originIndex = indexPath.row
                }
            }
            setMoveImgVPoint(longPressGes: longPressGes)
        case.ended:
            let point = longPressGes.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                if indexPath.row == originIndex || originIndex == -1 {
                    resetMoveTableViewCellAnimation()
                    return
                }
                
            }
            resetMoveTableViewCellAnimation()
        default:
            resetMoveTableViewCellAnimation()
            break
        }
    }
    
  
}

///处理手势
extension CashTreatyView {
    //cell跟随手指位置
    func setMoveImgVPoint(longPressGes: UILongPressGestureRecognizer) {
        let newPoin = longPressGes.location(in: self)
        
        //moveCellImg?.x = newPoin.x - moveCellImg!.width / 2
        moveCellImg?.y = newPoin.y - moveCellImg!.height / 2
    }
    
    //结束动画
    func resetMoveTableViewCellAnimation() {
        moveCellImg?.removeFromSuperview()
        moveCellImg = nil
        if userManager.isLogin {
            self.closure(self.dataArray)
            tableView.reloadData()
        }else{
            var temMs : [RealmCoinModel] = []
            for aModel in self.noLoginDataArray {
                let tem = RealmCoinModel()
                tem.id = aModel.id
                tem.coin = aModel.coin
                tem.currency = aModel.currency
                tem.price = aModel.price
                tem.deal_num = aModel.deal_num
                tem.isFall = aModel.isFall
                tem.ratio_str = aModel.ratio_str
                tem.isSelected = aModel.isSelected
                tem.price_digit = aModel.price_digit
                tem.priceColor  = aModel.priceColor
                temMs.append(tem)
            }
            RealmHelper.deleteModelList(model: RealmCoinModel())
            for tModel in temMs {
                RealmHelper.addModel(model: tModel)
            }
            self.noLoginDataArray = RealmHelper.queryModel(model: RealmCoinModel())
        }
    }
}
