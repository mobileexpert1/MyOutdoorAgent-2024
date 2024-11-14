//  LoginView.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import AuthenticationServices
import RecaptchaEnterprise


class LoginView: AbstractView, LoginViewModelDelegate {
    
    //MARK: - Objects
    private var loginViewModel: LoginViewModel?
    
    // MARK: - Variables
    var securePassword : Bool!
    var rememberMeHandler = false
    
    // MARK: - Outlets
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var loginBtn: UIView!
    @IBOutlet weak var googleBtn: UIImageView!
    @IBOutlet weak var appleBtn: UIImageView!
    @IBOutlet weak var facebookBtn: UIImageView!
    @IBOutlet weak var forgotPassBtn: UILabel!
    @IBOutlet weak var hidePassImgV: UIImageView!
    @IBOutlet weak var rememberMeBtn: UIImageView!
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var loginWithTop: NSLayoutConstraint!
    
    var recaptchaClient: RecaptchaClient?
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        Task {
//            do {
//              let client = try await Recaptcha.getClient(withSiteKey: "6LcrIyUqAAAAAD06acko38OqNjEBx4lxdhk5bMY8")
//              self.recaptchaClient = client
//            } catch let error as RecaptchaError {
//               print("RecaptchaClient creation error: \(String(describing: error.errorMessage)).")
//            }
//          }
        
        
        onViewLoad()
    }
//    
//    Site key: 6LcrIyUqAAAAAD06acko38OqNjEBx4lxdhk5bMY8
//
//    Secret key: 6LcrIyUqAAAAAN2nttpKD2fD7j0soxQlIUqg5vSK
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
    }
    
    private func onViewAppear() {
        setProperties()
        setDelegates()
    }
    
    private func setUI() {
        showNavigationBar(false)
    }
    
    private func setDelegates() {
        loginViewModel = LoginViewModel(self)
    }
    
    private func setProperties() {
        scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        passwordTxtF.isSecureTextEntry = true
        securePassword = true
        hidePassImgV.image = Images.hide.name
    }
    
    private func actionBlock() {
        // -- Hide and Unhide Password Action
        hidePassImgV.actionBlock {
            self.securePassword == true
            ? self.hideUnhidePass(false, Images.unhide.name, false)
            : self.hideUnhidePass(true, Images.hide.name, true)
        }
        
        // -- Remember me Button
        rememberMeBtn.actionBlock {
            self.loginViewModel?.handleCheckBox(handler: &(self.rememberMeHandler), checkBox: &(self.rememberMeBtn))
            
//            guard let recaptchaClient = self.recaptchaClient else {
//              print("RecaptchaClient creation failed.")
//              return
//            }
//            Task {
//              do {
//                let token = try await recaptchaClient.execute(withAction: RecaptchaAction.login)
//                print(token)
//              } catch let error as RecaptchaError {
//                  print(error.errorMessage ?? "33333333")
//              }
//            }
            
        }
        
        // -- Forgot Password Action
        forgotPassBtn.actionBlock {
            self.pushOnly(Storyboards.main.name, Controllers.forgotPassword.name, true)
        }
        
        // -- Google Action
        googleBtn.actionBlock {
            GoogleHandler.shared.onGoogleSignInCalled()
        }
        
        // -- Apple Action
        appleBtn.actionBlock {
            AppleHandler.shared.startSignInWithAppleFlow()
        }
        
        // -- Facebook Action
        facebookBtn.actionBlock {
            FacebookHandler.shared.onfacebookLoginCalled()
        }
    }
    
    private func hideUnhidePass(_ secureText: Bool, _ image: UIImage, _ securePassword: Bool) {
        self.passwordTxtF.isSecureTextEntry = secureText
        self.hidePassImgV.image = image
        self.securePassword = securePassword
    }
}

// MARK: - ViewWillTransition
extension LoginView {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setLoginView()
    }
    
    private func setLoginView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if (UIDevice.current.orientation == .landscapeLeft) || (UIDevice.current.orientation == .landscapeRight) {
                loginWithTop.constant = 20
            } else {
                loginWithTop.constant = 70
            }
        } else {
            loginWithTop.constant = 70
        }
    }
}
