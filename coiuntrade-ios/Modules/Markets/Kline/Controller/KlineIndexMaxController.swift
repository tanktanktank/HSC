//
//  KlineIndexMaxController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit

enum KlineIndexMax : String{
    case kdj  = "KDJ"
    case boll = "BOLL"
    case macd = "MACD"
}

class KlineIndexMaxController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vInput: UIView!
    @IBOutlet weak var vMaxInput: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnRest: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    @IBOutlet weak var txfCycle: UITextField!
    @IBOutlet weak var txfBroadband: UITextField!
    
    @IBOutlet weak var txfAgeCycle: UITextField!
    @IBOutlet weak var txfShortCycle: UITextField!
    @IBOutlet weak var txfLongCycle: UITextField!
    
    @IBOutlet weak var shortLab: UILabel!
    @IBOutlet weak var longLab: UILabel!
    @IBOutlet weak var avgLab: UILabel!
    
    var showType : KlineIndexMax = .boll
    var viewModel: KlineSetViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 注册cell
        self.tableView?.register(UINib(nibName: "KlineIndexMaxCell",bundle: nil), forCellReuseIdentifier: "KlineIndexMaxCell")
        self.lblTitle.text = self.showType.rawValue
        
        switch showType {
        case .boll:
            self.vInput.isHidden = false
            self.vMaxInput.isHidden = true
        case .macd,.kdj:
            self.vInput.isHidden = true
            self.vMaxInput.isHidden = false
            
        }
        
        self.lblTitle.text = showType.rawValue
        setupData()
        setupEvent()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.indexs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KlineIndexMaxCell = self.tableView?.dequeueReusableCell(withIdentifier: "KlineIndexMaxCell") as! KlineIndexMaxCell
        let rectTable = tableView.rectForRow(at: indexPath)
        let rect = tableView.convert(rectTable, to: tableView.superview)
        cell.top = CGFloat(rect.minY)
        cell.model = self.viewModel.indexs[indexPath.row]
        return cell
    }
    
    
    func setupEvent(){
        //MARK: 确认
        btnConfirm.rx.tap
            .subscribe(onNext: { [self] in
                
                if(showType == .boll){
                    dealWithBoll()
                }else if(showType == .macd){
                    dealWithMACD()
                }else if(showType == .kdj){
                    dealWithKDJ()
                }
                
            }).disposed(by: disposeBag)
    }
    func dealWithBoll(){
        var index: Int = 0
        for viewm in self.viewModel.indexs{
            let temMap = ["maDay":"1","maLineWidth":String(viewm.line), "maColor":viewm.color] as [String : String]
            let data = try? JSONSerialization.data(withJSONObject: temMap, options: [])
            let decoder = JSONDecoder()
            guard let mainMA = try? decoder.decode(MainMAItem.self, from: data!) else {
                return
            }
            UserDefaults.standard.setItem(mainMA, forKey: "KLineIndexBoll"+String(index))
            index += 1
        }
        let temBoolMap = ["cauculateWeek":txfCycle.text, "cauculateWidth":txfBroadband.text]
        let data = try? JSONSerialization.data(withJSONObject: temBoolMap, options: [])
        let decoder = JSONDecoder()
        guard let mainBoolItem = try? decoder.decode(MainBoolItem.self, from: data!) else {
            return
        }
        UserDefaults.standard.setItem(mainBoolItem, forKey: "KLineIndexBoll"+String(index))
        NotificationCenter.default.post(name: Notification.Name("KLineIndexUpdateNoti"), object: nil, userInfo: ["KLineType":"KLineBoll"])
        self.navigationController?.popViewController(animated: true)
    }
    func dealWithMACD(){
        
        var index: Int = 0
        for viewm in self.viewModel.indexs{
            let temMap = ["maDay":"1","maLineWidth":String(viewm.line), "maColor":viewm.color] as [String : String]
            let data = try? JSONSerialization.data(withJSONObject: temMap, options: [])
            let decoder = JSONDecoder()
            guard let mainMA = try? decoder.decode(MainMAItem.self, from: data!) else {
                return
            }
            UserDefaults.standard.setItem(mainMA, forKey: "KLineIndexMacd"+String(index))
            index += 1
        }
        let temMACDMap = ["fastWeek":txfShortCycle.text, "slowWeek":txfLongCycle.text, "avgWeek":txfAgeCycle.text]
        let data = try? JSONSerialization.data(withJSONObject: temMACDMap, options: [])
        let decoder = JSONDecoder()
        guard let mainMACDItem = try? decoder.decode(SecondMACDItem.self, from: data!) else {
            return
        }
        UserDefaults.standard.setItem(mainMACDItem, forKey: "KLineIndexMacd"+String(index))
        NotificationCenter.default.post(name: Notification.Name("KLineIndexUpdateNoti"), object: nil, userInfo: ["KLineType":"KLineMacd"])
        self.navigationController?.popViewController(animated: true)
    }
    func dealWithKDJ(){
        
        var index: Int = 0
        for viewm in self.viewModel.indexs{
            let temMap = ["maDay":"1","maLineWidth":String(viewm.line), "maColor":viewm.color] as [String : String]
            let data = try? JSONSerialization.data(withJSONObject: temMap, options: [])
            let decoder = JSONDecoder()
            guard let mainMA = try? decoder.decode(MainMAItem.self, from: data!) else {
                return
            }
            UserDefaults.standard.setItem(mainMA, forKey: "KLineIndexKDJ"+String(index))
            index += 1
        }
        let temKDJMap = ["calWeek":txfShortCycle.text, "avg1":txfLongCycle.text, "avg2":txfAgeCycle.text]
        let data = try? JSONSerialization.data(withJSONObject: temKDJMap, options: [])
        let decoder = JSONDecoder()
        guard let secondKDJItem = try? decoder.decode(SecondKDJItem.self, from: data!) else {
            return
        }
        UserDefaults.standard.setItem(secondKDJItem, forKey: "KLineIndexKDJ"+String(index))
        NotificationCenter.default.post(name: Notification.Name("KLineIndexUpdateNoti"), object: nil, userInfo: ["KLineType":"KLineKDJ"])
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupData(){
        viewModel = KlineSetViewModel()
        viewModel.klineMaxType = self.showType
        //MARK: 获取列表
        viewModel.requestTargetList(style: "Second")
            .subscribe(onNext: { value in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        if(showType == .boll){
            guard let mainBoll = UserDefaults.standard.getItem(MainBoolItem.self, forKey: "KLineIndexBoll3") else{
                txfCycle.text = "20"
                txfBroadband.text = "2"
                return
            }
            txfCycle.text = mainBoll.cauculateWeek
            txfBroadband.text = mainBoll.cauculateWidth
        }else if(showType == .macd){
            guard let secondMacd = UserDefaults.standard.getItem(SecondMACDItem.self, forKey: "KLineIndexMacd2") else{
                txfShortCycle.text = "12"
                txfLongCycle.text = "26"
                txfAgeCycle.text = "9"
                return
            }
            txfLongCycle.text = secondMacd.slowWeek
            txfShortCycle.text = secondMacd.fastWeek
            txfAgeCycle.text = secondMacd.avgWeek
        }else if(showType == .kdj){
            
            shortLab.text = "calculation_cycle".localized()
            longLab.text = "移动平均周期1"
            avgLab.text = "移动平均周期2"
            guard let secondKDJ = UserDefaults.standard.getItem(SecondKDJItem.self, forKey: "KLineIndexKDJ3") else{
                txfShortCycle.text = "9"
                txfLongCycle.text = "3"
                txfAgeCycle.text = "3"
                return
            }
            txfShortCycle.text = secondKDJ.calWeek
            txfLongCycle.text = secondKDJ.avg1
            txfAgeCycle.text = secondKDJ.avg2
        }
    }

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
