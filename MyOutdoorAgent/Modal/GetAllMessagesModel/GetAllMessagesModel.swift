//  GetAllMessagesModel.swift
//  MyOutdoorAgent
//  Created by CS on 28/11/22.

import Foundation

// MARK: - GetAllMessagesModel
struct GetAllMessagesModel : Codable {
    let message : String?
    let model : [GetAllMessagesModelClass]?
    let statusCode : Int?
}

// MARK: - GetAllMessagesModelClass
struct GetAllMessagesModelClass : Codable {
    let adMsgID : Int?
    let adminAccountID : Int?
    let adminFirstName : String?
    let adminInitials : String?
    let adminLastName : String?
    let attachments : String?
    let dateLastLogin : String?
    let firstName : String?
    let initials : String?
    let lastName : String?
    let messageText : String?
    let postedDate : String?
    let productID : Int?
    let productNo : String?
    let publicKey : String?
    let status : String?
    let userAccountID : Int?
    let userMsgID : Int?
    let userProfileID : Int?
    let userType : String?
}
