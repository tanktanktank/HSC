//
//  HSCoinBottomView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/11.
//

import UIKit

class HSCoinBottomView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.hexColor("222222")
        let width = SCREEN_WIDTH * 0.5
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        let rightV = UIView(frame: CGRect(x: leftV.maxX, y: 0, width: width, height: 53))
        
        let currencyView = createUpDownBtn(imageName: "klineCurrency", name: "Currency")
        let alertView = createUpDownBtn(imageName: "klineAlert", name: "Alert")
        let marginView = createUpDownBtn(imageName: "klineMargin", name: "Margin")
        leftV.addSubview(currencyView)
        leftV.addSubview(alertView)
        leftV.addSubview(marginView)
        rightV.addSubview(btnBuy)
        rightV.addSubview(btnSell)
        addSubview(leftV)
        addSubview(rightV)
        
        var index = 0
        let leftSubWidth = width/3
        for view in leftV.subviews{
            
            view.frame = CGRect(x: leftSubWidth * CGFloat(index), y: 0, width: leftSubWidth, height: leftV.height)
            index += 1
        }
        let btnW = (width - 39) * 0.5 //13*3
        btnBuy.frame = CGRect(x: 13, y: 8, width: btnW, height: 40)
        btnSell.frame = CGRect(x: btnBuy.maxX + 13, y: btnBuy.y, width: btnW, height: 40)
        btnBuy.addCorner(conrners: .allCorners, radius: 4)
        btnSell.addCorner(conrners: .allCorners, radius: 4)
    }
    
    
    func createUpDownBtn(imageName: String, name: String) -> UIView{
        
        let fatherView = UIView()
        
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: imageName)
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 10)
        lab.textColor = UIColor.hexColor("979797")
        lab.text = name
        lab.textAlignment = .center
        
        fatherView.addSubview(imageV)
        fatherView.addSubview(lab)
        
        imageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.width.height.equalTo(20)
        }
        lab.snp.makeConstraints { make in
            make.top.equalTo(imageV.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        
        return fatherView
    }
    
    lazy var btnBuy: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Buy", for: .normal)
        btn.setTitleColor(UIColor.hexColor("ffffff"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.hexColor("02C078")
        return btn
    }()
    
    lazy var btnSell: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Sell", for: .normal)
        btn.setTitleColor(UIColor.hexColor("ffffff"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.hexColor("F03851")
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
