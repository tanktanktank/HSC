//
//  RechageDetailCellView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit
enum RechageDetailCellViewType : Int{
    ///无copy图片
    case normal = 0
    ///右copy图片
    case copy = 1
}
class RechageDetailCellView: UIView {
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var contentV : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 12)
        v.textColor = .hexColor("FFFFFF")
        v.numberOfLines = 0
        v.textAlignment = .right
        return v
    }()
    lazy var btn : ZQButton = {
        let v = ZQButton()
        v.setImage(UIImage(named: "decopy"), for: .normal)
        return v
    }()
    var type : RechageDetailCellViewType = .normal{
        didSet{
            switch type {
            case .normal:
                btn.isHidden = true
                contentV.snp.remakeConstraints { make in
                    make.right.equalToSuperview().offset(-LR_Margin)
                    make.bottom.equalToSuperview().offset(-10)
                    make.width.equalTo(192)
                    make.top.equalToSuperview().offset(10)
                }
                break
            default:
                break
            }
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
extension RechageDetailCellView{
    func setUI(){
        self.addSubview(titleV)
        self.addSubview(contentV)
        self.addSubview(btn)
    }
    func initSubViewsConstraints(){
        btn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        contentV.snp.makeConstraints { make in
            make.right.equalTo(btn.snp.left).offset(-7)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(175)
            make.top.equalToSuperview().offset(10)
        }
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.centerY.equalToSuperview()
            make.right.equalTo(contentV.snp.left).offset(-20)
        }
    }
}
