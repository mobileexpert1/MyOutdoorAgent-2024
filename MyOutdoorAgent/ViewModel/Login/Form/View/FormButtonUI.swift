//  FormButtonUI.swift
//  MyOutdoorAgent
//  Created by CS on 10/09/22.

import UIKit

class FormButtonUI {
    
    // MARK: - Set Login Button Properties on tapped
    func setLoginBtnUI(_ loginBtn: UIButton, _ signupBtn: UIButton) {
        loginBtn.setTitle(ButtonText.login.text, for: .normal)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? setButtonFont(loginBtn, signupBtn, 18)
        : setButtonFont(loginBtn, signupBtn, 22)
        
        loginBtn.backgroundColor = Colors.bgGreenColor.value
        loginBtn.setTitleColor(.white, for: .normal)
        signupBtn.setTitle(ButtonText.signUp.text, for: .normal)
        signupBtn.backgroundColor = Colors.lightGrey.value
        signupBtn.setTitleColor(Colors.mediumGrey.value, for: .normal)
    }
    
    // MARK: - Set Signup Button Properties on tapped
    func setSignupBtnUI(_ loginBtn: UIButton, _ signupBtn: UIButton) {
        signupBtn.setTitle(ButtonText.signUp.text, for: .normal)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? setButtonFont(loginBtn, signupBtn, 18)
        : setButtonFont(loginBtn, signupBtn, 22)
        
        signupBtn.backgroundColor = Colors.bgGreenColor.value
        signupBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle(ButtonText.login.text, for: .normal)
        loginBtn.backgroundColor = Colors.lightGrey.value
        loginBtn.setTitleColor(Colors.mediumGrey.value, for: .normal)
    }
    
    // MARK: - Set Button font in ipad and iphone
    private func setButtonFont(_ loginBtn: UIButton, _ signupBtn: UIButton, _ size: CGFloat) {
        loginBtn.titleLabel?.font = UIFont(name: Fonts.nunitoSansBold.name, size: size)
        signupBtn.titleLabel?.font = UIFont(name: Fonts.nunitoSansBold.name, size: size)
    }
}
