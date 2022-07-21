//
//  KlineTargetController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/5.
//

import UIKit

class KlineTargetController: UIViewController {
    
    @IBOutlet weak var vMA: UIView!
    @IBOutlet weak var vEMA: UIView!
    @IBOutlet weak var vBOLL: UIView!
    
    @IBOutlet weak var vMACD: UIView!
    @IBOutlet weak var vFitEMA: UIView!
    @IBOutlet weak var vFitBOLL: UIView!
    
    var identifier:String = ""
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapMa = UITapGestureRecognizer()
        let tapEma = UITapGestureRecognizer()
        let tapBoll = UITapGestureRecognizer()
        let tapMacd = UITapGestureRecognizer()
        let tapFitEma = UITapGestureRecognizer()
        let tapFitBoll = UITapGestureRecognizer()
        
        self.vMA.addGestureRecognizer(tapMa)
        self.vEMA.addGestureRecognizer(tapEma)
        self.vBOLL.addGestureRecognizer(tapBoll)
        self.vMACD.addGestureRecognizer(tapMacd)
        self.vFitEMA.addGestureRecognizer(tapFitEma)
        self.vFitBOLL.addGestureRecognizer(tapFitBoll)
        
        let modules = [tapMa, tapEma, tapBoll,tapMacd, tapFitEma, tapFitBoll].map { $0! }
        let selectedModules = Observable.from(
            modules.map { view in view.rx.event.map {_ in view} }
        ).merge()
        selectedModules
            .flatMap { value  ->  Observable<Any> in
                switch value.view?.tag {
                case 100:
                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexController") as! KlineIndexController
                    controller.klineType = .ma
                    self.navigationController?.pushViewController(controller, animated: true)
                case 101:
                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexController") as! KlineIndexController
                    controller.klineType = .ema
                    self.navigationController?.pushViewController(controller, animated: true)
                case 102:
                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexMaxController") as! KlineIndexMaxController
                    controller.showType = .boll
                    self.navigationController?.pushViewController(controller, animated: true)
                case 103:
                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexMaxController") as! KlineIndexMaxController
                    controller.showType = .macd
                    self.navigationController?.pushViewController(controller, animated: true)
                case 104:
                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexMaxController") as! KlineIndexMaxController
                    controller.showType = .kdj
                    self.navigationController?.pushViewController(controller, animated: true)
                case 105:
                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexController") as! KlineIndexController
                    controller.klineType = .rsi
                    self.navigationController?.pushViewController(controller, animated: true)
                default:
                    print("this")
                }
                
                return Observable.just(true)
            }
            .subscribe(onNext: {value in
            
        }).disposed(by: disposeBag)
    }
    

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}







//class KlineTargetController: BaseViewController {
//
//    let dataArray = [["MA","EMA","BOLL"],["MACD","EMA","BOLL"]]
////    : Array<Array>
//    lazy var tableview : BaseTableView = {
//        let tableview = BaseTableView()
//        tableview.register(KlineTargetCell.self, forCellReuseIdentifier: "KlineTargetCell")
//        tableview.backgroundColor = .hexColor("1E1E1E")
//        tableview.isScrollEnabled = false
//        tableview.rowHeight = 56
//        tableview.delegate = self
//        tableview.dataSource = self
//        tableview.separatorStyle = .none
//        return tableview
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUI()
////        let tapMa = UITapGestureRecognizer()
////        let tapEma = UITapGestureRecognizer()
////        let tapBoll = UITapGestureRecognizer()
////        let tapMacd = UITapGestureRecognizer()
////        let tapFitEma = UITapGestureRecognizer()
////        let tapFitBoll = UITapGestureRecognizer()
////
////        self.vMA.addGestureRecognizer(tapMa)
////        self.vEMA.addGestureRecognizer(tapEma)
////        self.vBOLL.addGestureRecognizer(tapBoll)
////        self.vMACD.addGestureRecognizer(tapMacd)
////        self.vFitEMA.addGestureRecognizer(tapFitEma)
////        self.vFitBOLL.addGestureRecognizer(tapFitBoll)
////
////        let modules = [tapMa, tapEma, tapBoll,tapMacd, tapFitEma, tapFitBoll].map { $0! }
////        let selectedModules = Observable.from(
////            modules.map { view in view.rx.event.map {_ in view} }
////        ).merge()
////        selectedModules
////            .flatMap { value  ->  Observable<Any> in
////                switch value.view?.tag {
////                case 100:
////                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexController") as! KlineIndexController
////                    controller.klineType = .ma
////                    self.navigationController?.pushViewController(controller, animated: true)
////                case 101:
////                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexController") as! KlineIndexController
////                    controller.klineType = .ema
////                    self.navigationController?.pushViewController(controller, animated: true)
////                case 102:
////                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexMaxController") as! KlineIndexMaxController
////                    controller.showType = .boll
////                    self.navigationController?.pushViewController(controller, animated: true)
////                case 103:
////                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexMaxController") as! KlineIndexMaxController
////                    controller.showType = .macd
////                    self.navigationController?.pushViewController(controller, animated: true)
////                case 104:
////                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexMaxController") as! KlineIndexMaxController
////                    controller.showType = .kdj
////                    self.navigationController?.pushViewController(controller, animated: true)
////                case 105:
////                    let controller = getViewController(name: "KlineIndexStoryboard", identifier: "KlineIndexController") as! KlineIndexController
////                    controller.klineType = .rsi
////                    self.navigationController?.pushViewController(controller, animated: true)
////                default:
////                    print("this")
////                }
////
////                return Observable.just(true)
////            }
////            .subscribe(onNext: {value in
////
////        }).disposed(by: disposeBag)
//    }
//}
//
//
//extension KlineTargetController {
//
//    func setUI(){
//
//        titleLab.text = "指标设置"
//        titleLab.textColor = .hexColor("ffffff")
//
//        self.view.addSubview(tableview)
//        tableview.snp.makeConstraints { make in
//            make.left.equalTo(12)
//            make.right.equalTo(-12)
//            make.bottom.equalToSuperview()
//            make.top.equalTo(titleLab.snp.bottom)
//        }
//    }
//}
//
//extension KlineTargetController : UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        dataArray.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        60
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let view = UIView()
//        let label = UILabel()
//        label.font = FONTR(size: 12)
//        label.textColor = .hexColor("989898")
//        label.text = section == 0 ? "主图":"副图"
//        view.addSubview(label)
//        label.snp.makeConstraints { make in
//
//            make.left.equalTo(12)
//            make.centerY.equalToSuperview()
//        }
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        let array = dataArray[section] as Array
//        return array.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "KlineTargetCell") as! KlineTargetCell
//        let array = dataArray[indexPath.section] as Array
//        cell.text = array[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.addSectionCorner(at: indexPath, radius: 4)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        print("dddd")
//    }
//}
//
//private class KlineTargetCell : BaseTableViewCell{
//
//    var text : String? {
//
//        didSet{
//
//            titleLabel.text = text
//        }
//    }
//
//    private let titleLabel = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        self.contentView.addSubview(bgView)
//        self.contentView.backgroundColor = .hexColor("2D2D2D")
//        bgView.snp.makeConstraints { make in
//
//            make.left.right.top.bottom.equalToSuperview()
//        }
//
//        let arrowImgview = UIImageView(image: UIImage(named: "cellright"))
//        bgView.addSubview(arrowImgview)
//        arrowImgview.snp.makeConstraints { make in
//
//            make.right.equalTo(-12)
//            make.centerY.equalToSuperview()
////            make.height.equalTo(12.4)
////            make.width.equalTo(6.8)
//        }
//        titleLabel.textColor = .hexColor("FFFFFF")
//        titleLabel.font = FONTDIN(size: 14)
//        bgView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//
//            make.left.equalTo(12)
//            make.centerY.equalToSuperview()
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
