//  ForgotPasswordModel.swift
//  MyOutdoorAgent
//  Created by CS on 23/08/22.

import Foundation

// MARK: - ForgotPasswordModel
struct ForgotPasswordModel : Codable {
    let message : String?
    let statusCode : Int?
    let value : String?
}


// MARK: - ForgotPasswordModelMoa
struct ForgotPasswordModelMoa: Codable {
    let statusCode: Int
    let message: String
    let model: Model
}

// MARK: - Model
struct Model: Codable {
    let firstName, phone, email, publicKey: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

// MARK: - sendverificationcode
struct SendVerificationCodeModelMoa: Codable {
    let statusCode: Int
    let message: String
    let model: JSONNull?
}

// MARK: - sendverificationcode
struct ChangePasswordModelMoa: Codable {
    let statusCode: Int
    let message: String
    let value: JSONNull?
}
