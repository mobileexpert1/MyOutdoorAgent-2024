//  RegisterModel.swift
//  MyOutdoorAgent
//  Created by CS on 22/08/22.

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Codable {
    let message : String?
    let statusCode : Int?
    let model : RegisterModelClass?
}

// MARK: - RegisterModelClass
struct RegisterModelClass: Codable {
    let accountType : Int?
    let authenticationKey : String?
    let authenticationType : String?
    let authorizationKey : String?
    let city : String?
    let clientToken : String?
    let email : String?
    let firstName : String?
    let getNotifications : Bool?
    let groupName : String?
    let isBlacklisted : Bool?
    let isEmailVerified : Bool?
    let lastName : String?
    let password : String?
    let phone : String?
    let sourceClientID : Int?
    let st : String?
    let streetAddress : String?
    let zip : String?
}
