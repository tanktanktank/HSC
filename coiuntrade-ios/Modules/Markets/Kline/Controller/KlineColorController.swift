//
//  KlineColorController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class KlineColorController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    var type = DisposeBag()
    
    var selectIndex : IndexPath = [] {
        
        didSet{
            
            if oldValue == selectIndex || oldValue == [] {
                
                tableview.reloadRows(at: [selectIndex], with: .automatic)
            }else {
                
                tableview.reloadRows(at: [selectIndex , oldValue], with: .automatic)
            }
        }
    }
    //用于显示颜色配置
    var style : KlineColorStyle = .NewColor {
        
        didSet{

        }
    }
    
    lazy var tableview : BaseTableView = {
        let tableview = BaseTableView()
        
        tableview.register(KlineColorCell.self, forCellReuseIdentifier: "KlineColorCell")
        tableview.backgroundColor = .hexColor("1E1E1E")
        tableview.isScrollEnabled = false
        tableview.rowHeight = 86
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        return tableview
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLab.text = "颜色配置".localized()
        titleLab.textColor = .hexColor("ffffff")
        
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
        }

    }
    
    func showSelect(select:Int) {
//        switch select {
//        case 1:
//            self.ivNew.isHidden = true
//            self.ivCvd.isHidden = true
//            self.ivClassic.isHidden = false
//        case 2:
//            self.ivNew.isHidden = true
//            self.ivCvd.isHidden = false
//            self.ivClassic.isHidden = true
//        default:
//            self.ivCvd.isHidden = true
//            self.ivNew.isHidden = false
//            self.ivClassic.isHidden = true
//            break
//        }
    }
    
}

extension KlineColorController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KlineColorCell") as! KlineColorCell
        cell.title = title
        
        if indexPath.row == 0{
            
            cell.style = .NewColor
            cell.title = "新版色"
        }else if indexPath.row == 1 {
            
            cell.style = .classical
            cell.title = "经典色"
        }else {
            
            cell.style = .CVD
            cell.title = "色觉障碍(CVD)"
        }
        cell.checkImgview.isHidden =  selectIndex != indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.addSectionCorner(at: indexPath, radius: 4)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        self.selectIndex = indexPath
        
        if indexPath.row == 0{
            
//            cell.value = "悬浮窗"
        }else if indexPath.row == 1 {
            
//            cell.isSelect = false
        }else if indexPath.row == 2 {
            
//            cell.isSelect = false
        }
    }
}

private class KlineColorCell : BaseTableViewCell{
    
    
    //用于显示颜色配置
    var style : KlineColorStyle = .NewColor {
        
        didSet{
            rightcolorView.isHidden = false
            leftcolorView.isHidden = false

            switch style {
            case .NewColor:
                leftcolorView.backgroundColor = .hexColor("02C078")
                rightcolorView.backgroundColor = .hexColor("F03851")

            case .classical:
                
                leftcolorView.backgroundColor = .hexColor("7FA531")
                rightcolorView.backgroundColor = .hexColor("D22D6F")

            case .CVD:
                
                leftcolorView.backgroundColor = .hexColor("4BA2F2")
                rightcolorView.backgroundColor = .hexColor("D07F3E")
            }
        }
    }
    
    var title : String? {
        
        didSet{
            
            titleLabel.text = title
        }
    }
    
    
    
    private let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .hexColor("FFFFFF")
        titleLabel.font = FONTDIN(size: 14)
        return titleLabel
    }()
    let checkImgview = UIImageView(image: UIImage(named: "klineyes"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    let leftcolorView = UIView()
    let rightcolorView = UIView()

    func setUI(){
        
        self.contentView.addSubview(bgView)
        bgView.corner(cornerRadius: 4)
        self.contentView.backgroundColor = .hexColor("1E1E1E")
        bgView.snp.makeConstraints { make in

            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
            make.height.equalTo(56)

        }
        
        bgView.addSubview(checkImgview)
        checkImgview.snp.makeConstraints { make in
            
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(leftcolorView)
        leftcolorView.snp.makeConstraints { make in
            
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(15)
        }

        bgView.addSubview(rightcolorView)
        rightcolorView.snp.makeConstraints { make in
            
            make.left.equalTo(leftcolorView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(15)
        }

        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalTo(rightcolorView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
