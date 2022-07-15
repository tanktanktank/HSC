//
//  UserCerIDVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/22.
//

import UIKit

class UserCerIDVC: BaseViewController {
    
    var timeBtn: UIButton?
    var conuntryLab: UILabel?
    var countryTipLab: UILabel?
    var conuntryIcon: UIImageView?
    var rightImageView: UIImageView?
    var cerIDType = "IDTypeMine"//IDType
    var tabSources: [UserCerCardModel] = []
    var tabReadySources: [String] = []
    var cellType = "IDCell"
    var area = ""
    var countryIconPath = ""
    var countryText = ""
    var authType = Int(0)
    var countryId = ""
    var reAuth = false
    var cameraCardType = "1"
    var dataArr:Array<CountryModel> = Array()
    let viewM = UserCerViewModel()
    
    private var disposeBag = DisposeBag()
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())

    override func viewDidLoad() {
        super.viewDidLoad()

        viewM.delegate = self
        self.view.addSubview(idLabel)
        let countryView = createCountry()
        
        if(self.cerIDType == "IDTypeCard"){
        
            self.countryTipLab?.text = "选择证件签发国/地区"
            self.idLabel.text = "身份认证"
            self.confirmBtn.setTitle("tv_continue".localized(), for: .normal)
            setupTabSources()
            let tabY = createCardTipLab(beginY: countryView.maxY + 30)
            self.view.addSubview(self.curTableView)
            self.curTableView.frame = CGRect(x: 15, y: tabY + 12, width: SCREEN_WIDTH - 30, height: CGFloat(tabSources.count * 56 + (tabSources.count - 1) * 12))
            loadLocalCountrys()
        }else if(self.cerIDType == "IDTypeReady"){
            
            self.countryTipLab?.text = "您即将上传" + cardTypeName() + "。请确保："
            self.idLabel.text = "身份认证"
            self.countryTipLab?.textColor = .white
            let countryV = view.viewWithTag(1024)
            if((countryV) != nil){
                countryView.removeFromSuperview()
            }
            createRightCard()
            setupTabSources()
            idLabel.frame = CGRect(x: 12, y: 9, width: 92, height: 30)
            self.view.addSubview(self.curTableView)
            self.curTableView.frame = CGRect(x: 15, y: countryTipLab!.maxY + 12, width: SCREEN_WIDTH - 30, height: CGFloat(tabReadySources.count * 20 + (tabReadySources.count - 1) * 12))
            self.confirmBtn.setTitle("tv_continue".localized(), for: .normal)
            self.confirmBtn.frame = CGRect(x: 114, y: self.confirmBtn.y, width: SCREEN_WIDTH - 129, height: self.confirmBtn.height)
            createPreBtn()
            
        }else{
            let nameView = createCotent(name: "名字", tipName: "请输入名字")
            let nameLastView = createCotent(name: "姓氏", tipName: "请输入姓氏")
            let nameMiddleView = createCotent(name: "中间名", tipName: "请输入中间名")
            let timeView = createTimeCotent(name: "出生日期", tipName: "YYYY-MM-DD")
            let cardView = createCotent(name: "证件号", tipName: "请输入证件号")
            nameView.tag = 1025
            cardView.tag = 1026
            nameLastView.tag = 1027
            nameMiddleView.tag = 1028
            nameView.frame = CGRect(x: 15, y: countryView.maxY + 30, width: nameView.width, height: nameView.height)
            nameLastView.frame = CGRect(x: nameView.maxX + 25, y: countryView.maxY + 30, width: nameView.width, height: nameView.height)
            nameMiddleView.frame = CGRect(x: 15, y: nameLastView.maxY + 30, width: nameView.width, height: nameView.height)
            timeView.frame = CGRect(x: nameView.maxX + 25, y: nameLastView.maxY + 30, width: nameView.width, height: nameView.height)
            cardView.frame = CGRect(x: 15, y: nameMiddleView.maxY + 30, width: SCREEN_WIDTH - 30, height: nameView.height)
            
            if(self.area == "86"){
                
                nameLastView.isHidden = true
                nameMiddleView.isHidden = true
                timeView.isHidden = true
                cardView.frame = CGRect(x: 15, y: countryView.maxY + 30, width: SCREEN_WIDTH - 30, height: nameView.height)
                nameView.frame = CGRect(x: 15, y: cardView.maxY + 30, width: SCREEN_WIDTH - 30, height: nameView.height)
            }
            updateCountry()
        }
        
        self.view.addSubview(confirmBtn)
        setupEvent()
    }
    
    func updateCountry(){
        
        self.conuntryIcon?.kf.setImage(with: self.countryIconPath, placeholder: nil)
        self.conuntryLab?.text = self.countryText
        self.rightImageView?.isHidden = true
    }

    func setupTabSources(){
        
        if(cellType == "IDCell"){
            
            let userM = UserCerCardModel()
            userM.cardSel = true
            userM.cardType = "身份证"
            tabSources.append(userM)
            
            let userM1 = UserCerCardModel()
            userM1.cardSel = false
            userM1.cardType = "护照"
            tabSources.append(userM1)
            
            let userM2 = UserCerCardModel()
            userM2.cardSel = false
            userM2.cardType = "驾照"
            tabSources.append(userM2)
        }else{
            tabReadySources = ["这是您的官方未过期证件","这是原始文档,而非扫描件或副本","请取下卡夹或卡盖,避免反射或模糊","单张照片不得超过2M,照片格式仅限JPG、JPEG、PNG"]
        }
    }
    
    func cardTypeName() -> String{
        
        var name = "身份证"
        if(self.cameraCardType == "2"){
            name = "护照"
        }else if(self.cameraCardType == "3"){
            name = "驾照"
        }
        return name
    }
    
    func loadLocalCountrys(){
        
        guard let path = Bundle.main.path(forResource: "ad_country", ofType: "json") else { return }
        let localData = NSData.init(contentsOfFile: path)! as Data
        do {
            let jsonData = try JSON(data: localData)
            let model =  Country.deserialize(from: jsonData.dictionaryObject)
            var dataArr:Array<CountryModel> = model?.RECORDS ?? []
            for country in dataArr{
                if(country.countryphonecode == self.area){
                    
                    self.conuntryLab?.text = country.namezh
                    self.conuntryIcon?.kf.setImage(with: country.countryicon, placeholder: nil)
                    self.countryIconPath = country.countryicon
                    self.countryText = country.namezh
                    self.countryId = country.id
                    break
                }
            }
            
            
        } catch {
            print("解析失败")
        }
    }
    
    func createRightCard(){
        
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "UserCerReady")
        imageV.frame = CGRect(x: SCREEN_WIDTH - 66, y: 0, width: 48, height: 48)
        view.addSubview(imageV)
    }
    
    func createPreBtn(){
        
        let btn = UIButton(type: .custom)
        btn.setTitle("上一步", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("2d2d2d")
        btn.layer.cornerRadius = 4
        btn.frame = CGRect(x: 15, y: confirmBtn.y, width: 84, height: self.confirmBtn.height)
        view.addSubview(btn)
        btn.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func createCountry() -> UIView{
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("989898")
        lab.text = "国籍"
        lab.frame = CGRect(x: 15, y: idLabel.maxY + 30 , width: 250, height: 20)
        self.countryTipLab = lab
        
        let fatherV = UIView()
        fatherV.tag = 1024
        fatherV.frame = CGRect(x: 0, y: lab.maxY, width: view.width, height: 42)
        
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "UserCerQuestion")
        imageV.frame = CGRect(x: 15, y: 12 , width: 24, height: 24)
        self.conuntryIcon = imageV
        
        let rightImageV = UIImageView()
        rightImageV.image = UIImage.init(named: "cellright")
        rightImageV.frame = CGRect(x: fatherV.width - 15 - 20, y: 15 , width: 15, height: 15)
        self.rightImageView = rightImageV
        
        let labConuntry = UILabel()
        labConuntry.font = UIFont.systemFont(ofSize: 14)
        labConuntry.textColor = UIColor.hexColor("ffffff")
        labConuntry.text = "刚果民主共和国"
        labConuntry.frame = CGRect(x: imageV.maxX + 12, y: 13.6, width: rightImageV.x - (imageV.maxX + 24), height: 20)
        self.conuntryLab = labConuntry
        
        let lineV = UIView()
        lineV.backgroundColor = UIColor.hexColor("333333")
        lineV.frame = CGRect(x: 15, y: 41, width: fatherV.width - 35, height: 1)
        
        fatherV.addSubview(imageV)
        fatherV.addSubview(rightImageV)
        fatherV.addSubview(labConuntry)
        fatherV.addSubview(lineV)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickCountry))
        fatherV.addGestureRecognizer(tap)
        
        view.addSubview(lab)
        view.addSubview(fatherV)
        return fatherV
    }
    
    func createCotent(name: String, tipName: String) -> UIView{
        
        let contentW = (self.view.width - 55) * 0.5//15*2+25
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 0, y: 0, width: contentW, height: 58)
        view.addSubview(fatherV)
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("989898")
        lab.text = name
        lab.frame = CGRect(x: 0, y: 0 , width: contentW, height: 20)
        
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = tipName
        textField.textColor = .white
        textField.frame = CGRect(x: 0, y: lab.maxY + 12, width: contentW, height: 25)
        textField.tag = 512
        
        let lineV = UIView()
        lineV.backgroundColor = UIColor.hexColor("333333")
//        lineV.frame = CGRect(x: 0, y: 57, width: contentW, height: 1)
        
        fatherV.addSubview(lab)
        fatherV.addSubview(textField)
        fatherV.addSubview(lineV)
        
        lineV.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
            make.topMargin.equalTo(57)
        }
        return fatherV
    }
    
    func createTimeCotent(name: String, tipName: String) -> UIView{
        
        let contentW = (self.view.width - 55) * 0.5//15*2+25
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 0, y: 0, width: contentW, height: 58)
        view.addSubview(fatherV)
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("989898")
        lab.text = name
        lab.frame = CGRect(x: 0, y: 0 , width: contentW, height: 20)
        
        let timeBtn = UIButton(type: .custom)
        timeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        timeBtn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        timeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -32, bottom: 0, right: 32)
        timeBtn.setTitle(tipName, for: .normal)
        timeBtn.frame = CGRect(x: 0, y: lab.maxY + 12, width: contentW, height: 25)
        self.timeBtn = timeBtn
        
        let timeImageV = UIImageView()
        timeImageV.image = UIImage.init(named: "UserCerTime")
        timeImageV.frame = CGRect(x: contentW - 20, y: fatherV.height - 24, width: 20, height: 20)
        
        let lineV = UIView()
        lineV.backgroundColor = UIColor.hexColor("333333")
        lineV.frame = CGRect(x: 0, y: 57, width: contentW, height: 1)
        
        fatherV.addSubview(lab)
        fatherV.addSubview(timeBtn)
        fatherV.addSubview(lineV)
        fatherV.addSubview(timeImageV)
        return fatherV
    }
    
    func createCardTipLab(beginY: CGFloat) -> CGFloat{
        
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 0, y: beginY, width: SCREEN_WIDTH, height: 36)
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "使用政府签发的有效文件"
        lab.frame = CGRect(x: 15, y: 0 , width: 250, height: 20)
        
        let lab2 = UILabel()
        lab2.font = UIFont.systemFont(ofSize: 11)
        lab2.textColor = UIColor.hexColor("989898")
        lab2.text = "仅接受下列文件，其他所有文件将被拒绝。"
        lab2.frame = CGRect(x: 15, y: lab.maxY , width: 250, height: 16)
        
        fatherV.addSubview(lab)
        fatherV.addSubview(lab2)
        view.addSubview(fatherV)
        
        return fatherV.maxY
    }
    
    lazy var curTableView : BaseTableView = {
        let tableView = BaseTableView(frame: CGRect.zero, style: .plain)
        if(cellType == "IDCell"){
            tableView.register(UserCardCell.self, forCellReuseIdentifier: UserCardCell.UserCardCellID)
        }else{
            tableView.register(UserCardReadyCell.self, forCellReuseIdentifier: UserCardReadyCell.UserCardReadyCellID)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()

    lazy var idLabel: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 22) //UIFont(name: "PingFang SC-Bold", size: 22)
        lab.textColor = .white
        lab.text = "身份信息"
        lab.frame = CGRect(x: 12, y: 0, width: 92, height: 30)
        return lab
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("tv_confirm".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("FCD283")
        btn.layer.cornerRadius = 4
        btn.frame = CGRect(x: 12, y: view.height - 47 - 83 - (is_iPhoneXSeries() ? 54 : 0), width: view.width-24, height: 47)
        return btn
    }()
}

extension UserCerIDVC : UserCerViewMDelegate{
    
    func getUserCerInfoSuccess() {
        
        let userCerResultVC = UserCerResultVC()
        self.navigationController?.pushViewController(userCerResultVC, animated: true)
    }
}

extension UserCerIDVC : EntrustCondtionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (cellType == "IDCell") ? self.tabSources.count : self.tabReadySources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (cellType == "IDCell") ? 56 : 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(cellType == "IDCell"){
            let cell: UserCardCell = tableView.dequeueReusableCell(withIdentifier: UserCardCell.UserCardCellID) as! UserCardCell
            let model = tabSources[indexPath.section]
            cell.model = model
            cell.selectionStyle = .none
            return cell
        }else{
            let cell: UserCardReadyCell = tableView.dequeueReusableCell(withIdentifier: UserCardReadyCell.UserCardReadyCellID) as! UserCardReadyCell
            let tip = tabReadySources[indexPath.section]
            cell.nameLabel.text = tip
            cell.selectionStyle = .none
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(cellType == "IDCell"){
            for temM in tabSources{
                temM.cardSel = false
            }
            let model = tabSources[indexPath.section]
            model.cardSel = true
            self.authType = indexPath.section
            self.curTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    
    func clickStartBtn(btn: UIButton, endStr: String) {
    }
    
    func clickEndBtn(btn: UIButton, startStr: String) {
    }
    
    // MARK: - Action
    @objc func clickCountry() {
        
        if(self.cerIDType == "IDTypeMine"){
            return
        }
        let vc = CountListVC()
        vc.selectedCountryClick = {[weak self] (model : CountryModel) in
            self?.conuntryLab?.text = model.namezh
            self?.conuntryIcon?.kf.setImage(with: model.countryicon, placeholder: nil)
            self?.countryIconPath = model.countryicon
            self?.countryText = model.namezh
            self?.area = model.countryphonecode
            self?.countryId = model.id
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupEvent(){
        
        timeBtn?.rx.tap
            .subscribe(onNext: { [weak self] in
                
                let dataPicker = EWDatePickerViewController()
                self?.definesPresentationContext = true
                /// 回调显示方法
                dataPicker.backDate = { [weak self] date in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    let dateString: String = dateFormatter.string(from: date)
                    self?.timeBtn?.setTitle(dateString, for: .normal)
                    self?.timeBtn?.isSelected = true
                }
                dataPicker.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                dataPicker.picker.reloadAllComponents()
                /// 弹出时日期滚动到当前日期效果
                self?.present(dataPicker, animated: true) {
                    if (self!.currentDateCom.day!) - 2 > 0{
                        dataPicker.picker.selectRow(1, inComponent: 0, animated: true)
                        dataPicker.picker.selectRow((self!.currentDateCom.month!) - 1, inComponent: 1, animated:true)
                        dataPicker.picker.selectRow((self!.currentDateCom.day!) - 2, inComponent: 2, animated: true)
                    }else{
                        if (self!.currentDateCom.month!) - 2 > 0{
                            dataPicker.picker.selectRow(1, inComponent: 0, animated: true)
                            dataPicker.picker.selectRow((self!.currentDateCom.month!) - 2, inComponent: 1, animated:true)
                            dataPicker.picker.selectRow(0, inComponent: 2, animated: true)
                        }else{
                            dataPicker.picker.selectRow(0, inComponent: 0, animated: true)
                            dataPicker.picker.selectRow(0, inComponent: 1, animated:true)
                            dataPicker.picker.selectRow(0, inComponent: 2, animated: true)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        self.confirmBtn.rx.tap
            .subscribe(onNext: { [self] in
                
                if(self.cerIDType == "IDTypeMine"){
                    
                    let nameV = self.view.viewWithTag(1025)
                    let cardV = self.view.viewWithTag(1026)
                    let nameTF = nameV?.viewWithTag(512) as! UITextField
                    let cardTF = cardV?.viewWithTag(512) as! UITextField
                    let reqJuniomM = ReqUserJuniorM()
                    reqJuniomM.Name = nameTF.text!
                    reqJuniomM.IdCard = cardTF.text!
                    reqJuniomM.IdCardType = self.authType+1
                    reqJuniomM.CountryId = Int(self.countryId)!
                    if(self.area != "86"){
                        let nameLastV = self.view.viewWithTag(1027)
                        let nameMiddleV = self.view.viewWithTag(1028)
                        let nameLastTF = nameLastV?.viewWithTag(512) as! UITextField
                        let nameMiddleTF = nameMiddleV?.viewWithTag(512) as! UITextField
                        if(nameLastTF.text!.count > 0){
                            reqJuniomM.Surname = nameLastTF.text!
                        }
                        if(nameMiddleTF.text!.count > 0){
                            reqJuniomM.MiddleName = nameMiddleTF.text!
                        }
                        if(timeBtn!.isSelected){
                            reqJuniomM.BirthDate = timeBtn!.titleLabel!.text!
                        }
                    }
                    if(self.reAuth){
                        self.viewM.reqUpdateUserCerInfo(reqModel: reqJuniomM) {}
                    }else{
                        self.viewM.reqPostUserCerInfo(reqModel: reqJuniomM) {}
                    }
                    
                }else if(self.cerIDType == "IDTypeCard"){

                    let userCerInputVC = UserCerIDVC()
                    userCerInputVC.area = self.area
                    userCerInputVC.countryId = self.countryId
                    userCerInputVC.countryText = self.countryText
                    userCerInputVC.countryIconPath = self.countryIconPath
                    userCerInputVC.authType = self.authType
                    userCerInputVC.reAuth = self.reAuth
                    self.navigationController?.pushViewController(userCerInputVC, animated: true)
                }else if(self.cerIDType == "IDTypeReady"){
                    
                    let cameraVC = UserCerCameraVC()
                    cameraVC.cardType = self.cameraCardType
                    cameraVC.cardName = cardTypeName()
                    self.navigationController?.pushViewController(cameraVC, animated: true)
                }

            }).disposed(by: disposeBag)
    }
    
}

class UserCardCell: UITableViewCell {
    static let UserCardCellID = "UserCardCellID"
    lazy var nameLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = FONTM(size: 14)
        return lab
    }()
    lazy var statusImageV : UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage.init(named: "UserCerUnSel")
        return imageV
    }()
    var model : UserCerCardModel = UserCerCardModel(){
        didSet{
            
            self.nameLabel.text = model.cardType
            self.statusImageV.image = model.cardSel ? UIImage.init(named: "UserCerSel") : UIImage.init(named: "UserCerUnSel")

        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setupConstraints()
    }
    
    func setUI(){
     
        contentView.backgroundColor = UIColor.hexColor("2d2d2d")
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusImageV)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        self.backgroundColor = .clear
    }
    
    func setupConstraints(){
        
        nameLabel.snp.makeConstraints { make in
            
            make.left.margins.equalTo(15)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        statusImageV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class UserCardReadyCell: UITableViewCell {
    static let UserCardReadyCellID = "UserCardReadyCellID"
    lazy var nameLabel : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.hexColor("989898")
        lab.font = FONTR(size: HSWindowAdapter.calculateFontSize(input: 13))
        return lab
    }()
    lazy var statusImageV : UIImageView = {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.hexColor("fcd283")
        imageV.layer.cornerRadius = 3
        return imageV
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setupConstraints()
    }
    
    func setUI(){
    
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusImageV)
    }
    
    func setupConstraints(){
        
        statusImageV.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(6)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(statusImageV.snp.right).offset(12)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class UserCerCardModel : BaseModel{
    ///证件类型
    var cardType: String = ""
    ///是否选中
    var cardSel: Bool = false
}
