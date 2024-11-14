//  SaveSearchModel.swift
//  MyOutdoorAgent
//  Created by CS on 29/09/22.

import Foundation

// MARK: - SaveSearchModel
struct SaveSearchModel : Codable {
    let message : String?
    let model : Bool?
    let statusCode : Int?
}
