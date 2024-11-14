//  ListYourPropertyViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol ListYourPropertyViewModelDelegate : AnyObject {
    func successCalled(_ success: String)
    func errorCalled(_ error: String)
    func getStatesSuccessCalled()
    func getStatesErrorCalled(_ error: String)
    func dayPassSuccessCalled()
    func dayPassErrorCalled(_ error: String)
}

class ListYourPropertyViewModel {
    
    weak var delegate: ListYourPropertyViewModelDelegate?
    var getAllStatesArr = [GetAllStatesModelClass]()
    var dayPassArr : DayPassModel?
    let okBtn = [ButtonText.ok.text]
    
    init(_ delegate: ListYourPropertyViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Check Empty TextFields
    func checkEmptyFields(_ view: UIView, _ landownerType: String, _ firstName: String, _ lastName: String, _ phone: String, _ email: String, _ address: String, _ city: String, _ state: String, _ zip: String, _ subscriptionType: String) {
        if ((landownerType == "Landowner Type") || (state == "State") || firstName.isEmpty || lastName.isEmpty || phone.isEmpty || email.isEmpty || address.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty || subscriptionType.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (!phone.isValidMobile) || ((phone.count) < 10){
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validPhone.localizedDescription, buttons: okBtn, completion: nil)
        } else if ((zip.count) < 5) || ((zip.count) == 0){
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.zipLength.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            // Check Invalid TextFields
            let checkEmailValid = email.isEmailValid
            
            checkEmailValid == false
            ? UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
            : listYourPropertyApi(view, email, landownerType, firstName, lastName, phone, address, city, state, zip, subscriptionType)
        }
    }
    
    // MARK: - List your property api
    func listYourPropertyApi(_ view: UIView, _ email: String, _ landownerType: String, _ firstName: String, _ lastName: String, _ phone: String, _ address: String, _ city: String, _ state: String, _ zip: String, _ subscriptionType: String) {
        ApiStore.shared.listYourPropertyApi(view, email, landownerType, firstName, lastName, phone, address, city, state, zip, subscriptionType) { responseModel in
            responseModel.statusCode == 200
            ? (self.delegate?.successCalled(responseModel.message!))
            : (self.delegate?.errorCalled(responseModel.message!))
        }
    }
    
    // MARK: - Get all states Api
    func getAllStatesApi(_ view: UIView, completion : @escaping([GetAllStatesModelClass]) -> Void) {
        ApiStore.shared.getAllStatesApi(view) { responseModel in
            if responseModel.statusCode == 200 {
                self.getAllStatesArr = responseModel.model!
                self.delegate?.getStatesSuccessCalled()
                completion(self.getAllStatesArr)
            } else {
                self.delegate?.getStatesErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Day Pass Availability Api
    func dayPassAvailabilityApi(_ view: UIView, _ licenseActivityID: Int, _ dateOfArrival: String, _ daysCount: Int, completion : @escaping(DayPassModel) -> Void) {
        ApiStore.shared.dayPassAvailabilityApi(view, licenseActivityID, dateOfArrival, daysCount) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.dayPassArr = responseModel
                self.delegate?.dayPassSuccessCalled()
                completion(self.dayPassArr!)
            } else {
                self.delegate?.dayPassErrorCalled(responseModel.message)
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension ListYourPropertyViewModelDelegate {
    func successCalled(_ success: String) {
    }
    func errorCalled(_ error: String) {
    }
    func getStatesSuccessCalled() {
    }
    func getStatesErrorCalled(_ error: String) {
    }
    func dayPassSuccessCalled() {
    }
    func dayPassErrorCalled(_ error: String) {
    }
}
