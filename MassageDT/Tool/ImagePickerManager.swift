//
//  ImagePickerManager.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/22.
//

import Foundation
import UIKit

typealias ImageCompletionHandler = (UIImage?) -> Void

class ImagePickerManager: NSObject {
    // 闭包属性
    var imageCompletionHandler: ImageCompletionHandler?
    
    static func showImageSelect(_ imageCompletionHandler: @escaping ImageCompletionHandler) -> ImagePickerManager {
        let picker = ImagePickerManager()
        picker.imageCompletionHandler = imageCompletionHandler
        return picker
    }

    private weak var presentingViewController: UIViewController?

    init(presentingViewController: UIViewController? = topViewController()) {
        super.init()
        self.presentingViewController = presentingViewController
    }

    func presentImagePicker() {
        guard let presentingViewController = presentingViewController else {
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false // 设置为 true 允许编辑照片

        presentingViewController.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageCompletionHandler?(selectedImage)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
