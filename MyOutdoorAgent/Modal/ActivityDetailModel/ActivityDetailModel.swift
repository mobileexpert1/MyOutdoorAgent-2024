//  ActivityDetailModel.swift
//  MyOutdoorAgent
//  Created by CS on 04/10/22.
//
//import Foundation
//
//// MARK: - ActivityDetailModel
//struct ActivityDetailModel : Codable {
//    let message : String?
//    let model : ActivityDetailModelClass?
//    let statusCode : Int?
//}
//
//// MARK: - ActivityDetailModelClass
//struct ActivityDetailModelClass : Codable {
//    let activityDetail : ActivityDetail?
//    let activityDetailPageChecks : ActivityDetailPageCheck?
//    let amenities : [Amenity]?
//    let clientDetails : ClientDetail?
//    let images : [Image]?
//    let mapFiles : [MapFile]?
//    let members : [Member]?
//    let similarProperties : [SimilarProperty]?
//    let specialConditions : [SpecialCondition]?
//}
//
//// MARK: - LicensesMember
//struct Member : Codable {
//    let address : String?
//    let city : String?
//    let email : String?
//    let firstName : String?
//    let lastName : String?
//    let phone : String?
//    let state : String?
//    let zip : String?
//}
//
//// MARK: - SpecialCondition
//struct SpecialCondition : Codable {
//    let productID : Int?
//    let specCndDesc : String?
//    let specCndID : Int?
//}
//
//// MARK: - SimilarProperty
//struct SimilarProperty : Codable {
//    let countyName : String?
//    let displayText : String?
//    let imageFilename : String?
//    let licenseActivityID : Int?
//    let productID : Int?
//    let productNo : String?
//    let publicKey : String?
//    let stateName : String?
//}
//
//// MARK: - MapFile
//struct MapFile : Codable {
//    let countyName : String?
//    let displayName : String?
//    let mapFileID : Int?
//    let mapFileName : String?
//    let mapInfoJson : String?
//    let productID : Int?
//    let productName : String?
//    let productNo : String?
//    let regionName : String?
//    let stateName : String?
//}
//
//// MARK: - Image
//struct Image : Codable {
//    let caption : String?
//    let imageFileName : String?
//    let productID : Int?
//    let productImageID : Int?
//}
//
//// MARK: - ClientDetail
//struct ClientDetail : Codable {
//    let addClubMembers : Bool?
//    let allowTraxAppAccess : Bool?
//    let clientAdministration : Bool?
//    let clientCurrentFY : Bool?
//    let clientID : Int?
//    let clientSite : String?
//    let clubMemberLicense : Bool?
//    let deerHarvestInfo : Bool?
//    let externalLogins : Bool?
//    let recManualChecks : Bool?
//    let rightofEntry : Bool?
//    let roEAgreement : Bool?
//}
//
//// MARK: - Amenity
//struct Amenity : Codable {
//    let amenities : String?
//    let amenityIcon : String?
//    let amenityName : String?
//    let amenityType : String?
//    let amenityTypeID : Int?
//    let description : String?
//    let productID : Int?
//}
//
//// MARK: - ActivityDetailPageCheck
//struct ActivityDetailPageCheck : Codable {
//    let existingLicenseHolderAccountID : Int?
//    let existingLicenseHolderProfileID : Int?
//    let isFreeAccessPermit : Bool?
//    let isPreApprovalRequested : Bool?
//    let isRenewal : Bool?
//    let isUserProfileComplete : Bool?
//    let preApprRequestID : Int?
//    let preApprovalStatus : String?
//    let showAlreadyPurchasedButton : Bool?
//    let showComingSoonButton : Bool?
//    let showLicenseFee : Bool?
//    let showLicenseNowButton : Bool?
//    let showPreApprovalRequestButton : Bool?
//    let showRenewButton : Bool?
//    let showRequestEntry : Bool?
//    let showSoldOutButton : Bool?
//}
//
//// MARK: - ActivityDetail
//struct ActivityDetail : Codable {
//    let acres : Double?
//    let activityDescription : String?
//    let activityEndDate : String?
//    let activityNumber : String?
//    let activityStartDate : String?
//    let activityType : String?
//    let address : String?
//    let agreementName : String?
//    let city : String?
//    let clientLogoPath : String?
//    let countyID : Int?
//    let countyName : String?
//    let currentDateTime : String?
//    let displayDescription : String?
//    let displayName : String?
//    let guestPassAllowedDays : Int?
//    let guestPassCost : Float?
//    let hostApprovalRequired : Bool?
//    let licenseActivityID : Int?
//    let licenseAgreementURL : String?
//    let licenseEndDate : String?
//    let licenseFee : Double?
//    let licenseStartDate : String?
//    let maxGuestsAllowed : Int?
//    let maxMembersAllowed : Int?
//    let maxSaleQtyAllowed : Int?
//    let memberPassCost : Float?
//    let phone : String?
//    let preSale : Int?
//    let productID : Int?
//    let productNo : String?
//    let productType : String?
//    let productTypeID : Int?
//    let propertyName : String?
//    let publicKey : String?
//    let regionName : String?
//    let saleCount : Int?
//    let saleStartDateTime : String?
//    let state : String?
//    let status : String?
//    let timeZone : String?
//}
//
//
//
//
//// MARK: - Welcome
//struct ActivityDetailModels: Codable {
//    let type: String
//    let title: String
//    let status: Int
//    let traceID: String
//
//    enum CodingKeys: String, CodingKey {
//        case type, title, status
//        case traceID = "traceId"
//    }
//}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ActivityDetailModel: Codable {
    let statusCode: Int?
    let message: String?
    let model: ActivityDetailModelClass
}

// MARK: - Model
struct ActivityDetailModelClass: Codable {
    let amenities: [Amenity]?
    let images: [Image]?
    let mapFiles: [MapFile]?
    let specialConditions: [SpecialCondition]?
    let activityDetail: ActivityDetail?
    let clientDetails: ClientDetails?
    let similarProperties: [SimilarProperty]?
    let members: [Member]?
    let activityDetailPageChecks: ActivityDetailPageChecks?
    let clientDocuments: [ClientDocument]?
}

// MARK: - ActivityDetail
struct ActivityDetail: Codable {
    let activityType, displayName: String?
    let landownerName: String?
    let activityNumber: String?
    let maxSaleQtyAllowed, maxGuestsAllowed, guestPassCost, guestPassAllowedDays: Int?
    let memberPassCost, maxMembersAllowed, saleCount, productTypeID: Int?
    let productType: String?
    let preSale: Int?
    let agreementName: String?
    let productID : Int?
    let acres: Float?
    let address: String?
    let landownerEmail: String?
    let regionName, state, city, licenseStartDate: String?
    let licenseEndDate, activityStartDate, activityEndDate: String?
    let licenseFee : Float?
    let preSaleCharge: Int?
    let displayDescription, productNo, propertyName: String?
    let hostApprovalRequired: Bool?
    let countyID: Int?
    let countyName: String?
    let licenseActivityID: Int?
    let phone: String?
    let clientLogoPath, activityDescription: String?
    let paymentDueDate, currentDateTime, saleStartDateTime, timeZone: String?
    let licenseAgreementURL, status, publicKey: String?
}

// MARK: - ActivityDetailPageChecks
struct ActivityDetailPageChecks: Codable {
    let isPreApprovalRequested, isFreeAccessPermit: Bool?
    let preApprRequestID: Int?
    let preApprovalStatus: String?
    let existingLicenseHolderAccountID, existingLicenseHolderProfileID: Int?
    let isRenewal, isUserProfileComplete, showRequestEntry, showLicenseFee: Bool?
    let showPreApprovalRequestButton, showRenewButton, showLicenseNowButton, showAlreadyPurchasedButton: Bool?
    let showSoldOutButton, showComingSoonButton, showAcceptAndPayButton, showAcceptButton: Bool?
}

// MARK: - Amenity
struct Amenity: Codable {
    let productID, amenityTypeID: Int?
    let amenityName, amenityType, amenityIcon: String?
    let description: String?
    let amenities: [Amenity]?
}

// MARK: - ClientDetails
struct ClientDetails: Codable {
    let clientID: Int?
    let clientCurrentFY: Bool?
    let clientSite: String?
    let rightofEntry, roEAgreement, deerHarvestInfo, recManualChecks: Bool?
    let addClubMembers, allowTraxAppAccess, clubMemberLicense, clientAdministration: Bool?
    let externalLogins: Bool?
}

// MARK: - ClientDocument
struct ClientDocument: Codable {
    let clientDocumentID, clientID: Int?
    let clientDocument: String?
    let isPublic, rlu, permit, dayPass: Bool?
    let fileName: String?
    let uploadFile: String?
    let documentName: String?
}

// MARK: - Image
struct Image: Codable {
    let productImageID, productID: Int?
    let imageFileName: String?
    let caption: String?
}

// MARK: - MapFile
struct MapInfoJSON: Codable {
    let key1: String?
    let key2: Int?
    // Add more properties as needed
}

struct MapFile: Codable {
    let displayName, countyName, regionName, stateName: String?
    let productName, productNo: String?
    let mapFileID, productID: Int?
    let mapFileName: String?
    let mapInfoJSON: MapInfoJSON?
    
    enum CodingKeys: String, CodingKey {
        case displayName, countyName, regionName, stateName, productName, productNo, mapFileID, productID, mapFileName
        case mapInfoJSON = "mapInfoJson"
    }
}

// MARK: - SimilarProperty
struct SimilarProperty: Codable {
    let productID, licenseActivityID: Int?
    let imageFilename: String?
    let countyName, productNo, stateName, displayText: String?
    let publicKey: String?
}

// MARK: - SpecialCondition
struct SpecialCondition: Codable {
    let specCndID: Int?
    let specCndDesc: String?
    let productID: Int?
}
struct Member : Codable {
    let address : String?
    let city : String?
    let email : String?
    let firstName : String?
    let lastName : String?
    let phone : String?
    let state : String?
    let zip : String?
}
