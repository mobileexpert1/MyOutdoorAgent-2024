//  GoogleHandler.swift
//  MyOutdoorAgent
//  Created by CS on 23/08/22.

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import PKHUD

class GoogleHandler: NSObject {
    
    static let shared = GoogleHandler()
    
    var okBtn = [ButtonText.ok.text]
    
    func onGoogleSignInCalled() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        // Start the sign in flow
        GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.visibleViewController.self) { [unowned self] user, error in

          if let error = error {
              UIAlertController.showAlert(AppAlerts.alert.title, message: error.localizedDescription, buttons: self.okBtn, completion: nil)
            return
          }

          guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    UIAlertController.showAlert(AppAlerts.alert.title, message: error.localizedDescription, buttons: self.okBtn, completion: nil)
                }else {
                    // Signup Success
                    if let currentUser = Auth.auth().currentUser?.displayName, let email  = Auth.auth().currentUser?.email {
                        self.socialRegisterApi(UIApplication.visibleViewController.view, currentUser, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, false, false, email, EMPTY_STR, 0, authentication.accessToken, authentication.accessToken, "google", 0)
                    }
                }
            })
        }
    }
    
    // MARK: - Register Api
    func socialRegisterApi(_ view: UIView, _ firstName: String, _ streetAddress: String, _ city: String, _ st: String, _ zip: String, _ phone: String, _ groupName: String, _ getNotifications: Bool, _ isBlacklisted: Bool, _ email: String, _ password: String, _ accountType: Int, _ authenticationKey: String, _ authorizationKey: String, _ authenticationType: String, _ sourceClientID: Int) {
        ApiStore.shared.socialRegisterApi(view, firstName, streetAddress, city, st, zip, phone, groupName, getNotifications, isBlacklisted, email, password, accountType, authenticationKey, authorizationKey, authenticationType, sourceClientID) { responseModel in
            if responseModel.model != nil {
                let name = responseModel.model?.firstName
                DispatchQueue.main.async {
                    LocalStore.shared.isSocialHandler = "google"
                    LocalStore.shared.userId = (responseModel.model?.authToken)!
                    LocalStore.shared.name = name ?? ""
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
