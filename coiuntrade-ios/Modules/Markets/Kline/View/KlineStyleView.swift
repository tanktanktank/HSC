//
//  KlineStyleView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class KlineStyleView: UIView {

    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var vNull: UIView!
    @IBOutlet weak var vReality: UIView!
    
    @IBOutlet weak var btnNull: UIButton!
    @IBOutlet weak var btnReality: UIButton!
    
    let dataSubject = PublishSubject<Any>()
    
    private var disposeBag = DisposeBag()
    
    class func loadKlineStyleView(view:UIWindow) -> KlineStyleView {
        let kLineView = Bundle.main.loadNibNamed("KlineStyleView", owner: nil, options: nil)?[0] as! KlineStyleView
        kLineView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.addSubview(kLineView)
        
        //MARK: 取消
        kLineView.btnCancel.rx.tap.subscribe(onNext: {
            kLineView.removeFromSuperview()
            kLineView.dataSubject.onError(NSError(domain: "", code: 0))
        }).disposed(by: kLineView.disposeBag)
        
        //MAKR: 实心
        let tapReality = UITapGestureRecognizer()
        kLineView.vReality.addGestureRecognizer(tapReality)
        tapReality.rx.event
            .subscribe(onNext: { recognizer in
                kLineView.btnNull.isSelected = false
                kLineView.btnReality.isSelected = true
                kLineView.dataSubject.onNext("StyleReality")
                kLineView.dataSubject.onCompleted()
                kLineView.removeFromSuperview()
            })
            .disposed(by: kLineView.disposeBag)
        
        //MAKR: 空心
        let tapNull = UITapGestureRecognizer()
        kLineView.vNull.addGestureRecognizer(tapNull)
        tapNull.rx.event
            .subscribe(onNext: { recognizer in
                kLineView.btnNull.isSelected = true
                kLineView.btnReality.isSelected = false
                kLineView.dataSubject.onNext("StyleNull")
                kLineView.dataSubject.onCompleted()
                kLineView.removeFromSuperview()
            })
            .disposed(by: kLineView.disposeBag)
        
        return kLineView
    }

}
