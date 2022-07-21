//
//  TransferVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/15.
//

import UIKit

class TransferVC: BaseViewController {
    
    lazy var navRightBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "transfer_his"), for: .normal)
        btn.addTarget(self, action: #selector(tapNavRightBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var topView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var icon_from : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "transfer_icon_b")
        return v
    }()
    lazy var icon_to : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "transfer_icon_lever")
        return v
    }()
    lazy var fromTitle : UILabel = {
        let v = UILabel()
        v.text = "从".localized()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 12)
        return v
    }()
    lazy var toTitle : UILabel = {
        let v = UILabel()
        v.text = "到".localized()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 12)
        return v
    }()
    lazy var fromName : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTM(size: 12)
        v.text = "现货账户"
        return v
    }()
    lazy var toName : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTM(size: 12)
        v.text = "杠杆账户（全仓）"
        return v
    }()
    lazy var arrow_from : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .scaleAspectFit
        return v
    }()
    lazy var arrow_to : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_r")
        v.contentMode = .scaleAspectFit
        return v
    }()
    lazy var from_btn : UIButton = UIButton()
    lazy var to_btn : UIButton = UIButton()
    lazy var downV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "transfer_down")
        v.contentMode = .scaleAspectFit
        return v
    }()
    //交换
    lazy var changeBtn : ZQButton = {
        let v = ZQButton()
        v.setImage(UIImage(named: "transfer_icon_interaction"), for: .normal)
        v.addTarget(self, action: #selector(tapChangeBtn), for: .touchUpInside)
        return v
    }()
    lazy var coinV : CoinSelectedCellView = {
        let v = CoinSelectedCellView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var tipLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("E35461")
        v.font = FONTR(size: 10)
        v.text = "当前币种无可划转资产，请选择其他币种".localized()
        return v
    }()
    lazy var numTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.text = "数量".localized()
        v.font = FONTR(size: 13)
        return v
    }()
    lazy var numV : TransferNumView = {
        let v = TransferNumView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 4)
        return v
    }()
    lazy var usableTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTR(size: 12)
        v.text = "可用资产:".localized()
        return v
    }()
    
    lazy var usableVaule : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTDIN(size: 12)
        v.text = "--"
        return v
    }()
    lazy var freezeTitle : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTR(size: 12)
        v.text = "下单冻结:".localized()
        return v
    }()
    
    lazy var freezeVaule : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTDIN(size: 12)
        v.text = "--"
        return v
    }()
    
    lazy var sureBtn : UIButton = {
        let v = UIButton()
        v.setTitle("确认划转".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        v.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        v.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        v.setBackgroundImage(UIImage(named: "btn_selected"), for: .selected)
        v.isUserInteractionEnabled = false
        v.corner(cornerRadius: 4)
        v.titleLabel?.font = FONTB(size: 16)
        v.addTarget(self, action: #selector(tapSureBtn), for: .touchUpInside)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLab.text = "tv_fund_tran".localized()
        
        let item = UIBarButtonItem(customView: navRightBtn)
        self.navigationItem.rightBarButtonItem = item
        setUI()
        initSubViewsConstraints()
    }

}
//MARK: 交互事件
extension TransferVC{
    //MARK: 点击右导航
    @objc func tapNavRightBtn(){
        let vc = FuturesEntrustVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: 点击交换
    @objc func tapChangeBtn(sender : ZQButton){
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.3) {
            let rect1 = self.icon_from.frame
            let rect2 = self.icon_to.frame
            let rect3 = self.fromName.frame
            let rect4 = self.toName.frame
            let rect5 = self.arrow_from.frame
            let rect6 = self.arrow_to.frame
            let rect7 = self.from_btn.frame
            let rect8 = self.to_btn.frame
            self.icon_from.frame = rect2
            self.icon_to.frame = rect1
            self.fromName.frame = rect4
            self.toName.frame = rect3
            self.arrow_from.frame = rect6
            self.arrow_to.frame = rect5
            self.from_btn.frame = rect8
            self.to_btn.frame = rect7
        } completion: { isfinish in
            
        }

    }
    //MARK: 点击确认划转
    @objc func tapSureBtn(){
        
    }
    //MARK: 点击选择币种
    @objc func tapCoinV(){
        let vc = FutresSelectedCoinVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapFromBtn(){
        
    }
    @objc func tapToBtn(){
        
    }
    
}
//MARK: ui
extension TransferVC{
    func setUI(){
        view.addSubview(topView)
        topView.addSubview(icon_from)
        topView.addSubview(icon_to)
        topView.addSubview(fromTitle)
        topView.addSubview(toTitle)
        topView.addSubview(fromName)
        topView.addSubview(toName)
        topView.addSubview(arrow_from)
        topView.addSubview(arrow_to)
        topView.addSubview(downV)
        topView.addSubview(changeBtn)
        topView.addSubview(from_btn)
        topView.addSubview(to_btn)
        view.addSubview(coinV)
        view.addSubview(tipLab)
        view.addSubview(numTitle)
        view.addSubview(numV)
        view.addSubview(usableTitle)
        view.addSubview(usableVaule)
        view.addSubview(freezeTitle)
        view.addSubview(freezeVaule)
        view.addSubview(sureBtn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCoinV))
        coinV.addGestureRecognizer(tap)
        from_btn.addTarget(self, action: #selector(tapFromBtn), for: .touchUpInside)
        to_btn.addTarget(self, action: #selector(tapToBtn), for: .touchUpInside)
    }
    func initSubViewsConstraints(){
        topView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLab.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.height.equalTo(112)
        }
        coinV.snp.makeConstraints { make in
            make.left.equalTo(topView)
            make.right.equalTo(topView)
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.height.equalTo(56)
        }
        icon_from.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(22)
            make.width.height.equalTo(14)
        }
        icon_to.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-22)
            make.width.height.equalTo(14)
        }
        fromTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(38)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(20)
            make.height.equalTo(16)
        }
        toTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(38)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(20)
            make.height.equalTo(16)
        }
        fromName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(64)
            make.centerY.equalTo(icon_from)
            make.width.equalTo(100)
        }
        toName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(64)
            make.centerY.equalTo(icon_to)
            make.width.equalTo(100)
        }
        arrow_from.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(170)
            make.centerY.equalTo(fromTitle)
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
        arrow_to.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(170)
            make.centerY.equalTo(toTitle)
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
        from_btn.snp.makeConstraints { make in
            make.left.equalTo(fromName)
            make.right.equalTo(arrow_from)
            make.top.equalToSuperview()
            make.height.equalTo(56)
        }
        to_btn.snp.makeConstraints { make in
            make.left.equalTo(toName)
            make.right.equalTo(arrow_to)
            make.top.equalToSuperview().offset(56)
            make.height.equalTo(56)
        }
        downV.snp.makeConstraints { make in
            make.centerX.equalTo(icon_from)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }
        changeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(downV)
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(20)
        }
        tipLab.snp.makeConstraints { make in
            make.left.right.equalTo(coinV)
            make.top.equalTo(coinV.snp.bottom).offset(6)
        }
        numTitle.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(12)
            make.left.equalTo(coinV)
        }
        numV.snp.makeConstraints { make in
            make.left.equalTo(topView)
            make.right.equalTo(topView)
            make.top.equalTo(numTitle.snp.bottom).offset(12)
            make.height.equalTo(56)
        }
        usableTitle.snp.makeConstraints { make in
            make.left.equalTo(coinV)
            make.top.equalTo(numV.snp.bottom).offset(20)
        }
        usableVaule.snp.makeConstraints { make in
            make.left.equalTo(usableTitle.snp.right).offset(10)
            make.centerY.equalTo(usableTitle)
        }
        freezeTitle.snp.makeConstraints { make in
            make.left.equalTo(coinV)
            make.top.equalTo(usableTitle.snp.bottom).offset(20)
        }
        freezeVaule.snp.makeConstraints { make in
            make.left.equalTo(freezeTitle.snp.right).offset(10)
            make.centerY.equalTo(freezeTitle)
        }
        sureBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview().offset(-(34+SafeAreaBottom))
        }
    }
}
