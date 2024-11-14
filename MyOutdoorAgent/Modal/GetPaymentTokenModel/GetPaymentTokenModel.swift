//  GetPaymentTokenModel.swift
//  MyOutdoorAgent
//  Created by CS on 27/10/22.

import Foundation

// MARK: - GetPaymentTokenModel
struct GetPaymentTokenModel: Codable {
    let statusCode: Int?
    let message: String?
    let model: GetPaymentTokenModelClass?
}

// MARK: - GetPaymentTokenModelClass
struct GetPaymentTokenModelClass: Codable {
    let statusCode: Int?
    let message: String?
    let response: PaymentToken?
}

// MARK: - PaymentToken
struct PaymentToken: Codable {
    let paymentToken: String?
}
