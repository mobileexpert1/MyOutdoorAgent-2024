//  ContactUsViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol ContactUsViewModelDelegate : AnyObject {
    func successCalled(_ success: String)
    func errorCalled(_ error: String)
}

class ContactUsViewModel {
    
    weak var delegate: ContactUsViewModelDelegate?
    let okBtn = [ButtonText.ok.text]
    
    init(_ delegate: ContactUsViewModelDelegate) {
        self.delegate = delegate
    }
    
    // -- Check Empty TextFields
    func checkEmptyFields(_ view: UIView, _ name: String, _ email: String, _ description: String ,_ Purpose: String ) {
        if (name.isEmpty || email.isEmpty || description.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            // Check Invalid TextFields
            let checkEmailValid = email.isEmailValid
            
            checkEmailValid == false
            ? UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
            : contactUsApi(view, name, email, description ,Purpose)
        }
    }
    
    // -- Contact Us Api
    func contactUsApi(_ view: UIView, _ name: String, _ email: String, _ description: String,  _ Purpose: String) {
        ApiStore.shared.contactUsApi(view, name, email, description, Purpose) { responseModel in
            responseModel.statusCode == 200
            ? (self.delegate?.successCalled(responseModel.message!))
            : (self.delegate?.errorCalled(responseModel.message!))
        }
    }
}

//MARK: - Optional Delegates Defination
extension ContactUsViewModelDelegate {
    func successCalled(_ success: String) {
    }
    func errorCalled(_ error: String) {
    }
}


