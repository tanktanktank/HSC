//
//  ReChargeViewController.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/29.
//

import UIKit

class ReChargeViewController: BaseViewController {
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.bounces = false
        return v
    }()
    lazy var qrCodeV : UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var qrCodeDetailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTR(size: 11)
        lab.textColor = .hexColor("989898")
        lab.textAlignment = .center
        return lab
    }()
    lazy var copyAddressBtn : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = FONTR(size: 14)
        btn.setTitle("tv_copy_address".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.backgroundColor = .hexColor("FCD283")
        btn.corner(cornerRadius: 2)
        return btn
    }()
    lazy var saveQrCodeBtn : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = FONTB(size: 14)
        btn.setTitle("tv_save_qcode".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.backgroundColor = .hexColor("1E1E1E")
        btn.corner(cornerRadius: 2,borderColor:UIColor.hexColor("989898"),borderWidth: 1)
        return btn
    }()
    lazy var line : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var mainNetV : RechargeCellView = {
        let v = RechargeCellView()
        v.titleV.text = "主网".localized()
        v.contentV.text = "Bitcoin"
        v.btn.setImage(UIImage(named: "trchange"), for: .normal)
        return v
    }()
    lazy var addressV : RechargeCellView = {
        let v = RechargeCellView()
        v.titleV.text = "tv_charge_address".localized()
        v.contentV.text = " "
        v.btn.setImage(UIImage(named: "decopy"), for: .normal)
        return v
    }()
    lazy var memoV : RechargeCellView = {
        let v = RechargeCellView()
        v.titleV.text = "MEMO"
        v.contentV.font = FONTDIN(size: 14)
        v.contentV.text = "1515152"
        v.btn.setImage(UIImage(named: "decopy"), for: .normal)
        return v
    }()
    lazy var min_numTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "tv_recharge_min_num".localized()
        return v
    }()
    lazy var rec_numTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "tv_charge_confirm_num".localized()
        return v
    }()
    lazy var draw_numTitle : UILabel = {
        let v = UILabel()
        v.font = FONTR(size: 11)
        v.textColor = .hexColor("989898")
        v.text = "tv_charge_unlock_confirm_num".localized()
        return v
    }()
    lazy var min_num : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "0.00000001 BTC"
        return v
    }()
    lazy var rec_num : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "1区块确认"
        return v
    }()
    lazy var draw_num : UILabel = {
        let v = UILabel()
        v.font = FONTDIN(size: 11)
        v.textColor = .hexColor("FFFFFF")
        v.text = "2区块确认"
        return v
    }()
    var model : CoinModel = CoinModel(){
        didSet{
            self.titleLab.text = "tv_home_desposit".localized() + model.coin
            self.qrCodeDetailLab.text = "tv_recharge_tip".localized() + model.coin
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initSubViewsConstraints()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "wallets_history"), style: .plain, target: self, action: #selector(tapRightNav))
        
        qrCodeV.image = QRcode.createQRCodeByCIFilterWithString("https//www.baidu.com", andImage: UIImage(named: "app_logo") ?? UIImage())
    }
    

}
extension ReChargeViewController{
    @objc func tapRightNav(){
//        let vc = RechageDetaillVC()
//        let vc = WithdrawDetailVC()
        let vc = WithDrawViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: ui
extension ReChargeViewController{
    func setUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(qrCodeV)
        scrollView.addSubview(qrCodeDetailLab)
        scrollView.addSubview(copyAddressBtn)
        scrollView.addSubview(saveQrCodeBtn)
        scrollView.addSubview(line)
        scrollView.addSubview(mainNetV)
        scrollView.addSubview(addressV)
        scrollView.addSubview(memoV)
        scrollView.addSubview(min_numTitle)
        scrollView.addSubview(rec_numTitle)
        scrollView.addSubview(draw_numTitle)
        scrollView.addSubview(min_num)
        scrollView.addSubview(rec_num)
        scrollView.addSubview(draw_num)
    }
    func initSubViewsConstraints(){
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom)
            make.bottom.equalToSuperview().offset(-SafeAreaBottom)
        }
        qrCodeV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(164)
        }
        qrCodeDetailLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(qrCodeV.snp.bottom).offset(12)
        }
        copyAddressBtn.snp.makeConstraints { make in
            make.top.equalTo(qrCodeDetailLab.snp.bottom).offset(12)
            make.right.equalTo(self.view.snp.centerX).offset(-16)
            make.width.equalTo(103)
            make.height.equalTo(39)
        }
        saveQrCodeBtn.snp.makeConstraints { make in
            make.top.equalTo(qrCodeDetailLab.snp.bottom).offset(12)
            make.left.equalTo(self.view.snp.centerX).offset(16)
            make.width.equalTo(103)
            make.height.equalTo(39)
        }
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(copyAddressBtn.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        mainNetV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
        }
        addressV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainNetV.snp.bottom)
        }
        memoV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(addressV.snp.bottom)
        }
        min_numTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(memoV.snp.bottom).offset(20)
        }
        min_num.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(min_numTitle)
        }
        rec_numTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(min_numTitle.snp.bottom).offset(12)
        }
        rec_num.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(rec_numTitle)
        }
        draw_numTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalTo(rec_numTitle.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-10)
        }
        draw_num.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(draw_numTitle)
        }
    }
}
