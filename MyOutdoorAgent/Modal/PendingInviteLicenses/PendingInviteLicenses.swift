//  PendingInviteLicenses.swift
//  MyOutdoorAgent
//  Created by CS on 06/09/22.

import Foundation

// MARK: - PendingInviteLicenses
struct PendingInviteLicenses : Codable {
    let message : String?
    let model : [PendingInviteLicensesClass]?
    let statusCode : Int?
}

// MARK: - PendingInviteLicensesClass
struct PendingInviteLicensesClass : Codable {
    let acres : Float?
    let activityNumber : String?
    let agreementName : String?
    let clientInvoiceID : Int?
    let countyName : String?
    let displayName : String?
    let guestPassAllowedDays : Int?
    let guestPassCost : Float?
    let imageFilename : String?
    let isPaid : Bool?
    let licenseActivityID : Int?
    let licenseAgreement : String?
    let licenseContractID : Int?
    let licenseEndDate : String?
    let licenseStartDate : String?
    let maxMembersAllowed : Int?
    let memberPassCost : Float?
    let memberType : String?
    let motorizedAccess : Bool?
    let productID : Int?
    let productNo : String?
    let productTypeID : Int?
    let publicKey : String?
    let showAcceptButton : Bool?
    let showPayButton : Bool?
    let stateName : String?
}

