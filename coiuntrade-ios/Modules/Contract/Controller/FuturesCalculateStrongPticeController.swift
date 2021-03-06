//
//  FuturesCalculateStrongPticeController.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/20.
//

import UIKit

class FuturesCalculateStrongPticeController: BaseViewController {

    let disposebag = DisposeBag()
    
    fileprivate let typeBtn = DinOptionView(type: .normal)
    fileprivate let holdDirectionBtn = DinOptionView(type: .normal)

    lazy var buyBtn : UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = FONTM(size: 14)
        button.setBackgroundImage(UIImage(named: "futures_buy"), for: .normal)
        button.setBackgroundImage(UIImage(named: "futures_buy_selected"), for: .selected)
        button.setTitle("tv_trade_buy".localized(), for: .normal)
        button.setTitleColor(UIColor.hexColor("989898"), for:.normal)
        button.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for:.selected)
        button.rx.tap.subscribe ({ _ in
            if !button.isSelected{

                self.isBuy = true
            }

        }).disposed(by: disposebag)
        return button
    }()
    
    lazy var sellBtn : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FONTM(size: 14)
        button.setBackgroundImage(UIImage(named: "futures_sell"), for: .normal)
        button.setBackgroundImage(UIImage(named: "futures_sell_selected"), for: .selected)
        button.setTitleColor(UIColor.hexColor("989898"), for:.normal)
        button.setTitleColor(UIColor.hexColor("FFFFFF", alpha: 0.9), for:.selected)
        button.setTitle("tv_trade_sell".localized(), for: .normal)
        button.rx.tap.subscribe ({ _ in
            
            if !button.isSelected{

                self.isBuy = false
            }
        }).disposed(by: disposebag)
        return button
    }()


    var isBuy = false {

        didSet{
            if isBuy {
                sellBtn.isSelected = false
                buyBtn.isSelected = true
            }else{
                sellBtn.isSelected = true
                buyBtn.isSelected = false
            }
        }
    }
    
    lazy var slider : FuturesSliderView = FuturesSliderView()
    
    let addBtn : ZQButton = {
        let addBtn = ZQButton()
        addBtn.backgroundColor = .hexColor("2D2D2D")
        addBtn.setImage(UIImage(named: "futures_calculate_add"), for: .normal)
        return addBtn
    }()
    let minusBtn  : ZQButton = {
        let minusBtn = ZQButton()
        minusBtn.backgroundColor = .hexColor("2D2D2D")
        minusBtn.setImage(UIImage(named: "futures_calculate_minus"), for: .normal)
        return minusBtn
    }()
    let maxHoldLabel : TitleValueLabelView = {
        let maxHoldLabel = TitleValueLabelView()
        maxHoldLabel.title = "???????????????????????????????????????:"
        maxHoldLabel.value = "250,000 USDT"
        return maxHoldLabel
    }()
    
    let openPriceView = FuturesTitleInputView(title: "????????????")// ????????????
    let closePriceView = FuturesTitleInputView(title: "????????????")// ????????????
    let amountView = FuturesTitleInputView(title: "????????????")// ????????????

    let estPriceLabel : TitleValueLabelView = {
        let maxHoldLabel = TitleValueLabelView()
        maxHoldLabel.title = "???????????????"
        maxHoldLabel.value = "250,000 USDT"
        return maxHoldLabel
    }()

    let calculateBtn  : ZQButton = {
        let calculateBtn = ZQButton()
        calculateBtn.setBackgroundImage(UIImage.getImageWithColor(color: .hexColor("2D2D2D")), for: .disabled )
        calculateBtn.setBackgroundImage(UIImage.getImageWithColor(color: .hexColor("FCD283")), for: .normal)
        calculateBtn.setTitle("??????", for: .normal)
        calculateBtn.setTitleColor( .hexColor("989898"), for: .disabled)
        calculateBtn.setTitleColor( .hexColor("000000"), for: .normal)
        calculateBtn.isEnabled = false
        return calculateBtn
    }()

    
}
extension FuturesCalculateStrongPticeController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addConstraints()
        addEvent()
        // Do any additional setup after loading the view.
    }

    func setUI(){
        view.addSubview(typeBtn)
        view.addSubview(holdDirectionBtn)

        view.addSubview(buyBtn)
        view.addSubview(sellBtn)
        view.addSubview(slider)
        view.addSubview(addBtn)
        view.addSubview(minusBtn)
        view.addSubview(maxHoldLabel)
        view.addSubview(openPriceView)
        view.addSubview(closePriceView)
        view.addSubview(amountView)
        
        view.addSubview(estPriceLabel)
        
        view.addSubview(calculateBtn)
        typeBtn.textAligment = .center
        typeBtn.dataSource = ["??????","??????"]
        holdDirectionBtn.textAligment = .center
        holdDirectionBtn.dataSource = ["????????????","????????????"]
        
        isBuy = true
    }
    
    //snp??????
    func addConstraints() {
        
        typeBtn.snp.makeConstraints { make in
            
            make.left.top.equalToSuperview().offset(LR_Margin)
            make.height.equalTo(24)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-7.5-15)
        }

        holdDirectionBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.height.width.equalTo(typeBtn)
        }
        
        buyBtn.snp.makeConstraints { make in
            
            make.top.equalTo(typeBtn.snp.bottom).offset(LR_Margin)
            make.left.equalToSuperview().offset(LR_Margin)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-12.5)
        }
        sellBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.height.width.equalTo(buyBtn)
        }

        addBtn.snp.makeConstraints { make in
            make.right.equalTo(-LR_Margin)
            make.width.height.equalTo(26)
            make.top.equalTo(buyBtn.snp.bottom).offset(30)
        }
        
        minusBtn.snp.makeConstraints { make in
            make.right.equalTo(addBtn.snp.left).offset(-LR_Margin)
            make.centerY.width.height.equalTo(addBtn)
        }

        slider.snp.makeConstraints { make in
            
            make.left.equalToSuperview().offset(LR_Margin + 7.5)
            make.right.equalTo(minusBtn.snp.left).offset(-27.5)
            make.centerY.equalTo(addBtn)
            make.height.equalTo(72)
        }
        
        slider.minimumTrackImage = UIImage(named: "futures_calculate_slider_Min_bg")
        slider.maximumTrackImage = UIImage(named: "futures_calculate_slider_Max_bg")
        slider.titles =  ["1x","20x","40x","60x","80x","100x"]
        slider.isShowSliderText = true
        slider.isStepTouch = true

        maxHoldLabel.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.left.equalTo(LR_Margin)
            make.height.equalTo(17)
            make.top.equalTo(addBtn.snp.bottom).offset(42)
        }
        
        openPriceView.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.left.equalTo(LR_Margin)
            make.height.equalTo(62)
            make.top.equalTo(maxHoldLabel.snp.bottom).offset(LR_Margin)

        }

        closePriceView.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.left.equalTo(LR_Margin)
            make.height.equalTo(62)
            make.top.equalTo(openPriceView.snp.bottom).offset(LR_Margin)
        }
        
        amountView.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.left.equalTo(LR_Margin)
            make.height.equalTo(62)
            make.top.equalTo(closePriceView.snp.bottom).offset(LR_Margin)
        }

        let titleLabel = UILabel()
        titleLabel.text = "????????????"
        titleLabel.font = FONTM(size: 14)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.height.equalTo(20)
            make.top.equalTo(amountView.snp.bottom).offset(LR_Margin)
        }
        
        estPriceLabel.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(LR_Margin)
            make.height.equalTo(17)
        }

        let tipLabel = UILabel()
        tipLabel.text = "???????????????????????????????????????????????????????????????"
        tipLabel.font = FONTM(size: 10)
        tipLabel.textColor = .hexColor("989898")
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.height.equalTo(14)
            make.top.equalTo(estPriceLabel.snp.bottom).offset(12)
        }
        
        calculateBtn.corner(cornerRadius: 4)
        calculateBtn.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.bottom.equalToSuperview().offset(-SafeAreaBottom-49)
            make.height.equalTo(48)
        }

    }
    
    func addEvent() {
        
        typeBtn.clickBlock { isDirectionUp in
            
                let datas = ["??????","??????"]
    
                tipManager.showActionSheet(datas: datas , selectedIndex: 0) { index in
                    print("\(index)")
                }
        }
        
        holdDirectionBtn.clickBlock { isDirectionUp in
            
                let datas = ["????????????","????????????"]
    
                tipManager.showActionSheet(datas: datas , selectedIndex: 0) { index in
                    print("\(index)")
                }
        }
        slider.valueChange = { value in
            
            print( "???????????? \(value)")
        }

    }
        
}


extension FuturesCalculateStrongPticeController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
