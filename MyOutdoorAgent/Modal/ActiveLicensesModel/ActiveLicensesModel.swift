//  ActiveLicensesModel.swift
//  MyOutdoorAgent
//  Created by CS on 06/09/22.

import Foundation

// MARK: - ActiveLicensesModel
struct ActiveLicensesModel : Codable {
    let message : String?
    let model : [ActiveLicensesModelClass]?
    let statusCode : Int?
}

// MARK: - ActiveLicensesModelClass
struct ActiveLicensesModelClass : Codable {
    let acres : Float?
    let active : String?
    let activityNumber : String?
    let activityType : String?
    let agreementName : String?
    let allowMemberActions : Bool?
    let contactNumber : String?
    let contractStatus : String?
    let countyName : String?
    let displayDescription : String?
    let displayName : String?
    let email : String?
    let firstName : String?
    let fundName : String?
    let groupName : String?
    let guestPassAllowedDays : Int?
    let guestPassCost : Float?
    let imageFilename : String?
    let isAccepted : Int?
    let lastName : String?
    let licenseActivityID : Int?
    let licenseAgreement : String?
    let licenseContractID : Int?
    let licenseEndDate : String?
    let licenseFee : Float?
    let licenseStartDate : String?
    let licenseStatus : String?
    let maxGuestsAllowed : Int?
    let maxMembersAllowed : Int?
    let memberPassCost : Float?
    let motorizedAccess : Bool?
    let paymentDueDate : String?
    let paymentStatus : String?
    let paymentType : String?
    let phone : String?
    let productID : Int?
    let productNo : String?
    let productTypeID : Int?
    let propertyName : String?
    let publicKey : String?
    let renewalStatus : Int?
    let stateName : String?
    let status : String?
}

