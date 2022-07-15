//
//  HSCameraTool.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/30.
//

import UIKit

public protocol HSCameraDelegate: NSObjectProtocol {

    func cameraForChooseImage(image: UIImage)
    func cameraForChooseVideo(videoPath: String)
}

class HSCamera: NSObject {

    let imagePicker = UIImagePickerController()
    weak var imagePickerVC: UIViewController?
    weak var delegate: HSCameraDelegate?

    func showCamera(){
        
        // 验证相机是否可用
        if !isCameraAvailable() {
            print("相机不可用")
            return
        }
        
        guard let avaliableType = UIImagePickerController.availableMediaTypes(for: .camera) else {
            print("相机无法拍照")
            return
        }
        
//        imagePicker.mediaTypes = avaliableType                  // 选择拍照或视频
        imagePicker.sourceType = .camera                        // 选择调用相机
        imagePicker.delegate = self                             // 选择代理
        imagePickerVC?.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func isCameraAvailable() -> Bool {
        let isCameraAvailable =  UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        return isCameraAvailable
    }
}

//MARK: - < ImagePicker Delegate >
extension HSCamera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
        if type.contains("image") {
            let image = info[UIImagePickerController.InfoKey.originalImage]
            self.delegate?.cameraForChooseImage(image: image as! UIImage)
        }else if type.contains("movie") {
            // 录视频
            let url = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else {
                    print("保存失败")
                    return
                }
                guard let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
                    print("本地路径获取失败")
                    return
                }

                let videoPath = (path as NSString).appendingPathComponent("saveVideo.mp4")
                let url = URL(fileURLWithPath: videoPath)
                (data as NSData).write(to: url, atomically: true)
                self.delegate?.cameraForChooseVideo(videoPath: videoPath)

                
//                UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil)
//                DispatchQueue.main.async {
//                    print("保存成功")
//                }
                }.resume()
        }
    }
}
