//
//  SelectKLineView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit

typealias passLineWidthValue = (String)->()


class SelectKLineView: UIView {

    @IBOutlet weak var lineWidthV0: UIView!
    @IBOutlet weak var lineWidthV1: UIView!
    @IBOutlet weak var lineWidthV2: UIView!
    
    @IBOutlet weak var vLayer: UIView!
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var centerXLayout: NSLayoutConstraint!
    let dataSubject = PublishSubject<Any>()
    var passLineW : passLineWidthValue?

    private var disposeBag = DisposeBag()
    
    class func loadSelectLineView(top:CGFloat) -> SelectKLineView {
        let kLineView = Bundle.main.loadNibNamed("SelectKLineView", owner: nil, options: nil)?[0] as! SelectKLineView
        kLineView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        getTopVC()?.view.window?.addSubview(kLineView)
        kLineView.topLayout.constant = top + 50
        //MARK: 取消
        let tapLayer = UITapGestureRecognizer()
        kLineView.vLayer.addGestureRecognizer(tapLayer)
        tapLayer.rx.event
            .subscribe(onNext: { recognizer in
                kLineView.dataSubject.onError(NSError(domain: "", code: 0))
                kLineView.removeFromSuperview()
            })
            .disposed(by: kLineView.disposeBag)
        
        return kLineView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupEvent()
    }
    
    func setupEvent(){
        //TODO: 代码需优化
        
        let tap0 = UITapGestureRecognizer()
        lineWidthV0.addGestureRecognizer(tap0)
        tap0.rx.event.subscribe {[weak self] recognizer in
            self!.passLineW?( "0" )
        } onError: { error in
        } onCompleted: {
        } onDisposed: {
        }
        
        let tap1 = UITapGestureRecognizer()
        lineWidthV1.addGestureRecognizer(tap1)
        tap1.rx.event.subscribe {[weak self] recognizer in
            self!.passLineW?( "1" )
        } onError: { error in
        } onCompleted: {
        } onDisposed: {
        }
        
        let tap2 = UITapGestureRecognizer()
        lineWidthV2.addGestureRecognizer(tap2)
        tap2.rx.event.subscribe {[weak self] recognizer in
            self!.passLineW?( "2" )
        } onError: { error in
        } onCompleted: {
        } onDisposed: {
        }

    }
}
