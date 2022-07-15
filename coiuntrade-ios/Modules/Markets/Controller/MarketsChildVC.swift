//
//  MarketsChildVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/31.
//

import UIKit
enum MarketsType : Int{
    ///自选
    case accountLike = 1
    ///
    case spot = 2
    ///
    case other = 3
}
class MarketsChildVC: BaseViewController {
    
    ///
    var currency : String = ""{
        didSet{
            self.viewModel.reqModel.currency = currency
        }
    }
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(MarketsChildCell.self, forCellReuseIdentifier:  MarketsChildCell.CELLID)
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    var isSort : Int = 0 //0:默认 1:上 2:下
    var selectSort : Int = 0 //0:Name 1:vol 2:price 3:change
    var selectIndex : Int = 0
    var viewModel = MarketsViewModel()
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initSubViewsConstraints()
        
    }
    
}
// MARK: - 事件点击
extension MarketsChildVC{
    
}

// MARK: - UI
extension MarketsChildVC{
    
    func setUI(){
        view.addSubview(self.tableView)
    }
    func initSubViewsConstraints(){
        self.tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
       
    }
}

//MARK: UITableViewDelegate,UITableViewDataSource
extension MarketsChildVC : UITableViewDelegate,UITableViewDataSource{
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MarketsChildCell = tableView.dequeueReusableCell(withIdentifier: MarketsChildCell.CELLID) as! MarketsChildCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - UIScrollViewDelegate
extension MarketsChildVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollClosure = self.scrollClosure else {
            return
        }
        scrollClosure(scrollView)
    }
    
}
//MARK: JXPagingViewListViewDelegate
extension MarketsChildVC : JXPagingViewListViewDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.scrollClosure = callback
    }

    
}
