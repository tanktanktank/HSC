//
//  AdScrollLabel.swift
//  自动滚动Label
//
//  Created by Duangser on 2020/5/26.
//  Copyright © 2020 Duangser. All rights reserved.
//

import UIKit

class AdScrollLabelView: UIView {
    
    var adLabelClick: ((_ index:Int) -> Void)?
    
    /** 字体大小 默认14*/
    var labelFont:UIFont = .systemFont(ofSize: 14)
    
    /** 字体颜色 默认000000*/
    var labelColor:UIColor = UIColor.hexColor(0x989898)
    
    /** 文字对齐方式  默认居左*/
    var adTextAlignment:NSTextAlignment = .left
    
    /** 是否显示文字前的图片  默认false显示*/
    var isHiiddenAdImage = false
    
    /** 轮播间隔时间 默认2*/
    var adTimeInterval:TimeInterval = 3
    
    /** 图片与文字的间距 默认5 不显示图片的话设置也没有用 */
    var margin:CGFloat = 5.0
    
    /** 需要显示的所有文字 */
    private var adTextArray:Array<NoticeShowModel> = Array.init()
    
    /** 记录当前显示的第几个文字 */
    private var textIndex:Int = 0
    
    /** 文字的坐标x */
    private var labelX:CGFloat = 0

    /** 文字前的图片Image 有个默认图片 */
    lazy final var adImageView:UIImageView = {
        let _adImageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 15))
        _adImageView.image =  UIImage.init(named: "特惠") ?? UIImage.init()
        _adImageView.contentMode = .scaleAspectFit
        return _adImageView
    }()
    
    /** 用两个label轮流显示 */
    private lazy final var firstLabel:UILabel = {
        let _firstLabel = initAdLabel()
        let labelX = adImageView.frame.maxX + margin
        _firstLabel.frame = CGRect.init(x: labelX, y: 0, width: SCREEN_WIDTH-84 - labelX, height: 33)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstLabelActionTap))
        _firstLabel.addGestureRecognizer(tapGesture)
        return _firstLabel
    }()
    private lazy final var secondLabel:UILabel = {
        let _secondLabel = initAdLabel()
        let labelX = adImageView.frame.maxX + margin
        _secondLabel.frame = CGRect.init(x: labelX, y: -33, width: SCREEN_WIDTH-84 - labelX, height: 33)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondLabelActionTap))
        _secondLabel.addGestureRecognizer(tapGesture)
        return _secondLabel
    }()
    
    /** 计时器 */
    private lazy final var timer:Timer = {
        let _timer = Timer.scheduledTimer(timeInterval: adTimeInterval, target: self, selector: #selector(timeRepeat), userInfo: nil, repeats: true)
        return _timer
    }()
    
    // MARK: - 重写加载方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //判断是否需要显示图片
        if isHiiddenAdImage {
            labelX = 0
            adImageView.removeFromSuperview()
        }else{
            labelX = adImageView.frame.maxX + margin
            addSubview(adImageView)
        }
        firstLabel.frame.origin.x = labelX
        secondLabel.frame.origin.x = labelX
        //其它设置
        setLabel()
    }
    
    // MARK: - 设置lable
    private func setLabel(){
        firstLabel.textColor = labelColor
        firstLabel.font = labelFont
        firstLabel.textAlignment = adTextAlignment
        secondLabel.textColor = labelColor
        secondLabel.font = labelFont
        secondLabel.textAlignment = adTextAlignment
    }
    
    // MARK: - 加载view
    private func setupViews() {
        //居中
        adImageView.center.y = self.frame.height/2
        self.clipsToBounds = true
        addSubview(adImageView)
        addSubview(firstLabel)
        addSubview(secondLabel)
    }
    
    // MARK: - 开始滚动
    func beginScroll(textArray:Array<NoticeShowModel>) {
        guard textArray.count != 0 else {
            return
        }
        adTextArray = textArray
        if timer.isValid {
            if textArray.count <= 1{
            }else{
                let model1 : NoticeShowModel = self.adTextArray.safeObject(index: 1) ?? NoticeShowModel()
                self.secondLabel.text = model1.title
            }
        }
        
        let model0 : NoticeShowModel = self.adTextArray.safeObject(index: 0) ?? NoticeShowModel()
        self.firstLabel.text = model0.title
        self.firstLabel.tag = 10000
        self.secondLabel.tag = 10001
        textIndex = 2
    }
    
    // MARK: - 停止滚动
    func beginScroll() {
        timer.invalidate()
    }
    
    // MARK: - timer执行的方法
    @objc private func timeRepeat(){
        if textIndex == adTextArray.count{
            textIndex = 0
        }
        let labelHeight = frame.height
        let firstLabelY = firstLabel.frame.origin.y == 0 ? labelHeight:0
        let secondLabelY = secondLabel.frame.origin.y == 0 ? labelHeight:0

        UIView.animate(withDuration: 0.3, animations: {
//            if firstLabelY == 0{
                self.firstLabel.frame.origin.y = -labelHeight
                self.secondLabel.frame.origin.y = 0
//            }else{
//                self.secondLabel.frame.origin.y = -labelHeight
//                self.firstLabel.frame.origin.y = 0
//            }
//            self.firstLabel.frame.origin.y = firstLabelY
//            self.secondLabel.frame.origin.y = secondLabelY
        }) { (bool) in
            let model : NoticeShowModel = self.adTextArray.safeObject(index: self.textIndex) ?? NoticeShowModel()
            if firstLabelY == 0{
                self.secondLabel.frame.origin.y = 0
                self.firstLabel.frame.origin.y = labelHeight
                
                self.secondLabel.text =  model.title
                self.secondLabel.tag = self.textIndex + 10000
            }else{
                self.secondLabel.frame.origin.y = labelHeight
                self.firstLabel.frame.origin.y = 0
                self.firstLabel.text = model.title
                self.firstLabel.tag = self.textIndex + 10000
            }
            // +1
            self.textIndex += 1
        }
    }
    
    // MARK: - 点击事件
    @objc func firstLabelActionTap(){
        adLabelClick!(firstLabel.tag - 10000)
    }
    @objc func secondLabelActionTap(){
        adLabelClick!(secondLabel.tag - 10000)
    }
    // MARK: - 初始化label
    private func initAdLabel() ->  UILabel{
        let tempAdLabel = UILabel.init()
        tempAdLabel.font = labelFont
        tempAdLabel.textColor = labelColor
        tempAdLabel.textAlignment = adTextAlignment
        tempAdLabel.isUserInteractionEnabled = true
        return tempAdLabel
    }
}
