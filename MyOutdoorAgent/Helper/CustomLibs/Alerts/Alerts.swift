//  Alerts.swift
// https://github.com/pkluz/PKHUD

import Foundation
import PKHUD

class Alerts {
    
    static let shared = Alerts()
    
    func showSdkConnectionStatusAlert( connectionStatusText:String,  status:Bool) {
        switch status {
        case true:
            HUD.flash(.labeledSuccess(title: connectionStatusText, subtitle: EMPTY_STR), delay: 1.0)
        case false:
            HUD.flash(.labeledError(title: connectionStatusText, subtitle: EMPTY_STR), delay: 1.0)
        }
    }
    
    func showAlert(_ alertText:String) {
        HUD.flash(.label(alertText), delay: 1.0)
    }
    
    func showLoader() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView(title: EMPTY_STR, subtitle: EMPTY_STR)
        PKHUD.sharedHUD.show()
    }
    
    func hideLoader() {
        PKHUD.sharedHUD.hide()
    }
    
    func showLoaderWithText(text: String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView(title: text, subtitle: EMPTY_STR)
        PKHUD.sharedHUD.show()
    }
}
