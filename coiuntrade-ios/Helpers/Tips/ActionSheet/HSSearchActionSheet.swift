//
//  HSSearchActionSheet.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/20.
//

import UIKit

class HSSearchActionSheet: UIView {
    /// 返回数据回调
    public var clickCellAtion: ((Int)->())?
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor("000000", alpha: 0.3)
        return view
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.register(HSActionSheetNormalCell.self, forCellReuseIdentifier:  HSActionSheetNormalCell.CELLID)
        return table
    }()
    lazy var contentView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var titleLab : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTR(size: 14)
        return v
    }()
    lazy var closeBtn : ZQButton = {
        let v = ZQButton()
        v.setImage(UIImage(named: "tip_sheet_close"), for: .normal)
        v.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        return v
    }()
    lazy var searchV : UIView = {
        let v = UIView()
        v.corner(cornerRadius: 15)
        v.backgroundColor = .hexColor("2D2D2D")
        return v
    }()
    lazy var textF : QMUITextField = {
        let v = QMUITextField()
        v.font = FONTR(size: 12)
        v.textColor = .hexColor("FFFFFF")
        v.placeholder = "请输入关键字搜索".localized()
        v.placeholderColor = UIColor.hexColor("989898")
        v.setModifyClearButton()
        v.clearButtonMode = .whileEditing
        return v
    }()
    lazy var searchImageV : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "tip_sheet_search")
        return v
    }()
    var title : String = ""{
        didSet{
            self.titleLab.text = title
        }
    }
    
    var selectedIndex : Int = 0{
        didSet{
            self.tableView.reloadData()
        }
    }
    var datas : Array<String> = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    public func show() {
//        IQKeyboardManager.shared.enable = false
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
//        IQKeyboardManager.shared.enableAutoToolbar = false
        UIApplication.shared.windows.first?.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y -= self.contentView.bounds.size.height
            self.contentView.frame = rect
        }
    }
    public func dismiss() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y += self.contentView.bounds.size.height
            self.contentView.frame = rect
        } completion: { isok in
            self.removeAllSubViews()
            self.removeFromSuperview()
        }

    }
    /// 移除所有子控件
    func removeAllSubViews(){
        if self.subviews.count>0{
            self.subviews.forEach({$0.removeFromSuperview()})
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: 点击交换
extension HSSearchActionSheet{
    @objc func tapCancelBtn(){
        self.dismiss()
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        
        print("键盘弹起")
        
        print(keyboardheight)
        
        contentView.y = SCREEN_HEIGHT-(keyboardheight+84)
    }
    
    @objc func keyboardWillDisappear(notification:NSNotification){
        contentView.y = SCREEN_HEIGHT-contentView.height
        print("键盘落下")
    }
}
//MARK: ui
extension HSSearchActionSheet{
    func setUI(){
        self.addSubview(bgView)
        bgView.addSubview(contentView)
        contentView.addSubview(titleLab)
        contentView.addSubview(closeBtn)
        contentView.addSubview(searchV)
        contentView.addSubview(tableView)
        searchV.addSubview(textF)
        searchV.addSubview(searchImageV)
    }
    func initSubViewsConstraints(){
        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        contentView.frame = CGRect(x: 0, y: bgView.maxY, width: SCREEN_WIDTH, height: 363)
        contentView.addCorner(conrners: [.topLeft,.topRight], radius: 10)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        }
        closeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(titleLab)
            make.width.height.equalTo(10)
        }
        searchV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.top.equalTo(titleLab.snp.bottom).offset(12)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchV.snp.bottom).offset(10)
        }
        searchImageV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        textF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(searchImageV.snp.left).offset(-10)
        }
    }
}

extension HSSearchActionSheet : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HSActionSheetNormalCell = tableView.dequeueReusableCell(withIdentifier: HSActionSheetNormalCell.CELLID, for: indexPath) as! HSActionSheetNormalCell
//        let values = self.datas[indexPath.row]
        cell.values = "values"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if clickCellAtion != nil {
            clickCellAtion!(indexPath.row)
        }
        self.dismiss()
    }
}


class HSActionSheetNormalCell : UITableViewCell{
    static let CELLID = "HSActionSheetNormalCell"
    
    private lazy var titleLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("FFFFFF")
        v.font = FONTDIN(size: 12)
        return v
    }()
    private lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("0D0D0D")
        return v
    }()
    var values : String = ""{
        didSet{
            self.titleLab.text = values
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        contentView.addSubview(titleLab)
        contentView.addSubview(line)
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(LR_Margin)
        }
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
