//
//  FuturesSelectedCoinHeadView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/21.
//

import UIKit

class FuturesSelectedCoinHeadView: UIView {
    lazy var titleHisV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 14)
        v.text = "tv_market_search_history".localized()
        return v
    }()
    lazy var line1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
    }()
    lazy var collectionV :BaseCollectionView = {
        let v = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.backgroundColor = .clear
        v.dataSource = self
        v.delegate = self
        v.register(HomeSearchHisCell.self, forCellWithReuseIdentifier: HomeSearchHisCell.CELLID) //注册cell
        v.showsHorizontalScrollIndicator = false  //隐藏水平滚动条
        v.showsVerticalScrollIndicator = false  //隐藏垂直滚动条
        return v
    }()
    lazy var titleV : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 14)
        v.text = "币种列表".localized()
        return v
    }()
    lazy var line2 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898", alpha: 0.2)
        return v
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
extension FuturesSelectedCoinHeadView{
    ///点击hide0
    @objc func tapHideBBtn(sender : QMUIButton){
        sender.isSelected = !sender.isSelected
    }
}
//MARK: ui
extension FuturesSelectedCoinHeadView{
    func setUI(){
        //设置流水布局 layout
        let layout = collectionV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 94, height: 28)
        layout.minimumLineSpacing = 12  //行间距
        layout.minimumInteritemSpacing = (SCREEN_WIDTH-LR_Margin*2-94*3)/2.0  //列间距
        layout.scrollDirection = .vertical //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: LR_Margin, bottom: 15, right: LR_Margin)
        self.addSubview(titleHisV)
        self.addSubview(line1)
        self.addSubview(collectionV)
        self.addSubview(titleV)
        self.addSubview(line2)
    }
    func initSubViewsConstraints(){
        titleHisV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(30)
        }
        line1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleHisV.snp.bottom).offset(5)
            make.height.equalTo(0.5)
        }
        collectionV.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(58)
        }
        titleV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(collectionV.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        line2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleV.snp.bottom).offset(5)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension FuturesSelectedCoinHeadView : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeSearchHisCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchHisCell.CELLID, for: indexPath) as! HomeSearchHisCell
//        let model : RealmCoin = self.viewModel.historys.safeObject(index: indexPath.item) ?? RealmCoin()
        cell.labV.text = "--"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
