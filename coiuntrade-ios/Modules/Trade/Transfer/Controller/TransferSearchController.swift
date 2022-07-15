//
//  TransferSearchController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/25.
//

import UIKit
import SectionIndexView

enum TransferType : Int{
    case send = 1
    case receive = 2
    case flowWater = 3
}

class TransferSearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHot: UILabel!
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var hotHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var tableSearch: UITableView!
    
    @IBOutlet weak var vNot: UIView!
    
    var type : TransferType = .send
    private var disposeBag = DisposeBag()
    var viewModel: TransferViewModel!
    var homeViewModel: HomeViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        viewModel = TransferViewModel()
        homeViewModel = HomeViewModel()
        
        self.heightLayout.constant = TOP_HEIGHT
        
        //MARK: 文本提示 -->翻译
        self.txfSearch.attributedPlaceholder = NSAttributedString.init(string:"Search", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.HexColor(0x989898)])
        
        print("选择的类型\(type)")
        
        //MARK: 注册cell
        self.collectionView.collectionViewLayout = layout
        self.collectionView?.register(UINib.init(nibName: "SearchCoinColl", bundle: nil), forCellWithReuseIdentifier: "SearchCoinColl")
        self.tableView?.register(UINib(nibName: "ShowCoinCell",bundle: nil), forCellReuseIdentifier: "ShowCoinCell")
        self.tableSearch?.register(UINib(nibName: "SearchShowCell",bundle: nil), forCellReuseIdentifier: "SearchShowCell")
        
        //MARK: 获取热门币种
        homeViewModel.requestHotSearch()
            .subscribe(onNext: { array in
                let value = self.homeViewModel.allHots.count
                self.collectionView.reloadData()
                if value > 0{
                    self.topLayout.constant = 30
                    self.lblHot.isHidden = false
                    if value.isMultiple(of: 3) {
                        self.hotHeightLayout.constant = 39.0 * CGFloat(value)/3.0
                    } else {
                        if CGFloat(value)/3.0 > 1
                        {
                            let num = value / 3 + 1
                            self.hotHeightLayout.constant = 39.0 * CGFloat(num)
                        } else{
                            self.hotHeightLayout.constant = 39.0
                        }
                    }
                    self.vNot.isHidden = true
                } else{
                    self.vNot.isHidden = false
                    self.lblHot.isHidden = true
                    self.topLayout.constant = 10
                }
            })
            .disposed(by: disposeBag)
    
        //MARK: 获取所有币种
        viewModel.requestAllCoin()
            .subscribe(onNext: { value in
                let items = self.viewModel.letters.compactMap { (title) -> SectionIndexViewItem? in
                    if title == "#"
                    {
                        let item = SectionIndexViewItemView.init()
                        item.image = UIImage(named: "searchstart")
                        item.selectedImage = UIImage(named: "startyes")
                        return item
                    } else{
                        let item = SectionIndexViewItemView.init()
                        item.title = title
                        item.titleColor = UIColor.white
                        item.titleSelectedColor = UIColor.hexColor(0xFCD283)
                        item.indicator = SectionIndexViewItemIndicator.init(title: title)
                        return item
                    }
                }
                self.tableView.sectionIndexView(items: items)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.txfSearch.rx.text.orEmpty.asObservable()
            .flatMap({ value -> Observable<Any> in
                //限制输入长度
                self.homeViewModel.search = self.txfSearch.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                if !is_Blank(ref:  self.homeViewModel.search){
                    return self.homeViewModel.requestSearchCoin().catch { error in
                        return Observable.empty()
                    }
                } else{
                    self.homeViewModel.searchs.removeAll()
                    return Observable.just(0)
                }
            })
            .subscribe(onNext: {
                print("您输入的是：\($0)")
                if self.homeViewModel.searchs.count > 0 {
                    self.tableView.isHidden = true
                    self.tableSearch.isHidden = false
                    self.tableSearch.reloadData()
                } else{
                    self.tableView.isHidden = false
                    self.tableSearch.isHidden = true
                }
                
            }).disposed(by: disposeBag)
        
    }
    //MARK: 热门
    lazy var layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: self.view.frame.size.width/3, height:39.0)
            return layout
        }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel.allHots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemCell: SearchCoinColl = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCoinColl", for: indexPath) as! SearchCoinColl
        itemCell.model = self.homeViewModel.allHots[indexPath.row]
        return itemCell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.homeViewModel.allHots[indexPath.row]
        if type == .send
        {
            let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSendController") as! TransferSendController
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if type == .receive
        {
            let vc = ReChargeViewController()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
            
//            let controller = getViewController(name: "TransferStoryboard", identifier: "TransferReceiveController") as! TransferReceiveController
//            controller.model = model
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if type == .flowWater
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK: 币种列表
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.letters.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lets = viewModel.letters[section]
        let modelArr = viewModel.alls[lets]
        return modelArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0
        {
            let cell: ShowCoinCell = self.tableView.dequeueReusableCell(withIdentifier: "ShowCoinCell") as! ShowCoinCell
            let lets = viewModel.letters[indexPath.section]
            let modelArr = viewModel.alls[lets]
            cell.model = modelArr?[indexPath.row]
            return cell
        } else{
            let cell: SearchShowCell = self.tableSearch.dequeueReusableCell(withIdentifier: "SearchShowCell") as! SearchShowCell
            cell.model = homeViewModel.searchs[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lets = viewModel.letters[indexPath.section]
        let models = viewModel.alls[lets]
        if type == .send
        {
            let controller = getViewController(name: "TransferStoryboard", identifier: "TransferSendController") as! TransferSendController
            controller.model = models?[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if type == .receive
        {
            let vc = ReChargeViewController()
            let model : CoinModel = models?.safeObject(index: indexPath.row) ?? CoinModel()
            
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
//            let controller = getViewController(name: "TransferStoryboard", identifier: "TransferReceiveController") as! TransferReceiveController
//            controller.model = models?[indexPath.row]
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if type == .flowWater
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
