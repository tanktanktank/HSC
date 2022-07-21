//
//  FuturesSetStopPLSheet.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/18.
//

import UIKit
import RxSwift

class FuturesSetStopPLSheet: FuturesSheetBaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setEvent()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stopPLBtn : UIButton = {
        let stopPLBtn = UIButton()
        
        stopPLBtn.setTitle("止盈/止损", for: .normal)
        stopPLBtn.titleLabel?.font = FONTR(size: 16)
        stopPLBtn.setTitleColor( .white, for: .selected)
        stopPLBtn.setTitleColor( .hexColor("989898"), for: .normal)
        return stopPLBtn
    }()
    
    let stopPositionPLBtn : UIButton = {
        let stopPLBtn = UIButton()
        
        stopPLBtn.setTitle("仓位止盈止损", for: .normal)
        stopPLBtn.titleLabel?.font = FONTR(size: 16)
        stopPLBtn.setTitleColor( .white, for: .selected)
        stopPLBtn.setTitleColor( .hexColor("989898"), for: .normal)
        return stopPLBtn
    }()
    
    let line = UIView()
    let contractView = TitleValueLabelView()
    let openPriceView = TitleValueLabelView()
    let markPriceView = TitleValueLabelView()
    let infoView = TitleValueLabelView()
    
    let triggerPriceView = FuturesTitleInputView(title: "触发价格")// 触发价格
    let priceView = FuturesTitleInputView(title: "价格")       // 价格
    let triggerTypeView = FuturesTitleInputView(title: "触发类型", type: .button) // 触发类型
    let priceTypeView = FuturesTitleInputView(title: "委托类型", type: .button) // 委托类型
    let amountView = FuturesTitleInputView(title: "数量", type: .noArrow)      // 数量

    let stopProfileView = FuturesTitleInputView(title: "止盈") // 仓位的 止盈
    let stopLossView = FuturesTitleInputView(title: "止损")    //仓位的 止损
    let stopProfitTipLabel = UILabel()     // 触达--时，将会触发市价止盈委托平仓当前仓位。预期盈亏为--
    let stopLossTipLabel = UILabel()       // 触达--时，将会触发市价止损委托平仓当前仓位。预期盈亏为--
    var selectPercentView = SelectPercentView() //选择百分比

    let positionAmountView = TitleValueLabelView()
    let estimatePLView = TitleValueLabelView()
    let scrollView = UIScrollView()


    var  isStopPL : Bool = true{
        didSet{
            if isStopPL {
                stopPLBtn.isSelected = true
                stopPositionPLBtn.isSelected = false
                line.snp.remakeConstraints { make in
                    make.centerX.equalTo(stopPLBtn)
                    make.bottom.equalTo(stopPLBtn).offset(-4)
                    make.width.equalTo(28)
                    make.height.equalTo(3)
                }
                infoView.isHidden = true
                contractView.snp.remakeConstraints { make in
                    make.left.equalTo(LR_Margin)
                    make.top.equalToSuperview()
                    make.height.equalTo(28)
                    make.right.equalTo(-LR_Margin)
                }
                stopProfileView.isHidden = true
                stopLossView.isHidden = true
                stopProfitTipLabel.isHidden = true
                stopLossTipLabel.isHidden = true
                priceView.isHidden = false
                triggerPriceView.isHidden = false
                amountView.isHidden = false
                selectPercentView.isHidden = false
                priceTypeView.snp.remakeConstraints { make in
                    
                    make.height.width.right.equalTo(triggerTypeView)
                    make.top.equalTo(triggerTypeView.snp.bottom).offset(LR_Margin)
                }
                
                positionAmountView.isHidden = false
                estimatePLView.isHidden = false


            }else{
                stopPLBtn.isSelected = false
                stopPositionPLBtn.isSelected = true
                line.snp.remakeConstraints { make in
                    make.centerX.equalTo(stopPositionPLBtn)
                    make.bottom.equalTo(stopPLBtn).offset(-4)
                    make.width.equalTo(28)
                    make.height.equalTo(3)
                }
                infoView.isHidden = false
                contractView.snp.remakeConstraints { make in
                    make.left.equalTo(LR_Margin)
                    make.top.equalTo(infoView.snp.bottom)
                    make.height.equalTo(28)
                    make.right.equalTo(-LR_Margin)
                }
                stopProfileView.isHidden = false
                stopLossView.isHidden = false
                stopProfitTipLabel.isHidden = false
                stopLossTipLabel.isHidden = false
                priceView.isHidden = true
                triggerPriceView.isHidden = true
                amountView.isHidden = true
                selectPercentView.isHidden = true
                priceTypeView.snp.remakeConstraints { make in
                    
                    make.height.width.right.equalTo(triggerTypeView)
                    make.top.equalTo(triggerTypeView.snp.bottom).offset(57)
                }
                
                positionAmountView.isHidden = true
                estimatePLView.isHidden = true
            }
        }
    }

}
//MARK: ui
extension FuturesSetStopPLSheet{
 
    func setUI(){
        
        self.bottomBtn.setTitle("确认", for: .normal)
        self.bottomBtn.setTitleColor(.hexColor("1E1E1E"), for: .normal)
        contentView.snp.remakeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo((578 + SafeAreaBottom))
        }
        line.backgroundColor = .hexColor("FCD283")
        contentView.addSubview(stopPLBtn)
        contentView.addSubview(stopPositionPLBtn)
        contentView.addSubview(line)
        contentView.addSubview(scrollView)
    
        scrollView.addSubview(infoView)
        scrollView.addSubview(contractView)
        scrollView.addSubview(openPriceView)
        scrollView.addSubview(markPriceView)
        
        scrollView.addSubview(triggerPriceView)
        scrollView.addSubview(priceView)
        scrollView.addSubview(triggerTypeView)
        scrollView.addSubview(priceTypeView)
        scrollView.addSubview(amountView)
        scrollView.addSubview(stopProfileView)
        scrollView.addSubview(stopLossView)
        scrollView.addSubview(stopProfitTipLabel)
        scrollView.addSubview(stopLossTipLabel)
        scrollView.addSubview(stopProfitTipLabel)
        scrollView.addSubview(stopLossTipLabel)
        scrollView.addSubview(selectPercentView)
        scrollView.addSubview(positionAmountView)
        scrollView.addSubview(estimatePLView)


//        let stopProfitTipLabel = UILabel()     // 触达--时，将会触发市价止盈委托平仓当前仓位。预期盈亏为--
//        let stopLossTipLabel = UILabel()       // 触达--时，将会触发市价止损委托平仓当前仓位。预期盈亏为--
        stopProfitTipLabel.text = "触达--时，将会触发市价止盈委托平仓当前仓位。预期盈亏为--"
        stopProfitTipLabel.textColor = .hexColor("999999")
        stopProfitTipLabel.font = FONTR(size: 11)
        stopProfitTipLabel.numberOfLines = 0

        stopLossTipLabel.text = "触达--时，将会触发市价止损委托平仓当前仓位。预期盈亏为--"
        stopLossTipLabel.textColor = .hexColor("999999")
        stopLossTipLabel.font = FONTR(size: 11)
        stopLossTipLabel.numberOfLines = 0
        
        contractView.title = "合约"
        contractView.value = "PEOPLEUSDT 永续 / 买40x"
        contractView.valueColor = .hexColor("02C078")

        openPriceView.title = "开仓价格(BUSD)"
        openPriceView.value = "19,928,11"
        markPriceView.title = "标记价格(BUSD)"
        markPriceView.value = "19,928,11"
        infoView.title = "什么是仓位止盈止损？"
        
        positionAmountView.title = "仓位数量"
        positionAmountView.value = "10.00 USDT"
        positionAmountView.titleFont = FONTR(size: 14)
        positionAmountView.valueFont = FONTR(size: 14)
        estimatePLView.title = "预计盈亏"
        estimatePLView.value = "1.00 USDT"
        estimatePLView.titleFont = FONTR(size: 14)
        estimatePLView.valueFont = FONTR(size: 14)
        estimatePLView.isHideImg = false
        
        infoView.isHideImg = false
        selectPercentView.isSqure = true
    }
    
    func setConstraints() {
        
        stopPLBtn.snp.makeConstraints { make in
            make.left.equalTo(7.5)
            make.top.equalToSuperview()
            make.height.equalTo(52)
            make.width.equalTo(85)
        }
        stopPositionPLBtn.snp.makeConstraints { make in
            make.left.equalTo(stopPLBtn.snp.right)
            make.top.equalToSuperview()
            make.height.equalTo(52)
            make.width.equalTo(111)
        }

        
        scrollView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(stopPositionPLBtn.snp.bottom)
            make.bottom.equalTo(bottomBtn.snp.top)
        }
        
        let toScrollView = UIView()
        scrollView.addSubview(toScrollView)
        toScrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalTo( SCREEN_WIDTH)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-600)
        }

        infoView.snp.makeConstraints { make in
            make.left.equalTo(LR_Margin)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalTo(-LR_Margin)
        }
        
        contractView.snp.makeConstraints { make in
            make.left.equalTo(LR_Margin)
            make.top.equalTo(infoView.snp.bottom)
            make.height.equalTo(28)
            make.right.equalTo(-LR_Margin)
        }
        openPriceView.snp.makeConstraints { make in
            make.left.equalTo(LR_Margin)
            make.top.equalTo(contractView.snp.bottom)
            make.height.equalTo(28)
            make.right.equalTo(-LR_Margin)
        }
        markPriceView.snp.makeConstraints { make in
            make.left.equalTo(LR_Margin)
            make.top.equalTo(openPriceView.snp.bottom)
            make.height.equalTo(28)
            make.right.equalTo(-LR_Margin)
        }

        let lineview = UIView()
        lineview.backgroundColor = .hexColor("989898", alpha: 0.5)
        scrollView.addSubview(lineview)
        lineview.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.top.equalTo(markPriceView.snp.bottom).offset(7.5)
            make.height.equalTo(0.5)
            make.right.equalTo(-LR_Margin)
        }
        
        triggerTypeView.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.height.equalTo(62)
            make.width.equalTo(146)
            make.top.equalTo(lineview.snp.bottom).offset(LR_Margin)

        }
        
        triggerPriceView.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(triggerTypeView.snp.left).offset(-7)
            make.centerY.height.equalTo(triggerTypeView)
        }

        priceTypeView.snp.makeConstraints { make in
            
            make.height.width.right.equalTo(triggerTypeView)
            make.top.equalTo(triggerTypeView.snp.bottom).offset(LR_Margin)
        }

        priceView.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(priceTypeView.snp.left).offset(-7)
            make.centerY.height.equalTo(priceTypeView)
        }
        
        stopProfileView.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(triggerTypeView.snp.left).offset(-7)
            make.centerY.height.equalTo(triggerTypeView)
        }
        
        stopLossView.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(priceTypeView.snp.left).offset(-7)
            make.centerY.height.equalTo(priceTypeView)
        }
        
        amountView.snp.makeConstraints { make in
           
            make.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.top.equalTo(priceView.snp.bottom).offset(LR_Margin)
            make.height.equalTo(62)
        }
        
        selectPercentView.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.top.equalTo(amountView.snp.bottom)
            make.height.equalTo(50)
        }

        
        stopProfitTipLabel.snp.makeConstraints { make in
        
            make.left.equalTo(LR_Margin)
            make.top.equalTo(stopProfileView.snp.bottom).offset(10)
            make.right.equalTo(-LR_Margin)
        }
        stopLossTipLabel.snp.makeConstraints { make in
        
            make.left.equalTo(LR_Margin)
            make.top.equalTo(stopLossView.snp.bottom).offset(10)
            make.right.equalTo(-LR_Margin)
            make.height.equalTo(40)
        }
        
        positionAmountView.snp.makeConstraints { make in
        
            make.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.top.equalTo(selectPercentView.snp.bottom).offset(15)
            make.height.equalTo(19)
        }
        estimatePLView.snp.makeConstraints { make in
        
            make.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.top.equalTo(positionAmountView.snp.bottom).offset(15)
            make.height.equalTo(19)
        }
//        contentView.addSubview(positionAmountView)
//        contentView.addSubview(estimatePLView)

    }
    
    func setEvent(){
        
        isStopPL = true

        stopPLBtn.rx.tap.subscribe ({ _ in
            
            self.isStopPL = true
        }).disposed(by: disposebag)
        stopPositionPLBtn.rx.tap.subscribe ({ _ in
            
            self.isStopPL = false
        }).disposed(by: disposebag)

    }
}

