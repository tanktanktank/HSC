//
//  AvatarChooseView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/26.
//

import UIKit

protocol AvatarChooseViewDelegate: NSObjectProtocol{
    /// 选择头像
    func selectedHeadImage(model : HeadImageModel)
}
class AvatarChooseView: UIView {
    weak var delegate: AvatarChooseViewDelegate?
    ///背景
    lazy var bgView : UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = .hexColor("000000", alpha: 0.5)
        v.isUserInteractionEnabled = true
        return v
    }()
    ///内容
    lazy var contentView : UIView = {
        let v = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 329))
        v.backgroundColor = .hexColor("1E1E1E")
        v.addCorner(conrners: [.topLeft,.topRight], radius: 10)
        return v
    }()
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTR(size: 14)
        lab.text = "tv_select_head_image".localized()
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.text = "tv_prefenence_dialog_tip".localized()
        return lab
    }()
    lazy var closeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mine_close"), for: .normal)
        btn.addTarget(self, action: #selector(tapCloseBtn), for: .touchUpInside)
        return btn
    }()
    lazy var sureBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_save".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.backgroundColor = .hexColor("FCD283")
        btn.corner(cornerRadius: 4)
        btn.addTarget(self, action: #selector(tapSureBtn), for: .touchUpInside)
        return btn
    }()
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("common_cancel".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = FONTB(size: 16)
        btn.addTarget(self, action: #selector(tapCloseBtn), for: .touchUpInside)
        return btn
    }()
    var moreClick: (() -> Void)?
    ///选中的row
    var selectedIndex : Int = 0
    ///数据
    var dataArry : [HeadImageModel] = []
    
    private lazy var collectionView : BaseCollectionView = {
        let v = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        getDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AvatarChooseView{
    @objc func tapSureBtn(){
        let model : HeadImageModel = self.dataArry.safeObject(index: selectedIndex) ?? HeadImageModel()
        self.delegate?.selectedHeadImage(model: model)
        self.dismiss()
    }
    ///触摸屏幕其他位置
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss()
    }
    func getDataSource(){
        NetWorkRequest(InfoApi.getHeadImage, modelType: HeadImageModel.self) {[weak self] model in
            self?.dataArry = model as! [HeadImageModel]
            self?.collectionView.reloadData()
        }
    }
    @objc func tapCloseBtn(){
        dismiss()
    }
    func dismiss(){
        UIView.animate(withDuration: 0.5) {
            var rect = self.contentView.frame
            rect.origin.y = self.contentView.y + self.contentView.height
            self.contentView.frame = rect
        } completion: { finished in
            self.removeAllSubViews()
            self.removeFromSuperview()
        }

    }
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.5) {
            var rect = self.contentView.frame
            rect.origin.y = self.contentView.y - self.contentView.height
            self.contentView.frame = rect
        }
    }
    /// 移除所有子控件
    func removeAllSubViews(){
        if self.subviews.count>0{
            self.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}
// MARK: - UI
extension AvatarChooseView{
    func setUI() {
        self.addSubview(bgView)
        self.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(closeBtn)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(sureBtn)
        contentView.addSubview(detailLab)
        
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: AvatarCell.CELLID) //注册cell
        //设置流水布局 layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 20  //行间距
        layout.minimumInteritemSpacing = (SCREEN_WIDTH-24-50*5)/4.0  //列间距
        layout.scrollDirection = .vertical //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        
        collectionView.showsHorizontalScrollIndicator = false  //隐藏水平滚动条
        collectionView.showsVerticalScrollIndicator = false  //隐藏垂直滚动条
    }
    func initSubViewsConstraints() {
        self.frame = UIScreen.main.bounds
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
        }
        closeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(titleLab)
            make.width.height.equalTo(20)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(47)
            make.width.equalTo(100)
        }
        sureBtn.snp.makeConstraints { make in
            make.left.equalTo(cancelBtn.snp.right)
            make.bottom.height.equalTo(cancelBtn)
            make.right.equalToSuperview().offset(-12)
        }
        detailLab.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(12)
            make.left.equalTo(titleLab)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(detailLab.snp.bottom)
            make.bottom.equalTo(sureBtn.snp.top)
        }
    }
}
// MARK: - UICollectionViewDataSource
extension AvatarChooseView : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArry.count+1;
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : AvatarCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.CELLID, for: indexPath) as! AvatarCell
        if indexPath.item == dataArry.count {
            cell.iconView.image = UIImage(named: "mine_more")
            cell.statusView.isHidden = true
        }else{
            let model : HeadImageModel = self.dataArry.safeObject(index: indexPath.item) ?? HeadImageModel()
            cell.iconView.kf.setImage(with: URL(string: model.Headurl), placeholder: PlaceholderImg())
//            cell.iconView.image = UIImage(named: "")
//            cell.iconView.backgroundColor = .blue
            if indexPath.item == selectedIndex {
                cell.statusView.isHidden = false
            }else{
                cell.statusView.isHidden = true
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if indexPath.item == dataArry.count {
            /// 直接回调
            if self.moreClick != nil {
                self.moreClick!()
            }
            self.dismiss()

        }else{
            selectedIndex = indexPath.item
            collectionView.reloadData()
        }
    }
    
}


class AvatarCell: UICollectionViewCell {
    static let CELLID = "AvatarCell"
    lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.corner(cornerRadius: 25)
        return v
    }()
    lazy var statusView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "mine_select")
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconView)
        self.addSubview(statusView)
        iconView.frame = self.bounds
        statusView.frame = CGRect(x: iconView.maxX-16, y: iconView.maxY-16, width: 16, height: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
