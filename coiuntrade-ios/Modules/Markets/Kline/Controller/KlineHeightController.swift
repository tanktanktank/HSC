//
//  KlineHeightController.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/5.
//

import UIKit

typealias passValue = (CGFloat)->()

class KlineHeightController: BaseViewController {

    let slider = UISlider()
    
    
    
    private var disposeBag = DisposeBag()

    var pass:passValue?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLab.text = "chart_height".localized()
        
        self.view.addSubview(slider)
        slider.snp.makeConstraints { make in

            make.top.equalTo(titleLab.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(27)
            make.right.equalToSuperview().offset(-27)
        }
        
        let lowLabel = UILabel()
        self.view.addSubview(lowLabel)
        lowLabel.text = "index_popup_low".localized()
        lowLabel.textColor = .hexColor("989898")
        lowLabel.font = FONTR(size: 12)
        lowLabel.snp.makeConstraints { make in
            
            make.left.equalTo(slider)
            make.top.equalTo(slider.snp.bottom).offset(15)
            make.height.equalTo(20)
        }

        let highLabel = UILabel()
        self.view.addSubview(highLabel)
        highLabel.text = "index_popup_high".localized()
        highLabel.textColor = .hexColor("989898")
        highLabel.font = FONTR(size: 12)
        highLabel.snp.makeConstraints { make in
            
            make.right.equalTo(slider)
            make.top.equalTo(slider.snp.bottom).offset(15)
            make.height.equalTo(20)
        }

        let defaultLabel = UILabel()
        self.view.addSubview(defaultLabel)
        defaultLabel.text = "default_high".localized()
        defaultLabel.textColor = .hexColor("989898")
        defaultLabel.font = FONTR(size: 12)
        defaultLabel.snp.makeConstraints { make in
            
            make.centerX.equalTo(slider)
            make.top.equalTo(slider.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        
        slider.minimumValueImage = UIImage (named: "klineyuanset")
        slider.maximumValueImage = UIImage (named: "klineyuanno")

        
        let defaults = UserDefaults.standard
        let klineShowHeight = defaults.float(forKey: "KLineShowHeightKey")
        if(klineShowHeight > 0){
            slider.setValue(klineShowHeight, animated: false)
        }
        
        let topImageView = UIImageView(image: UIImage(named: "klineup"))
        topImageView.backgroundColor = .hexColor("2D2D2D")
        let middleView = UIView()
        middleView.backgroundColor = .hexColor("2D2D2D")
        let bottomImageView = UIImageView(image: UIImage(named: "klinedown"))
        bottomImageView.backgroundColor = .hexColor("2D2D2D")

        self.view.addSubview(topImageView)
        self.view.addSubview(middleView)
        self.view.addSubview(bottomImageView)

        topImageView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(defaultLabel.snp.bottom).offset(30)
            make.height.equalTo(181)
        }
        middleView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(topImageView.snp.bottom)
            make.height.equalTo(30)
        }

        bottomImageView.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(middleView.snp.bottom)
            make.height.equalTo(63).multipliedBy(SCREEN_WIDTH / 375.0)
        }


        slider.rx.value.asObservable()
            .subscribe(onNext: { [weak self] value in
                
                var updateValue = CGFloat(value)
                if value < 0.3 {
                    
                    updateValue = 0.3
                }
                let height = SCREEN_WIDTH / (375.0 / (328.0 * updateValue))
                topImageView.snp.updateConstraints { make in
                    
                    make.height.equalTo(height)
                }
                
                let defaults = UserDefaults.standard
                defaults.set(updateValue, forKey: "KLineShowHeightKey")
                let updateResult = (updateValue+0.5) / 1.0
                self?.pass?( updateResult )
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
