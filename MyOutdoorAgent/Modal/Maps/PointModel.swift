//  PointModel.swift
//  MyOutdoorAgent
//  Created by CS on 26/12/22.

//import Foundation
//
//// MARK: - PointModel
//struct PointModel: Codable {
//    let type: String?
//    let features: [Feature]?
//}
//
//// MARK: - Feature
//struct Feature: Codable {
//    let type: String?
//    let id: Int?
//    let geometry: Geometry?
//    let properties: Property?
//}
//
//// MARK: - Geometry
//struct Geometry: Codable {
//    let type: String?
//    let coordinates: [Double]?
//}
//
//// MARK: - Property
//struct Property: Codable {
//    let RLUNo: String?
//    let Objectid, IsLicensed: Int?
//}
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct PointModel: Codable {
    var type: String?
    var features: [Feature]?
}

// MARK: - Feature
struct Feature: Codable {
    var type: FeatureType?
    var id: Int?
    var geometry: Geometry?
    var properties: Propertie?
}

// MARK: - Geometry
struct Geometry: Codable {
    var type: GeometryType?
    var coordinates: [Double]?
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - Properties
struct Propertie: Codable {
    var rluNo: String?
    var objectid, isLicensed, esriOID: Int?

    enum CodingKeys: String, CodingKey {
        case rluNo = "RLUNo"
        case objectid = "OBJECTID"
        case isLicensed = "IsLicensed"
        case esriOID = "ESRI_OID"
    }
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}
