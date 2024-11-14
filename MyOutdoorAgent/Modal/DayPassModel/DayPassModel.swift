//  DayPassModel.swift
//  MyOutdoorAgent
//  Created by CS on 17/11/22.

import Foundation

// MARK: - DayPassModel
struct DayPassModel: Codable {
    let statusCode: Int
    let message: String
    let model: DayPassModelClass
}

// MARK: - DayPassModelClass
struct DayPassModelClass: Codable {
    let isAvailable: Bool
    let daypassTotalCost: Double
}
