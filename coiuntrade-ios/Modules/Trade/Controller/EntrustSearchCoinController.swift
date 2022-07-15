//
//  EntrustSearchCoinController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/24.
//

import UIKit

class EntrustSearchCoinController: UIViewController {
    
    let dataSubject = PublishSubject<String>()
    var viewModel = TradeViewModel()
    private var disposeBag = DisposeBag()
   

    
    lazy var txfSearch: UITextField = {
        let  txfSearch = UITextField()
        
        return txfSearch
    }()
    lazy var tableView: UITableView = {
        
        let  tableView = UITableView()
        tableView.register(UINib(nibName: "SearchCoinCell",bundle: nil), forCellReuseIdentifier: "SearchCoinCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight  = 56
        tableView.backgroundColor = .hexColor("1E1E1E")
        return tableView

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

        //MARK: 注册cell
        
        self.getAllDatas()
        
        //MARK: 搜索输入
        txfSearch.rx.text.orEmpty.asObservable()
            .flatMap({ value -> Observable<Any> in

                self.viewModel.search = self.txfSearch.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                if !is_Blank(ref:  self.viewModel.search){
                    return self.viewModel.requestSearchCoin().catch { error in
                        return Observable.empty()
                    }
                } else{
                    self.getAllDatas()
                    self.viewModel.searchs.removeAll()
                    return Observable.just(0)
                }
            })
            .subscribe(onNext: {
                self.tableView.reloadData()
                print("您输入的是：\($0)") //不加这行会报错？
            })
            .disposed(by: disposeBag)
    }
    
    func getAllDatas(){
        //MARK: 请求数据
        viewModel.requestSearchList()
            .subscribe(onNext: { value in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func backClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension EntrustSearchCoinController{
    
    func setUI(){
        
        self.view.backgroundColor = .hexColor("1E1E1E")
        self.txfSearch.attributedPlaceholder = NSAttributedString.init(string:"Search", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.HexColor(0x989898)])
        self.txfSearch.font = FONTR(size: 12)
        self.txfSearch.textColor = .white
        
        let cancelBtn = UIButton()
        cancelBtn.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        cancelBtn.setTitle("common_cancel".localized(), for: .normal)
        cancelBtn.setTitleColor(.hexColor("FCD283"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        cancelBtn.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(SafeAreaTop+25)
            make.width.greaterThanOrEqualTo(60)
            make.width.lessThanOrEqualTo(70)
        }

        let searchBgView = UIView()
        searchBgView.corner(cornerRadius: 15)
        searchBgView.backgroundColor = .hexColor("2D2D2D")
        self.view.addSubview(searchBgView)
        searchBgView.snp.makeConstraints { make in
            
            make.left.equalTo(12)
            make.right.equalTo(cancelBtn.snp.left)
            make.centerY.equalTo(cancelBtn)
            make.height.equalTo(30)
        }
        
        let searchImg = UIImageView(image: UIImage(named: "search-icon"))
        searchBgView.addSubview(searchImg)
        searchImg.snp.makeConstraints { make in
            
            make.right.equalTo(-10)
            make.height.width.equalTo(13)
            make.centerY.equalToSuperview()
        }

        searchBgView.addSubview(self.txfSearch)
        self.txfSearch.snp.makeConstraints { make in
            
            make.left.equalTo(LR_Margin)
            make.right.equalTo(searchImg.snp.left).offset(-10)
            make.centerY.top.bottom.equalToSuperview()
        }

        let titleLabel = UILabel()
        self.view.addSubview(titleLabel)

        titleLabel.text = "tv_coin_pair".localized()
        titleLabel.textColor = .hexColor("989898")
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.snp.makeConstraints { make in
            
            make.left.equalTo(12)
            make.top.equalTo(searchBgView.snp.bottom).offset(10)
            make.height.equalTo(17)
        }
        
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }

    }
}


extension EntrustSearchCoinController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchs.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.dataSubject.onNext("")
        } else{
            self.dataSubject.onNext(self.viewModel.searchs[indexPath.row].coin+"/"+self.viewModel.searchs[indexPath.row].currency)
        }
        self.dataSubject.onCompleted()
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchCoinCell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCoinCell") as! SearchCoinCell
        cell.model = self.viewModel.searchs[indexPath.row]
        return cell
    }

}
