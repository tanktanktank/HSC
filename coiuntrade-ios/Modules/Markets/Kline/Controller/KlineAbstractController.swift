//
//  KlineAbstractController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class KlineAbstractController : BaseViewController {
    
    private var disposeBag = DisposeBag()
    var type = DisposeBag()
    
    let titles = ["时间","开","高","低","收","涨跌","振幅","量","额"]
    let values = ["04-07 11:24","10,875.25","10,882.20","10,882.23","10,882.23","+0.00(+0.00%)","0","233.54","1,000.00"]

    
    var selectIndex : IndexPath = [] {
        
        didSet{
            
            if oldValue == selectIndex || oldValue == [] {
                
                tableview.reloadRows(at: [selectIndex], with: .automatic)
                
                
            }else {
                
                tableview.reloadRows(at: [selectIndex , oldValue], with: .automatic)
            }
            
            if selectIndex.row == 0{
                
                verTableview.isHidden = false
                collectionView.isHidden = true
            }else{
                
                verTableview.isHidden = true
                collectionView.isHidden = false
            }
        }
    }
    
    lazy var tableview : BaseTableView = {
        let tableview = BaseTableView()
        tableview.tag = 1
        tableview.register(KlineSetSubCell.self, forCellReuseIdentifier: "KlineSetSubCell")
        tableview.backgroundColor = .hexColor("1E1E1E")
        tableview.isScrollEnabled = false
        tableview.rowHeight = 56
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        return tableview
    }()
    
    lazy var verTableview : BaseTableView = {
        let tableview = BaseTableView()
        tableview.tag = 2
        tableview.register(KlineAbstractCell.self, forCellReuseIdentifier: "KlineAbstractCell")
        tableview.backgroundColor = .hexColor("1E1E1E")
        tableview.isScrollEnabled = false
        tableview.rowHeight = 18
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.tableHeaderView = UIView()
        tableview.tableHeaderView?.height = 6.5
        return tableview
    }()
    
    private lazy var collectionView : BaseCollectionView = {
        let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .hexColor("1E1E1E")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(KlineAbstractCollectionCell.self, forCellWithReuseIdentifier: "KlineAbstractCollectionCell") //注册cell
        //设置流水布局 layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 24)/3 , height: 18)
        layout.minimumLineSpacing = 20  //行间距
        layout.minimumInteritemSpacing = 0  //列间距
        layout.scrollDirection = .horizontal //滚动方向
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.showsHorizontalScrollIndicator = false  //隐藏水平滚动条
        collectionView.showsVerticalScrollIndicator = false  //隐藏垂直滚动条
        return collectionView
    }()



    let topImageView = UIImageView(image: UIImage(named: "klinesetbg"))
    let rightImageView = UIImageView(image: UIImage(named: "klinesetbg"))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLab.text = "K线十字线摘要".localized()
        titleLab.textColor = .hexColor("ffffff")
        
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(titleLab.snp.bottom)
            make.height.equalTo(56*2)
        }
        
        let previewLabel = UILabel()
        previewLabel.font = FONTR(size: 11)
        previewLabel.text = "预览"
        previewLabel.textColor = .hexColor("989898")
        self.view.addSubview(previewLabel)
        previewLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(tableview.snp.bottom)
            make.height.equalTo(48)
        }
        
        let imageView = UIImageView(image: UIImage(named: "klinesetbg"))
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(previewLabel.snp.bottom)
            make.height.equalTo(321)
        }

        imageView.addSubview(verTableview)
        verTableview.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-7)
            make.top.equalTo(22)
            make.width.equalTo(97)
            make.height.equalTo(175)
        }
            
        imageView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }

        verTableview.isHidden = false
        collectionView.isHidden = true
        
    }
    
    func showSelect(select:Int) {
    }
    
}
extension KlineAbstractController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return titles.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KlineAbstractCollectionCell", for: indexPath) as!  KlineAbstractCollectionCell
        cell.title = titles[indexPath.row]
        cell.value = values[indexPath.row]
        return cell
    }
}
extension KlineAbstractController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1{
            
            return 2
        }else{
            return titles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "KlineSetSubCell") as! KlineSetSubCell
            if indexPath.row == 0{
                
                cell.title = "悬浮窗"
            }else if indexPath.row == 1 {
                
                cell.title = "顶部浮层"
            }
            cell.checkImgview.isHidden = indexPath == self.selectIndex
            return cell

        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "KlineAbstractCell") as! KlineAbstractCell
            cell.title = titles[indexPath.row]
            cell.value = values[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.tag == 1{

            cell.addSectionCorner(at: indexPath, radius: 4)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            self.selectIndex = indexPath
            
            
        }
    }
}


    
//    //0: 悬浮窗 1: 顶部浮层
//    let dataSubject = PublishSubject<Any>()
//    private var disposeBag = DisposeBag()
//
//    @IBOutlet weak var vTop: UIView!
//    @IBOutlet weak var vSuspended: UIView!
//
//    @IBOutlet weak var ivTop: UIImageView!
//    @IBOutlet weak var ivSuspended: UIImageView!
//
//    @IBOutlet weak var vShowTop: UIView!
//    @IBOutlet weak var vShowRight: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let tapTop = UITapGestureRecognizer()
//        let tapSuspended = UITapGestureRecognizer()
//
//        self.vTop.addGestureRecognizer(tapTop)
//        self.vSuspended.addGestureRecognizer(tapSuspended)
//
//        let modules = [tapTop, tapSuspended].map { $0! }
//        let selectedModules = Observable.from(
//            modules.map { view in view.rx.event.map {_ in view} }
//        ).merge()
//        selectedModules.subscribe(onNext: { [self]value in
//            showSelect(select: value.view!.tag - 100)
//        }).disposed(by: disposeBag)
//
//        let klinePosition = UserDefaults.standard.string(forKey: "KLineIndexPosition")
//        if(klinePosition == "0"){
//            showSelect(select: 0) //悬浮窗
//        }else{
//            showSelect(select: 1) //顶部浮层
//        }
//    }
//
//    func showSelect(select:Int) {
//        switch select {
//        case 1:
//            self.ivTop.isHidden = false
//            self.vShowTop.isHidden = false
//            self.vShowRight.isHidden = true
//            self.ivSuspended.isHidden = true
//            UserDefaults.standard.setValue("1", forKey: "KLineIndexPosition")
//            NotificationCenter.default.post(name: Notification.Name("KLineUpdatePositionNoti"), object: nil, userInfo: ["type":"1"])
//
//        default:
//            self.ivTop.isHidden = true
//            self.vShowTop.isHidden = true
//            self.vShowRight.isHidden = false
//            self.ivSuspended.isHidden = false
//            UserDefaults.standard.setValue("0", forKey: "KLineIndexPosition")
//            NotificationCenter.default.post(name: Notification.Name("KLineUpdatePositionNoti"), object: nil, userInfo: ["type":"0"])
//            break
//        }
//    }
//    @IBAction func backClick(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//}

private class KlineAbstractCell : BaseTableViewCell{
    
    //用于显示颜色配置
    
    var title : String? {
        
        didSet{
            
            titleLabel.text = title
        }
    }
    //用于付值 右边文字
    var value : String? {
        
        didSet{
            
            valueLabel.text = value
        }
    }
        
    private let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .hexColor("989898")
        titleLabel.font = FONTR(size: 9)
        return titleLabel
    }()
    private let valueLabel : UILabel = {
        let valueLabel = UILabel()
        
        valueLabel.textColor = .hexColor("EBEBEB")
        valueLabel.font = FONTDIN(size: 9)
        return valueLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    func setUI(){
        self.contentView.backgroundColor = .hexColor("1E1E1E")
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalTo(7)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            
            make.right.equalTo(-7)
            make.centerY.equalToSuperview()
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class KlineAbstractCollectionCell : UICollectionViewCell{
    
    //用于显示颜色配置
    
    var title : String? {
        
        didSet{
            
            titleLabel.text = title
        }
    }
    //用于付值 右边文字
    var value : String? {
        
        didSet{
            
            valueLabel.text = value
        }
    }
        
    private let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .hexColor("989898")
        titleLabel.font = FONTR(size: 9)
        return titleLabel
    }()
    private let valueLabel : UILabel = {
        let valueLabel = UILabel()
        
        valueLabel.textColor = .hexColor("EBEBEB")
        valueLabel.font = FONTDIN(size: 9)
        return valueLabel
    }()

    override  init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI(){
        self.contentView.backgroundColor = .hexColor("1E1E1E")
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalTo(7)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            
            make.left.equalTo(33)
            make.centerY.equalToSuperview()
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



