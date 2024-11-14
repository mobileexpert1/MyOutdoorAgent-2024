//
//  AcessPointModel.swift
//  MyOutdoorAgent
//
//  Created by Mobile on 14/10/24.
//



import Foundation

// MARK: - Welcome
struct AcessPointModel: Codable {
    var type: String?
    var features: [AcessPointFeature]?
}

// MARK: - Feature
struct AcessPointFeature: Codable {
    var type: String?
    var id: Int?
    var geometry: Geometryss?
    var properties: Propertiesss?
}

// MARK: - Geometry
struct Geometryss: Codable {
    var type: String?
    var coordinates: [Double]?
}

//enum GeometryType: String, Codable {
//    case point = "Point"
//}

// MARK: - Properties
struct Propertiesss: Codable {
    var objectid: Int?
    var rluNo: RLUNo?
    var gateNo: String?
    var gateType: String?

    enum CodingKeys: String, CodingKey {
        case objectid = "OBJECTID"
        case rluNo = "RLUNo"
        case gateNo = "GateNo"
        case gateType = "GateType"
    }
}

enum GateType: String, Codable {
    case access = "Access"
    case other = "Other"
}

enum RLUNo: String, Codable {
    case cgSnoqualmieTreeFarm = "CG - Snoqualmie Tree Farm"
    case hpl = "HPL"
}

//enum FeatureType: String, Codable {
//    case feature = "Feature"
//}
