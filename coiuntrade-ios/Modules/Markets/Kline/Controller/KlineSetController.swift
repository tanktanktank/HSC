//
//  KlineSetController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/5.
//

import UIKit

//TODO: 坦克定义的 枚举放这，，，有必要？待优化
enum KlineColorStyle {
    case NewColor
    case classical
    case CVD
}

class KlineSetController: UIViewController {

    @IBOutlet weak var vAbstract: UIView!
    
    @IBOutlet weak var vTheme: UIView! //风格、绿色
    @IBOutlet weak var vStyle: UIView! //风格、红色
    
    @IBOutlet weak var vCycle: UIView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var vFit: UIView!
    
    @IBOutlet weak var lblKlineStyle: UILabel! //k线 阳线样式
    
    @IBOutlet weak var floatTipLabel: UILabel!
    @IBOutlet weak var summarySlider: UISwitch!
    @IBOutlet weak var shockSlider: UISwitch!
    
    var identifier:String = ""
    var selectTag:Int = 0
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: 功能模块
        let tapFit = UITapGestureRecognizer()
        let tapMain = UITapGestureRecognizer()
        let tapCycle = UITapGestureRecognizer()
        let tapTheme = UITapGestureRecognizer()
        let tapStyle = UITapGestureRecognizer()
        let tapAbstract = UITapGestureRecognizer()
        
        self.vFit.addGestureRecognizer(tapFit)
        self.vMain.addGestureRecognizer(tapMain)
        self.vCycle.addGestureRecognizer(tapCycle)
        self.vTheme.addGestureRecognizer(tapTheme)
        self.vStyle.addGestureRecognizer(tapStyle)
        self.vAbstract.addGestureRecognizer(tapAbstract)
        
        let modules = [tapFit, tapMain, tapCycle,tapTheme, tapStyle, tapAbstract].map { $0! }
        let selectedModules = Observable.from(
            modules.map { view in view.rx.event.map {_ in view} }
        ).merge()
        selectedModules
            .flatMap { value  ->  Observable<Any> in
                self.selectTag = value.view!.tag - 100
                switch value.view?.tag {
                case 100:
                    //MARK: K线十字线摘要
//                    let controller = getViewController(name: "KlineTargetStoryboard", identifier: "KlineAbstractController") as! KlineAbstractController
//                    self.navigationController?.pushViewController(controller, animated: true)
//                    return controller.dataSubject.catch { error in
//                        return Observable.empty()
//                    }
                    self.identifier = "KlineAbstractController"
                case 101:
                    //MARK: 风格设置
                    self.identifier = "KlineColorController"
                case 102:
                    //MARK: K线阳线样式
                    let klineView = KlineStyleView.loadKlineStyleView(view: self.view.window!)
                    return klineView.dataSubject.catch { _ in
                        return Observable.empty()
                    }
                case 103:
                    //MARK: 时间周期
                    self.identifier = "KlineWeekDayController"
                case 104:
                    //MARK: 双击主图效果
                    self.identifier = "KlineTapMainController"
                case 105:
                    //MARK: 双击副图效果
                    self.identifier = "KlineTapFitController"
                default:
                    print("this")
                }
                if is_Blank(ref: self.identifier) == false{
                
                    self.navigationController?.pushViewController(getViewController(name: "KlineTargetStoryboard", identifier: self.identifier), animated: true)
                }
                return Observable.just(true)
            }
            .subscribe(onNext: {value in
                if self.selectTag == 2 {
                    self.lblKlineStyle.text = value as! String == "StyleReality" ? "实心" : "空心"
                }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





//class KlineSetController: BaseViewController {
//
//    @IBOutlet weak var vAbstract: UIView!
//
//    @IBOutlet weak var vTheme: UIView! //风格、绿色
//    @IBOutlet weak var vStyle: UIView! //风格、红色
//
//    @IBOutlet weak var vCycle: UIView!
//    @IBOutlet weak var vMain: UIView!
//    @IBOutlet weak var vFit: UIView!
//
//    @IBOutlet weak var lblKlineStyle: UILabel! //k线 阳线样式
//
//    @IBOutlet weak var floatTipLabel: UILabel!
//    @IBOutlet weak var summarySlider: UISwitch!
//    @IBOutlet weak var shockSlider: UISwitch!
//
//    var identifier:String = ""
//    var selectTag:Int = 0
//    private var disposeBag = DisposeBag()
//    lazy var tableview : BaseTableView = {
//        let tableview = BaseTableView()
//
//        tableview.register(KlineSetCell.self, forCellReuseIdentifier: "KlineSetCell")
//        tableview.backgroundColor = .hexColor("1E1E1E")
//        tableview.isScrollEnabled = false
//        tableview.rowHeight = 56
//        tableview.delegate = self
//        tableview.dataSource = self
//        tableview.separatorStyle = .none
//        return tableview
//    }()
//
//    let titleArray = ["K线十字线摘要","轻点显示K线摘要","震动","风格设置","K线阳线样式","时间周期","双击主图效果","双击副图效果"]
//
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        self.titleLab.text = "指标设置".localized()
////
////
////        loadDefaultIndex()
////        setupEvent()
////
////        //MARK: 功能模块
////        let tapFit = UITapGestureRecognizer()
////        let tapMain = UITapGestureRecognizer()
////        let tapCycle = UITapGestureRecognizer()
////        let tapTheme = UITapGestureRecognizer()
////        let tapStyle = UITapGestureRecognizer()
////        let tapAbstract = UITapGestureRecognizer()
////
////        self.vFit.addGestureRecognizer(tapFit)
////        self.vMain.addGestureRecognizer(tapMain)
////        self.vCycle.addGestureRecognizer(tapCycle)
////        self.vTheme.addGestureRecognizer(tapTheme)
////        self.vStyle.addGestureRecognizer(tapStyle)
////        self.vAbstract.addGestureRecognizer(tapAbstract)
////
////        let modules = [tapFit, tapMain, tapCycle,tapTheme, tapStyle, tapAbstract].map { $0! }
////        let selectedModules = Observable.from(
////            modules.map { view in view.rx.event.map {_ in view} }
////        ).merge()
////        selectedModules
////            .flatMap { value  ->  Observable<Any> in
////                self.selectTag = value.view!.tag - 100
////                switch value.view?.tag {
////                case 100:
////                    //MARK: K线十字线摘要
//////                    let controller = getViewController(name: "KlineTargetStoryboard", identifier: "KlineAbstractController") as! KlineAbstractController
//////                    self.navigationController?.pushViewController(controller, animated: true)
//////                    return controller.dataSubject.catch { error in
//////                        return Observable.empty()
//////                    }
////                    self.identifier = "KlineAbstractController"
////                case 101:
////                    //MARK: 风格设置
////                    self.identifier = "KlineColorController"
////                case 102:
////                    //MARK: K线阳线样式
////                    let klineView = KlineStyleView.loadKlineStyleView(view: self.view.window!)
////                    return klineView.dataSubject.catch { _ in
////                        return Observable.empty()
////                    }
////                case 103:
////                    //MARK: 时间周期
////                    self.identifier = "KlineWeekDayController"
////                case 104:
////                    //MARK: 双击主图效果
////                    self.identifier = "KlineTapMainController"
////                case 105:
////                    //MARK: 双击副图效果
////                    self.identifier = "KlineTapFitController"
////                default:
////                    print("this")
////                }
////                if is_Blank(ref: self.identifier) == false{
////
////                    self.navigationController?.pushViewController(getViewController(name: "KlineTargetStoryboard", identifier: self.identifier), animated: true)
////                }
////                return Observable.just(true)
////            }
////            .subscribe(onNext: {value in
////                if self.selectTag == 2 {
////                    self.lblKlineStyle.text = value as! String == "StyleReality" ? "实心" : "空心"
////                }
////        }).disposed(by: disposeBag)
////    }
//
////    @IBAction func clickBack(_ sender: Any) {
////        self.navigationController?.popViewController(animated: true)
////    }
////
////    func setupEvent(){
////
////        summarySlider.rx.isOn.asObservable()
////            .subscribe(onNext: {
////
////                let defaults = UserDefaults.standard
////                defaults.set(($0) ? "1":"0", forKey: "KLineSetLighterKey")
////                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KLineSetLighterNoti"), object: nil)
////            })
////            .disposed(by: disposeBag)
////
////        shockSlider.rx.isOn.asObservable()
////            .subscribe(onNext: {
////
////                let defaults = UserDefaults.standard
////                defaults.set(($0) ? "1":"0", forKey: "KLineSetShockKey")
////                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KLineSetShockNoti"), object: nil)
////            })
////            .disposed(by: disposeBag)
////    }
////
////    func loadDefaultIndex(){
////
////        let defaults = UserDefaults.standard
////        let lighter = defaults.string(forKey: "KLineSetLighterKey")
////        if(lighter != nil){
////
////            summarySlider.isOn = (lighter == "1") ? true : false
////        }else{
////            summarySlider.isOn = true
////        }
////
////        let shock = defaults.string(forKey: "KLineSetShockKey")
////        if(shock != nil){
////
////            shockSlider.isOn = (shock == "1") ? true : false
////        }else{
////            shockSlider.isOn = true
////        }
////    }
//}
//
//
//extension KlineSetController {
//
//    func setUI(){
//
//        self.titleLab.text = "指标设置".localized()
//        titleLab.textColor = .hexColor("ffffff")
//
//        self.view.addSubview(tableview)
//        tableview.snp.makeConstraints { make in
//            make.left.equalTo(12)
//            make.right.equalTo(-12)
//            make.bottom.equalToSuperview()
//            make.top.equalTo(titleLab.snp.bottom).offset(20)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUI()
//    }
//
//}
//
//extension KlineSetController : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        titleArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "KlineSetCell") as! KlineSetCell
//        let title = titleArray[indexPath.row]
//        cell.title = title
//
//        if indexPath.row == 0{
//
//            cell.value = "悬浮窗"
//        }else if indexPath.row == 1 {
//
//            let defaults = UserDefaults.standard
//            let lighter = defaults.string(forKey: "KLineSetLighterKey")
//
//            if(lighter != nil){
//
//                if let lighter = lighter , lighter == "1" {
//
//                    cell.isSelect = true
//                }else{
//                    cell.isSelect = false
//                }
//            }else{
//                cell.isSelect = false
//            }
//
//        }else if indexPath.row == 2 {
//
//            let defaults = UserDefaults.standard
//            let shock = defaults.string(forKey: "KLineSetShockKey")
//            if(shock != nil){
//
//                if let shock = shock , shock == "1" {
//
//                    cell.isSelect = true
//                }else{
//                    cell.isSelect = false
//                }
//            }else{
//                cell.isSelect = true
//            }
//
//        }else if indexPath.row == 3{
//
//            cell.style = .CVD
//        }else if indexPath.row == 4{
//            cell.value = "实心"
//        }
//
//
//        cell.switchClick = {
//
//            if indexPath.row == 1 {
//
//                let defaults = UserDefaults.standard
//                defaults.set((cell.switchBtn.isOn) ? "1":"0", forKey: "KLineSetLighterKey")
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KLineSetLighterNoti"), object: nil)
//            }else if indexPath.row == 2{
//
//                let defaults = UserDefaults.standard
//                defaults.set((cell.switchBtn.isOn) ? "1":"0", forKey: "KLineSetShockKey")
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KLineSetShockNoti"), object: nil)
//            }
//        }
//
////        let array = dataArray[indexPath.section] as Array
////        cell.text = array[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.addSectionCorner(at: indexPath, radius: 4)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//        if indexPath.row == 0{
//
////             self.identifier = "KlineAbstractController"
////            self.navigationController?.pushViewController(getViewController(name: "KlineTargetStoryboard", identifier: self.identifier), animated: true)
//            self.navigationController?.pushViewController(KlineAbstractController(), animated: true)
//
//        }else if indexPath.row == 3{
//
//            self.navigationController?.pushViewController(KlineColorController(), animated: true)
//        }else if indexPath.row == 4{
//
//            let klineView = KlineStyleView.loadKlineStyleView(view: self.view.window!)
//
//            klineView.dataSubject.subscribe ({ row in
//
//                print("\(row)")
//            }).disposed(by: disposeBag)
//
//            return
//        }else if indexPath.row == 5{
//            self.navigationController?.pushViewController(KlineWeekDayController(), animated: true)
//
////           self.identifier = "KlineWeekDayController"
////            self.navigationController?.pushViewController(getViewController(name: "KlineTargetStoryboard", identifier: self.identifier), animated: true)
//        }else if indexPath.row == 6{
//
//            self.navigationController?.pushViewController(KlineTapMainController(), animated: true)
//
////            self.identifier = "KlineTapMainController"
////            self.navigationController?.pushViewController(getViewController(name: "KlineTargetStoryboard", identifier: self.identifier), animated: true)
//        }else if indexPath.row == 7{
//
//            self.navigationController?.pushViewController(KlineTapFitController(), animated: true)
//
////            self.identifier = "KlineTapFitController"
////            self.navigationController?.pushViewController(getViewController(name: "KlineTargetStoryboard", identifier: self.identifier), animated: true)
//        }
//    }
//}
//
//
//class KlineSetCell : BaseTableViewCell{
//
//    let disposeBag = DisposeBag()
//    var switchClick : NormalBlock?
//    //用于显示颜色配置
//    var style : KlineColorStyle = .NewColor {
//
//        didSet{
//            RightcolorView.isHidden = false
//            LeftcolorView.isHidden = false
//
//            switch style {
//            case .NewColor:
//                LeftcolorView.backgroundColor = .hexColor("02C078")
//                RightcolorView.backgroundColor = .hexColor("F03851")
//
//            case .classical:
//
//                LeftcolorView.backgroundColor = .hexColor("7FA531")
//                RightcolorView.backgroundColor = .hexColor("D22D6F")
//
//            case .CVD:
//
//                LeftcolorView.backgroundColor = .hexColor("4BA2F2")
//                RightcolorView.backgroundColor = .hexColor("D07F3E")
//            }
//        }
//    }
//
//    var title : String? {
//
//        didSet{
//
//            titleLabel.text = title
//        }
//    }
//    //用于付值 右边文字
//    var value : String? {
//
//        didSet{
//
//            valueLabel.text = value
//        }
//    }
//
//    //用于付值 UISwitch
//    var isSelect : Bool = false {
//
//        didSet{
//            arrowImgview.isHidden = true
//            switchBtn.isHidden = false
//            switchBtn.isOn = isSelect
//        }
//    }
//
//    let switchBtn = UISwitch()
//
//    private let titleLabel : UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .hexColor("FFFFFF")
//        titleLabel.font = FONTDIN(size: 14)
//        return titleLabel
//    }()
//    private let valueLabel : UILabel = {
//        let valueLabel = UILabel()
//
//        valueLabel.textColor = .hexColor("989898")
//        valueLabel.font = FONTR(size: 12)
//        return valueLabel
//    }()
//    let arrowImgview = UIImageView(image: UIImage(named: "cellright"))
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        setUI()
//    }
//
//    let LeftcolorView = UIView()
//    let RightcolorView = UIView()
//
//    func setUI(){
//
//        self.contentView.addSubview(bgView)
//        self.contentView.backgroundColor = .hexColor("2D2D2D")
//        bgView.snp.makeConstraints { make in
//
//            make.left.right.top.bottom.equalToSuperview()
//        }
//
//        bgView.addSubview(arrowImgview)
//        arrowImgview.snp.makeConstraints { make in
//
//            make.right.equalTo(-12)
//            make.centerY.equalToSuperview()
//        }
//
//        bgView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//
//            make.left.equalTo(12)
//            make.centerY.equalToSuperview()
//        }
//
//        bgView.addSubview(valueLabel)
//        valueLabel.snp.makeConstraints { make in
//
//            make.right.equalTo(arrowImgview.snp.left).offset(-12)
//            make.centerY.equalToSuperview()
//        }
//
//        switchBtn.isHidden = true
//        bgView.addSubview(switchBtn)
//        switchBtn.snp.makeConstraints { make in
//
//            make.right.equalTo(-12)
//            make.centerY.equalToSuperview()
//        }
//        switchBtn.rx.isOn.subscribe ({[weak self] _ in
//
//            self?.switchClick?()
//        }).disposed(by: disposeBag)
//
//        RightcolorView.isHidden = true
//        LeftcolorView.isHidden = true
//
//        bgView.addSubview(RightcolorView)
//        RightcolorView.snp.makeConstraints { make in
//
//            make.right.equalTo(-31)
//            make.centerY.equalToSuperview()
//            make.height.width.equalTo(15)
//        }
//
//        bgView.addSubview(LeftcolorView)
//        LeftcolorView.snp.makeConstraints { make in
//
//            make.right.equalTo(RightcolorView.snp.left).offset(-8)
//            make.centerY.equalToSuperview()
//            make.height.width.equalTo(15)
//        }
//
//
//
//
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
