//
//  PermitShapesModel.swift
//  MyOutdoorAgent
//
//  Created by Mobile on 14/10/24.
//

import Foundation

// MARK: - PermitShapesModel
struct PermitShapesModel: Codable {
    var type: String?
    var features: [PermitShapesFeature]?
}

// MARK: - PermitShapesFeature
struct PermitShapesFeature: Codable {
    var type: String?
    var id: Int?
    var geometry: Geometryes?
    var properties: Propertieses?
}

// MARK: - Geometry
struct Geometryes: Codable {
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
struct Propertieses: Codable {
    var rluNo: String?
    var isLicensed: Int?
    var objectID: Int?

    enum CodingKeys: String, CodingKey {
        case rluNo = "RLUNo"
        case isLicensed = "IsLicensed"
        case objectID = "ObjectID"
    }
}
