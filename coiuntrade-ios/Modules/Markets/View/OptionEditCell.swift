//
//  OptionEditCell.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/27.
//

import UIKit
protocol OptionEditCellDelegate : NSObjectProtocol {
    ///拖拽
    func dragView(cell:OptionEditCell,longPressGes: UILongPressGestureRecognizer)
    ///点击置顶
    func clickTopBtn(cell:OptionEditCell)
}
class OptionEditCell: UITableViewCell {
    public weak var delegate: OptionEditCellDelegate? = nil
    ///选中状态
    lazy var statusBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "markets_status_nol"), for: .normal)
        btn.setImage(UIImage(named: "markets_status_sel"), for: .selected)
        btn.isUserInteractionEnabled = false
//        btn.addTarget(self, action: #selector(tapStatusBtn), for: .touchUpInside)
        return btn
    }()
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = SEMIBOLDFONT(size: 15)
        lab.text = "BTC"
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTM(size: 11)
        lab.text = "/USDT"
        return lab
    }()
    ///置顶
    lazy var topBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "markets_top_nol"), for: .normal)
        btn.addTarget(self, action: #selector(tapTopBtn), for: .touchUpInside)
        return btn
    }()
    ///拖动
    lazy var dragView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "markets_drag_nol")
        v.contentMode = .center
        v.isUserInteractionEnabled = true
        return v
    }()
    static let CELLID = "ConutListCell"
    
    var model : CoinModel = CoinModel(){
        didSet{
            nameLab.text = model.coin
            detailLab.text = "/\(model.currency)"
            statusBtn.isSelected = model.isSelected
        }
    }
    var rModel : RealmCoinModel = RealmCoinModel(){
        didSet{
            nameLab.text = rModel.coin
            detailLab.text = "/\(rModel.currency)"
            statusBtn.isSelected = rModel.isSelected
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
// MARK: - 交互
extension OptionEditCell{
    @objc func drapCell(longPressGes: UILongPressGestureRecognizer){
        self.delegate?.dragView(cell: self,longPressGes:longPressGes)
    }
    @objc func tapTopBtn(){
        self.delegate?.clickTopBtn(cell: self)
    }
//    @objc func tapStatusBtn(){
//
//        self.statusBtn.isSelected = !self.statusBtn.isSelected
//    }
}
// MARK: - UI
extension OptionEditCell{
    func setUI() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .hexColor("2D2D2D")
        
        contentView.addSubview(statusBtn)
        contentView.addSubview(nameLab)
        contentView.addSubview(detailLab)
        contentView.addSubview(topBtn)
        contentView.addSubview(dragView)
        
        //手势
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(drapCell))
        longPressGes.minimumPressDuration = 0.5
        dragView.addGestureRecognizer(longPressGes)
    }
    func initSubViewsConstraints() {
        statusBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(statusBtn.snp.right)
            make.centerY.equalToSuperview()
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalTo(nameLab.snp.right)
            make.centerY.equalToSuperview()
        }
        dragView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-2)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        topBtn.snp.makeConstraints { make in
            make.right.equalTo(dragView.snp.left).offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
}
