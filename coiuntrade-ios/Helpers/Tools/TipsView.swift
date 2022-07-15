//
//  TipsView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/22.
//

import UIKit
enum tipsType : Int{
    case Normal = 0
    case OnlyTitle = 1
    case LoginError = 2
}
class TipsView: UIView {
    /// 返回数据回调
    public var backAtion: ((Bool)->())?
    var message = ""{
        didSet{
            detailLab.text = message
        }
    }
    var icon = ""{
        didSet{
            iconView.image = UIImage(named: icon)
        }
    }
    var title = ""{
        didSet{
            titleLab.text = title
        }
    }
    var type : tipsType = .Normal{
        didSet{
            switch type {
            case .OnlyTitle:
                contentView.snp.remakeConstraints { make in
                    make.centerY.equalTo(bgView.snp.centerY).offset(-30)
                    make.left.equalToSuperview().offset(55)
                    make.right.equalToSuperview().offset(-55)
                    make.height.equalTo(146)
                }
                break
            case .LoginError:
                break
            default:
                break
            }
        }
    }
    
    var actionArray : [String] = []{
        didSet{
            if actionArray.count == 2 {
                cancelBtn.setTitle(actionArray.safeObject(index: 0), for: .normal)
                sureBtn.setTitle(actionArray.safeObject(index: 1), for: .normal)
            }else{
                cancelBtn.setTitle(actionArray.safeObject(index: 0), for: .normal)
                cancelBtn.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-16)
                    make.width.equalTo(80)
                    make.height.equalTo(30)
                }
                sureBtn.isHidden = true
            }
        }
    }
    
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor("000000", alpha: 0.1)
        return view
    }()
    
    lazy var contentView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
//        contentView.corner(cornerRadius: 10)
        return v
    }()
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "")
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.textAlignment = .center
        lab.font = FONTR(size: 14)
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 11)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTR(size: 13)
        btn.tag = 0
        btn.addTarget(self, action: #selector(tapBtn(button:)), for: .touchUpInside)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        return btn
    }()
    lazy var sureBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTR(size: 13)
        btn.tag = 1
        btn.addTarget(self, action: #selector(tapBtn(button:)), for: .touchUpInside)
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        initSubViewsConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        UIApplication.shared.windows.first?.addSubview(self)
//        UIApplication.shared.keyWindow?.addSubview(self)
    }
    public func dismiss() {
        self.removeAllSubViews()
        self.removeFromSuperview()
    }
    
    /// 移除所有子控件
    func removeAllSubViews(){
        if self.subviews.count>0{
            self.subviews.forEach({$0.removeFromSuperview()})
        }
    }
    
    @objc func tapBack(){
        self.dismiss()
    }
    @objc func tapBtn(button : UIButton){
        if button.tag == 0 {
            if backAtion != nil {
                backAtion!(false)
            }
        }else{
            if backAtion != nil {
                backAtion!(true)
            }
        }
        self.dismiss()
    }
}

extension TipsView{
    func setUI(){
        self.addSubview(bgView)
        bgView.addSubview(contentView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLab)
        contentView.addSubview(detailLab)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(sureBtn)
    }
    func initSubViewsConstraints(){
        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        contentView.snp.makeConstraints { make in
            make.centerY.equalTo(bgView.snp.centerY).offset(-30)
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
            make.height.equalTo(216)
        }
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(iconView.snp.bottom).offset(12)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLab.snp.bottom).offset(24)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        sureBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
}
