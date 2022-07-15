//
//  HomeMessageDetailVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/6.
//

import UIKit

class HomeMessageDetailVC: BaseViewController {

    lazy var titleV : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 22)
        v.textColor = .hexColor("FFFFFF")
        v.numberOfLines = 0
        return v
    }()
    lazy var timeV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var contentV : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("FFFFFF")
        v.numberOfLines = 0
        return v
    }()
    lazy var joinBtn : ZQButton = {
        let v = ZQButton()
        v.setTitle("home_msg_list_Join".localized(), for: .normal)
        v.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        v.titleLabel?.font = FONTM(size: 12)
        v.addTarget(self, action: #selector(tapJoinBtn), for: .touchUpInside)
        return v
    }()
    let viewModel = HomeViewModel()
    
    private var disposeBag = DisposeBag()
    var model : MessageModel = MessageModel()
    var detailModel : MessageModel = MessageModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        getDataSource()
    }
    

}
// MARK: - 
extension HomeMessageDetailVC{
    func getDataSource(){
        self.viewModel.requestMessageDetail(id: self.model.id, type: self.model.type).subscribe { _result in
            self.detailModel = _result
            self.titleV.text = self.detailModel.little_title
            self.timeV.text = self.detailModel.create_time
            self.contentV.text = self.detailModel.content
            
        } onError: { Error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
    
    @objc func tapJoinBtn(){
        let vc = WebViewController()
        vc.urlStr = self.detailModel.url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - ui
extension HomeMessageDetailVC{
    func setUI(){
        view.addSubview(titleV)
        view.addSubview(timeV)
        view.addSubview(contentV)
        view.addSubview(joinBtn)
    }
    func initSubViewsConstraints(){
        titleV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
        timeV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(titleV.snp.bottom).offset(15)
        }
        contentV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(timeV.snp.bottom).offset(20)
        }
        joinBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(contentV.snp.bottom).offset(20)
        }
    }
}
