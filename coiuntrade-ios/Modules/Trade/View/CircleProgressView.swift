//
//  CircleProgressView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/6.
//

import UIKit

class CircleProgressView: UIView {
    // 灰色静态圆环
    var staticLayer: CAShapeLayer!
    // 进度可变圆环
    var arcLayer: CAShapeLayer!
    
    // 为了显示更精细，进度范围设置为 0 ~ 1000
    var progress = 0
    var progressColor : UIColor = .hexColor("02C078")
    
    lazy var textLab : UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = FONTM(size: 10)
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textLab)
        textLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Int,progressColor : UIColor ,text :String) {
        self.progress = progress
        self.progressColor = progressColor
        self.textLab.text = text
        self.textLab.textColor = progressColor
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if staticLayer == nil {
            staticLayer = createLayer(1000, .hexColor("989898"))
        }
        self.layer.addSublayer(staticLayer)
        if arcLayer != nil {
            arcLayer.removeFromSuperlayer()
        }
        arcLayer = createLayer(self.progress, progressColor)
        self.layer.addSublayer(arcLayer)
    }
    
    private func createLayer(_ progress: Int, _ color: UIColor) -> CAShapeLayer {
        let endAngle = -CGFloat.pi / 2 + (CGFloat.pi * 2) * CGFloat(progress) / 1000
        let layer = CAShapeLayer()
        layer.lineWidth = 1.5
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        let radius = self.bounds.width / 2 - layer.lineWidth
        let path = UIBezierPath.init(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: endAngle, clockwise: true)
        layer.path = path.cgPath
        return layer
    }
    
}
