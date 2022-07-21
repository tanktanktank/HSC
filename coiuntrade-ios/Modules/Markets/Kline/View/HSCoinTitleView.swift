//
//  HSCoinTitleView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/13.
//

import UIKit

//0: back, 1: change coin, 2: collect
typealias TitleVPass = (Int)->()


class HSCoinTitleView: UIView {

    var pass:TitleVPass?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupEvent()
    }
    
    func setupEvent(){
        
        changeBtn.rx.tap
            .subscribe(onNext: {
                
                self.pass?(1)
            }).disposed(by: disposeBag)
        
        backBtn.rx.tap
            .subscribe(onNext: {
                
                self.pass?(0)
            }).disposed(by: disposeBag)
        
        collectBtn.rx.tap
            .subscribe(onNext: {
                self.pass?(2)
            }).disposed(by: disposeBag)
    }
    
    func setupUI(){
        
        addSubview(backBtn)
        addSubview(titleLab)
        addSubview(changeBtn)
        addSubview(verticalBtn)
        addSubview(shareBtn)
        addSubview(collectBtn)
    }
    
    func setupConstraints(){
        
        backBtn.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(44)
            make.left.top.equalToSuperview()
        }
        titleLab.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        changeBtn.snp.makeConstraints { make in
            make.right.equalTo(titleLab.snp.left)
            make.height.top.equalToSuperview()
            make.width.equalTo(40)
        }
        collectBtn.snp.makeConstraints { make in
            make.right.height.top.equalToSuperview()
            make.width.equalTo(40)
        }
        shareBtn.snp.makeConstraints { make in
            make.right.equalTo(collectBtn.snp.left)
            make.height.top.equalToSuperview()
            make.width.equalTo(40)
        }
        verticalBtn.snp.makeConstraints { make in
            make.right.equalTo(shareBtn.snp.left)
            make.height.top.equalToSuperview()
            make.width.equalTo(40)
        }
    }
    

    lazy var titleLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.textColor = .white
        lab.text = "--/--"
        return lab
    }()
    
    lazy var changeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "kTitle"), for: .normal)
        return btn
    }()
    
    lazy var verticalBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "kgroup"), for: .normal)
        return btn
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "kshare"), for: .normal)
        return btn
    }()
    
    lazy var collectBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "kstart"), for: .normal)
        btn.setImage(UIImage.init(named: "kstartyes"), for: .selected)
        return btn
    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "nav_back"), for: .normal)
        return btn
    }()
    
    private var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
