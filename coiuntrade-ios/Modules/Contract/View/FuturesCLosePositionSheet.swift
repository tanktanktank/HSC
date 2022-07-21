//
//  FuturesCLosePositionSheet.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/19.
//

import UIKit

class FuturesCLosePositionSheet: FuturesSheetBaseView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setEvent()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    let contractView = TitleValueLabelView()
    let openPriceView = TitleValueLabelView()
    let markPriceView = TitleValueLabelView()
    
    let priceView = FuturesTitleInputView(title: "价格")       // 价格
    let priceTypeView = FuturesTitleInputView(title: "委托类型", type: .button) // 委托类型
    let amountView = FuturesTitleInputView(title: "数量", type: .noArrow)      // 数量

    var selectPercentView = SelectPercentView() //选择百分比

    let positionAmountView = TitleValueLabelView()
    let estimatePLView = TitleValueLabelView()
    let scrollView = UIScrollView()

}
//MARK: ui
extension FuturesCLosePositionSheet{
 
    func setUI(){
        
        self.bottomBtn.setTitle("确认", for: .normal)
        self.bottomBtn.setTitleColor(.hexColor("1E1E1E"), for: .normal)
        self.title = "平仓"
        self.titleAligment = .center
        contentView.snp.remakeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo((491 + SafeAreaBottom))
        }
        contentView.addSubview(scrollView)
    
        scrollView.addSubview(contractView)
        scrollView.addSubview(openPriceView)
        scrollView.addSubview(markPriceView)
        
        scrollView.addSubview(priceView)
        scrollView.addSubview(priceTypeView)
        scrollView.addSubview(amountView)
        scrollView.addSubview(selectPercentView)
        scrollView.addSubview(positionAmountView)
        scrollView.addSubview(estimatePLView)


        
        contractView.title = "合约"
        contractView.value = "PEOPLEUSDT 永续 / 买40x"
        contractView.valueColor = .hexColor("02C078")
        openPriceView.title = "开仓价格(BUSD)"
        openPriceView.value = "19,928,11"
        markPriceView.title = "标记价格(BUSD)"
        markPriceView.value = "19,928,11"
        
        positionAmountView.title = "仓位数量"
        positionAmountView.value = "10.00 USDT"
        positionAmountView.titleFont = FONTR(size: 14)
        positionAmountView.valueFont = FONTR(size: 14)
        estimatePLView.title = "预计盈亏"
        estimatePLView.value = "1.00 USDT"
        estimatePLView.titleFont = FONTR(size: 14)
        estimatePLView.valueFont = FONTR(size: 14)
        estimatePLView.isHideImg = false
        
        selectPercentView.isSqure = true
    }
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(LR_Margin)
            make.bottom.equalTo(bottomBtn.snp.top)
        }

        let toScrollView = UIView()
        scrollView.addSubview(toScrollView)
        toScrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.width.equalTo( SCREEN_WIDTH)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-550)
        }

        contractView.snp.makeConstraints { make in
            make.left.equalTo(LR_Margin)
            make.top.equalToSuperview()
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
        

        priceTypeView.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.height.equalTo(62)
            make.width.equalTo(146)
            make.top.equalTo(lineview.snp.bottom).offset(LR_Margin)
        }

        priceView.snp.makeConstraints { make in
            
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

    }
    
    func setEvent(){
        
    }
}

