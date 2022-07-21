//
//  FuturesSheetBaseView.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/7/18.
//

import UIKit
import RxSwift

class FuturesSheetBaseView: UIView {

    let disposebag = DisposeBag()
    
    var title : String? {  didSet{  titleLabel.text = title } } //设置title
    var titleAligment : NSTextAlignment? {  didSet{  titleLabel.textAlignment = titleAligment ?? .left } } //设置title

    let titleLabel = UILabel()

    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor("000000", alpha: 0.5)
        return view
    }()

    lazy var contentView : UIView = {
        let contentView = UIView()
        contentView.corner(cornerRadius: 10)
        contentView.backgroundColor = .hexColor("1E1E1E")
        return contentView
    }()
    lazy var bottomBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 4)
        btn.titleLabel?.font = FONTDIN(size: 16)
        btn.addTarget(self, action: #selector(bottomBtnClcik), for: .touchUpInside)
        btn.backgroundColor = .hexColor("FCD283")
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(bgView)
        bgView.addSubview(contentView)
        contentView.addSubview(bottomBtn)
        
        titleLabel.textColor = .white
        titleLabel.font = FONTR(size: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.top.left.equalTo(LR_Margin)
            make.right.equalTo(-LR_Margin)
            make.height.equalTo(22)
        }
        
        let closeBtn = UIButton()
        closeBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        closeBtn.setImage(UIImage(named: "iconcolse"), for: .normal)
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            
            make.right.top.equalToSuperview()
            make.width.equalTo(46)
            make.height.equalTo(52)
        }

        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        
        contentView.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo((243 + SafeAreaBottom))
        }
        bottomBtn.snp.makeConstraints { make in
            
            make.bottom.equalToSuperview().offset( -(SafeAreaBottom + 1))
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(48)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension FuturesSheetBaseView{

    public func show() {
        UIApplication.shared.windows.first?.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y -= self.contentView.bounds.size.height
            self.contentView.frame = rect
        }
    }
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y += self.contentView.bounds.size.height
            self.contentView.frame = rect
        } completion: { isok in
            self.removeAllSubViews()
            self.removeFromSuperview()
        }

    }
    /// 移除所有子控件
    func removeAllSubViews(){
        if self.subviews.count>0{
            self.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}

//MARK: ui
extension FuturesSheetBaseView{
    @objc func bottomBtnClcik(){
        self.dismiss()
    }
    
}


