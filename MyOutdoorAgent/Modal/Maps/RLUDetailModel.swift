//  RLUDetailModel.swift
//  MyOutdoorAgent
//  Created by CS on 26/12/22.

import Foundation

// MARK: - RLUDetailModel
struct RLUDetailModel : Codable {
    let message : String?
    let model : RLUDetailModelClass?
    let statusCode : Int?
}

// MARK: - RLUDetailModelClass
struct RLUDetailModelClass : Codable {
    let acres : Float?
    let caption : String?
    let countyName : String?
    let hostApprovalRequired : Bool?
    let imageFilename : String?
    let isAvailable : Bool?
    let licenseActivityID : Int?
    let licenseFee : Float?
    let productID : Int?
    let productNo : String?
    let propertyUserStatus : Int?
    let publicKey : String?
    let renewalStatus : Int?
    let requestStatus : String?
    let stateName : String?
    let status : String?
}
