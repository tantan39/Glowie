//
//  ImagePickerController.swift
//  Bloomr
//
//  Created by Tan Tan on 9/17/19.
//  Copyright © 2019 phdv. All rights reserved.
//
import CropViewController
import MobileCoreServices

enum CameraMode {
    case photo
    case video
}

protocol ImagePickerController {
    func openCamera(from viewController: BaseViewController?)
    func openCamera(from viewController: BaseViewController?, mode: CameraMode?)
}

extension ImagePickerController {
    func openCamera(from viewController: BaseViewController?) {
        guard let parent = viewController else { return }
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.videoQuality = .typeMedium
            imagePicker.allowsEditing = false
            imagePicker.delegate = parent as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            parent.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamera(from viewController: BaseViewController?, mode: CameraMode? = .photo) {
        guard let parent = viewController else { return }
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            if mode == .video {
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.cameraCaptureMode = .video
            }
            imagePicker.videoQuality = .typeMedium
            imagePicker.allowsEditing = false
            imagePicker.delegate = parent as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            parent.present(imagePicker, animated: true, completion: nil)
        }
    }
}
