//  AddVehicleModel.swift
//  MyOutdoorAgent
//  Created by CS on 11/10/22.

import Foundation

// MARK: - AddVehicleModel
struct AddVehicleModel : Codable {
    let message : String?
    let model : [AddVehicleModelClass]?
    let statusCode : Int?
}

// MARK: - AddVehicleModelClass
struct AddVehicleModelClass : Codable {
    let licenseContractId : Int?
    let vehicleColor : String?
    let vehicleDetailID : Int?
    let vehicleLicensePlate : String?
    let vehicleMake : String?
    let vehicleModel : String?
    let vehicleState : String?
    let vehicleType : String?
}
