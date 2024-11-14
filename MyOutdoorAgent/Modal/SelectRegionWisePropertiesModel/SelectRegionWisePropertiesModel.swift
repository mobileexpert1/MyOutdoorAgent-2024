//  SelectRegionWisePropertiesModel.swift
//  MyOutdoorAgent
//  Created by CS on 13/09/22.

import Foundation

// MARK: - SelectRegionWisePropertiesModel
struct SelectRegionWisePropertiesModel : Codable {
    let message : String?
    let model : [SelectRegionWisePropertiesModelClass]?
    let statusCode : Int?
}

// MARK: - SelectRegionWisePropertiesModelClass
struct SelectRegionWisePropertiesModelClass : Codable {
    let regionName: String?
    let rLURegionModel: [RLURegionModel]?
}

// MARK: - RLURegionModel
struct RLURegionModel: Codable {
    let productID: Int?
    let productNo, imageFileName, location: String?
    let licenseActivityID: Int?
    let displayName, publicKey: String?
}
