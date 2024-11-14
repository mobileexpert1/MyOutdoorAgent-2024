//  SocialRegisterModel.swift
//  MyOutdoorAgent
//  Created by CS on 17/10/22.

import Foundation

// MARK: - SocialRegisterModel
struct SocialRegisterModel : Codable {
    let message : String?
    let model : SocialRegisterModelClass?
    let statusCode : Int?
}

// MARK: - SocialRegisterModelClass
struct SocialRegisterModelClass : Codable {
    let accountType : Int?
    let authToken : String?
    let authenticationType : String?
    let city : String?
    let dateCreated : String?
    let dateLastLogin : String?
    let descriptionField : String?
    let email : String?
    let firstName : String?
    let getNotifications : Bool?
    let groupName : String?
    let isBlacklisted : Bool?
    let isEmailVerified : Bool?
    let isUserProfileComplete : Bool?
    let lastName : String?
    let message : String?
    let name : String?
    let phone : String?
    let st : String?
    let status : Int?
    let streetAddress : String?
    let token : String?
    let userAccountID : Int?
    let userProfileID : Int?
    let zip : String?
}
