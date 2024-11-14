//  AccountSettingsImagePicker.swift
//  MyOutdoorAgent
//  Created by CS on 16/09/22.

import UIKit

//MARK: - ImagePicker Delegates
extension AccountSettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // -- Show Image Upload Alert
    func showUploadImgAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: ButtonText.chooseImage.text, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: ButtonText.camera.text, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: ButtonText.gallery.text, style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: ButtonText.cancel.text, style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // -- Open Camera
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: AppAlerts.alert.title, message: AppAlerts.cameraAlert.title, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ButtonText.ok.text, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // -- Open Gallery
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // -- ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            self.imgStr = pickedImage.convertImageToBase64String(img: pickedImage)
            profileImgV.image = pickedImage
            //API HIT
            //self.updateImageOnServer()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

