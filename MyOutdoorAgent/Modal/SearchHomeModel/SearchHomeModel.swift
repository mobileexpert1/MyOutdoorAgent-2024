//  SearchHomeModel.swift
//  MyOutdoorAgent
//  Created by CS on 27/09/22.

//  SearchHomeModel.swift
//  MyOutdoorAgent
//  Created by CS on 27/09/22.

import Foundation

//// MARK: - SearchHomeModel
//struct SearchHomeModel: Codable {
//    let statusCode: Int
//    let message: String
//    let model: [SearchHomeModelClass]?
//}
//
//// MARK: - SearchHomeModelClass
//struct SearchHomeModelClass: Codable {
//    let displayName, activityNumber: String?
//    let activityType: ActivityType?
//    let maxSaleQtyAllowed, maxGuestsAllowed, guestPassCost, guestPassAllowedDays: Int?
//    let memberPassCost, maxMembersAllowed, preSaleCharge, saleCount: Int?
//    let isPurchased: Bool?
//    let productTypeID: Int?
//    let productType: String?
//    let preSale: Int?
//    let agreementName: String?
//    let productID, clientPropertyID, clientID : Int?
//    let acres: Float?
//    let clientRegionID: Int?
//    let address, regionName: String?
//    let state: State?
//    let city, licenseType: String?
//    let licenseStartDate, licenseEndDate, activityStartDate, activityEndDate: String?
//    let licenseFee: Int?
//    let displayDescription: String?
//    let productNo: String?
//    let propertyName: String?
//    let hostApprovalRequired, motorizedAccess: Bool?
//    let countyID: Int?
//    let countyName: String?
//    let licenseActivityID: Int?
//    let requestStatus: String?
//    let propertyUserStatus: Int?
//    let status: Status?
//    let preApprRequestID: Int?
//    let phone: String?
//    let clientLogoPath: ClientLogoPath?
//    let renewalStatus: Int?
//    let activityDescription: String?
//    let currentDateTime: String?
//    let saleStartDateTime: String?
//    let timeZone: TimeZone?
//    let licenseAgreementURL: String?
//    let publicKey: String?
//    let clientName: ClientName?
//    let clientPublicKey: ClientPublicKey?
//    let imagefilename: String?
//    let amenities: String?
//    let amenitiyList: [AmenitiyList]?
//    let specCndDesc: String?
//}
//    enum CodingKeys: String, CodingKey {
//        case displayName = "displayName"
//        case activityNumber = "activityNumber"
//        case activityType = "activityType"
//        case maxSaleQtyAllowed = "maxSaleQtyAllowed"
//        case maxGuestsAllowed = "maxGuestsAllowed"
//        case guestPassCost = "guestPassCost"
//        case guestPassAllowedDays = "guestPassAllowedDays"
//        case memberPassCost = "memberPassCost"
//        case maxMembersAllowed = "maxMembersAllowed"
//        case preSaleCharge = "preSaleCharge"
//        case saleCount = "saleCount"
//        case isPurchased = "isPurchased"
//        case productTypeID = "productTypeID"
//        case productType = "productType"
//        case preSale = "preSale"
//        case agreementName = "agreementName"
//        case productID = "productID"
//        case clientPropertyID = "clientPropertyID"
//        case clientID = "clientID"
//        case acres = "acres"
//        case clientRegionID = "clientRegionID"
//        case address = "address"
//        case regionName = "regionName"
//        case state = "state"
//        case city = "city"
//        case licenseType = "licenseType"
//        case licenseStartDate = "licenseStartDate"
//        case licenseEndDate = "licenseEndDate"
//        case activityStartDate = "activityStartDate"
//        case activityEndDate = "activityEndDate"
//        case licenseFee = "licenseFee"
//        case displayDescription = "displayDescription"
//        case productNo = "productNo"
//        case propertyName = "propertyName"
//        case hostApprovalRequired = "hostApprovalRequired"
//        case motorizedAccess = "motorizedAccess"
//        case countyID = "countyID"
//        case countyName = "countyName"
//        case licenseActivityID = "licenseActivityID"
//        case requestStatus = "requestStatus"
//        case propertyUserStatus = "propertyUserStatus"
//        case status = "status"
//        case preApprRequestID = "preApprRequestID"
//        case phone = "phone"
//        case clientLogoPath = "clientLogoPath"
//        case renewalStatus = "renewalStatus"
//        case activityDescription = "activityDescription"
//        case currentDateTime = "currentDateTime"
//        case saleStartDateTime = "saleStartDateTime"
//        case timeZone = "timeZone"
//        case licenseAgreementURL = "licenseAgreementURL"
//        case publicKey = "publicKey"
//        case clientName = "clientName"
//        case clientPublicKey = "clientPublicKey"
//        case imagefilename = "imagefilename"
//        case amenities = ""
//}
//
//enum ActivityType: String, Codable {
//    case dayPass = "Day Pass"
//    case licenseNow = "License Now"
//}
//
//// MARK: - AmenitiyList
//struct AmenitiyList: Codable {
//    let amenityName, amenityIcon: String
//}
//
//enum ClientLogoPath: String, Codable {
//    case assetsClientLogo13_LogoJPEG = "/Assets/ClientLogo/13_Logo.jpeg"
//    case assetsClientLogo361_LogoJPEG = "/Assets/ClientLogo/361_Logo.jpeg"
//    case assetsClientLogo364_LogoJPEG = "/Assets/ClientLogo/364_Logo.jpeg"
//    case assetsClientLogo356_Logo_LogoJPEG = "/Assets/ClientLogo/356_Logo.jpeg"
//}
//
//enum ClientName: String, Codable {
//    case hamptonLumberLLC = "Hampton Lumber LLC"
//    case johnCena = "John Cena"
//    case moaLandowner = "MOA Landowner"
//    case shivamTest = "Shivam Test"
//}
//
//enum ClientPublicKey: String, Codable {
//    case cli67Hz3Nfx = "cli_67hz3nfx"
//    case cliCismvhb1 = "cli_cismvhb1"
//    case cliE9I2L8Qs = "cli_e9i2l8qs"
//}
//
//enum CurrentDateTime: String, Codable {
//    case the20240902T232054 = "2024-09-02T23:20:54"
//    case the20240903T002054 = "2024-09-03T00:20:54"
//    case the20240903T012054 = "2024-09-03T01:20:54"
//}
//
//enum State: String, Codable {
//    case alabama = "Alabama"
//    case arizona = "Arizona"
//    case arkansas = "Arkansas"
//    case california = "California"
//    case washington = "Washington"
//}
//
//enum Status: String, Codable {
//    case statusOpen = "Open"
//}
//
//enum TimeZone: String, Codable {
//    case ct = "CT"
//    case mt = "MT"
//    case pt = "PT"
//}
struct SearchHomeModel: Codable {
    let statusCode: Int?
    let message: String?
    let model: [SearchHomeModelClass]
}

// MARK: - Model
struct SearchHomeModelClass: Codable {
    let displayName: String?
    let activityNumber: String?
    let activityType: String?
    let maxSaleQtyAllowed, maxGuestsAllowed, guestPassCost, guestPassAllowedDays: Int?
    let memberPassCost, maxMembersAllowed, preSaleCharge, saleCount: Int?
    let isPurchased: JSONNull?
    let productTypeID: Int?
    let productType: JSONNull?
    let preSale: Int?
    let agreementName: JSONNull?
    let productID, clientPropertyID, clientID: Int?
    let acres: Double?
    let clientRegionID: Int?
    let address, regionName: JSONNull?
    let state: String?
    let city, licenseType: JSONNull?
    let licenseStartDate, licenseEndDate, activityStartDate, activityEndDate: String?
    let licenseFee: Float?
    let displayDescription: JSONNull?
    let productNo: String?
    let propertyName: JSONNull?
    let hostApprovalRequired, motorizedAccess: Bool?
    let countyID: Int?
    let countyName: String?
    let licenseActivityID: Int?
    let requestStatus: JSONNull?
    let propertyUserStatus: Int?
    let status: String?
    let preApprRequestID: Int?
    let phone: JSONNull?
    let clientLogoPath: String?
    let renewalStatus: Int?
    let activityDescription: JSONNull?
    let currentDateTime: String?
    let saleStartDateTime: String?
    let timeZone: String?
    let licenseAgreementURL: JSONNull?
    let publicKey: String?
    let clientName: String?
    let clientPublicKey: String?
    let imagefilename, amenities: String?
    let amenitiyList: [AmenitiyList]?
    let specCndDesc: JSONNull?
}

enum ActivityType: String, Codable {
    case dayPass = "Day Pass"
    case licenseNow = "License Now"
}

// MARK: - AmenitiyList
struct AmenitiyList: Codable {
    let amenityName, amenityIcon: String?
}

enum ClientLogoPath: String, Codable {
    case assetsClientLogo13_LogoJPEG = "/Assets/ClientLogo/13_Logo.jpeg"
    case assetsClientLogo356_LogoJPEG = "/Assets/ClientLogo/356_Logo.jpeg"
    case assetsClientLogo370_LogoJPEG = "/Assets/ClientLogo/370_Logo.jpeg"
}

enum ClientName: String, Codable {
    case hamptonLumberLLC = "Hampton Lumber LLC"
    case shivamTest = "Shivam Test"
}

enum ClientPublicKey: String, Codable {
    case cli67Hz3Nfx = "cli_67hz3nfx"
    case cliDavpu7N4 = "cli_davpu7n4"
}

enum CurrentDateTime: String, Codable {
    case the20240904T055423 = "2024-09-04T05:54:23"
    case the20240904T065423 = "2024-09-04T06:54:23"
    case the20240904T075423 = "2024-09-04T07:54:23"
    case the20240904T082536 = "2024-09-04T08:25:36"
}

enum State: String, Codable {
    case alabama = "Alabama"
    case arizona = "Arizona"
    case arkansas = "Arkansas"
    case washington = "Washington"
}

enum Status: String, Codable {
    case statusOpen = "Open"
}

enum TimeZone: String, Codable {
    case ct = "CT"
    case mt = "MT"
    case pt = "PT"
}
