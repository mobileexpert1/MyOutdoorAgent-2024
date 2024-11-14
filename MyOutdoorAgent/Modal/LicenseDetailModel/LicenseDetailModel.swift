//  LicenseDetailModel.swift
//  MyOutdoorAgent
//  Created by CS on 07/10/22.

import Foundation

// MARK: - LicenseDetailModel
struct LicenseDetailModel : Codable {
    let message : String?
    let model : LicenseDetailModelClass?
    let statusCode : Int?
}

// MARK: - LicenseDetailModelClass
struct LicenseDetailModelClass : Codable {
    //    let acceptedBy : String?
    //    let acceptedDate : String?
    //    let activityType : String?
    //    let additionalInvoices : [String]?
    //    let amenities : [AmenityDetail]?
    //    let clientFeatures : ClientFeature?
    //    let clubMemberDetails : [ClubMemberDetail]?
    //    let contractFiscalYear : Int?
    //    let contractStatus : String?
    //    let executedBy : String?
    //    let executedDate : String?
    //    let licenseAcres : Float?
    //    let licenseAgreement : String?
    //    let licenseContractID : Int?
    //    let licenseDetails : LicenseDetail?
    //    let licenseMembers : [LicenseMember]?
    //    let licenseStatus : String?
    //    let licenseType : String?
    //    let mapFiles : [MapFileDetail]?
    //    let memberDetailsModel : MemberDetailsModel?
    //    let productID : Int?
    //    let productNo : String?
    //    let publicKey : String?
    //    let renewalActivity : RenewalActivity?
    //    let specialConditions : [SpecialConditions]?
    //    let vehicleDetails : [VehicleDetail]?
    
    let acceptedBy : String?
    let acceptedDate : String?
    let activityType : String?
    let additionalInvoices : [AdditionalInvoice]?
    let amenities : [AmenityDetail]?
    let clientFeatures : ClientFeature?
    let clubMemberDetails : [ClubMemberDetail]?
    let contractFiscalYear : Int?
    let contractStatus : String?
    let executedBy : String?
    let executedDate : String?
    let licenseAcres : Float?
    let licenseAgreement : String?
    let licenseContractID : Int?
    let licenseDetails : LicenseDetail?
    let licenseMembers : [LicenseMember]?
    let licenseStatus : String?
    let licenseType : String?
    let mapFiles : [MapFiles]?
    let memberDetailsModel : MemberDetailsModel?
    let productID : Int?
    let productNo : String?
    let publicKey : String?
    let renewalActivity : RenewalActivity?
    let specialConditions : [SpecialConditions]?
    let vehicleDetails : [VehicleDetail]?
    let clientDocument: [ClientDocuments]?
}

// MARK: - MapFileDetail
struct MapFileDetail : Codable {
    let countyName : String?
    let displayName : String?
    let mapFileID : Int?
    let mapFileName : String?
    let mapInfoJson : String?
    let productID : Int?
    let productName : String?
    let productNo : String?
    let regionName : String?
    let stateName : String?
}
struct MapFiles: Codable {
    let displayName, countyName, regionName, stateName: String?
    let productName, productNo: String?
    let mapFileID, productID: Int?
    let mapFileName: String?
    let mapInfoJSON: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName, countyName, regionName, stateName, productName, productNo, mapFileID, productID, mapFileName
        case mapInfoJSON = "mapInfoJson"
    }
}
struct MapInfoJSONS: Codable {
    let key1: String?
    let key2: Int?
    // Add more properties as needed
}

// MARK: - VehicleDetail
struct VehicleDetail : Codable {
    let licenseContractId : Int?
    let vehicleColor : String?
    let vehicleDetailID : Int?
    let vehicleLicensePlate : String?
    let vehicleMake : String?
    let vehicleModel : String?
    let vehicleState : String?
    let vehicleType : String?
}

// MARK: - ClubMemberDetail
struct ClubMemberDetail : Codable {
    let address : String?
    let city : String?
    let email : String?
    let firstName : String?
    let guestPassEndDate : String?
    let guestPassStartDate : String?
    let isPaid : Bool?
    let lastName : String?
    let licenseContractID : Int?
    let licenseContractMemberID : Int?
    let memberType : String?
    let phone : String?
    let state : String?
    let zip : String?
}

// MARK: - LicenseMember
struct LicenseMember : Codable {
    let contractStatus : String?
    let displayDescription : String?
    let email : String?
    let firstName : String?
    let internalNotes : String?
    let isAccepted : Bool?
    let isPaid : Bool?
    let lastName : String?
    let phone : String?
    let licenseContractID : String?
    let licenseContractMemberID : String?
    let licenseStatus : String?
    let licenseType : String?
    let memberType : String?
    let userAccountID : Int?
    let userProfileID : Int?
}

// MARK: - SpecialConditions
struct SpecialConditions : Codable {
    let specCndDesc : String?
    let specCndID : Int?
}

// MARK: - AmenityDetail
struct AmenityDetail : Codable {
    let amenityIcon : String?
    let amenityName : String?
    let amenityType : String?
    let amenityTypeID : Int?
    let description : String?
    let lastModifiedBy : String?
    let lastModifiedDate : String?
    let productAmenitiesID : Int?
    let productID : Int?
    let totalLicenseFee : Float?
}

// MARK: - RenewalActivity
struct RenewalActivity : Codable {
    let licenseActivityID : Int?
    let paymentDueDate : String?
    let publicKey : String?
}

// MARK: - MemberDetailsModel
struct MemberDetailsModel : Codable {
    let feePerMember : Float?
    let maxMembersAllowed : Int?
    let memberFeesAmountToPay : Float?
    let showPayMemberFeesButton : Bool?
    let totalMembersAdded : Int?
    let unpaidMembersCount : Int?
}

// MARK: - LicenseDetail
struct LicenseDetail : Codable {
    let acres : Float?
    let active : String?
    let activityNumber : String?
    let activityType : String?
    let agreementName : String?
    let allowMemberActions : Bool?
    let amount : Int?
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
    let invoiceType : String?
    let isAccepted : Int?
    let laPublicKey : String?
    let lastName : String?
    let lcPublicKey : String?
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

// MARK: - ClientFeature
struct ClientFeature : Codable {
    let addClubMembers : Bool?
    let allowTraxAppAccess : Bool?
    let clientAdministration : Bool?
    let clientCurrentFY : Bool?
    let clientID : Int?
    let clientSite : String?
    let clubMemberLicense : Bool?
    let deerHarvestInfo : Bool?
    let externalLogins : Bool?
    let recManualChecks : Bool?
    let rightofEntry : Bool?
    let roEAgreement : Bool?
}

// MARK: - AdditionalInvoice
struct AdditionalInvoice : Codable {
    let adInvoiceID : Int?
    let amount : String?
    let contractStatus : String?
    let dateAdded : String?
    let displayName : String?
    let invoicePaid : Bool?
    let invoiceTypeID : Int?
    let licenseHolderName : String?
    let paymentDate : String?
    let productNo : String?
    let typeName : String?
    
}
struct ClientDocuments: Codable {
    let clientDocumentID, clientID: Int?
    let clientDocument: String?
    let isPublic, rlu, permit, dayPass: Bool?
    let fileName: String?
    let uploadFile, clienDocxID: String?
    let documentName: String?
}
