//  SignupView.swift
//  MyOutdoorAgent
//  Created by CS on 04/08/22.

import UIKit

class SignupView: UIViewController, SignUpViewModelDelegate {
    
    //MARK: - Objects
    private var signUpViewModel: SignUpViewModel?
    
    // MARK: - Variables
    var termsAndConditionHandler = false
    
    // MARK: - Outlets
    @IBOutlet weak var firstnameTxtF: UITextField!
    @IBOutlet weak var lastnameTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passTxtF: UITextField!
    @IBOutlet weak var confirmPassTxtF: UITextField!
    @IBOutlet weak var termsConditionsImgV: UIImageView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var termsOfServiceBtn: UILabel!
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        actionBlock()
    }
    
    private func onViewAppear() {
        setUI()
    }
    
    private func setUI() {
        scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        termsConditionsImgV.image = Images.uncheck.name
        signupView.isUserInteractionEnabled = false
        signupView.alpha = 0.5
        signUpViewModel = SignUpViewModel(self)
    }
    
    private func actionBlock() {
        // -- Terms of Service Image Action
        termsConditionsImgV.actionBlock {
            self.signUpViewModel?.handleCheckBox(handler: &(self.termsAndConditionHandler), checkBox: &(self.termsConditionsImgV), signupView: self.signupView)
        }
    }
}

/*
// MARK: - UITextFields Delegates
extension SignupView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 8
        let currentString = (textField.text ?? EMPTY_STR) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
*/

