//
//  ChangPhoneSecurityVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/6.
//

import UIKit

class ChangPhoneSecurityVC: BaseViewController {
    
    lazy var commitBtn :UIButton = {
        let btn = UIButton()
        btn.setTitle("tv_commit".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .selected)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "btn_selected"), for: .selected)
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = FONTB(size: 16)
//        btn.addTarget(self, action: #selector(tapCommitBtn), for: .touchUpInside)
        return btn
    }()
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLab.text = "安全验证"
        setUI()
        initSubViewsConstraints()
    }

}
// MARK: - UI
extension ChangPhoneSecurityVC{
    func setUI() {
        view.addSubview(commitBtn)
        view.addSubview(scrollView)
        
    }
    func initSubViewsConstraints() {
        commitBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-83)
            make.height.equalTo(40)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
            make.bottom.equalTo(commitBtn.snp.top).offset(-10)
        }
    }
}
