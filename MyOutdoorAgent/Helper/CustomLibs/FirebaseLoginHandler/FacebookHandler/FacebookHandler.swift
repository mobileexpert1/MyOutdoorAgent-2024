//  FacebookHandler.swift
//  MyOutdoorAgent
//  Created by CS on 23/08/22.

import UIKit
import FacebookLogin
import FirebaseAuth
import PKHUD

class FacebookHandler: NSObject {
    
    static let shared = FacebookHandler()
    var okBtn = [ButtonText.ok.text]
    
    func onfacebookLoginCalled() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: UIApplication.visibleViewController.self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    UIAlertController.showAlert(AppAlerts.alert.title, message: error.localizedDescription, buttons: self.okBtn, completion: nil)
                }else {
                    // Signup Success
                    print("credential>>", credential)
                    print("tokenString>>", accessToken.tokenString)
                    print("success")
                    
                    if let currentUser = Auth.auth().currentUser?.displayName, let email  = Auth.auth().currentUser?.email {
                        self.socialRegisterApi(UIApplication.visibleViewController.view, currentUser, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, false, false, email, EMPTY_STR, 0, accessToken.tokenString, accessToken.tokenString, "facebook", 0)
                    }
                  
                }
            })
        }
    }
    
    // MARK: - Register Api
    func socialRegisterApi(_ view: UIView, _ firstName: String, _ streetAddress: String, _ city: String, _ st: String, _ zip: String, _ phone: String, _ groupName: String, _ getNotifications: Bool, _ isBlacklisted: Bool, _ email: String, _ password: String, _ accountType: Int, _ authenticationKey: String, _ authorizationKey: String, _ authenticationType: String, _ sourceClientID: Int) {
        ApiStore.shared.socialRegisterApi(view, firstName, streetAddress, city, st, zip, phone, groupName, getNotifications, isBlacklisted, email, password, accountType, authenticationKey, authorizationKey, authenticationType, sourceClientID) { responseModel in
            print(">>>>", responseModel)
            if responseModel.model != nil { 
                let name = ((responseModel.model?.firstName ?? "") + " " + (responseModel.model?.lastName ?? ""))
                DispatchQueue.main.async {
                    LocalStore.shared.userId = (responseModel.model?.authToken)!
                    LocalStore.shared.name = name
                    LocalStore.shared.userAccountId = (responseModel.model?.userAccountID)!
                    print(LocalStore.shared.userId)
                    HUD.flash(.label(AppAlerts.signUpSuccess.title), delay: 0.5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
                    }
                }
            } else {
                HUD.flash(.label(responseModel.message), delay: 1.0)
            }
        }
    }
}
