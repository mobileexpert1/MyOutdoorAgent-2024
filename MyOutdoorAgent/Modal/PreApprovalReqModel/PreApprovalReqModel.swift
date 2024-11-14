//  PreApprovalReqModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import Foundation

// MARK: - PreApprovalReqModel
struct PreApprovalReqModel : Codable {
    let message : String?
    let model : [PreApprovalReqModelClass]?
    let statusCode : Int?
}

// MARK: - PreApprovalReqModelClass
struct PreApprovalReqModelClass : Codable {
//    let acres : Float?
//    let countyName : String?
//    let dateSubmitted : String?
//    let displayName : String?
//    let imageFilename : String?
//    let licenseActivityID : Int?
//    let licenseEndDate : String?
//    let licenseFee : Float?
//    let licenseStartDate : String?
//    let licenseStatus : String?
//    let preApprRequestID : Int?
//    let productID : Int?
//    let productNo : String?
//    let propertyName : String?
//    let publicKey : String?
//    let requestStatus : String?
//    let stateName : String?
    
    
    let requestType, displayName: String?
    let preApprRequestID, productID: Int?
    let productNo: String?
    let requestStatus: String?
    let licenseActivityID: Int?
    let propertyName: String?
    let licenseFee: Double?
    let licenseStatus: String?
    let countyName, stateName: String?
    let acres: Double?
    let imageFilename, publicKey: String?
    let preSaleToken: String?
    let email, licenseStartDate, licenseEndDate, dateSubmitted: String?
}



