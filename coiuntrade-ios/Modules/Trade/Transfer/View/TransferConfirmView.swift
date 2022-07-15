//
//  TransferConfirmView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/25.
//

import UIKit

class TransferConfirmView: UIView {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    let dataSubject = PublishSubject<Bool>()
    
    private var disposeBag = DisposeBag()
    
    class func loadTransferConfirmView(view:UIWindow) -> TransferConfirmView {
        let confirmView = Bundle.main.loadNibNamed("TransferConfirmView", owner: nil, options: nil)?[0] as! TransferConfirmView
        confirmView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.addSubview(confirmView)
        
        //MARK: 取消
        confirmView.btnCancel.rx.tap.subscribe(onNext: {
            confirmView.removeFromSuperview()
            confirmView.dataSubject.onNext(true)
            confirmView.dataSubject.onCompleted()
        }).disposed(by: confirmView.disposeBag)
        
        return confirmView
    }

}
