//
//  KLineMoreView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/13.
//

import UIKit

typealias passTimeValue = ([String:String])->()
typealias passWeek = ()->()

class KLineMoreTimeV: UIView {
    
//    let bgView: UIView()
    private var disposeBag = DisposeBag()
    var pass:passTimeValue?
    var passW:passWeek?
    var allTimes = [[String:String]]()
    var oriy = 0
//    var fatherV: UIView
    
    lazy var bgHeadView: UIView = {
        
        let bgView = UIView()
        bgView.tag = 1024+100
        bgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.y)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        bgView.addGestureRecognizer(tap)
        return bgView
    }()
    
    lazy var bgView: UIView = {
        
        let bgView = UIView()
        bgView.tag = 1024+99
        bgView.frame = CGRect(x: 0, y: self.y, width: SCREEN_WIDTH, height: self.superview!.height)
        bgView.backgroundColor = .black.withAlphaComponent(0.66)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        bgView.addGestureRecognizer(tap)
        return bgView
    }()
    
    lazy var backgroundV: UIView = {
        
        let bgView = UIView()
        bgView.tag = 512
        bgView.frame = CGRect(x: 0, y: 0, width: self.width , height: self.superview!.height)
        bgView.backgroundColor = .black.withAlphaComponent(0.66)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        bgView.addGestureRecognizer(tap)
        return bgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.hexColor("1e1e1e")
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func bgClick() {
        hide()
    }
    
    
    func upShow(){
        
    }
    
    func upHide(){
        
    }

    func show(showy: CGFloat){
        self.y = showy
        let temBGView = self.superview?.viewWithTag(1024+99)
        let temHeadBGView = self.superview?.viewWithTag(1024+100)
        if(temBGView == nil){
            self.superview?.insertSubview(bgView, belowSubview: self)
        }
        if(temHeadBGView == nil){
            self.superview?.insertSubview(bgHeadView, belowSubview: self)
        }
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.height = 90
        }
//        addCorner(conrners: [.bottomLeft,.bottomRight], radius: 8)
    }
    func hide(){
        let temBGView = self.superview?.viewWithTag(1024+99)
        let temHeadBGView = self.superview?.viewWithTag(1024+100)
        if(temBGView != nil){
            temBGView?.removeFromSuperview()
        }
        if(temHeadBGView != nil){
            temHeadBGView?.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.height = 0
        }
    }
    
    @objc func tapBtn(button : UIButton){
        
        let info = allTimes[button.tag]
        pass?(info)
        hide()
    }
    
    func setUI(){
        
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
            self.addSubview(btn)
        }
        
        let lineV = UIView(frame: CGRect(x: 0, y: timeH+1, width: Int(SCREEN_WIDTH), height: 1))
        lineV.height = 0.5
        lineV.backgroundColor = .white
        self.addSubview(lineV)
        
        let weekLab = UILabel(frame: CGRect(x: margin, y: timeH + 2, width: 100, height: 28))
        weekLab.font = UIFont.systemFont(ofSize: 13)
        weekLab.textColor = .lightGray
        weekLab.textAlignment = .left
        weekLab.text = "周期设置"
        self.addSubview(weekLab)
        
        let rightImageV = UIImageView()
        rightImageV.image = UIImage.init(named: "cellright")
        rightImageV.contentMode = .scaleAspectFit
        rightImageV.frame = CGRect(x: Int(SCREEN_WIDTH) - 25, y: timeH + 8, width: 15, height: 15)
        self.addSubview(rightImageV)
        
        let weekBtn = UIButton(type: .custom)
        weekBtn.frame = CGRect(x: 0, y: timeH, width: Int(SCREEN_WIDTH), height: 30)
        weekBtn.rx.tap
            .subscribe(onNext: { [weak self]value in
                
                self?.passW?()
            }).disposed(by: disposeBag)
        self.addSubview(weekBtn)
    }

}
