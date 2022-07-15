//
//  KlineIndexController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

enum KlineIndex : String{
    case ma = "MA"
    case rsi = "RSI"
    case ema = "EMA"
}

class KlineIndexController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnRest: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var klineType : KlineIndex = .ma
    var viewModel: KlineSetViewModel!
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(klineType == .ema){
            btnConfirm.isHidden = true
            btnRest.isHidden = true
        }
        
        //MARK: 注册cell
        self.tableView?.register(UINib(nibName: "KlineIndexCell",bundle: nil), forCellReuseIdentifier: "KlineIndexCell")
        
        self.lblTitle.text = klineType.rawValue
        viewModel = KlineSetViewModel()
        viewModel.klineType = self.klineType
        //MARK: 获取列表
        viewModel.requestTargetList(style: "First")
            .subscribe(onNext: { value in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        //MARK: 重置

        //MARK: 确认
        btnConfirm.rx.tap
            .subscribe(onNext: { [self] in
                
                if(klineType == .rsi){
                    
                    var index: Int = 0
                    for viewm in self.viewModel.indexs{
                        let temMap = ["maDay":String(viewm.num), "maLineWidth":String(viewm.line), "maColor":viewm.color] as [String : String]
                        let data = try? JSONSerialization.data(withJSONObject: temMap, options: [])
                        let decoder = JSONDecoder()
                        guard let mainMA = try? decoder.decode(MainMAItem.self, from: data!) else {
                            return
                        }
                        UserDefaults.standard.setItem(mainMA, forKey: "KLineIndexRSI"+String(index))
                        index += 1
                    }
                    NotificationCenter.default.post(name: Notification.Name("KLineIndexUpdateNoti"), object: nil, userInfo: ["KLineType":"KLineRSI"])
                    self.navigationController?.popViewController(animated: true)
                }else{
                    var index: Int = 0
                    for viewm in self.viewModel.indexs{
                        let temMap = ["maDay":String(viewm.num), "maLineWidth":String(viewm.line), "maColor":viewm.color] as [String : String]
                        let data = try? JSONSerialization.data(withJSONObject: temMap, options: [])
                        let decoder = JSONDecoder()
                        guard let mainMA = try? decoder.decode(MainMAItem.self, from: data!) else {
                            return
                        }
                        UserDefaults.standard.setItem(mainMA, forKey: "ma5"+String(index))
                        index += 1
                    }
                    NotificationCenter.default.post(name: Notification.Name("KLineIndexUpdateNoti"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.indexs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: KlineIndexCell = self.tableView?.dequeueReusableCell(withIdentifier: "KlineIndexCell") as! KlineIndexCell
        let rectTable = tableView.rectForRow(at: indexPath)
        let rect = tableView.convert(rectTable, to: tableView.superview)
        cell.top = CGFloat(rect.minY)
        cell.model = self.viewModel.indexs[indexPath.row]
        return cell
    }
    

    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
