//
//  KlineTapMainController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class KlineTapMainController:  BaseViewController {
        
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
    
    lazy var tableview : BaseTableView = {
        let tableview = BaseTableView()
        
        tableview.register(KlineSetSubCell.self, forCellReuseIdentifier: "KlineSetSubCell")
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

        self.titleLab.text = "双击主图效果配置".localized()
        titleLab.textColor = .hexColor("ffffff")
        
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
        }

    }
    
    func showSelect(select:Int) {
    }
    
}

extension KlineTapMainController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KlineSetSubCell") as! KlineSetSubCell
        cell.title = title
        
        if indexPath.row == 0{
            
            cell.title = "切换主图指标"
        }else if indexPath.row == 1 {
            
            cell.title = "切换到横屏K线"
        }else if indexPath.row == 2 {
            
            cell.title = "无"
        }
        cell.checkImgview.isHidden =  selectIndex != indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.addSectionCorner(at: indexPath, radius: 4)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        self.selectIndex = indexPath
        
    }
}

class KlineSetSubCell : BaseTableViewCell{
    
    //用于显示颜色配置
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
    
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }

        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//    @IBOutlet weak var vMain: UIView!
//    @IBOutlet weak var vNone: UIView!
//    @IBOutlet weak var vHorizontal: UIView!
//
//    @IBOutlet weak var ivMain: UIImageView!
//    @IBOutlet weak var ivNone: UIImageView!
//    @IBOutlet weak var ivHhorizontal: UIImageView!
//
//    private var disposeBag = DisposeBag()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let tapNone = UITapGestureRecognizer()
//        let tapMain = UITapGestureRecognizer()
//        let tapHorizontal = UITapGestureRecognizer()
//
//        self.vMain.addGestureRecognizer(tapMain)
//        self.vNone.addGestureRecognizer(tapNone)
//        self.vHorizontal.addGestureRecognizer(tapHorizontal)
//
//        let modules = [tapNone, tapMain, tapHorizontal].map { $0! }
//        let selectedModules = Observable.from(
//            modules.map { view in view.rx.event.map {_ in view} }
//        ).merge()
//        selectedModules.subscribe(onNext: { [self]value in
//            showSelect(select: value.view!.tag - 100)
//        }).disposed(by: disposeBag)
//    }
//
//    func showSelect(select:Int) {
//        switch select {
//        case 1:
//            self.ivNone.isHidden = true
//            self.ivMain.isHidden = true
//            self.ivHhorizontal.isHidden = false
//        case 2:
//            self.ivNone.isHidden = false
//            self.ivMain.isHidden = true
//            self.ivHhorizontal.isHidden = true
//        default:
//            self.ivNone.isHidden = true
//            self.ivMain.isHidden = false
//            self.ivHhorizontal.isHidden = true
//            break
//        }
//    }
//
//    @IBAction func backClick(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//}
