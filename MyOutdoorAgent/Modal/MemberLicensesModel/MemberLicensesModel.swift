//  MemberLicensesModel.swift
//  MyOutdoorAgent
//  Created by CS on 06/09/22.

import Foundation

// MARK: - MemberLicensesModel
struct MemberLicensesModel : Codable {
    let message : String?
    let model : [MemberLicensesModelClass]?
    let statusCode : Int?
}

// MARK: - MemberLicensesModelClass
struct MemberLicensesModelClass : Codable {
    let acres : Float?
    let activityNumber : String?
    let countyName : String?
    let displayName : String?
    let imageFilename : String?
    let licenseContractID : Int?
    let licenseEndDate : String?
    let licenseStartDate : String?
    let productNo : String?
    let productTypeID : Int?
    let publicKey : String?
    let stateName : String?
}

