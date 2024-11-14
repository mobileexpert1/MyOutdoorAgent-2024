//  SavedSearchesModel.swift
//  MyOutdoorAgent
//  Created by CS on 19/09/22.

import Foundation

// MARK: - SavedSearchesModel
struct SavedSearchesModel : Codable {
    let message : String?
    let model : [SavedSearchesModelClass]?
    let statusCode : Int?
}

// MARK: - SavedSearchesModelClass
struct SavedSearchesModelClass : Codable {
    let Amenities : [String]?
    let Client : String?
    let FreeText : String?
    let IPAddress : String?
    let PriceMax : Float?
    let PriceMin : Float?
    let PropertyName : [String]?
    let RLU : String?
    let RLUAcresMax : Float?
    let RLUAcresMin : Float?
    let RegionName : [String]?
    let SearchName : String?
    let StateName : [String]?
    let UserAccountID : Int?
    let UserSearchID : Int?
    let county : String?
    let order : String?
    let productTypeID : Int?
    let sort : String?
}
