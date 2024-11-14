//  LoginViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 19/08/22.

import UIKit

protocol LoginViewModelDelegate : AnyObject {
    func loginSuccessCalled(_ success: String, _ token: String, _ name: String, _ userId: Int, _ email: String)
    func loginErrorCalled(_ error: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    var okBtn = [ButtonText.ok.text]
    
    init(_ delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Handle Check box Remember Me
    func handleCheckBox(handler : inout Bool, checkBox : inout UIImageView) {
        handler = !handler
        let resultChecker = self.toggleCheckBox(value: handler)
        checkBox.image = resultChecker
    }
    
    func toggleCheckBox(value: Bool) -> UIImage {
        if value {
            LocalStore.shared.isRemember = true
            return Images.check.name
        } else {
            LocalStore.shared.isRemember = false
            return Images.uncheck.name
        }
    }
    
    // MARK: - Check Empty TextFields
    func checkEmptyFields(_ view: UIView, _ email: String, _ password: String, _ authorizationKey: String, _ authenticationType: String) {
        if (email.isEmpty || password.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            // Check Invalid TextFields
            let checkEmailValid = email.isEmailValid
            //let checkPassValid = password.isPasswordValid
            
            if (!checkEmailValid) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
            } else if (password.count < 8) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passwordValid.localizedDescription, buttons: okBtn, completion: nil)
            }
//          else if (!checkPassValid) {
//              UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passwordValid.localizedDescription, buttons: okBtn, completion: nil)
//          }
            else {
                loginApi(view, email, password, authorizationKey, authenticationType)
            }
        }
    }
    
    // MARK: - Login Api
    func loginApi(_ view: UIView, _ email: String, _ password: String, _ authorizationKey: String, _ authenticationType: String) {
        ApiStore.shared.loginApi(view, email, password, authorizationKey, authenticationType) { responseModel in
            if responseModel.model != nil {
                responseModel.model?.isEmailVerified == false
                ? (UIAlertController.showAlert(AppAlerts.alert.title, message: (AppErrors.confirmEmail.localizedDescription), buttons: self.okBtn, completion: nil))
                : (self.delegate?.loginSuccessCalled(AppAlerts.loginSuccess.title, (responseModel.model?.token)!, ((responseModel.model?.firstName)! + " " + (responseModel.model?.lastName)!), (responseModel.model?.userAccountID)!, (responseModel.model?.email)!))
            } else {
                self.delegate?.loginErrorCalled(responseModel.message!)
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension LoginViewModelDelegate {
    func loginSuccessCalled(_ success: String, _ token: String, _ name: String, _ userId: Int, _ email: String) {
    }
    func loginErrorCalled(_ error: String) {
    }
}
