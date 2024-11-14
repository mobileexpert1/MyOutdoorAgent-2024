//  ChatModel.swift
//  MyOutdoorAgent
//  Created by CS on 11/10/22.

import Foundation

// MARK: - ChatModel
struct ChatModel: Codable {
    let adMsgID: Int?
    let productNo: String?
    let userMsgID, adminAccountID, productID, userAccountID: Int?
    let userProfileID: Int?
    let messageText, postedDate, status, userType: String?
    let initials, firstName, lastName, adminFirstName: String?
    let adminLastName, adminInitials, attachments, dateLastLogin: String?
    let publicKey: String?
}
