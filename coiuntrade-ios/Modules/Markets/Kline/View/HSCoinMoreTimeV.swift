//
//  HSCoinMoreTimeV.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/18.
//

import UIKit


typealias passMoreTimeValue = ([String:String])->()
typealias passMoreWeek = ()->()

class HSCoinMoreTimeV: UIView {
    
    private var disposeBag = DisposeBag()
    var pass:passMoreTimeValue?
    var passW:passMoreWeek?
    var allTimes = [[String:String]]()
    var oriy = 0
    
    lazy var bgHeadView: UIView = {
        
        let bgView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        bgView.addGestureRecognizer(tap)
        return bgView
    }()
    
    lazy var bgView: UIView = {
        
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.66)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        bgView.addGestureRecognizer(tap)
        return bgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setupContraints()
        self.alpha = 0.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func bgClick() {
        
        hide()
    }
    
    func show(){
        
        let view = viewWithTag(1024)
        UIView.animate(withDuration: 0.2, delay: 0.0) {[weak self] in
            self?.alpha = 1.0
            view?.snp.updateConstraints({ make in
                make.height.equalTo(90)
            })
        }
    }
    
    func hide(){
        let view = viewWithTag(1024)
        UIView.animate(withDuration: 0.2, delay: 0.0) {[weak self] in
            self?.alpha = 0.0
            view?.snp.updateConstraints({ make in
                make.height.equalTo(0)
            })
        }
    }

    @objc func tapBtn(button : UIButton){
        
        let info = allTimes[button.tag]
        pass?(info)
        hide()
    }
    
    
    func setupContraints(){
        
        let top = (is_iPhoneXSeries() ? 44 : 20) + 44
        bgHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(97+top+40)
        }
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(bgHeadView.snp.bottom)
        }
        let timeView = viewWithTag(1024)
        timeView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(bgHeadView.snp.bottom)
        })
    }
    
    func setUI(){
        
        addSubview(bgView)
        addSubview(bgHeadView)

        let timeView = UIView()
        timeView.tag = 1024
        timeView.backgroundColor = UIColor.hexColor("1e1e1e")
        addSubview(timeView)
        
        //60+30,,, 24
        allTimes = [["time":"3分","value":"3m"],["time":"5分","value":"5m"],["time":"30分","value":"30m"],["time":"2小时","value":"2h"],
                        ["time":"6小时","value":"6h"],["time":"8小时","value":"8h"],["time":"12小时","value":"12h"],["time":"3日","value":"3d"],
                        ["time":"周线","value":"1w"],["time":"月线","value":"1M"]]
        
        let lineCount = 6
        let margin = 10
        let timeH = 60
        let btnW = (Int(SCREEN_WIDTH) - (lineCount + 1)*margin)/lineCount
        let btnH = 24
        let topMargin = (timeH - btnH*2)/3
        for i in 0..<allTimes.count{

            let info = allTimes[i]
            let btn = UIButton(type: .custom)
            btn.setTitle(info["time"], for: .normal)
            btn.setTitleColor(UIColor.hexColor("ebebeb"), for: .normal)
            btn.backgroundColor = UIColor.hexColor("2d2d2d")
            btn.layer.cornerRadius = 4.0
            btn.clipsToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.frame = CGRect(x: margin + (btnW+margin) * (i%6), y: topMargin + (btnH+topMargin) * (i/6), width: btnW, height: btnH)
            btn.tag = i
            btn.addTarget(self, action: #selector(tapBtn(button:)), for: .touchUpInside)
            timeView.addSubview(btn)
        }
        
        let lineV = UIView(frame: CGRect(x: 0, y: timeH+1, width: Int(SCREEN_WIDTH), height: 1))
        lineV.height = 0.5
        lineV.backgroundColor = .white
        timeView.addSubview(lineV)
        
        let weekLab = UILabel(frame: CGRect(x: margin, y: timeH + 2, width: 100, height: 28))
        weekLab.font = UIFont.systemFont(ofSize: 13)
        weekLab.textColor = .lightGray
        weekLab.textAlignment = .left
        weekLab.text = "周期设置"
        timeView.addSubview(weekLab)
        
        let rightImageV = UIImageView()
        rightImageV.image = UIImage.init(named: "cellright")
        rightImageV.contentMode = .scaleAspectFit
        rightImageV.frame = CGRect(x: Int(SCREEN_WIDTH) - 25, y: timeH + 8, width: 15, height: 15)
        timeView.addSubview(rightImageV)
        
        let weekBtn = UIButton(type: .custom)
        weekBtn.frame = CGRect(x: 0, y: timeH, width: Int(SCREEN_WIDTH), height: 30)
        weekBtn.rx.tap
            .subscribe(onNext: { [weak self]value in
                
                self?.passW?()
            }).disposed(by: disposeBag)
        timeView.addSubview(weekBtn)
    }

}
