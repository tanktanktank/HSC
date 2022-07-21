//
//  FuturesHeadItemView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/15.
//

import UIKit

class FuturesHeadItemView: UIView {
    lazy var titleLab : UILabel = {
        let v = UILabel()
        v.font = FONTB(size: 11)
        v.textColor = .hexColor("989898")
        v.text = ""
        v.isUserInteractionEnabled = true
        return v
    }()
    lazy var amountLab : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 12)
        v.textColor = .hexColor("EBEBEB")
        v.text = "--"
        return v
    }()
    lazy var rateLab : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "≈--"
        return v
    }()
    lazy var arrowV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "futures_arrow_r")
        v.contentMode = .center
        v.isHidden = true
        return v
    }()
    public var isShowArrow = false{
        didSet{
            if isShowArrow {
                arrowV.isHidden = false
            }
        }
    }
    public var title : String = ""{
        didSet{
            titleLab.text = title
            titleLab.sizeToFit()
            
            titleLab.layoutIfNeeded()
            titleLab.setNeedsLayout()
            //layer
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = titleLab.bounds
            shapeLayer.position = titleLab.center
            shapeLayer.fillColor = UIColor.red.cgColor
            //设置虚线的颜色 - 颜色请必须设置
            shapeLayer.strokeColor = UIColor.hexColor("989898").cgColor
            //设置虚线的高度
            shapeLayer.lineWidth = 1.0
            //设置类型
            shapeLayer.lineJoin = .round
            /*
                10.f=每条虚线的长度
                3.f=每两条线的之间的间距
             */
            shapeLayer.lineDashPattern = [NSNumber.init(value: 4),NSNumber.init(value: 2.5)]
            // Setup the path
            let path1 = CGMutablePath()
            path1.move(to: CGPoint(x: 0, y: titleLab.height+2))
            path1.addLine(to: CGPoint(x: titleLab.width, y: titleLab.height+2))
            shapeLayer.path = path1
            self.layer.addSublayer(shapeLayer)
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
//MARK: ui
extension FuturesHeadItemView{
    func setUI(){
        self.addSubview(titleLab)
        self.addSubview(amountLab)
        self.addSubview(rateLab)
        self.addSubview(arrowV)
    }
    func initSubViewsConstraints(){
        titleLab.sizeToFit()
        titleLab.frame = CGRect(x: LR_Margin, y: 12, width: titleLab.width, height: 15)
        amountLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(4)
            make.height.equalTo(16)
        }
        rateLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.top.equalTo(amountLab.snp.bottom)
            make.height.equalTo(15)
        }
        arrowV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
    }
}
