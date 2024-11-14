//  MultipolygonModel.swift
//  MyOutdoorAgent
//  Created by CS on 26/12/22.
//

//import Foundation
//
//struct MultipolygonModel: Codable {
//    var type: String?
//    var features: [MultipolygonFeature]?
//}
//
//// MARK: - Feature
//struct MultipolygonFeature: Codable {
//    var type: String?
//    var id: Int?
//    var geometry: Geometrys?
//    var properties: Propertiess?
//}
//
//// MARK: - Geometry
//struct Geometrys: Codable {
//    var type: String?
//    var coordinates: [[[Double]]]?
//}
//
//// MARK: - Properties
//struct Propertiess: Codable {
//    var rluNo: String?
//    var isLicensed, objectid, esriOID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case rluNo = "RLUNo"
//        case isLicensed = "IsLicensed"
//        case objectid = "OBJECTID"
//        case esriOID = "ESRI_OID"
//    }
//}
import Foundation

// MARK: - Welcome
struct MultipolygonModel: Codable {
    var type: String?
    var features: [MultipolygonFeature]?
}

// MARK: - Feature
struct MultipolygonFeature: Codable {
    var type: String?
    var id: Int?
    var geometry: Geometrys?
    var properties: Propertiess?
}

// MARK: - Geometry
struct Geometrys: Codable {
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
struct Propertiess: Codable {
    var rluNo: String?
    var isLicensed, objectid, esriOID: Int?

    enum CodingKeys: String, CodingKey {
        case rluNo = "RLUNo"
        case isLicensed = "IsLicensed"
        case objectid = "OBJECTID"
        case esriOID = "ESRI_OID"
    }
}
