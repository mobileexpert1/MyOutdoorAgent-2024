//  AppleHandler.swift
//  MyOutdoorAgent
//  Created by CS on 23/08/22.

import UIKit
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import PKHUD

class AppleHandler: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleHandler()
    
    fileprivate var currentNonce: String?
    var okBtn = [ButtonText.ok.text]
    
    func startSignInWithAppleFlow() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
       // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)
        
        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = EMPTY_STR
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
       if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
         guard let nonce = currentNonce else {
           fatalError("Invalid state: A login callback was received, but no login request was sent.")
         }
         guard let appleIDToken = appleIDCredential.identityToken else {
           print("Unable to fetch identity token")
           return
         }
         guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
           print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
           return
         }
         // Initialize a Firebase credential.
           
           
           //let credential = OAuthProvider.credential(withProviderID: "apple.com", accessToken: idTokenString)
         let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
         // Sign in with Firebase.
         Auth.auth().signIn(with: credential) { (authResult, error) in
             if (error != nil) {
             // Error. If error.code == .MissingOrInvalidNonce, make sure
             // you're sending the SHA256-hashed nonce as a hex string with
             // your request to Apple.
                 
                 print(error?.localizedDescription)
                 UIAlertController.showAlert(AppAlerts.alert.title, message: error?.localizedDescription ?? "", buttons: self.okBtn, completion: nil)
             return
           }
             
           // User is signed in to Firebase with Apple.
           // ...
             
             print("success")
             print("idTokenString>>>", idTokenString)
             
             
             print("Name>>>", Auth.auth().currentUser?.displayName)
             
             print("email>>>", Auth.auth().currentUser?.email)
             
             print("fullname>>", appleIDCredential.fullName)
             
             if let currentUser = appleIDCredential.fullName , let email  = Auth.auth().currentUser?.email {
                 self.socialRegisterApi(UIApplication.visibleViewController.view, currentUser.description, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, false, false, email, EMPTY_STR, 0, idTokenString, idTokenString, "apple", 0)
             }
         }
       }
     }

    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.visibleViewController.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
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
