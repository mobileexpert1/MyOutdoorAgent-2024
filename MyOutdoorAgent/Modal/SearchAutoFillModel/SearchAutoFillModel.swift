//  SearchAutoFillModel.swift
//  MyOutdoorAgent
//  Created by CS on 27/09/22.

import Foundation

// MARK: - SearchAutoFillModel
struct SearchAutoFillModel : Codable {
    let message : String?
    let model : [SearchAutoFillModelClass]?
    let statusCode : Int?
}

// MARK: - SearchAutoFillModelClass
struct SearchAutoFillModelClass : Codable {
    let searchResult : String?
    let type : String?
}
