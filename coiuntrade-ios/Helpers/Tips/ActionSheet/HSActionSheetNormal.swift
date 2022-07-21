//
//  HSActionSheetNormal.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/7/21.
//

import UIKit

class HSActionSheetNormal: UIView {
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
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.corner(cornerRadius: 10)
        table.register(HSActionSheetdefCell.self, forCellReuseIdentifier:  HSActionSheetdefCell.CELLID)
        return table
    }()
    lazy var contentView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    var datas : Array<String> = []{
        didSet{
            if datas.count>10 {
                self.tableView.isScrollEnabled = true
            }else{
                self.tableView.isScrollEnabled = false
            }
            tableView.height = 48.0*CGFloat(self.datas.count)
            contentView.height = tableView.maxY+SafeAreaBottom
            
            self.tableView.reloadData()
        }
    }
    
    var selectedIndex = -1 // 默认选择可选
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
extension HSActionSheetNormal{
    @objc func tapCancelBtn(){
        self.dismiss()
    }
    func setUI(){
        self.addSubview(bgView)
        bgView.addSubview(contentView)
        contentView.addSubview(tableView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCancelBtn))
        bgView.addGestureRecognizer(tap)
    }
    func initSubViewsConstraints(){
        self.frame = UIScreen.main.bounds
        self.bgView.frame = self.frame
        tableView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        contentView.frame = CGRect(x: 0, y: bgView.maxY, width: SCREEN_WIDTH, height: tableView.maxY+SafeAreaBottom)
    }
}

extension HSActionSheetNormal : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HSActionSheetdefCell = tableView.dequeueReusableCell(withIdentifier: HSActionSheetdefCell.CELLID, for: indexPath) as! HSActionSheetdefCell
        let values = self.datas[indexPath.row]
        cell.isSelected = indexPath.row == self.selectedIndex
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


class HSActionSheetdefCell : UITableViewCell{
    static let CELLID = "HSActionSheetdefCell"
    
    override var isSelected: Bool {
        
        didSet{
            if isSelected {
                titleLab.textColor = .hexColor("FCD283")
            }else{
                titleLab.textColor = .hexColor("989898")
            }
        }
    }
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
//        titleLab.frame = contentView.bounds
        titleLab.snp.makeConstraints { make in
            
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
