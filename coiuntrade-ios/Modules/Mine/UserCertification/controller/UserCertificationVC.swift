//
//  UserCertificationVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/21.
//

import UIKit

class UserCertificationVC: BaseViewController {
    
    let cerView = UserCerView()
    let levelView = UserLevelView()
    let requireView = UserRequireV()
    let finishView = UserFinishView()
    let viewM = UserCerViewModel()
    var resCerModel = UserCerModel()

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewM.delegate = self
        setupUI()
        setupConstraints()
        setupEvent()
        reqData()
        NotificationCenter.default.addObserver(self, selector: #selector(updaNews), name: Notification.Name("UserCerResultVCUpdateNoti"), object: nil)
    }
    
    func setupEvent(){
        
        levelView.pass = { [weak self] update in
            
            if(update == 0){
                
                if((self?.resCerModel.idcardstate == "3" && self?.resCerModel.idcardlevel == "1") || (self?.resCerModel.idcardlevel == "2") || (self?.resCerModel.idcardlevel == "3")){
                    self?.requireView.requiredImageV.isHidden = false
                    self?.authContent(showLevel: 1)
                    self?.attestBtn.isHidden = true
                    self!.cerView.seeBtn.setTitle(self?.authTitle(level: "1", state: "3"), for: .normal)
                }
            }else if(update == 1){
                let curLevel = Int(self!.resCerModel.idcardlevel) ?? 0
                if(curLevel > 1 || (curLevel == 1 && self?.resCerModel.idcardstate == "3")){
                    
                    self?.authContent(showLevel: 2)
                    self!.cerView.seeBtn.setTitle(self?.authTitle(level: self!.resCerModel.idcardlevel, state: self!.resCerModel.idcardstate), for: .normal)
                }
                
                if(curLevel > 1){
                    if(curLevel > 2){
                        self?.requireView.requiredImageV.isHidden = false
                        self?.attestBtn.isHidden = true
                    }else{
                        if(self?.resCerModel.idcardstate == "3"){
                            self?.requireView.requiredImageV.isHidden = false
                            self?.attestBtn.isHidden = true
                        }else{
                            self?.requireView.requiredImageV.isHidden = true
                            self?.attestBtn.isHidden = false
                        }
                    }
                }else{
                    self?.requireView.requiredImageV.isHidden = true
                    self?.attestBtn.isHidden = false
                }
            }else{
                //高级
                let curLevel = Int(self!.resCerModel.idcardlevel) ?? 0
                if(curLevel > 2 || (curLevel == 2 && self?.resCerModel.idcardstate == "3")){
                    
                    self?.authContent(showLevel: 3)
                    if(self?.resCerModel.idcardlevel == "3"){
                        self?.requireView.requiredImageV.isHidden = false
                        self?.authContent(showLevel: 3)
                        self!.cerView.seeBtn.setTitle(self?.authTitle(level: self!.resCerModel.idcardlevel, state: self!.resCerModel.idcardstate), for: .normal)
                    }else{
                        self?.requireView.requiredImageV.isHidden = true
                        self?.attestBtn.isHidden = false
                    }
                }
            }
        }
        
        cerView.pass = { [weak self] in
            
            if(self?.resCerModel.userid == "0"){
                self?.showInfo(tip: "您的账户尚未认证")
            }else{
                

                if(self!.cerView.seeBtn.titleLabel!.text!.contains(find: "认证完成")){
                    self!.permissionView.show()
                }
                else if(self?.resCerModel.idcardstate == "1"){
                    
                    let userCerResultVC = UserCerResultVC()
                    self?.navigationController?.pushViewController(userCerResultVC, animated: true)
                }
                else if(self?.resCerModel.idcardstate == "2"){
                    let userCerResultVC = UserCerResultVC()
                    userCerResultVC.statue = "2"
                    userCerResultVC.reson = self?.resCerModel.reason ?? ""
                    userCerResultVC.area = self?.resCerModel.area ?? ""
                    self?.navigationController?.pushViewController(userCerResultVC, animated: true)
                }
            }
        }
        attestBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                if((self?.resCerModel.idcardstate == "3" && self?.resCerModel.idcardlevel == "1") || (self?.resCerModel.idcardlevel == "2" && self?.resCerModel.idcardstate != "3")){
                    let userIDReadyVC = UserCerIDVC()
                    userIDReadyVC.cerIDType = "IDTypeReady"
                    userIDReadyVC.cellType = "ReadyCell"
                    userIDReadyVC.cameraCardType = self!.resCerModel.idcardtype
                    self?.navigationController?.pushViewController(userIDReadyVC, animated: true)
                }
                else if((self?.resCerModel.idcardstate == "3" && self?.resCerModel.idcardlevel == "2") || self?.resCerModel.idcardlevel == "3"){
                    let userCerResultVC = UserCerResultVC()
                    userCerResultVC.statue = "4"
                    self?.navigationController?.pushViewController(userCerResultVC, animated: true)
                }
                else{
                    let userIDChooseVC = UserCerIDVC()
                    userIDChooseVC.cerIDType = "IDTypeCard"
                    userIDChooseVC.area = self?.resCerModel.area ?? ""
                    userIDChooseVC.reAuth = (self?.resCerModel.idcardstate == "2" ? true : false)
                    self?.navigationController?.pushViewController(userIDChooseVC, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    func reqData(){
        
        viewM.getUserCerInfo()
    }
    
    @objc func updaNews(){
        
        reqData()
    }
    
    func setupUI(){
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(cerView)
        scrollView.addSubview(levelView)
        scrollView.addSubview(requireView)
        scrollView.addSubview(finishView)
        scrollView.addSubview(attestBtn)
        scrollView.addSubview(permissionView)
        permissionView.addBG()
    }
    func setupConstraints(){
        
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        cerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 30)
        levelView.frame = CGRect(x: 0, y: cerView.maxY+30, width: view.width, height: 33)
        requireView.frame = CGRect(x: 0, y: levelView.maxY+30, width: view.width, height: 140) //20+40*3
        finishView.frame = CGRect(x: 0, y: requireView.maxY+30, width: view.width, height: 208) //20+20+56*3
        attestBtn.frame = CGRect(x: 12, y: finishView.maxY+93, width: view.width-24, height: 47)
    }
    
    func showInfo(tip: String){
        
        let fatherV = UIView()
        fatherV.frame = CGRect(x: (self.view.width - 157) * 0.5 , y: finishView.maxY + 19, width: 157, height: 30)
        fatherV.backgroundColor = .black
        fatherV.layer.cornerRadius = 15
        fatherV.clipsToBounds = true
        fatherV.alpha = 0.0
        
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "UserCerNoPass")
        imageV.frame = CGRect(x: 14, y: 8, width: 13.9, height: 13.9)
        
        let label = UILabel()
        label.text = tip
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.hexColor("ffffff")
        label.frame = CGRect(x: imageV.maxX + 6, y: 0, width: 120, height: fatherV.height)
        
        fatherV.addSubview(imageV)
        fatherV.addSubview(label)
        view.addSubview(fatherV)
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            fatherV.alpha = 1.0
        } completion: { Bool in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                fatherV.removeFromSuperview()
            }
        }

    }

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var attestBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("立即认证", for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)//UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("FCD283")
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var permissionView: UserCerPermissionView = {
        
        let permissionV = UserCerPermissionView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 349))
        return permissionV
    }()
}

extension UserCertificationVC : UserCerViewMDelegate{
    
    func getUserCerSuccess(model: UserCerModel) {
        
        self.resCerModel = model
        self.levelView.curLevel = Int(model.idcardlevel)!
        if(model.idcardlevel == "1" && model.idcardstate == "3"){
            self.levelView.curLevel = 2
        }
        else if(model.idcardlevel == "2" && model.idcardstate == "3"){
            self.levelView.curLevel = 3
        }
        
        if(model.userid == "0" || (model.idcardlevel == "1" && model.idcardstate != "3")){
         
            authContent(showLevel: 1)
            self.levelView.updateBtnStatue(index: 0)
        }else if( (model.idcardlevel == "2" && model.idcardstate != "3") || (model.idcardlevel == "1" && model.idcardstate == "3")){
            authContent(showLevel: 2)
            self.levelView.updateBtnStatue(index: 1)
        }else{
            authContent(showLevel: 3)
            self.levelView.updateBtnStatue(index: 2)
        }
        authPower()
        
        self.cerView.seeBtn.setTitle(authTitle(level: self.resCerModel.idcardlevel, state: self.resCerModel.idcardstate), for: .normal)
        if(model.userid == "0"){
            self.cerView.seeBtn.setImage(UIImage.init(named: "UserCerIDNoAuth"), for: .normal)
        }
        else if(model.idcardstate == "1"){
            self.cerView.seeBtn.setImage(UIImage.init(named: "UserCerIDAuthing"), for: .normal)
            self.attestBtn.backgroundColor = UIColor.hexColor("2d2d2d")
            self.attestBtn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
            self.attestBtn.isUserInteractionEnabled = false
        }
        else if(model.idcardstate == "2"){
            self.cerView.seeBtn.setImage(UIImage.init(named: "UserCerIDAuthFailer"), for: .normal)
            self.attestBtn.setTitle("继续认证", for: .normal)
        }else if(model.idcardstate == "3"){
            switch self.resCerModel.idcardlevel {
                case "1":
                    self.attestBtn.setTitle("继续认证", for: .normal)
                    break
                case "2":
                    break
                case "3":
                    break
                default: break
            }
        }
        if(self.resCerModel.idcardlevel == "3" || (model.idcardlevel == "2" && model.idcardstate == "3")){
            if(self.resCerModel.idcardstate == "3" && self.resCerModel.idcardlevel == "3"){
                self.attestBtn.isHidden = true
            }else{
                self.attestBtn.isHidden = false
                self.attestBtn.setTitle("再次认证", for: .normal)
            }
        }
    }
    func authContent(showLevel: Int){
        
        //showLevel 1,2,3 展示文案内容， 初中高
        if(showLevel == 1){
            let temV = view.viewWithTag(1024)
            let temV1 = view.viewWithTag(1025)
            let temV2 = view.viewWithTag(1026)
            temV?.isHidden = false
            temV1?.isHidden = false
            temV2?.isHidden = true
            let imageV = temV?.viewWithTag(512) as! UIImageView
            let label = temV?.viewWithTag(513) as! UILabel
            imageV.image = UIImage.init(named: "UserCerIDCard")
            label.text = "政府发行的证件类型"
            let imageV1 = temV1?.viewWithTag(512) as! UIImageView
            let label1 = temV1?.viewWithTag(513) as! UILabel
            imageV1.image = UIImage.init(named: "UserCerIDNumber")
            label1.text = "证件号码"
            
            let temFinishV = view.viewWithTag(2048)
            let temFinishV1 = view.viewWithTag(2049)
            let temFinishV2 = view.viewWithTag(2050)
            let finishLab = temFinishV?.viewWithTag(256) as! UILabel
            let finishLab1 = temFinishV1?.viewWithTag(256) as! UILabel
            let finishLab2 = temFinishV2?.viewWithTag(256) as! UILabel
            finishLab.text = "$50K 每日"
            finishLab1.text = "无限额"
            finishLab2.text = "$50K 每日"
            
        }else if(showLevel == 2){
        
            let temV = view.viewWithTag(1024)
            let temV1 = view.viewWithTag(1025)
            let temV2 = view.viewWithTag(1026)
            temV?.isHidden = false
            temV1?.isHidden = false
            temV2?.isHidden = false
            let imageV = temV?.viewWithTag(512) as! UIImageView
            let labe = temV?.viewWithTag(513) as! UILabel
            imageV.image = UIImage.init(named: "UserCerMineInfo")
            labe.text = "个人信息"
            let imageV1 = temV1?.viewWithTag(512) as! UIImageView
            let label = temV1?.viewWithTag(513) as! UILabel
            imageV1.image = UIImage.init(named: "UserCerIDCard")
            label.text = "政府发行的证件类型"
            
            let temFinishV = view.viewWithTag(2048)
            let temFinishV1 = view.viewWithTag(2049)
            let temFinishV2 = view.viewWithTag(2050)
            let finishLab = temFinishV?.viewWithTag(256) as! UILabel
            let finishLab1 = temFinishV1?.viewWithTag(256) as! UILabel
            let finishLab2 = temFinishV2?.viewWithTag(256) as! UILabel
            finishLab.text = "$100K 每日"
            finishLab1.text = "无限额"
            finishLab2.text = "$100K 每日"
        }else{
            let temV = view.viewWithTag(1024)
            let temV1 = view.viewWithTag(1025)
            let temV2 = view.viewWithTag(1026)
            temV?.isHidden = false
            temV1?.isHidden = true
            temV2?.isHidden = true
            let imageV = temV?.viewWithTag(512) as! UIImageView
            let label = temV?.viewWithTag(513) as! UILabel
            imageV.image = UIImage.init(named: "UserCerHight")
            label.text = "详细内容请联系人工客服"
            
            let temFinishV = view.viewWithTag(2048)
            let temFinishV1 = view.viewWithTag(2049)
            let temFinishV2 = view.viewWithTag(2050)
            let finishLab = temFinishV?.viewWithTag(256) as! UILabel
            let finishLab1 = temFinishV1?.viewWithTag(256) as! UILabel
            let finishLab2 = temFinishV2?.viewWithTag(256) as! UILabel
            finishLab.text = "$150K 每日"
            finishLab1.text = "无限额"
            finishLab2.text = "$150K 每日"
        }
    }
    func authPower(){
        
        if(self.resCerModel.idcardlevel == "1" || self.resCerModel.userid == "0" || (self.resCerModel.idcardlevel == "2" && self.resCerModel.idcardstate != "3")){
            permissionView.tabDataSources = [["title":"法币买入&卖出限额","content":"$50K 每日"],
                                             ["title":"数字货币充值","content":"无限额"],
                                             ["title":"数字货币提现限额","content":"$50K 每日"]]
            permissionView.curTableView.reloadData()
        }else{
            //TODO: 中高级判断
            permissionView.tabDataSources = [["title":"法币买入&卖出限额","content":"$100K 每日"],
                                             ["title":"数字货币充值","content":"无限额"],
                                             ["title":"数字货币提现限额","content":"$100K 每日"]]
            permissionView.curTableView.reloadData()
        }
    }
    func authTitle(level:String, state:String) -> String{
        
        var title = "查看当前功能"
        var curStatue = "未审核"
        var curLevel = "初级"
        switch level {
            case "1":
                curLevel = "初级"
                break
            case "2":
                curLevel = "中级"
                break
            case "3":
                curLevel = "高级"
                break
            default: break
        }
        switch state {
            case "1":
                curStatue = "审核中"
                self.cerView.seeBtn.setImage(UIImage.init(named: "UserCerIDAuthing"), for: .normal)
                break
            case "2":
                curStatue = "认证失败"
                self.cerView.seeBtn.setImage(UIImage.init(named: "UserCerIDAuthFailer"), for: .normal)
                break
            case "3":
                curStatue = "认证完成"
                self.cerView.seeBtn.setImage(UIImage.init(named: "UserCerSee"), for: .normal)
                break
            default: break
        }
        if(self.resCerModel.userid != "0"){
            title = curLevel + curStatue
        }
        return title
    }
}


class UserFinishView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    func setupUI(){
        
        addSubview(labelTip)
        let temV = createLineView(firstName: "法币买入&卖出限额", name: "$50K 每日")
        let temV1 = createLineView(firstName: "数字货币充值", name: "无限额")
        let temV2 = createLineView(firstName: "数字货币提现限额", name: "$50K 每日")
        temV.tag = 2048
        temV1.tag = 2049
        temV2.tag = 2050
        addSubview(temV)
        addSubview(temV1)
        addSubview(temV2)
    }
    func setupConstraints(){
        labelTip.frame = CGRect(x: 12, y: 0, width: 180, height: 20)
        let temV:UIView = self.viewWithTag(2048)!
        temV.frame = CGRect(x: temV.x , y: labelTip.maxY + 20, width: temV.width, height: temV.height)
        let temV1:UIView = self.viewWithTag(2049)!
        temV1.frame = CGRect(x: temV1.x, y: temV.maxY, width: temV1.width, height: temV1.height)
        let temV2:UIView = self.viewWithTag(2050)!
        temV2.frame = CGRect(x: temV2.x, y: temV1.maxY, width: temV2.width, height: temV2.height)
        
        temV.addCorner(conrners: [.topLeft,.topRight], radius: 4)
        temV2.addCorner(conrners: [.bottomLeft,.bottomRight], radius: 4)
    }
    func createLineView(firstName: String, name: String) -> UIView{
        
        let fatherV = UIView()
        fatherV.backgroundColor = UIColor.hexColor("2d2d2d")
        fatherV.frame = CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: 56)
        
        let firstLab = UILabel()
        firstLab.text = firstName
        firstLab.font = UIFont.systemFont(ofSize: 14)
        firstLab.textColor = UIColor.hexColor("989898")
        firstLab.frame = CGRect(x: 15, y: 0, width: 180, height: fatherV.height)

        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .right
        label.frame = CGRect(x: fatherV.width - 200 - 15, y: 0, width: 200, height: fatherV.height)
        label.tag = 256
        
        fatherV.addSubview(firstLab)
        fatherV.addSubview(label)
        return fatherV
    }
    
    lazy var labelTip: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = .white
        lab.text = "完成后获得以下权益"
        return lab
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class UserRequireV: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    func setupUI(){
        
        addSubview(labelTip)
        addSubview(requiredImageV)
        let temV = createLineView(imageStr: "UserCerMineInfo", name: "个人信息")
        let temV1 = createLineView(imageStr: "UserCerIDCard", name: "政府发行的身份证")
        let temV2 = createLineView(imageStr: "UserCerFace", name: "人脸识别认证")
        temV.tag = 1024
        temV1.tag = 1025
        temV2.tag = 1026
        addSubview(temV)
        addSubview(temV1)
        addSubview(temV2)
    }
    func setupConstraints(){
        labelTip.frame = CGRect(x: 12, y: 0, width: 32, height: 20)
        requiredImageV.frame = CGRect(x: labelTip.maxX + 6, y: 3, width: 13, height: 13)
        let temV:UIView = self.viewWithTag(1024)!
        temV.frame = CGRect(x: 0, y: labelTip.maxY + 20, width: SCREEN_WIDTH, height: 20)
        let temV1:UIView = self.viewWithTag(1025)!
        temV1.frame = CGRect(x: 0, y: temV.maxY + 20, width: SCREEN_WIDTH, height: 20)
        let temV2:UIView = self.viewWithTag(1026)!
        temV2.frame = CGRect(x: 0, y: temV1.maxY + 20, width: SCREEN_WIDTH, height: 20)
    }
    func createLineView(imageStr: String, name: String) -> UIView{
        
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 0, y: 0, width: self.width, height: 20)
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: imageStr)
        imageV.frame = CGRect(x: 12, y: 0, width: 20, height: 20)
        imageV.tag = 512
        
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.hexColor("989898")
        label.frame = CGRect(x: imageV.maxX + 12, y: 0, width: 180, height: 20)
        label.tag = 513
        fatherV.addSubview(imageV)
        fatherV.addSubview(label)
        fatherV.isHidden = true
        return fatherV
    }
    
    lazy var labelTip: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = .white
        lab.text = "要求"
        return lab
    }()
    
    lazy var requiredImageV: UIImageView = {
       
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "UserCerIFinished")
        imageV.isHidden = true
        return imageV
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias UserLevelViewPass = (Int)->()
class UserLevelView: UIView{
    
    private var disposeBag = DisposeBag()
    var curBtn = UIButton()
    var totalBttns = [UIButton]()
    var pass: UserLevelViewPass?
    var curLevel = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEvent()
    }
    override var frame: CGRect{
        didSet{
            setupConstraints()
        }
    }
    
    
    func updateBtnStatue(index: Int){
        
        let updateBtn = self.totalBttns[index]
        for temBtn in self.totalBttns{
            temBtn.isSelected = false
        }
        self.curBtn.backgroundColor = .clear
        updateBtn.isSelected = true
        updateBtn.backgroundColor = UIColor.hexColor("FCD283")
        self.curBtn = updateBtn
    }
    
    func setupEvent(){
        
        normalBtn.rx.tap.subscribe(onNext: {value in
            self.updateBtnStatue(index: 0)
            self.pass!(0)
        }).disposed(by: disposeBag)
        advancedBtn.rx.tap.subscribe(onNext: {value in
            
            if(self.curLevel > 1){
                self.updateBtnStatue(index: 1)
                self.pass!(1)
            }
        }).disposed(by: disposeBag)
        highBtn.rx.tap.subscribe(onNext: {value in
            if(self.curLevel > 2){
                self.updateBtnStatue(index: 2)
                self.pass!(2)
            }
        }).disposed(by: disposeBag)
    }
    
    func setupUI(){
        addSubview(normalBtn)
        addSubview(advancedBtn)
        addSubview(highBtn)
        totalBttns.append(normalBtn)
        totalBttns.append(advancedBtn)
        totalBttns.append(highBtn)
        normalBtn.isSelected = true
        normalBtn.backgroundColor = UIColor.hexColor("FCD283")
        curBtn = normalBtn
    }
    func setupConstraints(){

        let leftMargin = 12.0
        let margin = (self.width - 110*3 - leftMargin * 2) * 0.5
        normalBtn.frame = CGRect(x: leftMargin, y: 0, width: 110, height:self.height)
        advancedBtn.frame = CGRect(x: normalBtn.maxX + margin, y: 0, width: 110, height:self.height)
        highBtn.frame = CGRect(x: advancedBtn.maxX + margin, y: 0, width: 110, height:self.height)
    }
    
    lazy var normalBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("标准身份认证", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 17
        return btn
    }()
    lazy var advancedBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("进阶身份认证", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 17
        return btn
    }()
    lazy var highBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("高级身份认证", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 17
        return btn
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

typealias UserCerViewPassWeek = ()->()
class UserCerView: UIView{
    
    private var disposeBag = DisposeBag()
    var pass:UserCerViewPassWeek?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        seeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pass?()
            }).disposed(by: disposeBag)
    }
    override var frame: CGRect{
        didSet{
            setupConstraints()
        }
    }

    func setupUI(){
        
        addSubview(label)
        addSubview(seeBtn)
        addSubview(whyBtn)
        addSubview(safeBtn)
    }
    func setupConstraints(){
        label.frame = CGRect(x: 12, y: 0, width: 92, height: self.height)
        seeBtn.frame = CGRect(x: label.maxX + 6, y: (self.height - 26) * 0.5, width: 109, height: 26)
        safeBtn.frame = CGRect(x: self.width - 36, y: 0, width: 30, height: 30)
        whyBtn.frame = CGRect(x: self.safeBtn.x - 42, y: 0, width: 30, height: 30)
    }
    
    lazy var label: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 22) //UIFont(name: "PingFang SC-Bold", size: 22)
        lab.textColor = .white
        lab.text = "个人认证"
        return lab
    }()
    lazy var seeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("查看当前功能", for: .normal)
        btn.setTitleColor(UIColor.hexColor("ffffff"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.setImage(UIImage.init(named: "UserCerSee"), for: .normal)
        btn.backgroundColor = UIColor.hexColor("2d2d2d")
        btn.layer.cornerRadius = 13
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
        return btn
    }()
    lazy var whyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "UserCerQuestion"), for: .normal)
        return btn
    }()
    lazy var safeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "UserCerSafe"), for: .normal)
        return btn
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


