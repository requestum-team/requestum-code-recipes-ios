//
//  ImagePicker.swift
//  TownApp
//
//  Created by Alex Kovalov on 11/26/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit

final class ImagePicker: NSObject {
    
    enum Result {
        case success(originalImage: UIImage, editedImage: UIImage?)
        case noValue
        case denied(errorMessage: String)
        case remove
        case cancel
    }
    
    enum ErrorType: Error {
        case denied(errorMessage: String)
    }
    
    typealias Completion = (_ result: Result) -> Void
    
    fileprivate var completion: Completion?
    
    func presentInViewController(_ viewController: UIViewController, isEditable: Bool, sourceType: UIImagePickerController.SourceType, completion: @escaping Completion) {
        self.completion = completion
        

        let presentImagePickerClosure = { [unowned self] (sourceType: UIImagePickerController.SourceType) in
            do {
                try self.presentImagePickerInViewController(viewController, isEditable: isEditable, source: sourceType)
            } catch let error as ImagePicker.ErrorType {
                
                switch error {
                case .denied(let errorMessage):
                    self.completion?(Result.denied(errorMessage: errorMessage))
                    AlertsManager.showMediaSettingsAlert()
                    self.completion = nil
                }
                
            } catch _ {
                self.completion?(Result.cancel)
                self.completion = nil
            }
        }
        
        presentImagePickerClosure(sourceType)
    }
    
    fileprivate func presentImagePickerInViewController(_ viewController: UIViewController, isEditable: Bool, source: UIImagePickerController.SourceType) throws {
        
        guard source == .photoLibrary || (source == .camera && UIImagePickerController.isSourceTypeAvailable(.camera))  else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = isEditable
        imagePicker.sourceType = source
        
        switch source {
        case .camera:

            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            guard status != .restricted && status != .denied  else {
                throw ErrorType.denied(errorMessage: NSLocalizedString("DISABLED_CAMERA_ACCESS_MESSAGE", comment: ""))
            }
            
            imagePicker.showsCameraControls = true
            imagePicker.cameraCaptureMode = .photo
            imagePicker.cameraDevice = .rear
            viewController.present(imagePicker, animated: true, completion: nil)
            
        case .photoLibrary, .savedPhotosAlbum:
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                 viewController.present(imagePicker, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    guard status != .restricted && status != .denied  else {
                        return
                    }
                    DispatchQueue.main.async {
                        viewController.present(imagePicker, animated: true, completion: nil)
                    }
                }
            case .denied, .restricted:
                 throw ErrorType.denied(errorMessage: NSLocalizedString("DISABLED_CAMERA_ACCESS_MESSAGE", comment: ""))
            }
        @unknown default:
            break
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            completion?(Result.success(originalImage: originalImage, editedImage: info[UIImagePickerController.InfoKey.editedImage] as? UIImage))
            completion = nil
        } else {
            completion?(Result.noValue)
            completion = nil
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(Result.cancel)
        completion = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
