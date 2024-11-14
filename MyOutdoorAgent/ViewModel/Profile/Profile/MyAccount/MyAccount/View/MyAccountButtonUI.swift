//  MyAccountButtonUI.swift
//  MyOutdoorAgent
//  Created by CS on 15/09/22.

import UIKit

class MyAccountButtonUI {
    
    // MARK: - Set Account Settings Button Properties on tapped
    func setAccountSettingsBtnUI(_ accountSettingsBtn: UIButton, _ savedSearchesBtn: UIButton) {
        accountSettingsBtn.setTitle(ButtonText.accountSettings.text, for: .normal)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? setButtonFont(accountSettingsBtn, savedSearchesBtn, 18)
        : setButtonFont(accountSettingsBtn, savedSearchesBtn, 23)
        
        accountSettingsBtn.backgroundColor = Colors.bgGreenColor.value
        accountSettingsBtn.setTitleColor(.white, for: .normal)
        savedSearchesBtn.setTitle(ButtonText.savedSearches.text, for: .normal)
        savedSearchesBtn.backgroundColor = Colors.semiGrey.value
        savedSearchesBtn.setTitleColor(Colors.secondaryGrey.value, for: .normal)
    }
    
    // MARK: - Set Saved Searches Button Properties on tapped
    func setSavedSearchesBtnUI(_ accountSettingsBtn: UIButton, _ savedSearchesBtn: UIButton) {
        savedSearchesBtn.setTitle(ButtonText.savedSearches.text, for: .normal)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? setButtonFont(savedSearchesBtn, accountSettingsBtn, 18)
        : setButtonFont(savedSearchesBtn, accountSettingsBtn, 23)
        
        savedSearchesBtn.backgroundColor = Colors.bgGreenColor.value
        savedSearchesBtn.setTitleColor(.white, for: .normal)
        accountSettingsBtn.setTitle(ButtonText.accountSettings.text, for: .normal)
        accountSettingsBtn.backgroundColor = Colors.semiGrey.value
        accountSettingsBtn.setTitleColor(Colors.secondaryGrey.value, for: .normal) 
    }
    
    // MARK: - Set Button font in ipad and iphone
    private func setButtonFont(_ accountSettingsBtn: UIButton, _ savedSearchesBtn: UIButton, _ size: CGFloat) {
        accountSettingsBtn.titleLabel?.font = UIFont(name: Fonts.nunitoSansSemiBold.name, size: size)
        savedSearchesBtn.titleLabel?.font = UIFont(name: Fonts.nunitoSansSemiBold.name, size: size)
    }
}
