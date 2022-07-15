//
//  UserCerResultVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/27.
//

import UIKit
import Alamofire

class UserCerResultVC: BaseViewController {

    private var disposeBag = DisposeBag()
    var statue = "0" //0审核中，1审核成功，2审核失败 ,, 4 高级认证界面
    var reson = ""
    var area = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        setupConstraints()
        setupEvent()
        updateShow()
    }
    
    
    func setupEvent(){
        
        confirmBtn.rx.tap
            .subscribe(onNext:{
                
                if(self.statue == "4"){
                    
                    return
                }
                
                if(self.statue == "2"){
                    let userIDChooseVC = UserCerIDVC()
                    userIDChooseVC.cerIDType = "IDTypeCard"
                    userIDChooseVC.area = self.area
                    userIDChooseVC.reAuth = true
                    self.navigationController?.pushViewController(userIDChooseVC, animated: true)
                    return
                }
                
                var targetVC : UIViewController?
                for controller in self.navigationController!.viewControllers {
                    if controller.isKind(of: UserCertificationVC.classForCoder()) {
                        targetVC = controller
                        break
                    }
                }
                if targetVC != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserCerResultVCUpdateNoti"), object: nil)
                    self.navigationController?.popToViewController(targetVC!, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    func updateShow(){
        
        if(statue == "4"){
            
            tipContent.isHidden = true
            tipName.text = "完成高级认证需要联系人工客服才可完成\r\n详细相关规则请通过客服获取"
            confirmBtn.setTitle("人工服务", for: .normal)
            tipName.snp.updateConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH - 44)
                make.height.equalTo(44)
                make.top.equalTo(tipImageV.snp.bottom).offset(30)
            }
            tipName.textAlignment = .center
            tipName.numberOfLines = 0
        }
        else if(statue == "0"){
            
            tipName.text = "审核中"
            tipContent.text = "请耐心等待审核，通常1-3个工作日完成"
        }else if(statue == "2"){
            
            tipName.text = "您的资料未审核通过"
            tipContent.text = self.reson
            confirmBtn.setTitle("重新认证", for: .normal)
            tipImageV.image = UIImage.init(named: "UserCerIDReasonFailer")
        }
    }
    
    func setupUI(){
        
        view.addSubview(tipImageV)
        view.addSubview(tipName)
        view.addSubview(tipContent)
        view.addSubview(confirmBtn)
    }
    
    func setupConstraints(){
        
        tipImageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
            make.topMargin.equalTo(105)
        }
        
        tipName.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.height.equalTo(22)
            make.top.equalTo(tipImageV.snp.bottom).offset(30) //  topMargin.equalTo(30)
        }
        
        tipContent.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.top.equalTo(tipName.snp.bottom).offset(12) //  topMargin.equalTo(30)
            make.height.equalTo(20)
        }
    }
    
    
    lazy var tipImageV: UIImageView = {
        
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "UserCerPass")
        return imageV
    }()

    lazy var tipName: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.textAlignment = .center
        lab.text = "验证已通过"
        return lab
    }()
    
    lazy var tipContent: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("989898")
        lab.textAlignment = .center
        lab.text = "恭喜您，完成高级认证，已获得更高的功能权限"
        return lab
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("我已知晓", for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)//UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("FCD283")
        btn.layer.cornerRadius = 4
        btn.frame = CGRect(x: 12, y: view.height - 47 - 83 - (is_iPhoneXSeries() ? 54 : 0), width: view.width-24, height: 47)
        return btn
    }()
}
