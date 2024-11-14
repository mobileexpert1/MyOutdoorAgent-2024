//
//  MultiPolygonModel2.swift
//  MyOutdoorAgent
//
//  Created by Mobile on 15/10/24.
//


import Foundation

// MARK: - Welcome
struct MultiPolygonModel2: Codable {
    var type: String?
    var features: [MultiPolygonModelFeature]?
}

// MARK: - Feature
struct MultiPolygonModelFeature: Codable {
    var type: String?
    var id: Int?
    var geometry: Geometrye?
    var properties: Propertieseses?
}

// MARK: - Geometry
struct Geometrye: Codable {
    var type: String?
    var coordinates: Coordinates?

    enum Coordinates: Codable {
        case twoDimensional([[[Double]]])
        case fourDimensional([[[[Double]]]])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decode([[[Double]]].self) {
                self = .twoDimensional(value)
            } else if let value = try? container.decode([[[[Double]]]].self) {
                self = .fourDimensional(value)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid coordinate format")
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .twoDimensional(let coords):
                try container.encode(coords)
            case .fourDimensional(let coords):
                try container.encode(coords)
            }
        }
    }
}

// MARK: - Properties
struct Propertieseses: Codable {
    var rluNo: String?
    var isLicensed, objectid, esriOID: Int?

    enum CodingKeys: String, CodingKey {
        case rluNo = "RLUNo"
        case isLicensed = "IsLicensed"
        case objectid = "OBJECTID"
        case esriOID = "ESRI_OID"
    }
}


