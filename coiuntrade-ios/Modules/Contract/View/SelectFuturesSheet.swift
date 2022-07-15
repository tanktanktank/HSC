//
//  SelectFuturesSheet.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/15.
//

import UIKit
import RxSwift

class SelectFuturesSheet: UIView {

    let disposebag = DisposeBag()
    /// 返回数据回调
    public var clickCellAtion: ((Int)->())?
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor("000000", alpha: 0.5)
        return view
    }()

    lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.corner(cornerRadius: 10)
        contentView.backgroundColor = .hexColor("1E1E1E")
        return contentView
    }()
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTDIN(size: 16)
        btn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        btn.backgroundColor = .hexColor("FCD283")
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    
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
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SelectFuturesSheet{

    public func show() {
        UIApplication.shared.windows.first?.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y -= self.contentView.bounds.size.height
            self.contentView.frame = rect
        }
    }
    public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y += self.contentView.bounds.size.height
            self.contentView.frame = rect
        } completion: { isok in
            self.removeAllSubViews()
            self.removeFromSuperview()
        }

    }
    /// 移除所有子控件
    func removeAllSubViews(){
        if self.subviews.count>0{
            self.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}

//MARK: ui
extension SelectFuturesSheet{
    @objc func tapCancelBtn(){
        self.dismiss()
    }
    func setUI(){
        self.addSubview(bgView)
        bgView.addSubview(contentView)
        contentView.addSubview(cancelBtn)
        
        let titleLabel = UILabel()
        titleLabel.text = "保证金模式"
        titleLabel.textColor = .white
        titleLabel.font = FONTR(size: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.top.left.equalTo(LR_Margin)
            make.height.equalTo(22)
        }
        
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
    func initSubViewsConstraints(){
        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        
        contentView.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo((243 + SafeAreaBottom))
        }
        cancelBtn.snp.makeConstraints { make in
            
            make.bottom.equalToSuperview().offset( -(SafeAreaBottom + 1))
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(48)
        }
    }
}

