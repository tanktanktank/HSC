//
//  KlineIndexCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/6.
//

import UIKit

class KlineIndexCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var vColor: UIView!
    
    @IBOutlet weak var btnLine: UIButton!
    @IBOutlet weak var btnColor: UIButton!
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblShow: UILabel!
    
    @IBOutlet weak var txfNum: UITextField!
    @IBOutlet weak var ivColor: UIImageView!
    @IBOutlet weak var ivLineWidth: UIImageView!
    private var disposeBag = DisposeBag()
    
    var top : CGFloat = 0
    var model : KlineIndexModel!{
        didSet{
            self.lblShow.text = model.show
            self.txfNum.text = String(model.num)

            let updateImageStr = "block_"+model.color
            self.ivColor.image = UIImage.init(named: updateImageStr)
            self.ivLineWidth.image = UIImage.init(named: "line_grey_" + String(model.line))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let tem = Int(self.txfNum.text!)
        model.num = tem!
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let tem = Int(self.txfNum.text!)
        model.num = tem!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.txfNum.delegate = self
        
        //MARK: 选择线条
        let tapLine = UITapGestureRecognizer()
        self.vLine.addGestureRecognizer(tapLine)
        tapLine.rx.event
            .flatMap({ value -> Observable<Any> in
                self.btnLine.isSelected = true
                let loadView = SelectKLineView.loadSelectLineView(top: self.top)
                //line_grey_0
                loadView.passLineW = {[weak self] updateWidthStr in
                    
                    self?.ivLineWidth.image = UIImage.init(named: "line_grey_" + updateWidthStr)
                    self?.model.line = Int(updateWidthStr)!
                    loadView.removeFromSuperview()
                }
                return loadView.dataSubject.catch { error in
                    self.btnLine.isSelected = false
                    return Observable.empty()
                }
            })
            .subscribe(onNext: { recognizer in
                self.btnLine.isSelected = false
            })
            .disposed(by: self.disposeBag)
        
        //MARK: 选择颜色
        let tapColor = UITapGestureRecognizer()
        self.vColor.addGestureRecognizer(tapColor)
        tapColor.rx.event
            .flatMap({ value -> Observable<Any> in
                self.btnColor.isSelected = true
                let loadView = SelectColorView.loadSelectColorView(top: self.top)
                loadView.passColor = {[weak self] updateColorStr in
                    
                    self?.ivColor.image = UIImage.init(named: "block_"+updateColorStr)
                    self?.model.color = updateColorStr
                    loadView.removeFromSuperview()
                }
                return loadView.dataSubject.catch { error in
                    self.btnColor.isSelected = false
                    return Observable.empty()
                }
            })
            .subscribe(onNext: { recognizer in
                self.btnColor.isSelected = false
            })
            .disposed(by: self.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
