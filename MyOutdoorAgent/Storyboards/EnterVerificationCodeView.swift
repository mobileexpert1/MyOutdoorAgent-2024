//  EnterVerificationCodeView.swift
//  MyOutdoorAgent
//  Created by neha saini on 16/05/24.

import UIKit
import DPOTPView
import PKHUD

class EnterVerificationCodeView: UIViewController {
    
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var continueBtn: UIView!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var btnResend: UILabel!
    var headerText = ""
    var forgotModel : ForgotPasswordModelMoa?
    private var sentType = "phone"
    override func viewDidLoad() {
        super.viewDidLoad()
        print("public key --------->>>>> ", LocalStore.shared.PublicKey)
        setUI()
        
        headerLbl.text = headerText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actionBlock()
    }
    private func actionBlock() {
        // -- Reset Password Link
        continueBtn.actionBlock {
            if self.otpView.text == "" {
                Alerts().showAlert("Please enter an OTP")
            } else {
                if self.otpView.validate() {
                    ApiStore.shared.verifyCodeMoa(self.view, LocalStore.shared.PublicKey, self.otpView.text ?? "") { response in
                        if response.statusCode == 200 {
                            if response.message == "Code verified successfully." {
                                HUD.hide()   
                                LocalStore.shared.tempOtp = self.otpView.text ?? ""
                                self.pushOnly(Storyboards.main.name, Controllers.EnterNewPasswordView.name, true)
                            } else {
                                Alerts().showAlert(response.message)
                            }
                        } else {
                            Alerts().showAlert(response.message)
                        }
                    }
                }
            }
        }
        
        btnResend.actionBlock { [self] in
            
            ApiStore.shared.sendVerificationCodeMoa(view, sentType, forgotModel?.model.email ?? "",
                                                     (forgotModel?.model.phone == "" ? "" : forgotModel?.model.phone) ?? "",
                                                     forgotModel?.model.firstName ?? "",
                                                    forgotModel?.model.publicKey ?? "") { [self] response in
                if response.statusCode == 200 {
                    HUD.hide()
                    let vc = UIStoryboard(name: Storyboards.main.name, bundle: nil).instantiateViewController(withIdentifier:Controllers.EnterVerificationCodeView.name) as! EnterVerificationCodeView
                    if sentType == "phone" {
                        vc.headerText = "We send you a verification code by\ntext message to \(forgotModel?.model.phone ?? "")"
                    } else {
                        vc.headerText = "We send you a verification code by\nemail to \(forgotModel?.model.email ?? "")"
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                  
                }
            }
        }
        
    }
    private func setUI() {
        showNavigationBar(false)
       // HUD.hide()
        setcustomNav(customView: customNavBar, titleIsHidden: true, titleText: EMPTY_STR, navViewColor: .white, mainViewColor: .white, backImg: Images.back.name)
    }
    
    
}
