//
//  FuturesSubvies.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/19.
//

import UIKit

class FuturesTitleInputView : UIView{
    let disposebag = DisposeBag()
    
    enum TitleInputViewType {
  
        case nomal
        case button
        case noArrow
        case subBtn
    }
    
    var didClick : NormalBlock?
    
     lazy var type : TitleInputViewType? = nil {
        didSet{

            switch type {
                case .nomal:
                infoLabel.textAlignment = .right
                arrowImg.isHidden = false
                infoLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
                infoLabel.snp.remakeConstraints { make in
                    
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-32)
                    make.top.bottom.equalToSuperview()
                }
                infoLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

                textfield.snp.remakeConstraints { make in
                    
                    make.left.equalToSuperview().offset(LR_Margin)
                    make.right.equalTo(infoLabel.snp.left).offset(-10)
                    make.top.bottom.equalToSuperview()
                }
                case .button:
                infoLabel.textAlignment = .left
                arrowImg.isHidden = false
                infoLabel.snp.remakeConstraints { make in
                        
                    make.top.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(LR_Margin)
                    make.right.equalTo(-32)
                }
                case .noArrow:
                infoLabel.textAlignment = .right
                infoLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
                arrowImg.isHidden = true
                infoLabel.snp.remakeConstraints { make in

                    make.centerY.equalToSuperview()
                    make.right.equalTo(-15)
                    make.top.bottom.equalToSuperview()
                }
                textfield.snp.remakeConstraints { make in
                    
                    make.left.equalToSuperview().offset(LR_Margin)
                    make.right.equalTo(infoLabel.snp.left).offset(-10)
                    make.top.bottom.equalToSuperview()
                }
            case .subBtn:
                
                infoLabel.textAlignment = .right
                infoLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
                arrowImg.isHidden = true
                infoLabel.snp.remakeConstraints { make in

                    make.centerY.equalToSuperview()
                    make.right.equalTo(-15)
                    make.top.bottom.equalToSuperview()
                }
                
                
                subBtn.isHidden = false
                subBtn.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
                subBtn.snp.makeConstraints { make in
                    
                    make.centerY.equalToSuperview()
                    make.right.equalTo(infoLabel.snp.left).offset(-6)
                    make.top.bottom.equalToSuperview()

                }
                
                textfield.snp.remakeConstraints { make in
                    
                    make.left.equalToSuperview().offset(LR_Margin)
                    make.right.equalTo(subBtn.snp.left).offset(-10)
                    make.top.bottom.equalToSuperview()
                }


            case .none:
                print("")
            }
        }
     }
    
    var subBtnTitle : String? {
        
        didSet {
            
            if let subBtnTitle = subBtnTitle {
                
                subBtn.setTitle(subBtnTitle, for: .normal)
            }
        }
    }
    
    lazy var subBtn : UIButton = {
        
        let btn = UIButton()
        btn.setTitle(subBtnTitle, for: .normal)
        btn.setTitleColor(.hexColor("FCD283"), for: .normal)

        return btn
    }()
    
   lazy var title : String? = nil {
        
        didSet{

            titleLabel.text = title
        }
    }

    private let titleLabel = UILabel()
    private let textfield  = UITextField()
    private let infoLabel  = UILabel()
    private let arrowImg = UIImageView(image: UIImage(named: "index_top_down"))

    convenience init(title : String , type :TitleInputViewType = .nomal ) {
        self.init(frame: .zero)
        self.type = type
        self.title = title
    }
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
                
        titleLabel.text = ""
        titleLabel.textColor = .hexColor("999999")
        titleLabel.font = FONTR(size: 14)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.right.top.equalToSuperview()
            make.height.equalTo(19)
        }
        
        let bgView = UIView()
        bgView.backgroundColor = .hexColor("2D2D2D")
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        bgView.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-LR_Margin)
            make.width.equalTo(7)
        }
        infoLabel.text = "USDC"
        infoLabel.textColor = .white
        infoLabel.font = FONTR(size: 12)
        bgView.addSubview(infoLabel)
        
//        infoLabel.snp.makeConstraints { make in
//
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-32)
//            make.top.bottom.equalToSuperview()
//        }
        
        bgView.addSubview(textfield)
        textfield.placeholder = "nahhahaha"
        textfield.font = FONTR(size: 12)
//        textfield.snp.makeConstraints { make in
//
//            make.left.equalToSuperview().offset(LR_Margin)
//            make.right.equalTo(infoLabel.snp.left).offset(-10)
//            make.top.bottom.equalToSuperview()
//        }\
        
        bgView.addSubview(subBtn)
        subBtn.isHidden = true

        bgView.addTapForView().subscribe ({[weak self] _ in
            
            self?.didClick?()
        }).disposed(by: disposebag)

    }
}

class TitleValueLabelView : UIView{
    
    var title : String? {didSet{titleLabel.text = title}}
    var value : String? {didSet{valueLabel.text = value}}
    var titleFont : UIFont? {didSet{titleLabel.font = titleFont!}}
    var valueFont : UIFont? {didSet{valueLabel.font = valueFont!}}
    var titleColor : UIColor? {didSet{titleLabel.textColor = titleColor!}}
    var valueColor : UIColor? {didSet{valueLabel.textColor = valueColor!}}
    var isHideImg : Bool = true {didSet{imageView.isHidden = isHideImg}}
    
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "wallets_instructions"))

     override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
                
        titleLabel.text = "Minimum deposit"
        titleLabel.textColor = .hexColor("999999")
        titleLabel.font = FONTR(size: 11)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.centerY.equalToSuperview()
            make.height.equalTo(17)
        }
        

        self.addSubview(valueLabel)
        valueLabel.textColor = .white
        valueLabel.font = FONTR(size: 11)
        valueLabel.textAlignment = .right
        valueLabel.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.height.centerY.equalTo(titleLabel)
        }
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.height.width.equalTo(11)
        }
        
        imageView.isHidden = isHideImg
    }
}
//用于合约界面的点击弹出框
class DinOptionView : WLOptionView{
    
    convenience init(type:InputType = .normal) {
        
        self.init(frame: .zero, type: type)
    }
    
   override var dataSource:[String] {
        
        didSet {
            
            if type == .normal  {
                if rowheight != 0 {
                    self.tableViewHeight = CGFloat(CGFloat(self.dataSource.count) * rowheight)
                }else{
                    self.tableViewHeight = CGFloat(self.dataSource.count * cellHeight)
                }
            }else{
                tableViewHeight = 210
            }
            self.title = dataSource.first
        }
    }

    var selectAt : (((Int)->()))?
    
    override init(frame: CGRect, type: InputType) {
        super.init(frame: frame, type: type)
        
        self.isHaveDistance = true
        self.titleColor = .white
        self.backgroundColor = .hexColor("2D2D2D")
        self.cornerRadius = 4
        self.cellHeight = 40
        self.rightImgWidth = 7
        self.textAligment = .left
        self.titleLabel.font = FONTR(size: 12)
        self.animationTime = 0.1
        self.titleFont = FONTDIN(size: 11)
        self.selectedCallBack {[weak self] (viewTemp, index) in

            self?.selectIndex = index
            self?.selectAt?(index)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 class LeftImgRightTitleButton : UIButton{
    
    override var isSelected: Bool {
     
        didSet{
            
            if isSelected {
                
                myImageView.image = selectImg ?? nomalImg ?? image
            }else{
                myImageView.image = nomalImg ?? image
            }
        }
    }
    private var nomalImg : UIImage?
    private var selectImg : UIImage?
    override func setImage(_ image: UIImage?, for state: UIControl.State) {

        if state == .selected {
            selectImg = image
        }else {
            nomalImg = image
            self.image = image
        }
    }
    
    var font : UIFont = FONTDIN(size: 12) {  didSet{  myTitleLabel.font = font }}
    var title : String? { didSet{
            
            myTitleLabel.text = title
            updateContaints() } }
    var margin : Int = 10 { didSet { updateContaints() } }
    var textColor : UIColor = .hexColor("989898") { didSet{ myTitleLabel.textColor = textColor } }
    var image : UIImage? { didSet{
            myImageView.image = image
            updateContaints() } }
    var imageWidth : CGFloat = 20 { didSet{
            updateContaints() } }

    func updateContaints() {
        
        if ( image != nil ||  nomalImg != nil ), let _ = title  {
            myImageView.snp.remakeConstraints({ make in
                make.left.equalToSuperview()
                make.height.width.equalTo(imageWidth)
                make.centerY.equalToSuperview()
            })
            myTitleLabel.snp.remakeConstraints({ make in
                make.left.equalTo(myImageView.snp.right).offset(margin)
                make.right.equalTo(-10)
                make.centerY.equalToSuperview()
            })
        }}
    private let myTitleLabel = UILabel()
    private let myImageView = UIImageView()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
                
        self.addSubview(myTitleLabel)
        self.addSubview(myImageView)
        myTitleLabel.textColor = textColor
        myTitleLabel.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//需要定好位之后再给值
class FuturesSliderView : UIView{
    
    var  valueChange : ((CGFloat)->())? // 返回vulue
    
    let sliderTextView = UILabel()
    
    var minimumTrackImage : UIImage? {
        didSet{
            
            slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }
    }
    
    var maximumTrackImage : UIImage? {
        didSet{
            slider.setMaximumTrackImage(maximumTrackImage, for: .normal)
        }
    }
    
    // 是否分段点击 确保有传 titles
    var isStepTouch = false {
        
        didSet{
            
        }
    }
    
    //是否显示顶部的划块
    var  isShowSliderText = false{
        
        didSet{
            
            sliderTextView.isHidden = !isShowSliderText
        }
    }
    /// 需要最少两个item
    var titles : [String]? {
        
        didSet{
            
            self.layoutIfNeeded()
            
            if let titles = titles ,titles.count > 1{
                var i = 0
                let width = self.width - 12
                for title in titles {
                    
                    let label = UILabel()
                    label.text = title
                    label.textColor = .hexColor("989898")
                    label.font = FONTDIN(size: 12)
                    label.textAlignment = .center
                    slider.addSubview(label)
                    let x  = width * CGFloat(i) / CGFloat(titles.count - 1)
                    label.snp.makeConstraints { make in
                        
                        make.centerX.equalTo(x + 6)
                        make.bottom.equalToSuperview()
                        make.height.equalTo(15)
                    }
                    i += 1
                }
            }
        }
    }
        
    lazy var slider : UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "futures_slider"), for: .normal)
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        slider.setMinimumTrackImage(UIImage(named: "futures_calculate_slider_Min_bg"), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "futures_calculate_slider_Max_bg"), for: .normal)
        
        slider.addSubview(sliderTextView)
        sliderTextView.backgroundColor = .hexColor("707070")
        sliderTextView.textColor = .white
        sliderTextView.text = "1x"
        sliderTextView.font = FONTR(size: 12)
        sliderTextView.textAlignment = .center
        sliderTextView.snp.makeConstraints { make in
            
            make.centerX.equalTo(6)
            make.top.equalToSuperview()
            make.height.equalTo(15)
            make.width.equalTo(30)
        }
         
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        slider.addGestureRecognizer(tapGestureRecognizer)

        return slider
    }()
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
      //  print("A")
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        
        if isStepTouch {
            
            let count : CGFloat = CGFloat(titles?.count ?? 2 ) - 1
            
            let part = 1.0 / count
            
            let halfPart = part / 2

            var step = Int(newValue / part)
            
            let reminder = newValue.truncatingRemainder(dividingBy: part)
            
            if reminder > halfPart {
                
                step += 1
            }
            
            let value = CGFloat(step) * part
            
            self.slider.setValue(Float(value), animated: true)

        }else{
            
            self.slider.setValue(Float(newValue), animated: true)
        }
        
        self.sliderChange(self.slider)
    }
    
    ///slider滑动事件
    @objc private func sliderChange(_ slider: UISlider) {
    
        let value = CGFloat(slider.value)
        
        if isShowSliderText{
            
            let width = self.width - 12

            sliderTextView.snp.updateConstraints { make in
                
                make.centerX.equalTo( 6 + width * value )
            }
            sliderTextView.text = "\(Int( value * 100 < 1 ? 1 : value * 100 ))x"
        }
        
        self.valueChange?(value)
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(slider)
        sliderTextView.isHidden = !isShowSliderText

        slider.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class HPAlertController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private var padding: CGFloat = 12

    private var alertTintColor: UIColor!
    
    private var alertIcon: HPAlertIcon!
    
    private var alertTitle: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    private var alertMessage: String? {
        get {
            messageLabel.text
        }
        set {
            messageLabel.attributedText = NSAttributedString(string: newValue ?? "", attributes: messageLabelAttributes)
        }
    }
    
    
    private var messageLabelAttributes: [NSAttributedString.Key : Any] = {
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center
        
        attributes = [NSAttributedString.Key.foregroundColor : UIColor.hexColor("ffffff"),
                      NSAttributedString.Key.paragraphStyle : paragraphStyle,
                      NSAttributedString.Key.font : FONTM(size: 16) ]
        
        return attributes
    }()
    

    // MARK: - INITIALIZERS
    
    public init(title: String, message: String, icon: HPAlertIcon = .none, alertTintColor: UIColor ) {
        super.init(nibName: nil, bundle: nil)
        self.alertTintColor = alertTintColor
        self.alertMessage = message
        self.alertTitle = title
        self.alertIcon = icon
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - VIEWS
    
    private var cardView: UIView = {
        let cardView = UIView()
        
        cardView.backgroundColor = .hexColor("2D2D2D")
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        return cardView
    }()
    
    // Stack views
    
    private var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        
        mainStackView.spacing = 25
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return mainStackView
    }()
    
    private var labelsStackView: UIStackView = {
        let labelsStackView = UIStackView()
        
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 15
        labelsStackView.alignment = .fill
        
        return labelsStackView
    }()
    
    private var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        
        return buttonsStackView
    }()
    
    // Labels
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.font = FONTM(size: 20)
        titleLabel.textColor = .hexColor("ffffff")
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    private var messageLabel: UILabel = {
        let messageLabel = UILabel()
        
        messageLabel.font = FONTR(size: 16)
        messageLabel.textColor = .hexColor("ffffff")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return messageLabel
    }()
    
    // Icon
    
    private lazy var iconContainerView: UIView = {
        let iconContainerView = UIView()
        
        iconContainerView.isHidden = alertIcon == HPAlertIcon.none ? true : false
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconContainerView
    }()
    
    private lazy var iconBackgroundView: UIView = {
        let iconBackgroundView = UIView()
        
        iconBackgroundView.backgroundColor = alertTintColor
        iconBackgroundView.layer.cornerRadius = 65
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconBackgroundView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = alertIcon.rawValue
        iconImageView.tintColor = .hexColor("FCD283")
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconImageView
    }()
    
    
    // MARK: - PRIVATE HELPERS
    
    private func setUp() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .black.withAlphaComponent(0.2)
        setConstraints()
    }
    
    private func setConstraints() {
        view.addSubview(cardView)
        cardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        cardView.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding).isActive = true
        
        mainStackView.addArrangedSubview(iconContainerView)
        iconContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        iconContainerView.addSubview(iconBackgroundView)
        iconBackgroundView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        iconBackgroundView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        iconBackgroundView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor).isActive = true
        iconBackgroundView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor).isActive = true
        
        iconBackgroundView.addSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor).isActive = true
        
        mainStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(messageLabel)
        
        mainStackView.addArrangedSubview(buttonsStackView)
        
//        mainStackView.backgroundColor = .red
//        labelsStackView.backgroundColor = .blue
//        titleLabel.backgroundColor = .yellow
//        messageLabel.backgroundColor = .green
//        buttonsStackView.backgroundColor = kMainColor
        
    }
    
    // MARK: - PUBLIC METHODS
    
    public func addAction(_ action: HPAlertAction) {
        let button = HPAlertActionButton(action: action, tintColor: alertTintColor)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if #available(iOS 14.0, *) {
            button.addAction(UIAction(handler: { [weak self] _ in
                self?.dismiss(animated: true) {
                    action.handler()
                }
            }), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        
        buttonsStackView.addArrangedSubview(button)
    }
}

internal class HPAlertActionButton: UIButton {
    
    // MARK: - PROPERTIES
    
    private var action: HPAlertAction!
    
    private lazy var buttonBackgroundColor: UIColor = {
        var buttonBackgroundColor = UIColor()
        
        switch action.style {
        case .default:
            buttonBackgroundColor = .hexColor("FCD283")
        case .cancel:
            buttonBackgroundColor = .hexColor("1E1E1E")
        case .gotIt:
            buttonBackgroundColor = .hexColor("1E1E1E")
        case .destructive:
            buttonBackgroundColor = .hexColor("1E1E1E")
        case .none:
            break
        }
        
        return buttonBackgroundColor
    }()
    
    private lazy var buttonTextColor: UIColor = {
        var buttonTextColor = UIColor()
        
        switch action.style {
        case .default:
            buttonTextColor = .hexColor("000000")
        case .cancel:
            buttonTextColor = .hexColor("FCD283")
        case .gotIt:
            buttonTextColor = .hexColor("FCD283")
        case .destructive:
            buttonTextColor = .hexColor("FCD283")
        case .none:
            break
        }
        
        return buttonTextColor
    }()
    
    
    // MARK: - INITIALIZERS
    
    convenience init(action: HPAlertAction, tintColor: UIColor) {
        self.init(type: .custom)
        self.action = action
        self.tintColor = tintColor
        self.configureButton()
    }
    
    
    // MARK: - HELPERS
    
    func configureButton() {
        setTitle(action.title, for: .normal)
        setTitleColor(buttonTextColor, for: .normal)
        setTitleColor(buttonTextColor.withAlphaComponent(0.6), for: .highlighted)
        titleLabel?.font = FONTM(size: 16)
        backgroundColor = buttonBackgroundColor
        layer.cornerRadius = 6
        
    }
}


public class HPAlertAction: NSObject {
    
    private(set) var title: String!
    private(set) var style: HPAlertAction.Style!
    private(set) var handler: () -> Void
    
    public init(title: String, style: HPAlertAction.Style = .default, handler: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension HPAlertAction {
    public enum Style {
        case `default`
        case cancel
        case gotIt
        case destructive
    }
}

public enum HPAlertIcon: Equatable {
    case error
    case info
    case success
    case custom(UIImage)
    case none
    
    public var rawValue: UIImage? {
        switch self {
        case .error:
            return UIImage(named: "alert_error")
        case .info:
            return UIImage(named: "alert_info")
        case .success:
            return UIImage(named: "alert_success")
        case .custom(let icon):
            return icon
        case .none:
            return nil
        }
    }
}
