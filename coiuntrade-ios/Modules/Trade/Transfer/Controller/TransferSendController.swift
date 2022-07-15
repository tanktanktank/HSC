//
//  TransferSendController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/25.
//

import UIKit
import SwiftUI

class TransferSendController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSendContent: UILabel!
    
    @IBOutlet weak var txfAddress: UITextField!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var networkClick: UIButton!
    @IBOutlet weak var vNetwork: UIView!
    @IBOutlet weak var txfAmount: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var lblHave: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    
    var model : CoinModel!
    private var disposeBag = DisposeBag()
    var viewModel: TransferViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TransferViewModel()
        
        //MARK: 文本提示 -->翻译
        self.txfAddress.attributedPlaceholder = NSAttributedString.init(string:"Address", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.HexColor(0x989898)])
        self.txfAmount.attributedPlaceholder = NSAttributedString.init(string:"最少", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.HexColor(0x989898)])
        
        //MARK: 选择主网
        let tapNetwork = UITapGestureRecognizer()
        self.vNetwork.addGestureRecognizer(tapNetwork)
        tapNetwork.rx.event.flatMap { value -> Observable<Int> in
            let networkView = TransferNetworkView.loadNetworkView(view: self.view.window!,isSend: true)
            return networkView.dataSubject
        }.subscribe(onNext: {value in
            print(value)
        }).disposed(by: disposeBag)
        
        //MARK: 全部提取
        self.btnAll.rx.tap.subscribe(onNext: {

        }).disposed(by: disposeBag)
        
        //MARK: 清空
        self.btnClear.rx.tap.subscribe(onNext: {
            self.txfAmount.text?.removeAll()
        }).disposed(by: disposeBag)
        
        //MARK: 扫一扫
        self.btnScan.rx.tap
            .flatMap { value -> Observable<String> in
                let controller = ScanController(true)
                controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.navigationController?.present(controller, animated: true, completion: nil)
                return controller.dataSubject.catch { error in
                    return Observable.empty()
                }
            }.subscribe(onNext: {value in
                self.txfAddress.text = value
        }).disposed(by: disposeBag)
        
        //MARK: 地址
//        let input = self.txfAddress.rx.text.orEmpty.asDriver()
//            .throttle(.milliseconds(300))
//        input.map{ "当前字数：\($0)" }
//            .drive()
//            .disposed(by: disposeBag)
//        input.map{ $0.count > 5 }
//            .drive(btnConfirm.rx.isEnabled)
//            .disposed(by: disposeBag)
//
        //MARK: 提现
        self.btnConfirm.rx.tap
            .flatMap { value -> Observable<Bool> in
                self.viewModel.address = "111"
                return self.viewModel.requestTransferSend().catch { error in
                    self.lblError.isHidden = false
                    self.lblError.text = error.localizedDescription
                    print(error)
                    return Observable.empty()
                }
            }.flatMap({ value -> Observable<Bool> in
                let view = TransferConfirmView.loadTransferConfirmView(view: self.view.window!)
                return view.dataSubject.catch { error in
                    return Observable.empty()
                }
            }).flatMap({ alue -> Observable<Bool> in
                let controller =  SecurityVerificationVC()
                controller.fromeVCType = .verify
                self.navigationController?.pushViewController(controller, animated: true)
                return controller.dataSubject.catch { error in
                    return Observable.empty()
                }
            })
            .subscribe(onNext: {value in
                if value == true {
                    let controller = getViewController(name: "TransferStoryboard", identifier: "TransferStatusController")
                    self.navigationController?.pushViewController(controller, animated: true)
                } else{
                    
                }
            }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
