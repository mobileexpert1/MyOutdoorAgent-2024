//  Validations.swift
//  MyOutdoorAgent
//  Created by CS on 19/08/22.

import Foundation

extension String {
    
    // -- Email Validation
    var isEmailValid: Bool {
        let emailText = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        return emailText.evaluate(with: self)
    }
    
    // -- Password Validation
    var isPasswordValid: Bool {
        //^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,15}$   (For Special symbols Also)
        //^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,15}$
        let passwordText = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,15}$")
        return passwordText.evaluate(with: self)
    }
    
    // -- Mobile Validations
    //https://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    public var isValidMobile: Bool {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count)).first?.phoneNumber {
            return match == self
        } else {
            return false
        }
    }
}
