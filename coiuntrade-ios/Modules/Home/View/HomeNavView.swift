//
//  HomeNavView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/7.
//

import UIKit
protocol HomeNavViewDelegate : NSObjectProtocol {
    ///点击用户
    func clickMineBtn()
    ///点击搜索
    func clickSearchView()
    ///点击站内信
    func clickTopNoticeV()
}
class HomeNavView: UIView {
    
    public weak var delegate: HomeNavViewDelegate? = nil
    lazy var mineBtn : ZQButton = {
        let btn = ZQButton()
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.corner(cornerRadius: 15)
        btn.setTitle("N", for: .normal)
        btn.addTarget(self, action: #selector(tapMineBtn), for: .touchUpInside)
        return btn
    }()
    lazy var searchView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("2D2D2D")
        v.corner(cornerRadius: 15)
        return v
    }()
    lazy var addBtn : ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "scan_icon"), for: .normal)
        return btn
    }()
    lazy var topNoticeV : UIView = {
        let v = UIView()
        return v
    }()
    lazy var tzImageV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "tz-icon")
        v.contentMode = .center
        v.isUserInteractionEnabled = true
        return v
    }()
    lazy var tzLab : UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .hexColor("FCD283")
        lab.textColor = .hexColor("333333")
        lab.font = FONTM(size: 10)
        lab.textAlignment = .center
        lab.corner(cornerRadius: 6)
        return lab
    }()
    lazy var searchImage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "search-icon")
        v.contentMode = .center
        v.isUserInteractionEnabled = true
        return v
    }()
    lazy var searchLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 12)
        lab.textColor = .hexColor("989898")
        lab.text = "home_search".localized()
        return lab
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension HomeNavView{
    @objc func tapMineBtn(){
        self.delegate?.clickMineBtn()
    }
    @objc func tapSearchView(){
        self.delegate?.clickSearchView()
    }
    @objc func tapTopNoticeV(){
        self.delegate?.clickTopNoticeV()
    }
}
//MARK: ui
extension HomeNavView{
    func setUI(){
        self.addSubview(mineBtn)
        self.addSubview(addBtn)
        self.addSubview(topNoticeV)
        topNoticeV.addSubview(tzImageV)
        topNoticeV.addSubview(tzLab)
        self.addSubview(searchView)
        searchView.addSubview(searchLab)
        searchView.addSubview(searchImage)
        
        let tapSearch = UITapGestureRecognizer(target: self, action: #selector(tapSearchView))
        self.searchView.addGestureRecognizer(tapSearch)
        
        let tapNoticeV = UITapGestureRecognizer(target: self, action: #selector(tapTopNoticeV))
        self.addGestureRecognizer(tapNoticeV)
    }
    func initSubViewsConstraints(){
        mineBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.height.equalTo(30)
        }
        addBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.width.height.centerY.equalTo(mineBtn)
        }
        topNoticeV.snp.makeConstraints { make in
            make.right.equalTo(addBtn.snp.left).offset(-5)
            make.centerY.equalTo(mineBtn)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        tzImageV.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        tzLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(12)
        }
        searchView.snp.makeConstraints { make in
            make.left.equalTo(mineBtn.snp.right).offset(10)
            make.right.equalTo(topNoticeV.snp.left).offset(-5)
            make.centerY.equalTo(mineBtn)
            make.height.equalTo(30)
        }
        searchLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
        }
        searchImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
    }
}
