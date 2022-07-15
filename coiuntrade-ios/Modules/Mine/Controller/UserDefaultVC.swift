//
//  UserDefaultVC.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/25.
//

import UIKit

class UserDefaultVC: BaseViewController {
    
    /// 懒加载
    lazy var tableView : BaseTableView = {
        let table = BaseTableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .hexColor("1E1E1E")
        table.showsVerticalScrollIndicator = false
        table.register(NickNameCell.self, forCellReuseIdentifier:  NickNameCell.CELLID)
        table.register(UserAvatarCell.self, forCellReuseIdentifier:  UserAvatarCell.CELLID)
        return table
    }()
    lazy var navRightBtn : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        btn.setTitle("tv_save".localized(), for: .normal)
        btn.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
        btn.titleLabel?.font = FONTR(size: 14)
        btn.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
        btn.isSelected = false
        return btn
    }()
    lazy var nickNameCell = NickNameCell(style: .default, reuseIdentifier: NickNameCell.CELLID)
    lazy var userAvatarCell = UserAvatarCell(style: .default, reuseIdentifier: UserAvatarCell.CELLID)
    let viewModel = InfoViewModel()
    
    let info : InfoModel = userManager.infoModel ?? InfoModel()
    
    var head_image = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLab.text = "tv_setting_preference".localized()
        setUI()
        initSubViewsConstraints()
        
    }
}
extension UserDefaultVC{
    ///点击编辑
    @objc func tapSave(){
        navRightBtn.isSelected = !navRightBtn.isSelected
        name = nickNameCell.textV.text ?? ""
        viewModel.userUpdae(nick_name: name, head_image: head_image)
    }
}
extension UserDefaultVC : MineRequestDelegate{
    
    func userUpdaeSuccess(){
        ///保存
        nickNameCell.textV.resignFirstResponder()
        nickNameCell.textV.isUserInteractionEnabled = false
        NotificationCenter.default.post(name: LoginSuccessNotification, object: nil)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UI
extension UserDefaultVC{
    func setUI() {
        viewModel.delegate = self
        let item = UIBarButtonItem(customView: navRightBtn)
        self.navigationItem.rightBarButtonItem = item
        
        head_image = info.user_image
        name = info.nick_name
        
        nickNameCell.textV.text = name
        userAvatarCell.avatarView.kf.setImage(with: URL(string: head_image), placeholder: PlaceholderImg())
        view.addSubview(tableView)
    }
    func initSubViewsConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(15)
        }
    }
}
extension UserDefaultVC : AvatarChooseViewDelegate{
    func selectedHeadImage(model: HeadImageModel) {
        userAvatarCell.avatarView.kf.setImage(with: URL(string: model.Headurl), placeholder: PlaceholderImg())
        head_image = model.Headurl
    }
    
}
// MARK: - UI
extension UserDefaultVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return nickNameCell
        }else {
            return userAvatarCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            nickNameCell.textV.resignFirstResponder()
            let view = AvatarChooseView()
            view.delegate = self
            view.show()
            view.moreClick = {
                let imagePicker = UIImagePickerController.init()
                imagePicker.delegate = self
                imagePicker.modalPresentationStyle = .fullScreen
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
}
// MARK: - 相册选择
extension UserDefaultVC : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)
        let image = info[.originalImage] as! UIImage
        
        let cropperImage = RImageCropperViewController.init(originalImage: image, cropFrame: CGRect.init(x: (kScreenWidth - 339)/2, y: (kScreenHeight - 339)/2, width: 339, height: 339), limitScaleRatio: 30)
        cropperImage.delegate = self
        navigationController?.pushViewController(cropperImage, animated: true)
    }
    
}

extension UserDefaultVC : RImageCropperDelegate {
    func imageCropper(cropperViewController: RImageCropperViewController, didFinished editImg: UIImage) {
        userAvatarCell.avatarView.image = editImg
        HudManager.show()
        NetWorkRequest(InfoApi.uploadimg(image: editImg)) {[weak self] responseInfo in
            HudManager.dismissHUD()
            HudManager.showSuccess("上传成功")
            let dict : [String : Any] = responseInfo as! [String : Any]
            
            self?.head_image = dict["img_url"] as! String
        } failedWithCode: { msg, code in
            HudManager.dismissHUD()
            HudManager.showError(msg)
        }

        cropperViewController.navigationController?.popViewController(animated: false)
    }
    
    func imageCropperDidCancel(cropperViewController: RImageCropperViewController) {
        cropperViewController.navigationController?.popViewController(animated: false)
    }
}
