//
//  SectionHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/20.
//

import UIKit
protocol SectionHeadViewDelegate : NSObjectProtocol {
    ///点击开始时间
    func clickStarTime()
    ///点击开始时间
    func clickEndTime()
    ///点击确定
    func clickSure()
    ///点击币种
    func clickCoin()
    ///点击类状态
    func clickTypeV(status : Int)
}
class SectionHeadView: UIView {
    public weak var delegate: SectionHeadViewDelegate? = nil
    lazy var sureBtn : ZQButton = {
        let btn = ZQButton()
        btn.setTitle("tv_confirm".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(tapSureBtn), for: .touchUpInside)
        return btn
    }()
    lazy var endTimeBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("2022-03-02", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(tapEndTimeBtn), for: .touchUpInside)
        return btn
    }()
    lazy var starTimeBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("2022-03-02", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(tapStarTimeBtn), for: .touchUpInside)
        return btn
    }()
    lazy var lab : UILabel = {
        let lab = UILabel()
        lab.text = "至"
        lab.textColor = .hexColor("989898")
        lab.textAlignment = .center
        lab.font = FONTR(size: 11)
        return lab
    }()
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())
    var kindB  = WLOptionView(frame: .zero, type: .btnType)
    var typeV  = WLOptionView(frame: .zero, type: .normal)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        
        let dateString = String(format: "%02ld-%02ld-%02ld", (self.currentDateCom.year!),(self.currentDateCom.month!), (self.currentDateCom.day!))
        endTimeBtn.setTitle(dateString, for: .normal)
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
        starTimeBtn.setTitle(starString, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension SectionHeadView{
    @objc func tapStarTimeBtn(){
        self.delegate?.clickStarTime()
    }
    @objc func tapEndTimeBtn(){
        self.delegate?.clickEndTime()
    }
    @objc func tapSureBtn(){
        self.delegate?.clickSure()
    }
}
extension SectionHeadView{
    func setUI() {
        kindB.title = "tv_coin_type".localized()
        kindB.selectedCallBack {[weak self] (viewTemp, index) in
            self?.kindB.selectIndex = index
        }
        kindB.clickBlock {[weak self]  isDirectionUp in
            self?.delegate?.clickCoin()
        }
        typeV.dataSource = ["tv_all".localized(),"tv_wait_confirm".localized(),"tv_success".localized()]
        typeV.title = "tv_all".localized()
        typeV.cornerRadius = 4
        typeV.selectedCallBack {[weak self] (viewTemp, index) in
            self?.kindB.selectIndex = index
            self?.delegate?.clickTypeV(status: index)
        }
        self.addSubview(kindB)
        self.addSubview(typeV)
        self.addSubview(sureBtn)
        self.addSubview(starTimeBtn)
        self.addSubview(lab)
        self.addSubview(endTimeBtn)
    }
    func initSubViewsConstraints() {
        kindB.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(65)
        }
        typeV.snp.makeConstraints { make in
            make.left.equalTo(kindB.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(65)
        }
        sureBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(23)
        }
        endTimeBtn.snp.makeConstraints { make in
            make.right.equalTo(sureBtn.snp.left).offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(23)
        }
        starTimeBtn.snp.makeConstraints { make in
            make.right.equalTo(endTimeBtn.snp.left).offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(23)
        }
        lab.snp.makeConstraints { make in
            make.left.equalTo(starTimeBtn.snp.right)
            make.right.equalTo(endTimeBtn.snp.left)
            make.top.bottom.equalToSuperview()
        }
    }
}
