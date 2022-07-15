//
//  TransferNetworkView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/25.
//

import UIKit

class TransferNetworkView: UIView,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var lblRemark: UILabel!
    
    let dataSubject = PublishSubject<Int>() //选择的数据
    var isSend: Bool = false
    private var disposeBag = DisposeBag()
    
    class func loadNetworkView(view:UIWindow,isSend:Bool) -> TransferNetworkView {
        let networkView = Bundle.main.loadNibNamed("TransferNetworkView", owner: nil, options: nil)?[0] as! TransferNetworkView
        networkView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        //MARK: 注册cell
        networkView.tableView?.register(UINib(nibName: "ShowNetworkCell",bundle: nil), forCellReuseIdentifier: "ShowNetworkCell")
        networkView.tableView?.register(UINib(nibName: "ChooseNetworkCell",bundle: nil), forCellReuseIdentifier: "ChooseNetworkCell")
        networkView.isSend = isSend
        networkView.tableView.reloadData()
        networkView.lblRemark.textAlignment = isSend ? .center:.left
        view.addSubview(networkView)
        
        //MARK: 取消
        networkView.btnCancel.rx.tap.subscribe(onNext: {
            networkView.removeFromSuperview()
        }).disposed(by: networkView.disposeBag)
        
        return networkView
    }
    //MARK: 热门
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isSend {
            let cell: ChooseNetworkCell = self.tableView.dequeueReusableCell(withIdentifier: "ChooseNetworkCell") as! ChooseNetworkCell
                return cell
        } else{
            let cell: ShowNetworkCell = self.tableView.dequeueReusableCell(withIdentifier: "ShowNetworkCell") as! ShowNetworkCell
                return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSubject.onNext(indexPath.row)
        self.dataSubject.onCompleted()
        self.removeFromSuperview()
    }
    
}
