//  LocalStore.swift
//  MyOutdoorAgent
//  Created by CS on 22/08/22.

import UIKit

class LocalStore: NSObject {
    
    static var shared = LocalStore()
    
    var userIdKey = "userIdKey"
    var userProfileIdKey = "userProfileIdKey"
    var userAccountIdKey = "userAccountIdKey"
    var authenticationTypeKey = "authenticationTypeKey"
    var isUserProfileCompleteKey = "isUserProfileCompleteKey"
    var emailKey = "emailKey"
    var getNotificationsKey = "getNotificationsKey"
    var nameKey = "nameKey"
    var firstNameKey = "firstNameKey"
    var lastNameKey = "lastNameKey"
    var streetAddressKey = "streetAddressKey"
    var cityKey = "cityKey"
    var stateKey = "stateKey"
    var streetAddKey = "streetAddKey"
    var zipcodeKey = "zipcodeKey"
    var mobileNoKey = "mobileNoKey"
    var addressKey = "addressKey"
    var clubNameKey = "clubNameKey"
    var isScreenHandlerKey = "isScreenHandlerKey"
    var isSocialHandlerKey = "isSocialHandlerKey"
    var emailHandlerKey = "emailHandlerKey"
    var passwordHandlerKey = "passwordHandlerKey"
    var isRememberKey = "isRememberKey"
    var isCountySearchKey = "isCountySearchKey"
    var isRLUSearchKey = "isRLUSearchKey"
    var isRegionSearchKey = "isRegionSearchKey"
    var isPropertySearchKey = "isPropertySearchKey"
    var isfreeTextSearchKey = "isfreeTextSearchKey"
    var selectedPropertyIndexKey = "selectedPropertyIndexKey"
    var userRoleIDKey = "userRoleIDKey"
    var adminLastMsgIdKey = "adminLastMsgIdKey"
    var userLastMsgIdKey = "userLastMsgIdKey"
    
    
    var userId: String {
        get{ return UserDefaults.standard.string(forKey: userIdKey) ?? EMPTY_STR }
        set{ UserDefaults.standard.set(newValue, forKey: userIdKey) }
    }
    
    var userProfileId : Int {
        get { return UserDefaults.standard.integer(forKey: userProfileIdKey) }
        set { return UserDefaults.standard.set(newValue, forKey: userProfileIdKey) }
    }
    
    var userAccountId : Int {
        get { return UserDefaults.standard.integer(forKey: userAccountIdKey)}
        set { return UserDefaults.standard.set(newValue, forKey: userAccountIdKey) }
    }
    
    var authenticationType : String {
        get { return UserDefaults.standard.string(forKey: authenticationTypeKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: authenticationTypeKey) }
    }
    
    var isUserProfileComplete : Bool {
        get { return UserDefaults.standard.bool(forKey: isUserProfileCompleteKey) }
        set { return UserDefaults.standard.set(newValue, forKey: isUserProfileCompleteKey) }
    }
    
    var email : String {
        get { return UserDefaults.standard.string(forKey: emailKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: emailKey) }
    }
    
    var getNotifications : Bool {
        get { return UserDefaults.standard.bool(forKey: getNotificationsKey) }
        set { return UserDefaults.standard.set(newValue, forKey: getNotificationsKey) }
    }
    
    var name : String {
        get { return UserDefaults.standard.string(forKey: nameKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: nameKey) }
    }
    
    var fisrtName : String {
        get { return UserDefaults.standard.string(forKey: firstNameKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: firstNameKey) }
    }
    
    var lastName : String {
        get { return UserDefaults.standard.string(forKey: lastNameKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: lastNameKey) }
    }
    
    var streetAddress : String {
        get { return UserDefaults.standard.string(forKey: streetAddressKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: streetAddressKey) }
    }
    
    var city : String {
        get { return UserDefaults.standard.string(forKey: cityKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: cityKey) }
    }
    
    var state : String {
        get { return UserDefaults.standard.string(forKey: stateKey) ?? CommonKeys.state.name}
        set { return UserDefaults.standard.set(newValue, forKey: stateKey) }
    }
    
    var streetAdd : String {
        get { return UserDefaults.standard.string(forKey: streetAddKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: streetAddKey) }
    }
    
    var zipcode : String {
        get { return UserDefaults.standard.string(forKey: zipcodeKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: zipcodeKey) }
    }
    
    var mobileNo : String {
        get { return UserDefaults.standard.string(forKey: mobileNoKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: mobileNoKey) }
    }
    
    var address : String {
        get { return UserDefaults.standard.string(forKey: addressKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: addressKey) }
    }
    
    var clubname: String {
        get { return UserDefaults.standard.string(forKey: clubNameKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: clubNameKey) }
    }
    
    var isScreenHandler : Bool {
        get { return UserDefaults.standard.bool(forKey: isScreenHandlerKey) }
        set { return UserDefaults.standard.set(newValue, forKey: isScreenHandlerKey) }
    }
    
    var isSocialHandler : String {
        get { return UserDefaults.standard.string(forKey: isSocialHandlerKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: isSocialHandlerKey) }
    }
    
    var emailHandler : String {
        get { return UserDefaults.standard.string(forKey: emailHandlerKey) ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: emailHandlerKey) }
    }
    
    var passwordHandler : String {
        get { return UserDefaults.standard.string(forKey: passwordHandlerKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: passwordHandlerKey) }
    }
    
    var isRemember : Bool {
        get { return UserDefaults.standard.bool(forKey: isRememberKey) }
        set { return UserDefaults.standard.set(newValue, forKey: isRememberKey) }
    }
    
    var countySearchName : String {
        get { return UserDefaults.standard.string(forKey: isCountySearchKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: isCountySearchKey) }
    }
    
    var rluSearchName : String {
        get { return UserDefaults.standard.string(forKey: isRLUSearchKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: isRLUSearchKey) }
    }
    
    var regionSearchName : String {
        get { return UserDefaults.standard.string(forKey: isRegionSearchKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: isRegionSearchKey) }
    }
    
    var propertySearchName : String {
        get { return UserDefaults.standard.string(forKey: isPropertySearchKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: isPropertySearchKey) }
    }
    
    var freeTextSearchName : String {
        get { return UserDefaults.standard.string(forKey: isfreeTextSearchKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: isfreeTextSearchKey) }
    }
    
    var selectedPropertyIndex : Int {
        get { return UserDefaults.standard.integer(forKey: selectedPropertyIndexKey)}
        set { return UserDefaults.standard.set(newValue, forKey: selectedPropertyIndexKey) }
    }
    
    var userRoleID : String {
        get { return UserDefaults.standard.string(forKey: userRoleIDKey) ?? EMPTY_STR}
        set { return UserDefaults.standard.set(newValue, forKey: userRoleIDKey) }
    }
    
    var adminLastMsgId : Int {
        get { return UserDefaults.standard.integer(forKey: adminLastMsgIdKey)}
        set { return UserDefaults.standard.set(newValue, forKey: adminLastMsgIdKey) }
    }
    
    var userLastMsgId : Int {
        get { return UserDefaults.standard.integer(forKey: userLastMsgIdKey)}
        set { return UserDefaults.standard.set(newValue, forKey: userLastMsgIdKey) }
    }
    
    var PublicKey: String {
        get{ return UserDefaults.standard.string(forKey: "PublicKey") ?? EMPTY_STR }
        set{ UserDefaults.standard.set(newValue, forKey: "PublicKey") }
    }
    
    var tempOtp: String {
        get{ return UserDefaults.standard.string(forKey: "tempOtp") ?? EMPTY_STR }
        set{ UserDefaults.standard.set(newValue, forKey: "tempOtp") }
    }
    var usename : String {
        get { return UserDefaults.standard.string(forKey: "usename") ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: "usename") }
    }
    var userEmail : String {
        get { return UserDefaults.standard.string(forKey: "userEmail") ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: "userEmail") }
    }
    var navigationScreen : String {
        get { return UserDefaults.standard.string(forKey: "navigationScreen") ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: "navigationScreen") }
    } 
    var selectedAmenitiesArr: [String] {
        get {
            return UserDefaults.standard.array(forKey: "selectedAmenitiesArr")as? [String] ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedAmenitiesArr")
        }
    }
    var coordinatePointArr: [[Double]] {
        get {
            return UserDefaults.standard.array(forKey: "coordinatePointArr") as? [[Double]] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "coordinatePointArr")
        }
    }
    var isLicensedArr: [Int] {
        get {
            return UserDefaults.standard.array(forKey: "isLicensedArr") as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLicensedArr")
        }
    }
    var productNo : String {
        get { return UserDefaults.standard.string(forKey: "productNo") ?? EMPTY_STR }
        set { return UserDefaults.standard.set(newValue, forKey: "productNo") }
    }
    var productTypeId : Int {
        get { return UserDefaults.standard.integer(forKey: "productTypeId")}
        set { return UserDefaults.standard.set(newValue, forKey: "productTypeId") }
    }
}
