//
//  WLOptionView.swift
//  SearchView
//
//  Created by jykj on 2020/5/11.
//  Copyright © 2020 wanglei. All rights reserved.
//

import UIKit
import SnapKit
enum InputType:Int{
    case search//搜索输入框
    case normal//选择输入框
    case btnType//按钮类型
}
protocol WLOPtionViewDelegate{
    func optionView(view:WLOptionView ,selectedIndex:(Int));
    func searchOptionView(view:WLOptionView ,selctedString:String ,selectedIndex:(Int));
}
//可选协议方法
extension WLOPtionViewDelegate {
     func optionView(view:WLOptionView ,selectedIndex:(Int)){}
    func searchOptionView(view:WLOptionView ,selctedString:String ,selectedIndex:(Int)){}
}
typealias SelectedBlock = (_ view:WLOptionView ,_ selectedIndex:(Int))-> Void
typealias SearchSelectedBlock = (_ view:WLOptionView ,_ selctedString:String,_ selectedIndex:(Int))-> Void

typealias ClickBlock = (_ isDirectionUp:Bool)-> Void
let rows = 5

class WLOptionView: UIView, UITableViewDelegate, UITableViewDataSource {

    var animationTime = 0.3
    var type:InputType!
    var isHaveDistance = false
    var cellHeight = 30 {
        
        didSet{
            
            if type == .normal  {
                if rowheight != 0 {
                    self.tableViewHeight = CGFloat(CGFloat(self.dataSource.count) * rowheight)
                }else{
                    self.tableViewHeight = CGFloat(self.dataSource.count * cellHeight)
                }
            }else{
                tableViewHeight = 210
            }
        }
    }
    var textAligment : NSTextAlignment = .center{
        
        didSet{
            self.titleLabel.textAlignment = textAligment
        }
    }

    var dataSource:[String] = []{
        didSet {
            
            if type == .normal  {
                if rowheight != 0 {
                    self.tableViewHeight = CGFloat(CGFloat(self.dataSource.count) * rowheight)
                }else{
                    self.tableViewHeight = CGFloat(self.dataSource.count * cellHeight)
                }
            }else{
                tableViewHeight = 210
            }
            
        }
    }
    
    //标题
    var rightImgWidth:CGFloat = 10{
        didSet {
            
            rightImageView.snp.updateConstraints { (make) in
                make.width.equalTo(rightImgWidth)
            }
        }
    }

    //标题
    var title:String?{
        didSet {
            self.titleLabel.text = title
        }
    }
    //提示输入
    var placeholder:String?{
        didSet {
            self.searchTextField.placeholder = placeholder
        }
    }
    //颜色
          var keyWordColor:UIColor?{
              didSet {
                 self.searchTextField.textColor = keyWordColor
              }
          }
       // 标题字体大小
       var keyWordFontSize:CGFloat?{
           didSet {
               self.searchTextField.font = .systemFont(ofSize: keyWordFontSize!)
           }
       }
    //标题颜色
    var titleColor:UIColor?{
        didSet {
            self.titleLabel.textColor = titleColor
        }
    }
    // 标题字体大小
    var titleFont:UIFont?{
        didSet {
            
            self.titleLabel.font = titleFont!
        }
    }
    //视图圆角
    var cornerRadius:CGFloat?{
        didSet {
            self.corner(cornerRadius: cornerRadius ?? 0)
        }
    }
    //视图边框颜色
    var borderColor:UIColor?{
        didSet {
//            self.layer.borderColor = borderColor!.cgColor
        }
    }
    //边框宽度
    var borderWidth:CGFloat?{
        didSet {
//            self.layer.borderWidth = borderWidth!
        }
    }
    //cell高度
    var rowheight:CGFloat = 0{
        didSet {
            self.tableView.rowHeight = rowheight
        }
    }
    var selectIndex = 0{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //tableView的高度
    var tableViewHeight:CGFloat?
    var delegate: WLOPtionViewDelegate?
    var selectedBlock: SelectedBlock?
    var searchSelectedBlock: SearchSelectedBlock?
    var clickBlock: ClickBlock?
    
    var isDirectionUp:Bool = false
    var isShowing:Bool = false
    
    //block
    func selectedCallBack(block:@escaping (_ view:WLOptionView ,_ selectedIndex:(Int))->Void ) {
        selectedBlock = block
    }
    func searchSelectedCallBack(block:@escaping (_ view:WLOptionView ,_ selctedString:String,_ selectedIndex:(Int))->Void ) {
           searchSelectedBlock = block
       }
    func clickBlock(block:@escaping (_ isDirectionUp:Bool) -> Void ){
        clickBlock = block
    }
    //初始化
   init(frame: CGRect ,type: InputType) {
        super.init(frame: frame)
        self.type = type
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        cornerRadius = 5
        borderWidth = 1
        borderColor = UIColor.init(red: 153.0/255, green: 153.0/255, blue: 153.0/255, alpha: 1)
        addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.snp.right).offset(-10)
            make.width.equalTo(rightImgWidth)
        }
        if type == InputType.search {
            addSubview(searchTextField)
            searchTextField.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.snp.left).offset(10)
                make.right.equalTo(rightImageView.snp.left)
            }
        }else{
            addSubview(titleLabel)
            addSubview(maskBtn)
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(self.snp.left).offset(8)
                make.right.equalTo(rightImageView.snp.left)
            }
            maskBtn.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalToSuperview()
            }
        }
        
       
       
    }
    //MARK: show,dissmiss
      @objc func show(){
          if type == .btnType {
              isDirectionUp = !isDirectionUp
//               self.rightImageView.image = isDirectionUp ? UIImage.init(named: "index_top_down") : UIImage.init(named: "index_top_up")
              print("click=====")
              
              if (clickBlock != nil) {
                  clickBlock!(isDirectionUp)
              }
          }else{
              isShowing = true
               self.rightImageView.image = isDirectionUp ? UIImage.init(named: "index_top_down") : UIImage.init(named: "index_top_up")
              let window:UIWindow = UIApplication.shared.windows[0]
              window.backgroundColor = .hexColor("FFFFF", alpha: 0.2)
              window.addSubview(backgroundBtn)
              window.addSubview(tableView)
              // 获取按钮在屏幕中的位置
              let frame = self.convert(self.bounds, to: window)
              let tableViewY = frame.origin.y + frame.size.height
              var tableViewFrame:CGRect = CGRect.init()
              tableViewFrame.size.width = frame.size.width
              tableViewFrame.size.height = tableViewHeight!
              tableViewFrame.origin.x = frame.origin.x;
              
              if (tableViewY + tableViewHeight! < UIScreen.main.bounds.size.height) {
                  tableViewFrame.origin.y = tableViewY
                  isDirectionUp = false
              }else {
                  tableViewFrame.origin.y = frame.origin.y - tableViewHeight!
                  self.isDirectionUp = true
              }
              tableView.frame = CGRect.init(x: tableViewFrame.origin.x, y: tableViewFrame.origin.y+((isDirectionUp ?tableViewHeight:0)!) + (isHaveDistance ? 5 : 0), width: tableViewFrame.size.width, height: 0)
         
              UIView.animate(withDuration: animationTime) {
                  self.tableView.frame = CGRect.init(x: tableViewFrame.origin.x, y: tableViewFrame.origin.y + (self.isHaveDistance ? 5 : 0), width: tableViewFrame.size.width, height: tableViewFrame.size.height);
                  print("%@",NSCoder.string(for: self.tableView.frame))
              }
          }
         
        }
        @objc func dissmiss(){
            isShowing = false
             self.rightImageView.image = isShowing ? UIImage.init(named: "index_top_up") : UIImage.init(named: "index_top_down")
            UIView.animate(withDuration: animationTime, animations: {
//                 self.rightImageView.transform = .identity
                self.tableView.frame = CGRect.init(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y + ((self.isDirectionUp ? self.tableViewHeight : 0)!), width: self.tableView.frame.size.width, height: 0)
            }) { (finished) in
                self.backgroundBtn.removeFromSuperview()
                self.tableView.removeFromSuperview()
            }
          
               
         
        }
    @objc func searchWithKeyword(sender:UITextField){
          if !isShowing {
              show()
          }
//         self.rightImageView.image = isShowing ? UIImage.init(named: "index_top_down") : UIImage.init(named: "index_top_up")
          if sender.text!.count > 0 {
              var array = [String]()
              for str:String in tempDataSource {
                  if str.contains(find: sender.text!) {
                      array.append(str)
                  }
              }
              dataSource = array
              if array.count == 0 {
                  dissmiss()
              }
          }else{
              dataSource = tempDataSource
              dissmiss()
          }
          tableView.reloadData()
      }
    //MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0{
            return 0
        }
           return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.CELLID, for: indexPath) as! OptionCell
        
        cell.titleLab.text = dataSource[indexPath.row]
        cell.titleLab.textAlignment = textAligment
        if indexPath.row == selectIndex {
            cell.titleLab.textColor = .hexColor("FCD283")
        }else{
            cell.titleLab.textColor = .hexColor("989898")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == InputType.search {
            searchTextField.text = dataSource[indexPath.row]
            dissmiss()
            self.delegate?.searchOptionView(view: self, selctedString:dataSource[indexPath.row], selectedIndex: indexPath.row)
            if (searchSelectedBlock != nil) {
                searchSelectedBlock!(self,dataSource[indexPath.row],indexPath.row)
            }
            searchTextField.resignFirstResponder()
        }else{
            title = dataSource[indexPath.row]
            dissmiss()
            self.delegate?.optionView(view: self, selectedIndex: indexPath.row)
            if (selectedBlock != nil) {
                selectedBlock!(self,indexPath.row)
            }
        }
        
       
       
    }
    // MARK:懒加载控件
    //标题控件
    lazy var titleLabel: UILabel={
        let tv = UILabel.init()
        tv.text = "请选择时间"
        tv.textColor = .hexColor("989898")
        tv.font = FONTR(size: 13)
        tv.textAlignment = .center
        return tv
    }()
    //右边箭头图片
    lazy var rightImageView: UIImageView={
        let rg = UIImageView.init()
        rg.image = UIImage.init(named: "index_top_down")
        rg.clipsToBounds = true
        return rg
    }()
    //控件透明按钮，也可以给控件加手势
    lazy var maskBtn: UIButton={
        let mb = UIButton.init(type: .custom)
        mb.backgroundColor = .clear
        mb.clipsToBounds = true
        mb.addTarget(self, action: #selector(show), for: .touchUpInside)
        return mb
    }()
    
    //选项列表
    lazy var tableView: UITableView={
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.tableFooterView = UIView.init()
        tv.rowHeight = CGFloat(cellHeight)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = .hexColor("2D2D2D")
        tv.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        tv.layer.shadowColor = UIColor.lightGray.cgColor
        tv.layer.shadowOpacity = 0.8;
        tv.layer.shadowRadius = 4;
//        tv.layer.borderColor = UIColor.gray.cgColor;
//        tv.layer.borderWidth = 0.5;
        tv.layer.cornerRadius = cornerRadius ?? 5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
        tv.register(OptionCell.self, forCellReuseIdentifier: OptionCell.CELLID)
        return tv;
    }()
    lazy var backgroundBtn: UIButton={
        let bb = UIButton.init(type: .custom)
        bb.backgroundColor = .clear
        bb.frame = UIScreen.main.bounds
        bb.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        return bb
    }()
    lazy var searchTextField: UITextField={
         let sf = UITextField.init()
         sf.placeholder = "请输入关键字";
         sf.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
         sf.addTarget(self, action: #selector(searchWithKeyword), for: .editingChanged)
         sf.font = .systemFont(ofSize: 16)
         return sf
     }()
    lazy var tempDataSource: [String]={
        var ts = [String]()
        ts = self.dataSource
        return ts
    }()
    
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}


class OptionCell : UITableViewCell{
    static let CELLID = "OptionCell"
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("989898")
        lab.font = FONTR(size: 12)
        lab.textAlignment = .center
        return lab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
