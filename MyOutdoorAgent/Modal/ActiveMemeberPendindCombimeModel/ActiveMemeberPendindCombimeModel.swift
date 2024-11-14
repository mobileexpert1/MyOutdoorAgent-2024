//
//  ActiveMemeberPendindCombimeModel.swift
//  MyOutdoorAgent
//
//  Created by Mobile on 02/09/24.
//

import Foundation
// MARK: - MemberLicensesModel
struct ActiveMemeberPendindCombimeModel : Codable {
    let message : String?
    let model : [ActiveMemeberPendindCombimeModelClass]?
    let statusCode : Int?
}

// MARK: - MemberLicensesModelClass
struct ActiveMemeberPendindCombimeModelClass : Codable {
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
    let agreementName : String?
    let clientInvoiceID : Int?
    let guestPassAllowedDays : Int?
    let guestPassCost : Float?
    let isPaid : Bool?
    let licenseActivityID : Int?
    let licenseAgreement : String?
    let maxMembersAllowed : Int?
    let memberPassCost : Float?
    let memberType : String?
    let motorizedAccess : Bool?
    let productID : Int?
    let showAcceptButton : Bool?
    let showPayButton : Bool?
    let active : String?
    let activityType : String?
    let allowMemberActions : Bool?
    let contactNumber : String?
    let contractStatus : String?
    let displayDescription : String?
    let email : String?
    let firstName : String?
    let fundName : String?
    let groupName : String?
    let isAccepted : Int?
    let lastName : String?
    let licenseFee : Float?
    let licenseStatus : String?
    let maxGuestsAllowed : Int?
    let paymentDueDate : String?
    let paymentStatus : String?
    let paymentType : String?
    let phone : String?
    let propertyName : String?
    let renewalStatus : Int?
    let status : String?
}
