//
//  SelectLeverSheet.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/18.
//

import UIKit

class FuturesLeverSheet: FuturesSheetBaseView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var slider : UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "futures_slider"), for: .normal)
//        slider.minimumTrackTintColor = .red
//        slider.maximumTrackTintColor = .blue
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        slider.setMinimumTrackImage(UIImage(named: "futures_lever_slider_Min_bg"), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "futures_lever_slider_Max_bg"), for: .normal)
        
        var i = 0
        let width = SCREEN_WIDTH - 30
        for title in ["1x","10x","20x","30x","40x","50x"] {
            
            let label = UILabel()
            label.text = title
            label.textColor = .hexColor("989898")
            label.font = FONTDIN(size: 12)
            label.textAlignment = .center
            slider.addSubview(label)

            
            let x  = width * CGFloat(i) / 5.0
            
            
            label.snp.makeConstraints { make in
                
                make.centerX.equalTo(x)
                make.centerY.equalToSuperview().offset(15)
                make.height.equalTo(15)
            }
            
            
            i += 1
        }
        
        return slider
    }()

    ///slider滑动事件
    @objc private func sliderChange(_ slider: UISlider) {
        let value = slider.value
        print(value)
    }

    lazy var LeverInputView : TradeInputView = {
        
        let placeholder = "tv_trigger_price".localized()
        let view = TradeInputView()
        view.isHasButtons = true
        view.inputTextField.placeholder = placeholder
        view.inputTextField.text = "50X"
        view.inputTextField.tag = 0
//        self.updateUnit.subscribe { _ in
//
//            view.placeholder = "tv_trigger_price".localized() + "(\(self.coinModel.currency))"
//        }.disposed(by: disposeBag)
        return view
    }()
    
    let maxLabel : UILabel = {
        let maxLabel = UILabel()
        maxLabel.font = FONTR(size: 14)
        maxLabel.textColor = .hexColor("E9E9E9")
        maxLabel.text = "当前杠杆倍数最高可开：50,000 BUSD"
        return maxLabel
    }()
    let warningLabel : UILabel = {
        let warningLabel = UILabel()
        warningLabel.font = FONTR(size: 10)
        warningLabel.text = "选择超过(10x)杠杆交易会增加强行平仓风险，请注意相关风险，更多信息请参考这里。"
        warningLabel.textColor = .hexColor("E35461")
        warningLabel.numberOfLines = 0
        return warningLabel
    }()

}

//MARK: ui
extension FuturesLeverSheet{
 
    func setUI(){
        self.titleAligment = .center
        self.title = "调整杠杆"
        self.bottomBtn.setTitle("确认", for: .normal)
        
        contentView.snp.remakeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo((318 + SafeAreaBottom))
        }

        contentView.addSubview(slider)
        contentView.addSubview(LeverInputView)
        LeverInputView.snp.makeConstraints { make in
            
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(51)
            make.height.equalTo(36)
        }
        
        slider.snp.makeConstraints { make in
            
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(LeverInputView.snp.bottom)
            make.height.equalTo(72)
        }
        
        let dotView = UIView()
        dotView.backgroundColor = .white
        dotView.corner(cornerRadius: 3)
        contentView.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.width.height.equalTo(6)
            make.top.equalTo(slider.snp.bottom).offset(24)
        }
        contentView.addSubview(maxLabel)
        maxLabel.snp.makeConstraints { make in
            
            make.left.equalTo(dotView.snp.right).offset(10)
            make.centerY.equalTo(dotView)
        }
        
        
        let warningImg = UIImageView(image: UIImage(named: "futures_warning"))
        contentView.addSubview(warningImg)
        warningImg.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.width.height.equalTo(13)
            make.top.equalTo(dotView.snp.bottom).offset(21)
        }
        
        contentView.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            
            make.left.equalTo(warningImg.snp.right).offset(5)
            make.top.equalTo(warningImg)
            make.right.equalTo(-LR_Margin)
        }
        
    }
    
    override func bottomBtnClcik() {
        
        print("fuvkc ")
    }
    
}

