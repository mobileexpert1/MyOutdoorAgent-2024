//  EnterNewPasswordView.swift
//  MyOutdoorAgent
//  Created by neha saini on 17/05/24.

import UIKit
import PKHUD
class EnterNewPasswordView: AbstractView {

    
    @IBOutlet weak var customNavBar: CustomNavBar!
    
    @IBOutlet weak var enterNewPasswordTxtField: UITextField!
    @IBOutlet weak var hideImgForNewPassword: UIImageView!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var hideImgForConfirmPassword: UIImageView!
    
    @IBOutlet weak var saveBtn: UIView!
    
    var passwordSecureBool = true
    var confirmSecureBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        print("public key --------->>>>> ", LocalStore.shared.PublicKey)
        print("temp otp --------->>>>> ", LocalStore.shared.tempOtp)
        
        
        self.hideImgForNewPassword.image = UIImage(named: "hide")
        self.hideImgForConfirmPassword.image = UIImage(named: "hide")
        
        
        self.enterNewPasswordTxtField.isSecureTextEntry = self.passwordSecureBool
        self.confirmPasswordTxtField.isSecureTextEntry = self.confirmSecureBool
        
        
        hideImgForNewPassword.actionBlock(){
            self.passwordSecureBool = !self.passwordSecureBool
            self.enterNewPasswordTxtField.isSecureTextEntry = self.passwordSecureBool
            if self.hideImgForNewPassword.image == UIImage(named: "hide") {
                self.hideImgForNewPassword.image = UIImage(named: "eye")
            } else if  self.hideImgForNewPassword.image == UIImage(named: "eye") {
                self.hideImgForNewPassword.image = UIImage(named: "hide")
            }
            
        }
        
        hideImgForConfirmPassword.actionBlock(){ [self] in
            self.confirmSecureBool = !self.confirmSecureBool
            self.confirmPasswordTxtField.isSecureTextEntry = self.confirmSecureBool
            if self.hideImgForConfirmPassword.image == UIImage(named: "hide") {
                self.hideImgForConfirmPassword.image = UIImage(named: "eye")
            } else if  self.hideImgForConfirmPassword.image == UIImage(named: "eye") {
                self.hideImgForConfirmPassword.image = UIImage(named: "hide")
            }
        }
        
        saveBtn.actionBlock { [self] in
            if enterNewPasswordTxtField.text != "" {
                if enterNewPasswordTxtField.text != confirmPasswordTxtField.text {
                    self.alertError1()
                } else {
                    ApiStore.shared.updatePasswordMoa(self.view, enterNewPasswordTxtField.text ?? "", LocalStore.shared.PublicKey, LocalStore.shared.tempOtp) { response in
                        if response.statusCode == 200 {
                            HUD.hide()
                            self.goToLoginPage()
                        }
                    }
                }
            } else {
                print("add validation")
            }
            
        }
    }
    
    func alertError() {
        let alert = UIAlertController(title: "Error", message: "New Password and Confirm Password is not same", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
//            self.enterNewPasswordTxtField.text = nil
//            self.confirmPasswordTxtField.text = nil
//            self.passwordSecureBool = true
//            self.confirmSecureBool = true
//            self.enterNewPasswordTxtField.isSecureTextEntry = self.passwordSecureBool
//            self.confirmPasswordTxtField.isSecureTextEntry = self.confirmSecureBool
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alertError1() {
        let alert = UIAlertController(title: "Error", message: "New Password and Confirm Password is not same", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(
            title: "OK", style: UIAlertAction.Style.default, handler: { action in
              
            }
        ))
        
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: true, titleText: EMPTY_STR, navViewColor: .white, mainViewColor: .white, backImg: Images.back.name)
    }
    
}

