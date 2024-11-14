//  AccountSettingsViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol AccountSettingsViewModelDelegate : AnyObject {
    func viewProfileSuccessCalled()
    func viewProfileErrorCalled(_ error: String)
    func notificationsSuccessCalled()
    func notificationsErrorCalled(_ error: String)
}

class AccountSettingsViewModel {
    
    weak var delegate: AccountSettingsViewModelDelegate?
    var userProfileModel : UserProfileModelClass?
    var mobileNotificationsModel : MobileNotificationsModel?
    
    init(_ delegate: AccountSettingsViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Set View User Api
    func setViewUserProfileApi(_ view: UIView, completion : @escaping(UserProfileModelClass) -> Void) {
        ApiStore.shared.userProfileApi(view) { responseModel in
            if responseModel.model != nil {
                if responseModel.statusCode == 200 {
                    self.userProfileModel = responseModel.model!
                    self.delegate?.viewProfileSuccessCalled()
                    completion(self.userProfileModel!)
                } else {
                    self.delegate?.viewProfileErrorCalled(responseModel.message!)
                }
            } else {
                self.delegate?.viewProfileErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Manage Notifications Api
    func manageNotificationsApi(_ view: UIView, _ notifications: Bool, completion : @escaping(MobileNotificationsModel) -> Void) {
        ApiStore.shared.manageNotificationsApi(view, notifications) { responseModel in
            if responseModel.statusCode == 200 {
                self.mobileNotificationsModel = responseModel
                self.delegate?.notificationsSuccessCalled()
                completion(self.mobileNotificationsModel!)
            } else {
                self.delegate?.notificationsErrorCalled(responseModel.message!)
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension AccountSettingsViewModelDelegate {
    func viewProfileSuccessCalled() {
    }
    func viewProfileErrorCalled(_ error: String) {
    }
    func notificationsSuccessCalled() {
    }
    func notificationsErrorCalled(_ error: String) {
    }
}
