//
//  UserCerCameraVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/27.
//

import UIKit

class UserCerCameraVC: BaseViewController {
    
    var frontBtn = UIButton()
    var reverseBtn = UIButton()
    var videoType = 1 //1 上传身份证，2 上传视频
    let camera = HSCamera()
    var currentImageType = 0 //0正面、1反面、2视频
    let viewM = UserCerViewModel()
    var reqAdvanceM = ReqUserAdvanceM()
    var videoPath:URL?
    ///证件类型 1.身份证 2.护照 3.驾照
    var cardType = "1"
    var cardName = ""
    var videoCode = ""
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewM.delegate = self
        camera.delegate = self
        camera.imagePickerVC = self
        setupConstraints()
        setupUI()
        setupEvent()
        reqData()
    }
    
    
    func setupEvent(){
        
        preBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    
        frontBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                if(self?.videoType == 2){
//                    self?.camera.showCamera()
                    self?.currentImageType = 2
                    let lxCameraVC = LXFCameraController()
                    lxCameraVC.shootCompletionBlock = {[weak self] videoUrl,videoTimeLength,thumbnailImage,videoError in
                        
                        if(videoError == nil){
                            self?.frontBtn.setImage(thumbnailImage, for: .normal)
                            self?.frontBtn.isSelected = true
                            self?.videoPath = videoUrl
                            self?.dismiss(animated: true)
                            
                            let upLoadingView = self!.frontBtn.viewWithTag(1024) as! UserUploadingView
                            let bgView = self!.frontBtn.viewWithTag(1025)
                            let tipLab = self!.frontBtn.viewWithTag(1026)
                            bgView?.isHidden = false
                            upLoadingView.isHidden = false
                            tipLab?.isHidden = true
                            upLoadingView.show()
                            /// upload video
                            let videoUrl = self?.videoPath
                            let videoData = NSData.init(contentsOf: videoUrl!)
                            NetWorkRequest(UserCerApi.uploadKYCVideo(video: videoData ?? NSData())) {[weak self] responseInfo in
                                upLoadingView.finish()
                                let dict : [String : Any] = responseInfo as! [String : Any]
                                self?.reqAdvanceM.IdCardVideo = dict["filepath"] as! String
                            } failedWithCode: { msg, code in
                                HudManager.showError(msg)
                            }
                            
                        }
                    }
                    lxCameraVC.readCode = self?.videoCode
                    lxCameraVC.modalPresentationStyle = .fullScreen
                    self?.present(lxCameraVC, animated: true)
                }else{
                    self?.camera.showCamera()
                    self?.currentImageType = 0
                }

            }).disposed(by: disposeBag)
        reverseBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.camera.showCamera()
                self?.currentImageType = 1
            }).disposed(by: disposeBag)
        
        confirmBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                
                if(self?.videoType == 2){
                    
                    if(self!.frontBtn.isSelected){
                        
                        self!.reqAdvanceM.VerifyType = 2//TODO: 修改认证类型为动态设置，，，活体验证做判断
                        self!.viewM.reqPostUserAdvanceInfo(reqModel: self!.reqAdvanceM) {}
                    }else{
                        HudManager.showInfo("请录制视频")
                    }
                    print("upload video")
                    return
                }
                if(self!.frontBtn.isSelected){
                }else{
                    return
                }
                if(self!.reverseBtn.isSelected){
                }else{
                    return
                }
                let cameraVC = UserCerCameraVC()
                cameraVC.videoType = 2
                cameraVC.reqAdvanceM = self!.reqAdvanceM
                cameraVC.cardType = self!.cardType
                cameraVC.cardName = self!.cardName
                self?.navigationController?.pushViewController(cameraVC, animated: true)

            }).disposed(by: disposeBag)
    }
    
    func reqData(){
        
        if(self.videoType == 2){
            
            viewM.getVideoCode()
        }
    }
    
    
    func setupUI(){
        
        view.addSubview(idLabel)
        if(videoType == 1){
            let tipVMaxY = createCardTipLab(beginY: idLabel.maxY + 30)
            let temV = createCamareSub(imageName: "UserCerCameraFront", name: "上传" + self.cardName + "正面", content: "请保持照片中" + self.cardName + "显示完整字体清晰可见，亮度均匀")
            temV.frame =  CGRect(x: 15, y: tipVMaxY + 30, width: SCREEN_WIDTH - 30, height: 91)
            let temV2 = createCamareSub(imageName: "UserCerCameraReverse", name: "上传" + self.cardName + "反面", content: "请保持照片中" + self.cardName + "显示完整字体 清晰可见，亮度均匀")
            temV2.frame =  CGRect(x: 15, y: temV.maxY + 30, width: SCREEN_WIDTH - 30, height: 91)
            view.addSubview(confirmBtn)
            view.addSubview(preBtn)
        }else{
            
            idLabel.text = "实名认证"
            view.addSubview(videoTipLab)
            let temV = createCamareVideoSub(imageName: "UserCerRecord", name: "录制视频")
            let temV2 = createCamareVideoSub(imageName: "UserCerDemo", name: "示例姿势")
            temV.frame =  CGRect(x: 0, y: videoTipLab.maxY + 15, width: SCREEN_WIDTH, height: temV.height)
            temV2.frame =  CGRect(x: 0, y: temV.maxY + 30, width: SCREEN_WIDTH , height: temV2.height)
            view.addSubview(confirmBtn)
        }
    }
    
    func setupConstraints(){
        
        idLabel.frame = CGRect(x: 12, y: 9, width: 92, height: 30)
        if(self.videoType == 1){
            preBtn.frame = CGRect(x: 15, y: view.height - 47 - 83 - (is_iPhoneXSeries() ? 54 : 0), width: 84, height: 47)
            confirmBtn.frame = CGRect(x: preBtn.maxX + 15, y: view.height - 47 - 83 - (is_iPhoneXSeries() ? 54 : 0), width: view.width - (preBtn.maxX + 30), height: 47)
        }else{
            videoTipLab.frame = CGRect(x: 15, y: idLabel.maxY + 30, width: SCREEN_WIDTH - 30, height: 80)
            confirmBtn.frame = CGRect(x: 15, y: view.height - 47 - 83 - (is_iPhoneXSeries() ? 54 : 0), width: view.width - 30, height: 47)
            confirmBtn.setTitleColor(UIColor.hexColor("1e1e1e"), for: .normal)
            confirmBtn.backgroundColor = UIColor.hexColor("fcd283")
            confirmBtn.isEnabled = true
        }
    }
    
    func createCardTipLab(beginY: CGFloat) -> CGFloat{
        
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 0, y: beginY, width: SCREEN_WIDTH, height: 36)
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = "上传个人" + self.cardName
        lab.frame = CGRect(x: 15, y: 0 , width: 250, height: 20)
        
        let lab2 = UILabel()
        lab2.font = UIFont.systemFont(ofSize: 11)
        lab2.textColor = UIColor.hexColor("989898")
        lab2.text = "认证通过后资料不可修改，平台会保护你的个人信息"
        lab2.frame = CGRect(x: 15, y: lab.maxY , width: 320, height: 16)
        
        fatherV.addSubview(lab)
        fatherV.addSubview(lab2)
        view.addSubview(fatherV)
        
        return fatherV.maxY
    }
    
    func createCamareSub(imageName: String, name: String, content: String) -> UIView{
        
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: 91)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 148, height: fatherV.height)
        btn.imageView?.contentMode = .scaleAspectFill
        
        let bgView = UIView()
        bgView.frame = btn.bounds
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        bgView.isUserInteractionEnabled = false
        bgView.isHidden = true
        bgView.tag = 1025
        btn.addSubview(bgView)
        let loadingWH = 48.0
        let loadingV = UserUploadingView(frame: CGRect(x: (btn.width - loadingWH) * 0.5, y: (btn.height - loadingWH) * 0.5, width: loadingWH, height: loadingWH))
        loadingV.isUserInteractionEnabled = false
        loadingV.backLineColor = UIColor.hexColor("989898")
        loadingV.progressColor = UIColor.hexColor("fcd283")
        loadingV.textLabel.textColor = UIColor.hexColor("fcd283")
        loadingV.isHidden = true
        loadingV.tag = 1024
        btn.addSubview(loadingV)
        if(name == "上传" + self.cardName + "正面"){
            self.frontBtn = btn
        }else{
            self.reverseBtn = btn
        }
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = name
        lab.frame = CGRect(x: btn.maxX + 17, y: 13 , width: fatherV.width - (btn.maxX + 17), height: 20)
        
        let lab2 = UILabel()
        lab2.font = UIFont.systemFont(ofSize: 12)
        lab2.textColor = UIColor.hexColor("989898")
        lab2.text = content
        lab2.numberOfLines = 0
        lab2.frame = CGRect(x: btn.maxX + 17, y: lab.maxY + 12 , width: lab.width, height: 34)
        
        
        fatherV.addSubview(btn)
        fatherV.addSubview(lab)
        fatherV.addSubview(lab2)
        view.addSubview(fatherV)
        return fatherV
    }
    
    func createCamareVideoSub(imageName: String, name: String) -> UIView{
        
        let fatherV = UIView()
        fatherV.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 121)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.frame = CGRect(x: fatherV.width - 196 - 58, y: 0, width: 196, height: 121)
        
        let bgView = UIView()
        bgView.frame = btn.bounds
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        bgView.isUserInteractionEnabled = false
        bgView.isHidden = true
        bgView.tag = 1025
        btn.addSubview(bgView)
        let loadingWH = 48.0
        let loadingV = UserUploadingView(frame: CGRect(x: (btn.width - loadingWH) * 0.5, y: (btn.height - loadingWH) * 0.5, width: loadingWH, height: loadingWH))
        loadingV.isUserInteractionEnabled = false
        loadingV.backLineColor = UIColor.hexColor("989898")
        loadingV.progressColor = UIColor.hexColor("fcd283")
        loadingV.textLabel.textColor = UIColor.hexColor("fcd283")
        loadingV.isHidden = true
        loadingV.tag = 1024
        btn.addSubview(loadingV)
        if(name == "录制视频"){
            self.frontBtn = btn
            
            let recordTipbtn = UIButton(type: .custom)
            recordTipbtn.setTitle("点击录制", for: .normal)
            recordTipbtn.setTitleColor(UIColor.hexColor("ffffff"), for: .normal)
            recordTipbtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            recordTipbtn.backgroundColor = UIColor.hexColor("bebebe").withAlphaComponent(0.15)
            recordTipbtn.layer.cornerRadius = 4
            recordTipbtn.isUserInteractionEnabled = false
            recordTipbtn.frame = CGRect(x: (btn.width - 68) * 0.5 , y: (btn.height - 26) * 0.5, width: 68, height: 26)
            recordTipbtn.tag = 1026
            btn.addSubview(recordTipbtn)
        }else{
            self.reverseBtn = btn
            self.reverseBtn.isUserInteractionEnabled = false
            self.reverseBtn.isEnabled = false
        }
        
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("ffffff")
        lab.text = name
        lab.sizeToFit()
        lab.frame = CGRect(x: 15, y: (fatherV.height - 20) * 0.5 ,width: lab.width, height: 20)
        
        fatherV.addSubview(btn)
        fatherV.addSubview(lab)
        view.addSubview(fatherV)
        return fatherV
    }
    
    
    lazy var videoTipLab: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.hexColor("989898")
        lab.text = "请拿出本人手机与" + self.cardName + "件准备拍摄录像,录像时请单手确保麦克风音量、吐字清晰、声音洪亮,确保朗读内容与屏燕内容相同,录制后上传时可能需要1-2分钟,请耐心等待。"
        lab.numberOfLines = 0
        return lab
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("tv_continue".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("2d2d2d")
        btn.layer.cornerRadius = 4
        btn.isEnabled = false
        return btn
    }()
    
    lazy var preBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("上一步", for: .normal)
        btn.setTitleColor(UIColor.hexColor("989898"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //UIFont(name: "PingFang SC-Bold", size: 16)
        btn.backgroundColor = UIColor.hexColor("2d2d2d")
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var idLabel: UILabel = {
       
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 22) //UIFont(name: "PingFang SC-Bold", size: 22)
        lab.textColor = .white
        lab.text = "身份认证"
        lab.frame = CGRect(x: 12, y: 0, width: 92, height: 30)
        return lab
    }()
}

extension UserCerCameraVC: HSCameraDelegate{
    
    func cameraForChooseImage(image: UIImage) {
        
        if(self.currentImageType == 0){
            self.frontBtn.setImage(image, for: .normal)
            self.frontBtn.isSelected = true
            
            let upLoadingView = self.frontBtn.viewWithTag(1024) as! UserUploadingView
            let bgView = self.frontBtn.viewWithTag(1025)
            bgView?.isHidden = false
            upLoadingView.isHidden = false
            upLoadingView.show()
            NetWorkRequest(UserCerApi.uploadKYCImg(image: (self.frontBtn.imageView?.image!)!)) {[weak self] responseInfo in
                upLoadingView.finish()
                
                let dict : [String : Any] = responseInfo as! [String : Any]
                self?.reqAdvanceM.IdCardImage1 = dict["filepath"] as! String
                
                if(self!.reverseBtn.isSelected){
                    self!.confirmBtn.isEnabled = true
                    self!.confirmBtn.backgroundColor = UIColor.hexColor("fcd283")
                    self!.confirmBtn.setTitleColor(UIColor.hexColor("1e1e1e"), for: .normal)
                }
            } failedWithCode: { msg, code in
                HudManager.showError(msg)
            }
            
        }else if(self.currentImageType == 1){
            self.reverseBtn.setImage(image, for: .normal)
            self.reverseBtn.isSelected = true
            
            let upLoadingView = self.reverseBtn.viewWithTag(1024) as! UserUploadingView
            let bgView = self.reverseBtn.viewWithTag(1025)
            bgView?.isHidden = false
            upLoadingView.isHidden = false
            upLoadingView.show()
            NetWorkRequest(UserCerApi.uploadKYCImg(image: (self.reverseBtn.imageView?.image!)!)) {[weak self] responseInfo in
                upLoadingView.finish()

                let dict : [String : Any] = responseInfo as! [String : Any]
                self?.reqAdvanceM.IdCardImage2 = dict["filepath"] as! String
                
                if(self!.frontBtn.isSelected){
                    self!.confirmBtn.isEnabled = true
                    self!.confirmBtn.backgroundColor = UIColor.hexColor("fcd283")
                    self!.confirmBtn.setTitleColor(UIColor.hexColor("1e1e1e"), for: .normal)
                }
            } failedWithCode: { msg, code in
                HudManager.showError(msg)
            }
            

        }
    }
    
    func cameraForChooseVideo(videoPath: String) {}
}

extension UserCerCameraVC : UserCerViewMDelegate{
    
    func getUserCerInfoSuccess() {
        
        let userCerResultVC = UserCerResultVC()
        self.navigationController?.pushViewController(userCerResultVC, animated: true)
    }
    
    func getVideoCodeSuccess(code: String) {
        self.videoCode = code
    }
}

extension UserCerCameraVC{
    
    func getVideoFirstViewImage(videoPath: String) -> UIImage{
        
        let url = URL(fileURLWithPath: videoPath)
        let asset:AVURLAsset = AVURLAsset.init(url: url)
        let assetGen = AVAssetImageGenerator(asset: asset)
        assetGen.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 0, timescale: 600)
//        var actualTime : CMTime = CMTimeMakeWithSeconds(0, 0)
        var actualTime:CMTime = .zero
        if let cgImage = try? assetGen.copyCGImage(at: time, actualTime: &actualTime) {
            let image = UIImage(cgImage: cgImage)
            return image
        }
        return UIImage()
    }

}


