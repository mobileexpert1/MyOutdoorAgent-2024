//  MyConversationsModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import Foundation

// MARK: - MyConversationsModel
struct MyConversationsModel : Codable {
    let message : String?
    let model : [MyConversationsModelClass]?
    let statusCode : Int?
}

// MARK: - MyConversationsModelClass
struct MyConversationsModelClass : Codable {
    let postedDate : String?
    let productID : Int?
    let productNo : String?
    let unreadCount : Int?
}
