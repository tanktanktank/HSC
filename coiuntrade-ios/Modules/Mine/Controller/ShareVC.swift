//
//  ShareVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/5.
//

import UIKit

class ShareVC: BaseViewController {
    lazy var shareImageView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "share_bg")
        return v
    }()
    lazy var bottomView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var cententView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var shareBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("common_cancel".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.backgroundColor = .hexColor("1E1E1E")
        btn.titleLabel?.font = FONTR(size: 14)
        btn.addTarget(self, action: #selector(tapShareBtn), for: .touchUpInside)
        return btn
    }()
    lazy var backBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(tapBackBtn), for: .touchUpInside)
        return btn
    }()
    private lazy var collectionView : BaseCollectionView = {
        let v = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return v
    }()
    var dataArray = [["title" : "Telegram" , "iconName" : "share_telegram"],["title" : "Facebook" , "iconName" : "share_facebook"],["title" : "tv_save_pic".localized() , "iconName" : "share_save"],["title" : "tv_home_moudle_more".localized() , "iconName" : "share_more"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hexColor("000000")
        setUI()
        initSubViewsConstraints()
//        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}
//MARK: 点击事件
extension ShareVC{
    ///点击返回
    @objc func tapBackBtn(){
        navigationController?.popViewController(animated: true)
    }
    @objc func tapShareBtn(){
        navigationController?.popViewController(animated: true)
    }
    //MARK: 保存图片
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error != nil {
            HudManager.showOnlyText("保存失败")
        } else {
            HudManager.showOnlyText("保存成功")
        }
    }
}
// MARK: - UI
extension ShareVC{
    func setUI() {
        view.addSubview(shareImageView)
        view.addSubview(bottomView)
        view.addSubview(cententView)
        view.addSubview(backBtn)
        bottomView.addSubview(shareBtn)
        cententView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(SareCell.self, forCellWithReuseIdentifier: SareCell.CELLID) //注册cell
        //设置流水布局 layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (SCREEN_WIDTH-1)/4.0, height: 110)
        layout.minimumLineSpacing = 0  //行间距
        layout.minimumInteritemSpacing = 0  //列间距
        layout.scrollDirection = .vertical //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.showsHorizontalScrollIndicator = false  //隐藏水平滚动条
        collectionView.showsVerticalScrollIndicator = false  //隐藏垂直滚动条
    }
    func initSubViewsConstraints() {
        backBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(STATUSBAR_HIGH)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(SafeAreaBottom + 49)
        }
        shareImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLab)
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.bottom.equalTo(bottomView.snp.top).offset(-62)
        }
        cententView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(-0.5)
            make.height.equalTo(110)
        }
        shareBtn.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(49)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ShareVC : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count;
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : SareCell = collectionView.dequeueReusableCell(withReuseIdentifier: SareCell.CELLID, for: indexPath) as! SareCell
        let dict = dataArray.safeObject(index: indexPath.item)
        cell.iconView.image = UIImage(named: dict?["iconName"] ?? "")
        cell.titleLab.text = dict?["title"] ?? ""
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if indexPath.item == 2 {///保存
            UIImageWriteToSavedPhotosAlbum(shareImageView.image!, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        if indexPath.item == 3 {///更多
            let text = "xxxx"
            let image : UIImage = UIImage(named: "share_bg") ?? UIImage()
            let activityVC = UIActivityViewController(activityItems: [text, image], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
            return
        }
    }
}

class SareCell: UICollectionViewCell {
    static let CELLID = "SareCell"
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 12)
        v.textAlignment = .center
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconView)
        self.addSubview(titleLab)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        titleLab.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
