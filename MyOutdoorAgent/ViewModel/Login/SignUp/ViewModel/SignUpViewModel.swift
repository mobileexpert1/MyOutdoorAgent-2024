//  SignUpViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 19/08/22.

import UIKit

protocol SignUpViewModelDelegate : AnyObject {
    func signUpSuccessCalled(_ success: String, _ token: String, _ name: String)
    func signUpErrorCalled(_ error: String)
    func emailNotVerified(_ error: String)
}

class SignUpViewModel {
    
    weak var delegate : SignUpViewModelDelegate?
    var okBtn = [ButtonText.ok.text]
    
    init(_ delegate: SignUpViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Handle Check box
    func handleCheckBox(handler : inout Bool, checkBox : inout UIImageView, signupView: UIView) {
        handler = !handler
        let resultChecker = self.toggleCheckBox(value: handler, signupView: signupView)
        checkBox.image = resultChecker
    }
    
    func toggleCheckBox(value: Bool, signupView: UIView) -> UIImage {
        if value {
            signupView.isUserInteractionEnabled = true
            signupView.alpha = 1.0
            return Images.check.name
        } else {
            signupView.isUserInteractionEnabled = false
            signupView.alpha = 0.5
            return Images.uncheck.name
        }
    }
    
    // MARK: - Check Empty TextFields
    func checkEmptyFields( _ view: UIView, _ firstname: String, _ lastName: String, _ email: String, _ password: String, _ confirmPassword: String, _ accountType : String, _ authenticationKey: String, _ authenticationType: String, _ sourceClientID: String) {
        if (firstname.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            // Check Invalid TextFields
            let checkEmailValid = email.isEmailValid
            let checkPassValid = password.isPasswordValid
            
            if (!checkEmailValid) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
            } else if (!checkPassValid) || (password.count < 8) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passwordValid.localizedDescription, buttons: okBtn, completion: nil)
            } else if (password != confirmPassword) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passNotMatch.localizedDescription, buttons: okBtn, completion: nil)
            } else {
                registerApi(view, firstname, lastName, email, password, confirmPassword, accountType, authenticationKey, authenticationType, sourceClientID)
            }
        }
    }
    
    // MARK: - Register Api
    func registerApi(_ view: UIView, _ firstname: String, _ lastName: String, _ email: String, _ password: String, _ confirmPassword: String, _ accountType : String, _ authenticationKey: String, _ authenticationType: String, _ sourceClientID: String) {
        ApiStore.shared.registerApi(view, firstname, lastName, email, password, confirmPassword, accountType, authenticationKey, authenticationType, sourceClientID) { responseModel in
            if responseModel.model != nil {
                let name = ((responseModel.model?.firstName)! + " " + (responseModel.model?.lastName)!)
                responseModel.model?.isEmailVerified == false
                ? (self.delegate?.emailNotVerified(AppErrors.confirmEmail.localizedDescription))
                : (self.delegate?.signUpSuccessCalled(AppAlerts.signUpSuccess.title, (responseModel.model?.clientToken)!, name))
            } else {
                self.delegate?.signUpErrorCalled(responseModel.message!)
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension SignUpViewModelDelegate {
    func signUpSuccessCalled(_ success: String, _ token: String, _ name: String) {
    }
    func signUpErrorCalled(_ error: String) {
    }
    func emailNotVerified(_ error: String) {
    }
}
