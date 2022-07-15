//
//  DatePickerView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/18.
//

import UIKit

class DatePickerView: UIView {
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    let dataSubject = PublishSubject<Any>()
    var startTIme : Int = 0
    var endTime : Int = 0
    private var disposeBag = DisposeBag()
    
    class func loadDatePickerView(view:UIWindow) -> DatePickerView {
        let datePickerView = Bundle.main.loadNibNamed("DatePickerView", owner: nil, options: nil)?[0] as! DatePickerView
        datePickerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.addSubview(datePickerView)
        datePickerView.btnEnd.setTitle(DateManager.getDateStringStamp(Date()), for: .normal)
        datePickerView.btnStart.setTitle(DateManager.getDateStringStamp(Date()), for: .normal)
        datePickerView.datePicker.setValue(UIColor.white, forKey: "textColor")
        
        //MARK: 选择时间
        datePickerView.datePicker.addTarget(datePickerView, action: #selector(selectDate(_:)), for: UIControl.Event.valueChanged)
        
        //MARK: 取消
        datePickerView.btnCancel.rx.tap.subscribe(onNext: {
            datePickerView.dataSubject.onError(NSError(domain: "", code: 0))
            datePickerView.removeFromSuperview()
        }).disposed(by: datePickerView.disposeBag)
        
        //MARK: 确定 翻译
        datePickerView.btnConfirm.rx.tap
            .flatMap({ value -> Observable<Any> in
                if datePickerView.startTIme < datePickerView.endTime {
                    HudManager.showOnlyText("起始时间不能大于结束时间")
                    return Observable.empty()
                } else{
                    return Observable.just(0)
                }
            })
            .subscribe(onNext: {value in
                datePickerView.dataSubject.onNext([datePickerView.startTIme,datePickerView.endTime])
                datePickerView.dataSubject.onCompleted()
                datePickerView.removeFromSuperview()
            }).disposed(by: datePickerView.disposeBag)
        
        //MARK: 开始时间
        datePickerView.btnStart.rx.tap.subscribe(onNext: {
            datePickerView.btnEnd.isSelected = false
            datePickerView.btnStart.isSelected = true
        }).disposed(by: datePickerView.disposeBag)
     
        //MARK: 结束时间
        datePickerView.btnEnd.rx.tap.subscribe(onNext: {
            datePickerView.btnEnd.isSelected = true
            datePickerView.btnStart.isSelected = false
        }).disposed(by: datePickerView.disposeBag)
        
        
        return datePickerView
    }
    
    @objc func selectDate(_ datePicker:UIDatePicker){
        let interval = Int(datePicker.date.timeIntervalSince1970)
        if self.btnEnd.isSelected {
            self.endTime = interval
            self.btnEnd.setTitle(DateManager.getDateStringStamp(datePicker.date), for: .normal)
        } else {
            self.startTIme = interval
            self.btnStart.setTitle(DateManager.getDateStringStamp(datePicker.date), for: .normal)
        }
    }
}

