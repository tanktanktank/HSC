//
//  HSActionSheet.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/14.
//

import UIKit

class HSActionSheet: UIView {
    /// 返回数据回调
    public var clickCellAtion: ((Int)->())?
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor("000000", alpha: 0.1)
        return view
    }()
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("2D2D2D")
        table.showsVerticalScrollIndicator = false
        table.corner(cornerRadius: 10)
        table.register(HSActionSheetCell.self, forCellReuseIdentifier:  HSActionSheetCell.CELLID)
        return table
    }()
    lazy var contentView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.corner(cornerRadius: 10)
        btn.titleLabel?.font = FONTDIN(size: 16)
        btn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        btn.backgroundColor = .hexColor("434343")
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.setTitle("取消", for: .normal)
        return btn
    }()
    var datas : Array<String> = []{
        didSet{
            if datas.count>10 {
                self.tableView.isScrollEnabled = true
            }else{
                self.tableView.isScrollEnabled = false
            }
            tableView.height = 48.0*CGFloat(self.datas.count)
            cancelBtn.y = tableView.maxY+14
            contentView.height = cancelBtn.maxY+SafeAreaBottom
            
            self.tableView.reloadData()
        }
    }
    public func show() {
        UIApplication.shared.windows.first?.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = self.contentView.frame
            rect.origin.y -= self.contentView.bounds.size.height
            self.contentView.frame = rect
        }
    }
    public func dismiss() {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: ui
extension HSActionSheet{
    @objc func tapCancelBtn(){
        self.dismiss()
    }
    func setUI(){
        self.addSubview(bgView)
        bgView.addSubview(contentView)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(tableView)
    }
    func initSubViewsConstraints(){
        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        tableView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-LR_Margin*2, height: 48.0*CGFloat(self.datas.count))
        cancelBtn.frame = CGRect(x: 0, y: tableView.maxY+14, width: tableView.width, height: 48)
        contentView.frame = CGRect(x: LR_Margin, y: bgView.maxY, width: SCREEN_WIDTH-LR_Margin*2, height: cancelBtn.maxY+SafeAreaBottom)
    }
}

extension HSActionSheet : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HSActionSheetCell = tableView.dequeueReusableCell(withIdentifier: HSActionSheetCell.CELLID, for: indexPath) as! HSActionSheetCell
        let values = self.datas[indexPath.row]
        cell.values = values
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


class HSActionSheetCell : UITableViewCell{
    static let CELLID = "HSActionSheetCell"
    
    private lazy var titleLab : UILabel = {
        let v = UILabel()
        v.textColor = .hexColor("989898")
        v.font = FONTM(size: 14)
        v.textAlignment = .center
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
        titleLab.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
