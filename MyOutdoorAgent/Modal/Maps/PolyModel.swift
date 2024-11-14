//  PolyModel.swift
//  MyOutdoorAgent
//  Created by CS on 26/12/22.

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let imageUploadAPIModel = try? JSONDecoder().decode(ImageUploadAPIModel.self, from: jsonData)

// MARK: - ImageUploadAPIModel
struct PolyModel: Codable {
    let type: String
    var features: [PolyFeature]
}

// MARK: - Feature
struct PolyFeature: Codable {
    let type: String
    let id: Int
    let geometry: PolyGeometry
    let properties: Properties
}

// MARK: - Geometry
struct PolyGeometry: Codable {
    let type: String
    let coordinates: [[[Coordinate]]]
}

enum Coordinate: Codable {
    case double(Double)
    case doubleArray([Double])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Double].self) {
            self = .doubleArray(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        throw DecodingError.typeMismatch(Coordinate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Coordinate"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .doubleArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Properties
struct Properties: Codable {
    let rluNo: String
    let isLicensed, objectID: Int?

    enum CodingKeys: String, CodingKey {
        case rluNo = "RLUNo"
        case isLicensed = "IsLicensed"
        case objectID = "ObjectId"
    }
}
