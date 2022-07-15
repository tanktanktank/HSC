//
//  UserUploadingView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/5.
//

import UIKit

class UserUploadingView: UIView {

    /// 底条颜色
    public var backLineColor: UIColor = .lightGray
    
    /// 底条宽度
    public var backLineWidth: CGFloat = 2.4
    
    /// 进度条颜色
    public var progressColor: UIColor = .brown
    
    /// 进度条宽度
    public var progressWidth: CGFloat = 2.4
    
    /// 进度比例（0～1）
    public var ratio: CGFloat = 0 {
        didSet {
            var newValue = ratio
            if newValue < 0 {
                newValue = 0
            } else if (newValue > 1) {
                newValue = 1
            }
            self.lineLayer?.strokeEnd  = newValue
        }
    }
    
    /// 开始弧度
    public var startAngle: CGFloat = CGFloat(-(Double.pi / 2))
    
    /// 结束弧度
    public var endAngle: CGFloat = CGFloat(Double.pi / 2 * 3)
    
    /// 中间文本框
    public lazy private(set) var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .brown
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 10)
        return textLabel
    }()
    
    private var lineLayer: CAShapeLayer?
    private var backLayer: CAShapeLayer?

    
    var timer: Timer?
    var countDown: Int = 600
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = .clear
        addSubview(textLabel)
        
        addSubview(resultImageV)
        addSubview(resultLab)
    }
    
    func show(){
        
        self.textLabel.isHidden = false
        self.lineLayer?.isHidden = false
        self.backLayer?.isHidden = false
        self.resultImageV.isHidden = true
        self.resultLab.isHidden = true
        countDown = 600
        self.ratio = 0.01
        self.textLabel.text = "1%"
        timer = Timer.scheduledTimer(timeInterval: 0.0318, target: self, selector: #selector(timeFun), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    func finish(){
        self.ratio = 1
        self.textLabel.text = "100%"
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }

        UIView.animate(withDuration: 0.1, delay: 0.0) {

        } completion: {[weak self]  Bool in
            self?.showSuccess()
        }
    }
    func showSuccess(){
        
        self.backLayer?.isHidden = true
        self.lineLayer?.isHidden = true
        self.textLabel.isHidden = true
        self.resultImageV.isHidden = false
        self.resultLab.isHidden = false
    }
    @objc func timeFun() {
        countDown -= 2
        let percent = CGFloat(600 - countDown) / 600.0
        if(percent >= 0.35){
            self.ratio = 0.35
            self.textLabel.text = "35%"

            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            return
        }
        let tip = String(format: "%.0f", (percent * 100)) //percent * 100
        self.ratio = percent
        self.textLabel.text = tip + "%"  //"\(Int(ceil(Double(countDown) / 10.0)))"
        if countDown == 0 {
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius: CGFloat = ((self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width)-(self.backLineWidth > self.progressWidth ? self.backLineWidth : self.progressWidth))*0.5;
        
        let path = UIBezierPath()
        let centerPoint = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: true)
        
        let backLayer = CAShapeLayer()
        backLayer.frame = self.bounds
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.lineWidth = self.backLineWidth
        backLayer.strokeColor = self.backLineColor.cgColor
        backLayer.strokeStart = 0
        backLayer.strokeEnd = 1
        backLayer.lineCap = .round
        backLayer.path = path.cgPath
        self.layer.addSublayer(backLayer)
        self.backLayer = backLayer
        
        let lineLayer = CAShapeLayer()
        lineLayer.frame = self.bounds
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = self.progressWidth
        lineLayer.strokeColor = self.progressColor.cgColor
        lineLayer.strokeStart = 0
        lineLayer.strokeEnd = self.ratio
        lineLayer.lineCap = .round
        lineLayer.path = path.cgPath
        self.layer.addSublayer(lineLayer)
        self.lineLayer = lineLayer
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.8, height: self.bounds.size.height * 0.5)
        self.textLabel.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        self.resultImageV.frame = CGRect(x: (self.width - 27) * 0.5, y: 1, width: 27, height: 27)
        self.resultLab.frame = CGRect(x: 0, y: self.resultImageV.maxY + 6, width: self.width , height: 20)
    }
    
    lazy var resultImageV: UIImageView = {
        
        let imageview = UIImageView()
        imageview.image = UIImage.init(named: "UserCerUploadFinish")
        imageview.isHidden = true
        return imageview
    }()
    
    lazy var resultLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 11)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "提交成功"
        lab.isHidden = true
        return lab
    }()
}
