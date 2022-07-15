//
//  EWDatePickerViewController.swift
//  EWDatePicker
//
//  Created by Ethan.Wang on 2018/8/27.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class EWDatePickerViewController: UIViewController {

    var backDate: ((Date) -> Void)?
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())    //日期类型
    private var yearNum : Int = 2
    var containV:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT-246, width: SCREEN_WIDTH, height: 246))
        view.backgroundColor = .hexColor("1E1E1E")
        return view
    }()
    var backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    var picker: UIPickerView!
//    lazy var endTimeBtn : UIButton = {
//        let btn = UIButton()
//        btn.setTitle("2022-03-02", for: .normal)
//        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
//        btn.titleLabel?.font = FONTM(size: 13)
//        btn.backgroundColor = .hexColor("2D2D2D")
//        btn.layer.cornerRadius = 4
//        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(tapEndTimeBtn), for: .touchUpInside)
//        return btn
//    }()
//    lazy var starTimeBtn : UIButton = {
//        let btn = UIButton()
//        btn.setTitle("2022-03-02", for: .normal)
//        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
//        btn.titleLabel?.font = FONTM(size: 13)
//        btn.backgroundColor = .hexColor("2D2D2D")
//        btn.layer.cornerRadius = 4
//        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(tapStarTimeBtn), for: .touchUpInside)
//        return btn
//    }()
//    lazy var lab : UILabel = {
//        let lab = UILabel()
//        lab.text = "至"
//        lab.textColor = .hexColor("989898")
//        lab.textAlignment = .center
//        lab.font = FONTR(size: 11)
//        return lab
//    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    @objc func tapStarTimeBtn(){
//        let dateString = String(format: "%02ld-%02ld-%02ld", self.picker.selectedRow(inComponent: 0) + (self.currentDateCom.year!), self.picker.selectedRow(inComponent: 1) + 1, self.picker.selectedRow(inComponent: 2) + 1)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//
//    }
//    @objc func tapEndTimeBtn(){
//
//    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        drawMyView()
    }
    // MARK: - Func
    private func drawMyView() {
        self.view.backgroundColor = UIColor.clear
        self.view.insertSubview(self.backgroundView, at: 0)
        self.modalPresentationStyle = .custom//viewcontroller弹出后之前控制器页面不隐藏 .custom代表自定义
        let titleLab = UILabel(frame: CGRect(x: 80, y: 10, width: SCREEN_WIDTH-160, height: 20))
        
        let cancel = UIButton(frame: CGRect(x: 0, y: 10, width: 70, height: 20))
        let sure = UIButton(frame: CGRect(x: SCREEN_WIDTH - 80, y: 10, width: 70, height: 20))
        cancel.setTitle("common_cancel".localized(), for: .normal)
        sure.setTitle("tv_confirm".localized(), for: .normal)
        cancel.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        sure.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        cancel.addTarget(self, action: #selector(self.onClickCancel), for: .touchUpInside)
        sure.addTarget(self, action: #selector(self.onClickSure), for: .touchUpInside)
        cancel.titleLabel?.font = FONTR(size: 12)
        sure.titleLabel?.font = FONTR(size: 12)
        titleLab.text = "起始时间"
        titleLab.textColor = .hexColor("FFFFFF")
        titleLab.font = FONTR(size: 14)
        titleLab.textAlignment = .center
        self.containV.addSubview(cancel)
        self.containV.addSubview(sure)
        self.containV.addSubview(titleLab)
//        self.containV.addSubview(lab)
//        self.containV.addSubview(starTimeBtn)
//        self.containV.addSubview(endTimeBtn)
//        lab.frame = CGRect(x: (SCREEN_WIDTH-80)/2.0, y: titleLab.maxY+10, width: 80, height: 31)
//        starTimeBtn.frame = CGRect(x: 12, y: lab.y, width: lab.x-12, height: lab.height)
//        endTimeBtn.frame = CGRect(x: lab.maxX, y: lab.y, width: starTimeBtn.width, height: lab.height)
        
        picker = UIPickerView(frame: CGRect(x: 0, y: titleLab.maxY+10, width: SCREEN_WIDTH, height: 216))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.clear
        picker.clipsToBounds = true//如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        //创建日期选择器
        self.containV.addSubview(picker)
        self.view.addSubview(self.containV)
        

        self.transitioningDelegate = self as UIViewControllerTransitioningDelegate//自定义转场动画
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
//            self.picker.selectRow(9, inComponent: 0, animated: true)
//            self.picker.reloadComponent(0)
//        }
    }

    // MARK: onClick
    @objc func onClickCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func onClickSure() {
        let dateString = String(format: "%02ld-%02ld-%02ld", self.picker.selectedRow(inComponent: 0) + (self.currentDateCom.year!)-1, self.picker.selectedRow(inComponent: 1) + 1, self.picker.selectedRow(inComponent: 2) + 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        /// 直接回调显示
        if self.backDate != nil {
            self.backDate!(dateFormatter.date(from: dateString) ?? Date())
        }
        /*** 如果需求需要不能选择已经过去的日期
         let dateSelect = dateFormatter.date(from: dateString)
         let date = Date()
         let calendar = Calendar.current
         let dateNowString = String(format: "%02ld-%02ld-%02ld", calendar.component(.year, from: date) , calendar.component(.month, from: date), calendar.component(.day, from: date))

        /// 判断选择日期与当前日期关系
        let result:ComparisonResult = (dateSelect?.compare(dateFormatter.date(from: dateNowString)!))!

        if result == ComparisonResult.orderedAscending {
            /// 选择日期在当前日期之前,可以选择使用toast提示用户.
            return
            }else{
            /// 选择日期在当前日期之后. 正常调用
            if self.backDate != nil{
                self.backDate!(dateFormatter.date(from: dateString) ?? Date())
            }
        }
         */
        self.dismiss(animated: true, completion: nil)
    }
    ///点击任意位置view消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let currentPoint = touches.first?.location(in: self.view)
        if !self.containV.frame.contains(currentPoint ?? CGPoint()) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
// MARK: - PickerViewDelegate
extension EWDatePickerViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearNum
        } else if component == 1 {
            return 12
        } else {
            let year: Int = pickerView.selectedRow(inComponent: 0) + currentDateCom.year!
            let month: Int = pickerView.selectedRow(inComponent: 1) + 1
            let days: Int = howManyDays(inThisYear: year, withMonth: month)
            return days
        }
    }
    private func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH / 3
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {//显示的文字
        var showStr = ""
        if component == 0 {
            showStr = "\((currentDateCom.year!) - (yearNum - 1 - row))\("年")"
        } else if component == 1 {
            showStr = "\(row + 1)\("月")"
        } else {
            showStr = "\(row + 1)\("日")"
        }
        //这里宽度随便给的， 高度也是随便给的 不能比row的高度大，能显示出来就行
        let showLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 34))
        showLabel.textAlignment = .center
        showLabel.textColor = .hexColor("989898")
        showLabel.font = FONTR(size: 18)
        //重新加载label的文字内容
        showLabel.text = showStr
        return showLabel
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//            return "\((currentDateCom.year!) + row)\("年")"
//        } else if component == 1 {
//            return "\(row + 1)\("月")"
//        } else {
//            return "\(row + 1)\("日")"
//        }
//    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            pickerView.reloadComponent(2)
        }
    }
}
// MARK: - 转场动画delegate
extension EWDatePickerViewController:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = EWDatePickerPresentAnimated(type: .present)
        return animated
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = EWDatePickerPresentAnimated(type: .dismiss)
        return animated
    }
}
