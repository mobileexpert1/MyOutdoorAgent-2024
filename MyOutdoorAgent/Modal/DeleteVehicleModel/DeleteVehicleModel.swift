//  DeleteVehicleModel.swift
//  MyOutdoorAgent
//  Created by CS on 07/10/22.

import Foundation

// MARK: - DeleteVehicleModel
struct DeleteVehicleModel: Codable {
    let statusCode: Int
    let message: String
    let model: [DeleteVehicleModelClass]?
}

// MARK: - DeleteVehicleModelClass
struct DeleteVehicleModelClass: Codable {
    let vehicleDetailID, licenseContractID: Int?
    let vehicleType: String?
    let vehicleMake, vehicleModel, vehicleColor, vehicleLicensePlate: String?
    let vehicleState: String?
}
