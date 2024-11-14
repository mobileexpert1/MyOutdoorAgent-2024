//  UserProfileModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import Foundation

// MARK: - UserProfileModel
struct UserProfileModel : Codable {
    let message : String?
    let model : UserProfileModelClass?
    let statusCode : Int?
}

// MARK: - UserProfileModelClass
struct UserProfileModelClass : Codable {
    let authenticationType : String?
    let city : String?
    let clubName : String?
    let email : String?
    let firstName : String?
    let getNotifications : Bool?
    let groupName : String?
    let isUserProfileComplete : Bool?
    let lastName : String?
    let phone : String?
    let st : String?
    let stateName : String?
    let status : Int?
    let streetAddress : String?
    let userAccountID : Int?
    let userProfileID : Int?
    let zip : String?
}
