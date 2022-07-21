//
//  KlineWeekDayController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit
//import RxSwift


class KlineWeekDayController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var lblSelect: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnRest: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
//    var viewModel: KlineSetViewModel!
    private var disposeBag = DisposeBag()
    lazy var viewModel: KlineSetViewModel = {
       let viewModel = KlineSetViewModel()
       return viewModel
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel = KlineSetViewModel()

        self.collectionView.collectionViewLayout = layout
        self.collectionView?.register(UINib.init(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        
        //MARK: 获取列表
        viewModel.requestWeekDayList(isReset: false)
            .subscribe(onNext: { value in
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        //MARK: 重置
        self.btnRest.rx.tap
            .subscribe(onNext: {value in
                self.viewModel.requestWeekDayList(isReset: true)
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        self.confirmBtn.rx.tap
            .subscribe(onNext: {value in

                let temSelects = self.viewModel.selects
                if(temSelects.count > 4){
                    var localSelStr = ""
                    var index = 1
                    for temSel in temSelects{
                        index += 1
                        localSelStr.append(temSel)
                        if(index <= temSelects.count){
                            localSelStr.append(",")
                        }
                    }
                    UserDefaults.standard.setValue(localSelStr, forKey: "KLineLocalTimeKey")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KLineLocalTimeNoti"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    lazy var layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (self.view.frame.size.width - 12)/3, height: 39)
            return layout
        }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.weeks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemCell: WeekDayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
        itemCell.model = self.viewModel.weeks[indexPath.row]
        return itemCell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.viewModel.weeks[indexPath.row]
        if model.isSelect == true {
            for week in self.viewModel.weeks {
                if week.time == model.time{
                    week.isSelect = false
                }
            }
            if let index = self.viewModel.selects.firstIndex(of: model.time) {
                self.viewModel.selects.remove(at: index)
            }
            
        } else {
            print(self.viewModel.selects)
            if self.viewModel.selects.count >= 5 {
                print("已经5个了")
            } else{
                self.viewModel.selects.append(model.time)
                for week in self.viewModel.weeks {
                    if week.time == model.time{
                        week.isSelect = true
                    }
                }
            }
        }
        
        self.lblSelect.text = String(self.viewModel.selects.count)
        self.collectionView.reloadData()
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}





//class KlineWeekDayController: BaseViewController{
//
//
//    private lazy var collectionView : BaseCollectionView = {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0 , right: 6)
//        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 12)/3, height: 39)
//
//       let collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//       collectionView.backgroundColor = .hexColor("1E1E1E")
//       collectionView.dataSource = self
//       collectionView.delegate = self
////       collectionView.register(WeekDayCell.self, forCellWithReuseIdentifier: "WeekDayCell") //注册cell
//        collectionView.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
//       //设置流水布局 layout
//       return collectionView
//       }()
//
//
//    let disposebag = DisposeBag()
//
//      let showSelectLabel  = UILabel()
////    @IBOutlet weak var collectionView: UICollectionView!
////
//    let btnRest: UIButton = {
//        let btnRest = UIButton()
//        btnRest.setTitle("重置", for: .normal)
//        btnRest.titleLabel?.font = FONTB(size: 16)
//        btnRest.setTitleColor( .hexColor("989898"), for: .normal)
//        return btnRest
//    }()
//     let confirmBtn: UIButton = {
//         let confirmBtn = UIButton()
//         confirmBtn.setTitle("确认", for: .normal)
//         confirmBtn.titleLabel?.font = FONTB(size: 16)
//         confirmBtn.setTitleColor( .hexColor("1E1E1E"), for: .normal)
//         confirmBtn.corner(cornerRadius: 4)
//         confirmBtn.backgroundColor = .hexColor("FCD283")
//         return confirmBtn
//     }()
//
//    private var disposeBag = DisposeBag()
//    lazy var viewModel: KlineSetViewModel = {
//       let viewModel = KlineSetViewModel()
//       return viewModel
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUI()
//        addEvent()
//        self.setCountLabel(selectCount: self.viewModel.selects.count )
//    }
//
//}
//
////
//extension KlineWeekDayController{
//
//    func setUI() {
//
//        self.titleLab.text = "K线十字线摘要".localized()
//        titleLab.textColor = .hexColor("ffffff")
//
//        self.view.addSubview(showSelectLabel)
////        showSelectLabel.text = "展示周期（5/5）"
//        showSelectLabel.textColor = .hexColor("989898")
//        showSelectLabel.font = FONTM(size: 14)
//        showSelectLabel.snp.makeConstraints { make in
//
//            make.left.equalTo(12)
//            make.top.equalTo(self.titleLab.snp.bottom).offset(30)
//            make.height.equalTo(20)
//        }
//
//
//        self.view.addSubview(confirmBtn)
//        self.view.addSubview(btnRest)
//
//        btnRest.snp.makeConstraints { make in
//
//            make.left.equalToSuperview()
//            make.height.equalTo(48)
//            make.width.equalTo(100)
//            make.bottom.equalTo(-SafeAreaBottom-2)
//        }
//
//        confirmBtn.snp.makeConstraints { make in
//
//            make.left.equalTo(btnRest.snp.right)
//            make.right.equalTo(-12)
//            make.height.bottom.equalTo(btnRest)
//        }
//
//
//
//        self.view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//
//            make.left.right.equalToSuperview()
//            make.top.equalTo(showSelectLabel.snp.bottom).offset(30)
//            make.bottom.equalTo(confirmBtn.snp.top).offset(-10)
//        }
//    }
//
//    func addEvent()  {
//
//        //MARK: 获取列表
//        viewModel.requestWeekDayList(isReset: false)
//            .subscribe(onNext: { [weak self] value in
//
//                self?.setCountLabel(selectCount: self?.viewModel.selects.count ?? 0)
//                self?.collectionView.reloadData()
//            })
//            .disposed(by: disposeBag)
//
////        //MARK: 重置
//        self.btnRest.rx.tap
//            .subscribe(onNext: {value in
//                self.viewModel.requestWeekDayList(isReset: true)
//                self.collectionView.reloadData()
//            }).disposed(by: disposeBag)
//
//        self.confirmBtn.rx.tap
//            .subscribe(onNext: {value in
//
//                let temSelects = self.viewModel.selects
//                if(temSelects.count > 4){
//                    var localSelStr = ""
//                    var index = 1
//                    for temSel in temSelects{
//                        index += 1
//                        localSelStr.append(temSel)
//                        if(index <= temSelects.count){
//                            localSelStr.append(",")
//                        }
//                    }
//                    UserDefaults.standard.setValue(localSelStr, forKey: "KLineLocalTimeKey")
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KLineLocalTimeNoti"), object: nil)
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }).disposed(by: disposeBag)
//    }
//
//    func setCountLabel(selectCount : Int){
//
//        let attributedString = NSMutableAttributedString.init()//初始化
//        attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: "展示周期（", font: 14, color: .hexColor("989898")))
//        attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: "\(selectCount)", font: 14, color: .hexColor("FCD283")))
//        attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: "/5）", font: 14, color: .hexColor("989898")))
//        showSelectLabel.attributedText = attributedString
//    }
//
//}
//extension KlineWeekDayController : UICollectionViewDelegate, UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel.weeks.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath) as! WeekDayCell
//        itemCell.model = self.viewModel.weeks[indexPath.row]
//        return itemCell;
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = self.viewModel.weeks[indexPath.row]
//        if model.isSelect == true {
//            for week in self.viewModel.weeks {
//                if week.time == model.time{
//                    week.isSelect = false
//                }
//            }
//            if let index = self.viewModel.selects.firstIndex(of: model.time) {
//                self.viewModel.selects.remove(at: index)
//            }
//
//        } else {
//            print(self.viewModel.selects)
//            if self.viewModel.selects.count >= 5 {
//                print("已经5个了")
//            } else{
//                self.viewModel.selects.append(model.time)
//                for week in self.viewModel.weeks {
//                    if week.time == model.time{
//                        week.isSelect = true
//                    }
//                }
//            }
//        }
//
//        self.setCountLabel(selectCount: self.viewModel.selects.count )
//
//
////        self.lblSelect.text = String(self.viewModel.selects.count)
//        self.collectionView.reloadData()
//    }
//
//}
