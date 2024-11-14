//  FormView.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit
import PKHUD
import WebKit

class FormView: AbstractView, WKUIDelegate {
    
    //MARK: - Objects
    private var loginViewModel: LoginViewModel?
    private var signUpViewModel: SignUpViewModel?
    
    // MARK: - Variables
    var okBtn = [ButtonText.ok.text]
    var webView: WKWebView!
    
    // MARK: - Computed Variables
    private lazy var loginView: LoginView = {
        var viewController = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Controllers.login.name) as! LoginView
        self.add(asChildViewController: viewController, containerV)
        return viewController
    }()
    
    private lazy var signupView: SignupView = {
        var viewController = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Controllers.signUp.name) as! SignupView
        self.add(asChildViewController: viewController, containerV)
        return viewController
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var containerV: UIView!
    @IBOutlet var termsOfServicePopUpView: TermsOfServiceView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    // MARK: - ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        setTermsServiceView()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
    }
    
    private func onViewAppear() {
        remove(asChildViewController: signupView)
        add(asChildViewController: loginView, containerV)
        
        if LocalStore.shared.isRemember == true {
            loginView.rememberMeBtn.image = Images.check.name
            loginView.emailTxtF.text = LocalStore.shared.emailHandler
            loginView.passwordTxtF.text = LocalStore.shared.passwordHandler
        } else {
            loginView.rememberMeBtn.image = Images.uncheck.name
            loginView.emailTxtF.text = EMPTY_STR
            loginView.passwordTxtF.text = EMPTY_STR
        }
    }
    
    private func setUI() {
        showNavigationBar(false)
        loginViewModel = LoginViewModel(self)
        signUpViewModel = SignUpViewModel(self)
    }
    
    private func actionBlock() {
        // -- Login Action
        loginBtn.actionBlock {
            self.remove(asChildViewController: self.signupView)
            self.add(asChildViewController: self.loginView, self.containerV)
            FormButtonUI().setLoginBtnUI(self.loginBtn, self.signupBtn)
            self.setSignUp()
        }
        
        // -- SignUp Action
        signupBtn.actionBlock {
            self.remove(asChildViewController: self.loginView)
            self.add(asChildViewController: self.signupView, self.containerV)
            FormButtonUI().setSignupBtnUI(self.loginBtn, self.signupBtn)
            self.setLogin()
        }
        
        // -- Login Button
        loginView.loginBtn.actionBlock {
            self.loginViewModel?.checkEmptyFields(self.view, self.loginView.emailTxtF.text!, self.loginView.passwordTxtF.text!, EMPTY_STR, CommonKeys.orbis.name)
        }
        
        // -- SignUp Button
        signupView.signupView.actionBlock {
            self.signUpViewModel?.checkEmptyFields(self.view, self.signupView.firstnameTxtF.text!, self.signupView.lastnameTxtF.text!, self.signupView.emailTxtF.text!, self.signupView.passTxtF.text!, self.signupView.confirmPassTxtF.text!, ZERO_STR, EMPTY_STR, CommonKeys.orbis.name, ZERO_STR)
        }
        
        // -- Terms of Service Action
        signupView.termsOfServiceBtn.actionBlock {
            self.viewTransition(self.termsOfServicePopUpView)
            self.showWebView()
        }
    }
    
    private func setSignUp() {
        let txtFieldArr = [self.signupView.firstnameTxtF, self.signupView.lastnameTxtF, self.signupView.emailTxtF, self.signupView.passTxtF, self.signupView.confirmPassTxtF]
        txtFieldArr.forEach { textFields in
            textFields?.text = EMPTY_STR
        }
    }
    
    private func setLogin() {
        if LocalStore.shared.isRemember != true {
            let txtFieldArr = [self.loginView.emailTxtF, self.loginView.passwordTxtF]
            txtFieldArr.forEach { textFields in
                textFields?.text = EMPTY_STR
            }
        }
    }
    
    private func showWebView() {
        self.webView = WKWebView(frame: self.termsOfServicePopUpView.termsOfServiceV.bounds, configuration: WKWebViewConfiguration())
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.termsOfServicePopUpView.termsOfServiceV.addSubview(self.webView)
        self.webView.scrollView.subviews.forEach { $0.isUserInteractionEnabled = false }
        let myURL = URL(string: Urls.termsService.name)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
        
        // -- Accept Button in Terms of service
        self.termsOfServicePopUpView.acceptBtn.actionBlock {
            self.removeView(self.termsOfServicePopUpView)
        }
        
        // -- Cross Button in Terms of service
        self.termsOfServicePopUpView.crossBtn.actionBlock {
            self.removeView(self.termsOfServicePopUpView)
        }
    }
    
    private func setTermsServiceView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.termsOfServicePopUpView.termsServiceTop.constant = 60
                self.termsOfServicePopUpView.termsServiceBottom.constant = 60
                self.termsOfServicePopUpView.crossBtnTop.constant = 45
            default:
                self.termsOfServicePopUpView.termsServiceTop.constant = 120
                self.termsOfServicePopUpView.termsServiceBottom.constant = 120
                self.termsOfServicePopUpView.crossBtnTop.constant = 105
            }
        } else {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.termsOfServicePopUpView.termsServiceTop.constant = 20
                        self.termsOfServicePopUpView.termsServiceBottom.constant = 20
                        self.termsOfServicePopUpView.crossBtnTop.constant = 10
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.termsOfServicePopUpView.termsServiceTop.constant = 100
                        self.termsOfServicePopUpView.termsServiceBottom.constant = 100
                        self.termsOfServicePopUpView.crossBtnTop.constant = 90
                    }
                }
            }
        }
    }
}

// MARK: - LoginViewModelDelegate
extension FormView: LoginViewModelDelegate {
    func loginSuccessCalled(_ success: String, _ token: String, _ name: String, _ userId: Int, _ email: String) {
        DispatchQueue.main.async { [self] in
            LocalStore.shared.userId = token
            LocalStore.shared.name = name
            LocalStore.shared.email = email
            LocalStore.shared.userAccountId = userId
            
            if LocalStore.shared.isRemember == true {
                LocalStore.shared.emailHandler = self.loginView.emailTxtF.text!
                LocalStore.shared.passwordHandler = self.loginView.passwordTxtF.text!
            } else {
                LocalStore.shared.emailHandler = EMPTY_STR
                LocalStore.shared.passwordHandler = EMPTY_STR
            }
            
            print(token)
            print(LocalStore.shared.userId)
            HUD.flash(.label(success), delay: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
            }
        }
    }
    
    func loginErrorCalled(_ error: String) {
        HUD.hide()
        let okBtn = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: error, buttons: okBtn, completion: nil)
    }
}

// MARK: - SignUpViewModelDelegate
extension FormView: SignUpViewModelDelegate {
    func signUpSuccessCalled(_ success: String, _ token: String) {
        DispatchQueue.main.async {
            LocalStore.shared.userId = token
            print(token)
            HUD.flash(.label(success), delay: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
            }
        }
    }
    
    func signUpErrorCalled(_ error: String) {
        HUD.hide()
        UIAlertController.showAlert(AppAlerts.alert.title, message: error, buttons: okBtn) { alert, index in
            if index == 0 {
                UIApplication.visibleViewController.pushOnly(Storyboards.main.name, Controllers.form.name, true)
            }
        }
    }
    
    func emailNotVerified(_ error: String) {
        UIAlertController.showAlert(AppAlerts.alert.title, message: (AppErrors.confirmEmail.localizedDescription), buttons: okBtn) { alert, index in
            if index == 0 {
                UIApplication.visibleViewController.pushOnly(Storyboards.main.name, Controllers.form.name, true)
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension FormView : WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.termsOfServicePopUpView.activityIndicatorV.startAnimating()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.termsOfServicePopUpView.activityIndicatorV.stopAnimating()
        self.termsOfServicePopUpView.activityIndicatorV.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.termsOfServicePopUpView.activityIndicatorV.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let btns = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
            if index == 0 {
                self.removeView(self.termsOfServicePopUpView)
            }
        }
    }
}

// MARK: - ViewWillTransition
extension FormView {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                self.termsOfServicePopUpView.termsServiceTop.constant = 20
                self.termsOfServicePopUpView.termsServiceBottom.constant = 20
                self.termsOfServicePopUpView.crossBtnTop.constant = 10
            case .landscapeRight:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.termsOfServicePopUpView.termsServiceTop.constant = 20
                    self.termsOfServicePopUpView.termsServiceBottom.constant = 20
                    self.termsOfServicePopUpView.crossBtnTop.constant = 10
                    self.termsOfServicePopUpView.layoutIfNeeded()
                }
            case .portrait, .portraitUpsideDown:
                self.termsOfServicePopUpView.termsServiceTop.constant = 100
                self.termsOfServicePopUpView.termsServiceBottom.constant = 100
                self.termsOfServicePopUpView.crossBtnTop.constant = 90
            default:
                self.termsOfServicePopUpView.termsServiceTop.constant = 100
                self.termsOfServicePopUpView.termsServiceBottom.constant = 100
                self.termsOfServicePopUpView.crossBtnTop.constant = 90
            }
        } else {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.termsOfServicePopUpView.termsServiceTop.constant = 60
                self.termsOfServicePopUpView.termsServiceBottom.constant = 60
                self.termsOfServicePopUpView.crossBtnTop.constant = 45
            case .portrait, .portraitUpsideDown:
                self.termsOfServicePopUpView.termsServiceTop.constant = 120
                self.termsOfServicePopUpView.termsServiceBottom.constant = 120
                self.termsOfServicePopUpView.crossBtnTop.constant = 105
            default:
                self.termsOfServicePopUpView.termsServiceTop.constant = 120
                self.termsOfServicePopUpView.termsServiceBottom.constant = 120
                self.termsOfServicePopUpView.crossBtnTop.constant = 105
            }
        }
    }
}
