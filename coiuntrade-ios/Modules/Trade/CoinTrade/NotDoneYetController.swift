//
//  NotDoneYetController.swift
//  coiuntrade-ios
//
//  Created by WMT on 2022/6/27.
//

import UIKit
import SwiftUI

class NotDoneYetController: BaseViewController {
    
    typealias scrollCallback = ((_ scrollView : UIScrollView) -> Void)?
    var scrollClosure : scrollCallback = nil
    let contentLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLangage), name: SettingLanguageNotification, object: nil)

        self.view.backgroundColor = .hexColor("1E1E1E")
        
        self.view.addSubview(tradeTableView)
        tradeTableView.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        
        
        contentLabel.textColor = .hexColor("989898")
        contentLabel.font = FONTR(size: 16)
        contentLabel.text = "tv_tips".localized()
        contentLabel.textAlignment = .center
        self.view.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()

//            make.center.equalToSuperview()
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func changeLangage(notify : Notification){

        contentLabel.text = "tv_tips".localized()

    }

    
    //内容
    lazy var tradeTableView : BaseTableView = {
        let tableView = BaseTableView(frame: CGRect.zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .hexColor("1E1E1E")
        return tableView
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: JXPagingViewListViewDelegate
extension NotDoneYetController : JXPagingViewListViewDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return tradeTableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.scrollClosure = callback
    }

}

