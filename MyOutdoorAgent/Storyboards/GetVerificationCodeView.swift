//  GetVerificationCodeView.swift
//  MyOutdoorAgent
//  Created by neha saini on 16/05/24.

import UIKit
import PKHUD

class GetVerificationCodeView: UIViewController {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var textMessageView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var txtMsgLbl: UILabel!
    @IBOutlet weak var emailImg: UIImageView!
    @IBOutlet weak var txtMsgImg: UIImageView!
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var continueBtn: UIView!
    
    var forgotModel : ForgotPasswordModelMoa?
    private var sentType = "phone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        actionBlock()
        
        if forgotModel != nil {
            emailLbl.text = forgotModel?.model.email
            if forgotModel?.model.phone == "" {
                txtMsgLbl.text = "-"
                emailImg.image = UIImage(named: "check-mark")
                txtMsgImg.image = UIImage(named: "round")
                sentType = "email"
            } else {
                txtMsgLbl.text = forgotModel?.model.phone
                txtMsgImg.image = UIImage(named: "check-mark")
                emailImg.image = UIImage(named: "round")
                sentType = "phone"
            }
        }
    }
    
    
    private func actionBlock() {
        // -- Reset Password Link
        continueBtn.actionBlock { [self] in
            
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
        textMessageView.actionBlock { [self] in
            if forgotModel?.model.phone != "" {
                txtMsgImg.image = UIImage(named: "check-mark")
                emailImg.image = UIImage(named: "round")
                sentType = "phone"
            }
        }
        emailView.actionBlock { [self] in
            emailImg.image = UIImage(named: "check-mark")
            txtMsgImg.image = UIImage(named: "round")
            sentType = "email"
        }
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: true, titleText: EMPTY_STR, navViewColor: .white, mainViewColor: .white, backImg: Images.back.name)
    }
}
