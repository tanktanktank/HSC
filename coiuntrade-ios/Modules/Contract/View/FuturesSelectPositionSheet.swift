//
//  SelectFuturesSheet.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/15.
//

import UIKit
import RxSwift

class FuturesSelectPositionSheet: FuturesSheetBaseView {

    /// 返回数据回调
    public var clickCellAtion: ((Int)->())?
    
    lazy var fullBtn :UIButton = {
        
        let btn = UIButton()
        btn.setTitle("全仓", for: .normal)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.titleLabel?.font = FONTR(size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.rx.tap.subscribe ({ [weak self] _ in
            
            self?.isFullSelect = true
        }).disposed(by: disposebag)

        return btn
    }()
    lazy var crossBtn :UIButton = {
        
        let btn = UIButton()
        btn.setTitle("逐仓", for: .normal)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.titleLabel?.font = FONTR(size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.rx.tap.subscribe ({ [weak self] _ in
            
            self?.isFullSelect = false
        }).disposed(by: disposebag)
        return btn
    }()
    
    lazy var tipBtn : LeftImgRightTitleButton = {
        let tipBtn = LeftImgRightTitleButton()
        tipBtn.image = UIImage(named: "mdown")
        tipBtn.title = "什么是全仓和逐仓模式？"
        tipBtn.imageWidth = 7
        tipBtn.margin = 5
        
        tipBtn.rx.tap.subscribe ({ [weak self] _ in
            
            let isShow  = self?.isShowTip ?? false
            
            self?.isShowTip = !isShow
        }).disposed(by: disposebag)

        return tipBtn
    }()
    
    var isFullSelect : Bool = false{
        
        didSet {
            
            if isFullSelect{
             
                fullBtn.corner(cornerRadius: 4, toBounds: true, borderColor: .hexColor("FCD283"), borderWidth: 1)
                crossBtn.corner(cornerRadius: 4, toBounds: true, borderColor: .clear, borderWidth: 1)
            }else{
                
                fullBtn.corner(cornerRadius: 4, toBounds: true, borderColor: .clear, borderWidth: 1)
                crossBtn.corner(cornerRadius: 4, toBounds: true, borderColor: .hexColor("FCD283"), borderWidth: 1)
            }
        }
    }
    
    var isShowTip : Bool = false{

        didSet{
            
            if isShowTip{
                
                contentView.snp.updateConstraints { make in
                    
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo((243 + SafeAreaBottom + 40))
                }

            }else{
                
                contentView.snp.updateConstraints { make in
                    
//                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo((243 + SafeAreaBottom))
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: ui
extension FuturesSelectPositionSheet{
    @objc func tapCancelBtn(){
        self.dismiss()
    }
    func setUI(){
        
        self.title = "保证金模式"

        let closeBtn = UIButton()
        closeBtn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        closeBtn.setImage(UIImage(named: "iconcolse"), for: .normal)
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            
            make.right.top.equalToSuperview()
            make.width.equalTo(46)
            make.height.equalTo(52)
        }
        contentView.addSubview(fullBtn)
        contentView.addSubview(crossBtn)
        isFullSelect = true
        
        fullBtn.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(LR_Margin)
            make.height.equalTo(43)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-(15 + 8))
        }

        crossBtn.snp.makeConstraints { make in
            
            make.right.equalTo(-LR_Margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(LR_Margin)
            make.height.equalTo(43)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-(15 + 8))
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "调整保证金模式仅对当前合约生效。"
        tipLabel.font = FONTM(size: 14)
        tipLabel.textColor = .hexColor("989898")
        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.top.equalTo(fullBtn.snp.bottom).offset(LR_Margin)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(tipBtn)
        tipBtn.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.top.equalTo(tipLabel.snp.bottom).offset(LR_Margin)
            make.height.equalTo(20)
        }
    }
}

