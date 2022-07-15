//
//  WithDrawViewController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import UIKit

class WithDrawViewController: BaseViewController {
    lazy var detailLab : UILabel = {
        let v = UILabel()
        v.font = FONTM(size: 14)
        v.textColor = .hexColor("989898")
        return v
    }()
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
//        v.bounces = false
        return v
    }()
    lazy var addressV : WithDrawScanView = {
        let v = WithDrawScanView()
        v.titleV.text = "tv_cash_flow_address".localized()
        return v
    }()
    lazy var mainNetV : WithDrawArrowCellView = {
        let v = WithDrawArrowCellView()
        v.titleV.text = "tv_recharge_mian_net".localized()
        return v
    }()
    lazy var memoV : WithDrawScanView = {
        let v = WithDrawScanView()
        v.titleV.text = "MEMO"
        return v
    }()
    lazy var amountV : WithAmountView = {
        let v = WithAmountView()
        v.titleV.text = "tv_withdraw_account".localized()
        return v
    }()
    lazy var tipLab : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 13)
        v.textColor = .hexColor("989898")
        v.text = "tv_tip".localized()
        return v
    }()
    lazy var msgIcon1 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898")
        v.corner(cornerRadius: 2)
        return v
    }()
    lazy var msgIcon2 : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("989898")
        v.corner(cornerRadius: 2)
        return v
    }()
    lazy var mssageLab1 : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "tv_withdraw_one".localized()
        v.numberOfLines = 0
        return v
    }()
    lazy var mssageLab2 : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "tv_withdraw_tip_two".localized()
        v.numberOfLines = 0
        return v
    }()
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
//        titleLab.removeFromSuperview()
        self.titleLab.text = "发送".localized() + "--"
        setUI()
        initSubViewsConstraints()
        eventInteraction()
        
        self.detailLab.text = "转账".localized() + "--" + "到数字币地址".localized()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.shared.enable = false
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared.enable = true。chOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}
//MARK: 交互事件
extension WithDrawViewController{
    func eventInteraction(){
        //MARK: 扫一扫
        addressV.scanBtn.rx.tap
            .flatMap { value -> Observable<String> in
                let controller = ScanController(true)
                controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.navigationController?.present(controller, animated: true, completion: nil)
                return controller.dataSubject.catch { error in
                    return Observable.empty()
                }
            }.subscribe(onNext: {value in
                self.addressV.textF.text = value
        }).disposed(by: disposeBag)
        memoV.scanBtn.rx.tap
            .flatMap { value -> Observable<String> in
                let controller = ScanController(true)
                controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.navigationController?.present(controller, animated: true, completion: nil)
                return controller.dataSubject.catch { error in
                    return Observable.empty()
                }
            }.subscribe(onNext: {value in
                self.memoV.textF.text = value
        }).disposed(by: disposeBag)
        
        //MARK: 选择主网
        let tapNetwork = UITapGestureRecognizer()
        self.mainNetV.bgView.addGestureRecognizer(tapNetwork)
        tapNetwork.rx.event.flatMap { value -> Observable<Int> in
            let networkView = TransferNetworkView.loadNetworkView(view: self.view.window!,isSend: true)
            return networkView.dataSubject
        }.subscribe(onNext: {value in
//            self.mainNetV.contentLab.text = value
            print(value)
        }).disposed(by: disposeBag)
    }
}
//MARK: ui
extension WithDrawViewController{
    func setUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(titleLab)
        scrollView.addSubview(detailLab)
        scrollView.addSubview(addressV)
        scrollView.addSubview(mainNetV)
        scrollView.addSubview(memoV)
        scrollView.addSubview(amountV)
        scrollView.addSubview(tipLab)
        scrollView.addSubview(msgIcon1)
        scrollView.addSubview(mssageLab1)
        scrollView.addSubview(msgIcon2)
        scrollView.addSubview(mssageLab2)
    }
    func initSubViewsConstraints(){
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
            make.bottom.equalToSuperview().offset(-SafeAreaBottom)
        }
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(12)
        }
        addressV.snp.makeConstraints { make in
            make.width.equalTo(SCREEN_WIDTH)
            make.left.right.equalToSuperview()
            make.top.equalTo(detailLab.snp.bottom).offset(40)
        }
        mainNetV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(addressV.snp.bottom).offset(20)
        }
        memoV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainNetV.snp.bottom).offset(20)
        }
        amountV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(memoV.snp.bottom).offset(20)
        }
        tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(amountV.snp.bottom).offset(30)
        }
        msgIcon1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(tipLab.snp.bottom).offset(22)
            make.width.height.equalTo(4)
        }
        mssageLab1.snp.makeConstraints { make in
            make.left.equalTo(msgIcon1.snp.right).offset(2)
            make.top.equalTo(msgIcon1.snp.centerY).offset(-8)
            make.right.equalToSuperview().offset(-LR_Margin)
        }
        msgIcon2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(mssageLab1.snp.bottom).offset(18)
            make.width.height.equalTo(4)
        }
        mssageLab2.snp.makeConstraints { make in
            make.left.equalTo(msgIcon2.snp.right).offset(2)
            make.top.equalTo(msgIcon2.snp.centerY).offset(-8)
            make.right.equalToSuperview().offset(-LR_Margin)
            make.bottom.equalToSuperview()
        }
    }
}
