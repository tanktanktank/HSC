//
//  KlineIndexMaxCell.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/7.
//

import UIKit

class KlineIndexMaxCell: UITableViewCell {
    
    
    @IBOutlet weak var lineImageV: UIImageView!
    @IBOutlet weak var lineBtn: UIButton!
    
    @IBOutlet weak var colorShowView: UIView!
    @IBOutlet weak var colorBtn: UIButton!
    
    @IBOutlet weak var lineWidthView: UIView!
    @IBOutlet weak var colorView: UIView!
    private var disposeBag = DisposeBag()
    var top : CGFloat = 0
    var model : KlineIndexModel!{
        didSet{

            self.updateLineColor()
            self.lineImageV.image = UIImage.init(named: "line_grey_" + String(model.line))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        //MARK: 选择线条
        let tapLine = UITapGestureRecognizer()
        self.lineWidthView.addGestureRecognizer(tapLine)
        tapLine.rx.event
            .flatMap({ value -> Observable<Any> in
                self.lineBtn.isSelected = true
                let loadView = SelectKLineView.loadSelectLineView(top: self.top)
                loadView.centerXLayout.constant -= 48
                loadView.passLineW = {[weak self] updateWidthStr in
                    
                    self?.lineImageV.image = UIImage.init(named: "line_grey_" + updateWidthStr)
                    self?.model.line = Int(updateWidthStr)!
                    loadView.removeFromSuperview()
                }
                return loadView.dataSubject.catch { error in
                    self.lineBtn.isSelected = false
                    return Observable.empty()
                }
            })
            .subscribe(onNext: { recognizer in
                self.lineBtn.isSelected = false
            })
            .disposed(by: self.disposeBag)
        
        //MARK: 选择颜色
        let tapColor = UITapGestureRecognizer()
        self.colorView.addGestureRecognizer(tapColor)
        tapColor.rx.event
            .flatMap({ value -> Observable<Any> in
                self.colorBtn.isSelected = true
                let loadView = SelectColorView.loadSelectColorView(top: self.top)
                loadView.passColor = {[weak self] updateColorStr in
                    
                    self?.model.color = updateColorStr
                    self?.updateLineColor()
                    loadView.removeFromSuperview()
                }
                return loadView.dataSubject.catch { error in
                    self.colorBtn.isSelected = false
                    return Observable.empty()
                }
            })
            .subscribe(onNext: { recognizer in
                self.colorBtn.isSelected = false
            })
            .disposed(by: self.disposeBag)
        
    }
    
    func updateLineColor(){
        
        if(model.color == "yellow"){
            self.colorShowView.backgroundColor = .yellow
        }else if(model.color == "pink"){
            self.colorShowView.backgroundColor = UIColor(red: 255/255.0, green: 192/255.0, blue:  203/255.0, alpha: 1.0)
        }else if(model.color == "purple"){
            self.colorShowView.backgroundColor = .purple
        }else if(model.color == "red"){
            self.colorShowView.backgroundColor = .red
        }else if(model.color == "green"){
            self.colorShowView.backgroundColor = .green
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
