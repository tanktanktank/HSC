//
//  SelectColorView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit

typealias passColorValue = (String)->()


class SelectColorView: UIView {
    
    
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var pinkBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var purpleBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    
    @IBOutlet weak var vLayer: UIView!
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    let dataSubject = PublishSubject<Any>()
    var passColor : passColorValue?
    
    private var disposeBag = DisposeBag()
    
    class func loadSelectColorView(top:CGFloat) -> SelectColorView {
        let kColorView = Bundle.main.loadNibNamed("SelectColorView", owner: nil, options: nil)?[0] as! SelectColorView
        kColorView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        getTopVC()?.view.window?.addSubview(kColorView)
        kColorView.topLayout.constant = top + 50
        //MARK: 取消
        let tapLayer = UITapGestureRecognizer()
        kColorView.vLayer.addGestureRecognizer(tapLayer)
        tapLayer.rx.event
            .subscribe(onNext: { recognizer in
                kColorView.dataSubject.onError(NSError(domain: "", code: 0))
                kColorView.removeFromSuperview()
            })
            .disposed(by: kColorView.disposeBag)
        
        return kColorView
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupEvent()
    }
    
    func setupEvent(){
        
        let buttons = [self.yellowBtn, self.pinkBtn, self.redBtn, self.purpleBtn, self.greenBtn].map { $0! }
        let choseButton = Observable.from(
            buttons.map { button in button.rx.tap.map {button} }
        ).merge()
        choseButton.map{[weak self] value in
            
            let colorStrs = ["yellow","pink","red","purple","green"]
            let colorStr = colorStrs[value.tag - 1024]
            self!.passColor?( colorStr )

        }.subscribe(onNext: {value in
        }).disposed(by: disposeBag)
    }
}
