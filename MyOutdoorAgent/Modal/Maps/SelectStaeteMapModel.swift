//
//  SelectStaeteMapModel.swift
//  MyOutdoorAgent
//
//  Created by Mobile on 15/10/24.
//

//import Foundation
//
//// MARK: - Welcome
//struct SelectStaeteMapModel: Codable {
//    var type: String?
//    var features: [SelectStaeteMapFeature]?
//}
//
//// MARK: - Feature
//struct SelectStaeteMapFeature: Codable {
//    var type: String?
//    var geometry: Geometryeses?
//    var properties: Propertiesese?
//}
//
//// MARK: - Geometry
//struct Geometryeses: Codable {
//    var type: String?
//    var coordinates: [[[Double]]]?
//}
//
//// MARK: - Properties
//struct Propertiesese: Codable {
//    var stateAbbr: String?
//
//    enum CodingKeys: String, CodingKey {
//        case stateAbbr = "STATE_ABBR"
//    }
//}
import Foundation

// MARK: - Welcome
struct SelectStateMapModel: Codable {
    var type: String?
    var features: [SelectStateMapFeature]?
}

// MARK: - Feature
struct SelectStateMapFeature: Codable {
    var type: String?
    var geometry: Geometryeses?
    var properties: Propertiesese?
}

// MARK: - Geometry
struct Geometryeses: Codable {
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
struct Propertiesese: Codable {
    var stateAbbr: String?

    enum CodingKeys: String, CodingKey {
        case stateAbbr = "STATE_ABBR"
    }
}
