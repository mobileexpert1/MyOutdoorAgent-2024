//  MobileNotificationsModel.swift
//  MyOutdoorAgent
//  Created by CS on 22/09/22.

import Foundation

// MARK: - MobileNotificationsModel
struct MobileNotificationsModel : Codable {
    let message : String?
    let statusCode : Int?
    let value : Bool?
}
