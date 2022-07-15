//
//  CoinDetailheadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/20.
//

import UIKit

typealias CoinPass = ()->()

class CoinDetailheadView: UIView {
    
    
    var passW:CoinPass?
    private var disposeBag = DisposeBag()

    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 14)
        lab.text = "-"
        return lab
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 14)
        lab.text = "tv_total_balance_value".localized()
        lab.textAlignment = .center
        return lab
    }()
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("EBEBEB")
        lab.font = FONTDIN(size: 26)
        lab.text = "-"
        lab.textAlignment = .center
        return lab
    }()
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTDIN(size: 14)
        lab.text = "-"
        lab.textAlignment = .center
        return lab
    }()
    lazy var leftTitleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "tv_avilable_blance".localized()
        lab.textAlignment = .center
        return lab
    }()
    lazy var leftDetailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("EBEBEB")
        lab.font = FONTDIN(size: 12)
        lab.text = "-"
        lab.textAlignment = .center
        return lab
    }()
    lazy var rightTitleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "tv_oeder_freeze".localized()
        lab.textAlignment = .center
        return lab
    }()
    lazy var rightDetailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("EBEBEB")
        lab.font = FONTDIN(size: 12)
        lab.text = "-"
        lab.textAlignment = .center
        return lab
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    ///行情
    lazy var marketView : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 4
        v.backgroundColor = .hexColor("000000")
        v.clipsToBounds = true
        return v
    }()
    lazy var nameB : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTDIN(size: 14)
        lab.text = "BTC/USDT"
        return lab
    }()
    lazy var priceB : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("F03851")
        lab.font = FONTDIN(size: 14)
        lab.text = "-"
        lab.textAlignment = .center
        return lab
    }()
    lazy var priceLimit : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("F03851")
        lab.font = FONTR(size: 14)
        lab.text = "+6.87%"
        lab.textAlignment = .center
        return lab
    }()
    lazy var dealBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_go_trade".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 14)
        return btn
    }()
    ///更多
    lazy var moreView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    lazy var moreTitleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTM(size: 14)
        lab.text = "tv_market_search_history".localized()
        return lab
    }()
    lazy var moreDetailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "tv_home_moudle_more".localized()
        return lab
    }()
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "wallets_more")
        v.contentMode = .center
        return v
    }()
    var model : AllbalanceModel = AllbalanceModel(){
        didSet{
            self.iconView.kf.setImage(with: model.coin_code_image, placeholder: nil)
            self.nameLab.text = model.coin_code
            self.totalLab.text = self.addMicrometerLevel(valueSwift: model.total_num)
            self.moneyLab.text = "≈\(self.addRateSymbol(value: model.total_num_rate))"
            self.leftDetailLab.text = model.use_num
            self.rightDetailLab.text = model.freeze_num
            
            self.nameB.text = model.tradeName
            self.priceB.text = model.tradePrice
            self.priceLimit.text = model.tradeWidth
            print("更新的数据=="+(self.priceLimit.text ?? "00")!+"END")
            if (model.tradeWidth.hasPrefix("-")) == true {
                self.priceB.textColor = UIColor.hexColor(0xF03851)
                self.priceLimit.textColor = UIColor.hexColor(0xF03851)
            } else{
                self.priceB.textColor = UIColor.hexColor(0x02C078)
                self.priceLimit.textColor = UIColor.hexColor(0x02C078)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        setupEvent()
    }
    
    func setupEvent(){
        
        dealBtn.rx.tap
            .subscribe(onNext: {
                self.passW!()
            }).disposed(by: disposeBag)
    }
    
    func updateConstraint(){
        
        marketView.snp.updateConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CoinDetailheadView{
    func setUI() {
        self.addSubview(iconView)
        self.addSubview(nameLab)
        self.addSubview(titleLab)
        self.addSubview(totalLab)
        self.addSubview(moneyLab)
        self.addSubview(leftTitleLab)
        self.addSubview(leftDetailLab)
        self.addSubview(rightTitleLab)
        self.addSubview(rightDetailLab)
        self.addSubview(line)
        self.addSubview(marketView)
        self.addSubview(moreView)
        moreView.addSubview(moreTitleLab)
        moreView.addSubview(moreDetailLab)
        moreView.addSubview(arrow)
        marketView.addSubview(nameB)
        marketView.addSubview(priceB)
        marketView.addSubview(priceLimit)
        marketView.addSubview(dealBtn)
    }
    func initSubViewsConstraints() {
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(STATUSBAR_HIGH+22)
            make.right.equalTo(self.snp.centerX).offset(-2)
            make.width.height.equalTo(18)
        }
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(2)
            make.centerY.equalTo(iconView)
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLab.snp.bottom).offset(21)
        }
        totalLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(12)
        }
        moneyLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalLab.snp.bottom).offset(6)
        }
        leftTitleLab.snp.makeConstraints { make in
            make.centerX.equalTo(SCREEN_WIDTH/4.0)
            make.top.equalTo(moneyLab.snp.bottom).offset(15)
        }
        leftDetailLab.snp.makeConstraints { make in
            make.centerX.equalTo(leftTitleLab)
            make.top.equalTo(leftTitleLab.snp.bottom).offset(12)
        }
        rightTitleLab.snp.makeConstraints { make in
            make.centerX.equalTo(SCREEN_WIDTH/4.0*3)
            make.centerY.equalTo(leftTitleLab)
        }
        rightDetailLab.snp.makeConstraints { make in
            make.centerX.equalTo(rightTitleLab)
            make.centerY.equalTo(leftDetailLab)
        }
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(leftDetailLab.snp.bottom).offset(28)
            make.height.equalTo(3)
        }
        marketView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(56)
        }
        moreView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(marketView.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }
        moreTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(19)
        }
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(moreTitleLab)
            make.width.equalTo(14)
            make.height.equalTo(13)
        }
        moreDetailLab.snp.makeConstraints { make in
            make.right.equalTo(arrow.snp.left).offset(-4)
            make.centerY.equalTo(moreTitleLab)
        }
        nameB.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        dealBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        priceB.snp.makeConstraints { make in
            make.left.equalTo(nameB.snp.right)
            make.right.equalTo(marketView.snp.centerX)
            make.centerY.equalToSuperview()
        }
        priceLimit.snp.makeConstraints { make in
            make.right.equalTo(dealBtn.snp.left)
            make.left.equalTo(marketView.snp.centerX)
            make.centerY.equalToSuperview()
        }
    }
}
