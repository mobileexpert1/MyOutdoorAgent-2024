//  ForgotPasswordViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 22/08/22.

import UIKit

protocol ForgotPasswordModelDelegate : AnyObject {
    func successCalled(_ success: String)
    func errorCalled(_ error: String)
    func accountNotExitCalled(_ error: String)
}

class ForgotPasswordViewModel {
    
    weak var delegate: ForgotPasswordModelDelegate?
    var okBtn = [ButtonText.ok.text]
    
    init(_ delegate: ForgotPasswordModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Check Empty TextField
    func checkEmptyFields(_ view: UIView, _ email: String) {
        if !email.isEmpty {
            email.isEmailValid == false
            ? (UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil))
            : (forgotPasswordApi(view, email))
        } else {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.emailReq.localizedDescription, buttons: okBtn, completion: nil)
        }
    }
    
    // MARK: - Forgot Password Api
    func forgotPasswordApi(_ view: UIView, _ email: String) {
        ApiStore.shared.forgotPasswordApi(view, email) { responseModel in
            switch responseModel.statusCode {
            case 200:
                self.delegate?.successCalled(responseModel.message!)
            case 500:
                self.delegate?.accountNotExitCalled(AppErrors.accountNotExit.localizedDescription)
            default:
                self.delegate?.errorCalled(responseModel.message!)
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension ForgotPasswordModelDelegate {
    func successCalled(_ success: String) {
    }
    func errorCalled(_ error: String) {
    }
    func accountNotExitCalled(_ error: String) {
    }
}
