//  GetAllAmenitiesModel.swift
//  MyOutdoorAgent
//  Created by CS on 27/09/22.

import Foundation

// MARK: - GetAllAmenitiesModel
struct GetAllAmenitiesModel : Codable {
    let message : String?
    let model : [GetAllAmenitiesModelClass]?
    let statusCode : Int?
}

// MARK: - GetAllAmenitiesModelClass
struct GetAllAmenitiesModelClass : Codable {
    let amenities : String?
    let amenityIcon : String?
    let amenityName : String?
    let amenityType : String?
    let amenityTypeID : Int?
    let descriptionField : String?
    let productID : Int?
}
