//
//  HSQuotesView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/19.
//

import UIKit

class HSQuotesView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupEvent()
    }
    
    
    @objc func bgClick() {
        
        HSQuotesView.hide()
    }
    
    class func show(){

        let fwindow = UIApplication.shared.delegate!.window!!
        var quoteView = fwindow.viewWithTag(1999) as? HSQuotesView
        if(quoteView == nil){
            let fr = fwindow.bounds
            quoteView = HSQuotesView(frame: fr)
//            quoteView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)//fwindow.bounds
            quoteView!.tag = 1999
            fwindow.addSubview(quoteView!)
        }
        quoteView!.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0) {

            quoteView!.bgView.alpha = 1.0
            quoteView!.hqView.frame = CGRect(x: 0, y: 0, width: quoteView!.hqView.width, height: quoteView!.hqView.height)
        }
        
    }
    
    class func hide(){
        
        let fwindow = UIApplication.shared.delegate!.window!!
        let quoteView = fwindow.viewWithTag(1999) as? HSQuotesView
        if(quoteView != nil){
            quoteView!.endEditing(true)
            UIView.animate(withDuration: 0.3, delay: 0.0) {

                quoteView!.bgView.alpha = 0.0
                quoteView!.hqView.frame = CGRect(x: -quoteView!.hqView.width, y: 0, width: quoteView!.hqView.width, height: quoteView!.hqView.height)
            }
            completion: {_ in
                quoteView!.isHidden = true
            }
        }
    }
    
    @objc func tapBtn(button : UIButton){
        
        let line = hqNameView.viewWithTag(1024)
        for btn in self.hqNameBtns{
            
            if(btn == button){
                btn.isSelected = true
                line?.centerX = btn.centerX
            }else{
                btn.isSelected = false
            }
        }
        hqContentView.setContentOffset( CGPoint(x: (CGFloat(button.tag) * hqContentView.width), y: 0), animated: true)
    }
    
    
    func setupUI(){
        
        addSubview(bgView)
        addSubview(hqView)
        hqView.addSubview(hqTitleLab)
        hqView.addSubview(hqSearchView)
        hqView.addSubview(hqNameView)
        hqView.addSubview(hqContentView)
    }
    
    func setupConstraints(){
        
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        let hqViewW = SCREEN_WIDTH - 50
        hqView.frame = CGRect(x: -hqViewW, y: 0, width: hqViewW, height: SCREEN_HEIGHT)
        hqTitleLab.frame = CGRect(x: 15, y: 80, width: 250, height: 30)
        hqSearchView.frame = CGRect(x: 15, y: hqTitleLab.maxY + 20, width: hqView.width - 30, height: 30)
        hqNameView.frame = CGRect(x: 15, y: hqSearchView.maxY + 20, width: hqView.width - 30, height: 30)
        hqContentView.frame = CGRect(x: 15, y: hqNameView.maxY + 10, width: hqView.width - 30, height: hqView.height - (hqNameView.maxY + 30))
        
        hqSearchView.addCorner(conrners: .allCorners, radius: 15)
        
        var idx = 0
        for subv in hqContentView.subviews{
            subv.frame = CGRect(x: CGFloat(CGFloat(idx) * hqContentView.width), y: 0, width: hqContentView.width, height: hqContentView.height)
            idx += 1
        }
        hqContentView.contentSize = CGSize(width: CGFloat(CGFloat(hqContents.count) * hqContentView.width), height: 1.0)
    }
    
    func setupEvent(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bgClick))
        bgView.addGestureRecognizer(tap)
    }

    
    lazy var hqTitleLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 22)
        lab.textColor = .white
        lab.text = "选择交易对"
        return lab
    }()
    
    lazy var hqSearchView: HSSearchView = {
        
        let view = HSSearchView()
        view.backgroundColor = UIColor.hexColor("2d2d2d")
        return view
    }()
    
    lazy var hqNameView: UIScrollView = {
    
        let scrollV = UIScrollView()
        
        let lineV = UIView()
        lineV.frame = CGRect(x: 0, y: 27, width: 38, height: 3)
        lineV.backgroundColor = UIColor.hexColor("fcd283")
        lineV.addCorner(conrners: .allCorners, radius: 1.5)
        lineV.tag = 1024
        
        let btnMargin = 30.0
        var idx: Int = 0
        for str in hqNames {
            let btn = UIButton()
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.hexColor("8c8c8c"), for: .normal)
            btn.setTitleColor(UIColor.hexColor("ffffff"), for: .selected)
            btn.frame = CGRect(x: CGFloat(idx) * (66+btnMargin), y: 0, width: 78, height: 20)
            btn.tag = idx
            scrollV.addSubview(btn)
            self.hqNameBtns.append(btn)
            if(idx == 0){
                btn.isSelected = true
                lineV.centerX = btn.centerX
            }
            idx += 1
            btn.addTarget(self, action: #selector(tapBtn(button:)), for: .touchUpInside)
        }
        scrollV.addSubview(lineV)
        return scrollV
    }()
    
    lazy var hqContentView: UIScrollView = {
    
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.isScrollEnabled = false
        var idx: Int = 0
        for str in hqNames {
            let tableW = (SCREEN_WIDTH - 50)
            let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.rowHeight  = 19
            tableView.tag = idx
            scrollV.addSubview(tableView)
            tableView.backgroundColor = .clear
            idx += 1
        }
        return scrollV
    }()
    
    lazy var bgView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.382)
        view.alpha = 0.0
        return view
    }()
    
    lazy var hqView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.hexColor("1e1e1e")
        return view
    }()
    
    lazy var hqNames: [String] = {
       
        let names = ["U本位合约","币本位合约"]
        return names
    }()
    lazy var hqNameBtns = [UIButton]()
    
    lazy var hqContents: [[[String:String]]] = {
       
        var hqCS = [[[String:String]]]()
        var contents = [[String:String]]()
        let contents1 = [[String:String]]()
        contents.append(["name":"ADABUSD"])
        contents.append(["name":"ADABUSD"])
        contents.append(["name":"ADABUSD"])
        hqCS.append(contents)
        hqCS.append(contents1)
        return hqCS
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HSQuotesView: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hqContents[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 11.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 19
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 11))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 11))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HSQuoteCell.dequeTableViewCell(tableView: tableView)
        return cell
    }
}


class HSSearchView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchImageV)
        addSubview(searchTF)
        
        searchImageV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
            make.width.height.equalTo(13.5)
        }
        
        searchTF.snp.makeConstraints { make in
            
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(searchImageV.snp.right).offset(8)
        }
    }
    
    lazy var searchImageV: UIImageView = {
        
        let imagev = UIImageView()
        imagev.image = UIImage.init(named: "search-icon")
        return imagev
    }()
    
    lazy var searchTF: UITextField = {
        
        let searchTextField = UITextField()
        searchTextField.font = UIFont.systemFont(ofSize: 12)
        return searchTextField
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HSQuoteCell: UITableViewCell{
    

    class func dequeTableViewCell(tableView: UITableView) -> HSQuoteCell{
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "HSQuoteCellID") as? HSQuoteCell
        if(cell == nil){
            cell = HSQuoteCell.init(style: .default, reuseIdentifier: "HSQuoteCellID")
            cell!.setupSubViews()
            cell!.setupConstrants()
            cell!.backgroundColor = .clear
            cell!.contentView.backgroundColor = .clear
            cell!.selectionStyle = .none
        }
        return cell!
    }
    
    func setupSubViews(){
        
        contentView.addSubview(nameLab)
    }
    func setupConstrants(){
        
        nameLab.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    
    lazy var nameLab: UILabel = {
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = .white
        lab.text = "ADABUSD 永续"
        return lab
    }()
}
