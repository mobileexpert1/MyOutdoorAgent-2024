//
//  NonMotorizedModel.swift
//  MyOutdoorAgent
//
//  Created by Mobile on 15/10/24.
//

import Foundation

// MARK: - Welcome
struct NonMotorizedModel: Codable {
    var type: String?
    var features: [NonMotorizedFeature]?
}

// MARK: - Feature
struct NonMotorizedFeature: Codable {
    var type: String?
    var id: Int?
    var geometry: Geometryy?
    var properties: Propertiessss?
}

// MARK: - Geometry
struct Geometryy: Codable {
    var type: String?
    var coordinates: [[[[Double]]]]?
}

// MARK: - Properties
struct Propertiessss: Codable {
    var rluNo: String?
    var esriOID: Int?
    var productType: String?

    enum CodingKeys: String, CodingKey {
        case rluNo = "RLUNo"
        case esriOID = "ESRI_OID"
        case productType = "ProductType"
    }
}

