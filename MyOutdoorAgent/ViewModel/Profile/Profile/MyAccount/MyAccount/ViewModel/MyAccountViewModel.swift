//  MyAccountViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol MyAccountViewModelDelegate : AnyObject {
    func editProfileSuccessCalled(_ success: String)
    func editProfileErrorCalled(_ error: String)
    func logOutSuccessCalled()
    func logOutErrorCalled(_ error: String)
    func changePassSuccessCalled(_ success: String)
    func changePassErrorCalled(_ error: String)
    func getStatesSuccessCalled()
    func getStatesErrorCalled(_ error: String)
}

class MyAccountViewModel {
    
    weak var delegate: MyAccountViewModelDelegate?
    var okBtn = [ButtonText.ok.text]
    var editUserProfileModel : EditUserProfileModel?
    var getAllStatesArr = [GetAllStatesModelClass]()
    
    init(_ delegate: MyAccountViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Check Empty TextFields
    func changePassValid(_ view: UIView, _ currentPass: String, _ newPass: String, _ confirmPass: String) {
        if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        }
        else {
            //let checkPassValid = newPass.isPasswordValid
            
//            if (!checkPassValid) {
//                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passwordValid.localizedDescription, buttons: okBtn, completion: nil)
//            }
            if (newPass.count < 8) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passwordValid.localizedDescription, buttons: okBtn, completion: nil)
            } else if (newPass != confirmPass) {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.passNotMatch.localizedDescription, buttons: okBtn, completion: nil)
            } else {
                changePassApi(view, currentPass, newPass)
            }
        }
    }
    
    // MARK: - Check Validations in Edit Profile Api
    func checkValidationsProfile(_ view: UIView, _ firstName: String, _ lastName: String, _ streetAddress : String, _ city : String, _ st : String, _ zip : String, _ phone : String, _ clubName: String) {
        if (firstName.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.firstNameReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (lastName.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.lastNameReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (streetAddress.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.addressReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (city.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.cityReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (st.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.stateReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (phone.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.phoneReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (!phone.isValidMobile) || ((phone.count) < 10){
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validPhone.localizedDescription, buttons: okBtn, completion: nil)
        } else if ((zip.count) < 5) || ((zip.count) == 0){
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.zipLength.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            editUserProfileApi(view, firstName, lastName, streetAddress, city, st, zip, phone, clubName) { _ in
            }
        }
    }
    
    // MARK: - Edit User Profile Api
    func editUserProfileApi(_ view: UIView, _ firstName: String, _ lastName: String, _ streetAddress : String, _ city : String, _ st : String, _ zip : String, _ phone : String, _ clubName: String, completion : @escaping(EditUserProfileModel) -> Void) {
        ApiStore.shared.editUserProfileApi(view, LocalStore.shared.userProfileId, LocalStore.shared.userAccountId, firstName, lastName, streetAddress, city, st, zip, phone, clubName, clubName, LocalStore.shared.email, LocalStore.shared.getNotifications, LocalStore.shared.authenticationType, LocalStore.shared.isUserProfileComplete, EMPTY_STR, 1) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.editUserProfileModel = responseModel
                self.delegate?.editProfileSuccessCalled(AppAlerts.profileUpdate.title)
                completion(self.editUserProfileModel!)
            } else {
                self.delegate?.editProfileErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Get all states Api
    func getAllStatesApi(_ view: UIView, completion : @escaping([GetAllStatesModelClass]) -> Void) {
        ApiStore.shared.getAllStatesApi(view) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.getAllStatesArr = responseModel.model!
                self.delegate?.getStatesSuccessCalled()
                completion(self.getAllStatesArr)
            } else {
                self.delegate?.getStatesErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Change Password Api
    func changePassApi(_ view: UIView, _ password: String, _ newPassword: String) {
        ApiStore.shared.changePassApi(view, password, newPassword) { responseModel in
            print(responseModel)
            
            responseModel.statusCode == 200
            ? self.delegate?.changePassSuccessCalled(AppAlerts.changePassword.title)
            : self.delegate?.changePassErrorCalled(responseModel.message!)
        }
    }
    
    // MARK: - LogOut Alert
    func logOutAlert(_ view: UIView) {
        let btns = [ButtonText.yes.text, ButtonText.no.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppAlerts.logOutAlert.title, buttons: btns) { alert, index in
            if index == 0 {
                LocalStore.shared.navigationScreen = ""
                self.logoutApi(view)
            }
        }
    }
    
    // MARK: - Logout Api
    func logoutApi(_ view: UIView) {
        ApiStore.shared.logoutApi(view) { responseModel in
            print(responseModel)
            responseModel.statusCode == 200
            ? self.delegate?.logOutSuccessCalled()
            : self.delegate?.logOutErrorCalled(responseModel.message!)
        }
    }
}

//MARK: - Optional Delegates Defination
extension MyAccountViewModelDelegate {
    func editProfileSuccessCalled(_ success: String) {
    }
    func editProfileErrorCalled(_ error: String) {
    }
    func logOutSuccessCalled() {
        LocalStore.shared.navigationScreen = ""
    }
    func logOutErrorCalled(_ error: String) {
    }
    func changePassSuccessCalled(_ success: String) {
    }
    func changePassErrorCalled(_ error: String) {
    }
    func getStatesSuccessCalled() {
    }
    func getStatesErrorCalled(_ error: String) {
    }
}
