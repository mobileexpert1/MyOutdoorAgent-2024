//  AcceptManualPaymentModel.swift
//  MyOutdoorAgent
//  Created by CS on 26/09/22.

import Foundation

// MARK: - AcceptManualPaymentModel
struct AcceptManualPaymentModel : Codable {
    let message : String?
    let value : String?
    let statusCode : Int?
}
