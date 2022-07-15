//
//  TransferReceiveController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/26.
//

import UIKit

class TransferReceiveController: UIViewController {

    @IBOutlet weak var btnNetwork: UIButton!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblReamrk: UILabel!
    
    @IBOutlet weak var ivCoin: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBOutlet weak var lblNetwork: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblBlock: UILabel!
    @IBOutlet weak var lblSubmitBlock: UILabel!
    
    @IBOutlet weak var btnCopyAddress: UIButton!
    @IBOutlet weak var btnCopyMemo: UIButton!
    
    var model : CoinModel!
    private var disposeBag = DisposeBag()
    var viewModel: TransferViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.lblCoin.text = "充值\(model.coin)"
        viewModel = TransferViewModel()
        self.btnSave.layer.borderColor = UIColor.hexColor(0x989898).cgColor
        
        //MARK: 二维码
        self.ivCoin.image = QRcode.createQRCodeByCIFilterWithString("ssssssssssssssssssssssss11dasdsa", andImage: UIImage(named: "wallets_check_selscted")!)
        
        //MARK: 选择主网
        self.btnNetwork.rx.tap
            .flatMap { value -> Observable<Int> in
                let networkView = TransferNetworkView.loadNetworkView(view: self.view.window!,isSend: false)
                return networkView.dataSubject
            }.subscribe(onNext: {value in
                
            }).disposed(by: disposeBag)
        
        //MARK: 保存
        self.btnSave.rx.tap
            .subscribe(onNext: {value in
                UIImageWriteToSavedPhotosAlbum(self.ivCoin.image!, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }).disposed(by: disposeBag)
        
        //MARK: 复制MEMO
        self.btnCopyMemo.rx.tap
            .subscribe(onNext: {value in
                UIPasteboard.general.string = self.lblMemo.text
                
            }).disposed(by: disposeBag)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 保存图片
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error != nil {
            HudManager.showOnlyText("保存失败")
        } else {
            HudManager.showOnlyText("保存成功")
        }
    }
}

