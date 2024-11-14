//  ApiConstants.swift
//  MyOutdoorAgent
//  Created by CS on 22/08/22.

import Foundation

//Client Url = "https://client.myoutdooragent.com//RLU_Images/"

// MARK: - Headers
let headers: [String: String] = [
    "Content-Type" : "application/json; charset=utf-8",
    "clientsite" : "MOA"
]

let headersMoa: [String: String] = [
    "Content-Type" : "application/json; charset=utf-8"
]

struct Headers {
    static let content_Type = "Content-Type"
    static let client_site = "clientsite"
    static let authorization = "Authorization"
    static let content_Type_Value = "application/json; charset=utf-8"
    static let client_site_Value = "MOA"
}

// MARK: - BASE URL
//struct Apis {
//    static let baseUrl = "https://datav2.myoutdooragent.com/api/"
//    static let paymentUrl = "https://adminv2.myoutdooragent.com"
//    static let pdfUrl = "https://adminv2.myoutdooragent.com/"
//    static let rluImageUrl = "https://adminv2.myoutdooragent.com/RLU_Images/"
//    static let amenitiesUrl = "https://adminv2.myoutdooragent.com"
//    static let mapUrl = "https://adminv2.myoutdooragent.com/Assets/MapFiles/"
//    static let licenseAmenitiesUrl = "https://adminv2.myoutdooragent.com/icon/"
//    static let openPaymentTokenUrl = "https://testoneconnect.myoutdooragent.com/payment/"
//    static let licensePdfUrl = "https://datav2.myoutdooragent.com/"
//}

//struct Apis {
//    static let baseUrl = "https://datav2.myoutdooragent.com/api/"
//   // static let baseUrl = "https://services.myoutdooragent.com/api/"
//    static let rluImageUrl = "https://client.myoutdooragent.com/RLU_Images/"
//  //  static let rluImageUrl = "https://adminv2.myoutdooragent.com/RLU_Images/"
//    static let mapUrl = "https://client.myoutdooragent.com/Assets/MapFiles/"
//    //   static let mapUrl = "https://adminv2.myoutdooragent.com/Assets/MapFiles/"
//    //vish
//    //static let pdfUrl = "https://client.myoutdooragent.com/"
//       static let pdfUrl = "https://adminv2.myoutdooragent.com/"
//    static let openPaymentTokenUrl = "https://oneconnect.myoutdooragent.com/payment/"
//    //   static let openPaymentTokenUrl = "https://testoneconnect.myoutdooragent.com/payment/"
//    
//    
//    static let paymentUrl = "https://client.myoutdooragent.com"
//    //   static let paymentUrl = "https://adminv2.myoutdooragent.com"
//    static let amenitiesUrl = "https://client.myoutdooragent.com"
//    //   static let amenitiesUrl = "https://adminv2.myoutdooragent.com"
//    static let licenseAmenitiesUrl = "https://client.myoutdooragent.com/icon/"
//    //   static let licenseAmenitiesUrl = "https://adminv2.myoutdooragent.com/icon/"
//    static let licensePdfUrl = "https://services.myoutdooragent.com/"
//}


//struct Apis {
//    static let baseUrl = "https://datav2.myoutdooragent.com/api/"
//    static let rluImageUrl = "https://adminv2.myoutdooragent.com/RLU_Images/"
//    static let mapUrl = "https://adminv2.myoutdooragent.com/Assets/MapFiles/"
//    static let pdfUrl = "https://adminv2.myoutdooragent.com/"
//    static let openPaymentTokenUrl = "https://testoneconnect.myoutdooragent.com/payment/"
//    
//    
//    static let paymentUrl = "https://adminv2.myoutdooragent.com"
//    static let amenitiesUrl = "https://adminv2.myoutdooragent.com"
//    static let licenseAmenitiesUrl = "https://adminv2.myoutdooragent.com/icon/"
//    static let licensePdfUrl = "https://datav2.myoutdooragent.com/"
//}

struct Apis {
    static let baseUrl = "https://services.myoutdooragent.com/api/"
        static let rluImageUrl = "https://client.myoutdooragent.com/RLU_Images/"
        static let mapUrl = "https://client.myoutdooragent.com/Assets/MapFiles/"
           static let pdfUrl = "https://client.myoutdooragent.com/"
        static let openPaymentTokenUrl = "https://oneconnect.myoutdooragent.com/payment/"
        
        
        static let paymentUrl = "https://client.myoutdooragent.com"
        static let amenitiesUrl = "https://client.myoutdooragent.com"
        static let licenseAmenitiesUrl = "https://client.myoutdooragent.com/icon/"
        static let licensePdfUrl = "https://services.myoutdooragent.com/"
}




// MARK: - FORM
// Social Register Api
struct SocialRegisterApi {
    static let baseApi = (Apis.baseUrl) + "account/userregister"
    static let firstName = "FirstName"
    static let streetAddress = "StreetAddress"
    static let city = "City"
    static let st = "St"
    static let zip = "ZIP"
    static let phone = "Phone"
    static let groupName = "GroupName"
    static let getNotifications = "GetNotifications"
    static let isBlacklisted = "IsBlacklisted"
    static let email = "Email"
    static let password = "Password"
    static let accountType = "AccountType"
    static let authenticationKey = "AuthenticationKey"
    static let authorizationKey = "AuthorizationKey"
    static let authenticationType = "AuthenticationType"
    static let sourceClientID = "SourceClientID"
}

// User Register Api
struct RegisterApi {
    static let baseApi = (Apis.baseUrl) + "account/userregister"
    static let firstName = "FirstName"
    static let lastName = "LastName"
    static let email = "Email"
    static let password = "Password"
    static let confirmPassword = "ConfirmPassword"
    static let accountType = "AccountType"
    static let authenticationKey = "AuthenticationKey"
    static let authenticationType = "AuthenticationType"
    static let sourceClientID = "SourceClientID"
}

// Login Api
struct LoginApi {
    static let baseApi = (Apis.baseUrl) + "account/Authorize"
    static let email = "Email"
    static let password = "Password"
    static let authorizationKey = "AuthorizationKey"
    static let authenticationType = "AuthenticationType"
}

// Forgot Password Api
struct ForgotPasswordApi {
    static let baseApi = (Apis.baseUrl) + "account/forgotpasswordv2"
    static let email = "Email"
}

// MARK: - HOME

// Get All Amenities Api
struct GetAllAmenitiesApi {
    static let baseApi = (Apis.baseUrl) + "search/getallamenities"
}


// Search Api
struct SearchHomeApi {
    static let baseApi = (Apis.baseUrl) + "search/SearchV2"
    static let stateName = "State"
    static let Product = "Product"
    static let county = "County"
    static let amenities = "Amenities"
    static let ProductAcresMin = "ProductAcresMin"
    static let ProductAcresMax = "ProductAcresMax"
    static let priceMin = "ProductPriceMin"
    static let priceMax = "ProductPriceMax"
    static let client = "Client"
    static let productTypeID = "ProductTypeID"
    static let order = "Order"
    static let sort = "Sort"
    static let PageNumber = "PageNumber"
}
//        "State": [],  //
//            "County": [],
//            "Product": [],
//            "Amenities": [],
//            "ProductAcresMin": 0,
//            "ProductAcresMax": 0,
//            "ProductPriceMin": 0,
//            "ProductPriceMax": 0,
//            "Client": "",
//            "ProductTypeID": 0,
//            "Sort": "",
//            "Order": "",
//            "PageNumber": 1
// Select RegionWise Properties Api
struct RegionwiseProperties {
    static let baseApi = (Apis.baseUrl) + "property/regionwiseproperties"
}

// Activity Detail Api
struct ActivityDetailApi {
    static let baseApi = (Apis.baseUrl) + "Property/ActivityDetailV3"
    static let publicKey = "PublicKey"
    static let token = "token"
}

// Right of Entry Form Api
struct RightOfEntryFormApi {
    static let baseApi = (Apis.baseUrl) + "License/rightofentryform"
    static let roERequestID = "RoERequestID"
    static let productID = "ProductID"
    static let userAccountID = "UserAccountID"
    static let tractName = "TractName"
    static let productNo = "ProductNo"
    static let county = "County"
    static let state = "State"
    static let userName = "UserName"
    static let dateOfAccessRequested = "dateOfAccessRequested"
    static let permittee = "Permittee"
    static let address = "Address"
    static let roEUsersLists = "RoEUsersLists"
}

// Get Payment Token Api
struct GetPaymentTokenApi {
    static let baseApi = (Apis.baseUrl) + "payment/getpaymenttoken"
    static let requestType = "requestType"
    static let rluNo = "rluNo"
    static let fundAccountKey = "fundAccountKey"
    static let clientInvoiceId = "clientInvoiceId"
    static let userAccountId = "userAccountId"
    static let email = "email"
    static let licenseFee = "licenseFee"
    static let paidBy = "paidBy"
    static let cancelUrl = "cancelUrl"
    static let errorUrl = "errorUrl"
    static let productTypeId = "productTypeId"
    static let returnUrl = "returnUrl"
    static let productID = "productID"
    static let invoiceTypeID = "invoiceTypeID"
}

// Day Pass Availability Api
struct DayPassAvailabilityApi {
    static let baseApi = (Apis.baseUrl) + "Property/daypassavailibility"
    static let licenseActivityID = "licenseActivityID"
    static let dateOfArrival = "dateOfArrival"
    static let daysCount = "daysCount"
}

// Add Harvesting Details
struct AddHarvestingDetailsApi {
    static let baseApi = (Apis.baseUrl) + "license/addharvestingdetails"
    static let huntingSeason = "huntingSeason"
    static let buckCount = "buckCount"
    static let doeCount = "doeCount"
    static let turkeyCount = "turkeyCount"
    static let bearCount = "bearCount"
    static let productID = "productID"
}

// Property License Agreement
struct GenerateLicenseContractApi {
    static let baseApi = (Apis.baseUrl) + "License/generateContractv2"
    static let licenseActivityID = "LicenseActivityID"
}

// MARK: - Search

// Search AutoFill Api
struct AutoFillSearchApi {
    static let baseApi = (Apis.baseUrl) + "search/searchAutofill"
    static let searchText = "SearchText"
}

struct DeleteAccountApi {
    static let baseApi = (Apis.baseUrl) + "account/DeleteUser"
}

// Available States Api
struct AvailableStatesApi {
    static let baseApi = (Apis.baseUrl) + "search/getavailablestates"
}

// Get Available County by State
struct GetAvailableCountyByStates {
    static let baseApi = (Apis.baseUrl) + "Search/getavailablecountiesbystate"
    static let stateAbbr = "StateAbbr"
}

// Save Search Api
struct SaveSearchApi {
    static let baseApi = (Apis.baseUrl) + "search/SaveSearch"
    static let stateName = "StateName"
    static let regionName = "RegionName"
    static let propertyName = "PropertyName"
    static let freeText = "freeText"
    static let county = "County"
    static let rLU = "RLU"
    static let amenities = "Amenities"
    static let rLUAcresMin = "RLUAcresMin"
    static let rLUAcresMax = "RLUAcresMax"
    static let priceMin = "PriceMin"
    static let priceMax = "PriceMax"
    static let userAccountID = "UserAccountID"
    static let iPAddress = "IPAddress"
    static let client = "Client"
    static let productTypeID = "ProductTypeID"
    static let searchName = "SearchName"
}

// MARK: - MESSAGE

// Message list - My Conversations Api
struct MyConversationsApi {
    static let baseApi = (Apis.baseUrl) + "message/myconversations"
}

// Get All Message API
struct GetAllMessagesApi {
    static let baseApi = (Apis.baseUrl) + "Message/GetAllMessages"
    static let productID = "ProductID"
}

// Send Message API
struct SendMessageApi {
    static let baseApi = (Apis.baseUrl) + "Message/sendmessage"
    static let productID = "ProductID"
    static let messageText = "MessageText"
}

// Refresh Message API
struct RefreshMessageApi {
    static let baseApi = (Apis.baseUrl) + "Message/RefreshMessages"
    static let userMsgID = "UserMsgID"
    static let productID = "ProductID"
}

// MARK: - PROFILE

// Edit User Profile Api
struct EditUserProfileApi {
    static let baseApi = (Apis.baseUrl) + "user/editprofile"
    static let userProfileID = "userProfileID"
    static let userAccountID = "userAccountID"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let streetAddress = "streetAddress"
    static let city = "city"
    static let st = "st"
    static let zip = "zip"
    static let phone = "phone"
    static let groupName = "groupName"
    static let clubName = "clubName"
    static let email = "email"
    static let getNotifications = "getNotifications"
    static let authenticationType = "authenticationType"
    static let isUserProfileComplete = "isUserProfileComplete"
    static let stateName = "stateName"
    static let status = "status"
}

// View User Profile Api
struct UserProfileApi {
    static let baseApi = (Apis.baseUrl) + "user/userprofile"
}

// Get States Api
struct StatesApi {
    static let baseApi = (Apis.baseUrl) + "search/getallstates"
}

// Manage Notifications Api
struct ManageNotificationsApi {
    static let baseApi = (Apis.baseUrl) + "account/manageNotifications"
    static let notifications = "Notifications"
}

// Change Password Api
struct ChangePasswordApi {
    static let baseApi = (Apis.baseUrl) + "user/changepassword"
    static let password = "Password"
    static let newPassword = "NewPassword"
}

// Saved Searches Api
struct SavedSearchesApi {
    static let baseApi = (Apis.baseUrl) + "search/SavedSearches"
}

// Delete Searches Api
struct DeleteSearchesApi {
    static let baseApi = (Apis.baseUrl) + "search/deletesearch"
    static let userSearchID = "UserSearchID"
}

// Logout Api
struct LogOutApi {
    static let baseApi = (Apis.baseUrl) + "Account/Logout"
}

// My Licenses Api
// -- Active License Api
struct MyLicensesApi {
    static let baseApi = (Apis.baseUrl) + "license/mylicenses"
}

// -- Member License Api
struct MemberLicensesApi {
    static let baseApi = (Apis.baseUrl) + "license/memberoflicenses"
}

// -- Pending License Api
struct PendingLicensesApi {
    static let baseApi = (Apis.baseUrl) + "license/pendinginviteslicenses"
}

// -- Accept Manual Payment Request Api
struct AcceptManualPaymentApi {
    static let baseApi = (Apis.baseUrl) + "License/userAcceptManualPayment"
    static let licenseContractID = "LicenseContractID"
}

// -- Accept Licenses Request Api
struct AcceptLicensesReqApi {
    static let baseApi = (Apis.baseUrl) + "license/acceptlicenserequest"
    static let licenseContractID = "LicenseContractID"
    static let userAccountID = "UserAccountID"
}

// -- Expired License Api
struct ExpiredLicensesApi {
    static let baseApi = (Apis.baseUrl) + "license/expiredlicenses"
}

// Pre Approval Request Api
struct PreApprovalReqApi {
//    static let baseApi = (Apis.baseUrl) + "search/mypreapprovalrequests"
    static let baseApi = (Apis.baseUrl) + "search/mypreapprovalrequestsv2"
}

// Submit Pre Approval Request Api
struct SubmitPreApprovalReqApi {
    static let baseApi = (Apis.baseUrl) + "search/preapprovalrequestv2"
    static let userAccountID = "UserAccountID"
    static let licenseActivityID = "LicenseActivityID"
    static let requestComments = "RequestComments"
    static let productID = "ProductID"
}

// Cancel Pre Approval Request Api
struct CancelPreApprovalReqApi {
    static let baseApi = (Apis.baseUrl) + "search/cancelpreapprovalrequest"
    static let preApprRequestID = "preApprRequestID"
}

// License Detail Api
struct LicenseDetailApi {
    static let baseApi = (Apis.baseUrl) + "license/licensedetailv3"
    static let publicKey = "PublicKey"
}

// Add Member Api
struct AddMemberApi {
    static let baseApi = (Apis.baseUrl) + "club/addClubMember"
//    static let licenseContractID = "LicenseContractID"
//    static let firstName = "FirstName"
//    static let lastName = "LastName"
//    static let email = "Email"
//    static let phone = "Phone"
//    static let address = "Address"
//    static let state = "State"
//    static let city = "City"
//    static let zip = "Zip"
    
    static let licenseContractID = "licensecontractid"
    static let firstName = "firstname"
    static let lastName = "lastname"
    static let email = "email"
    static let phone = "Phone"
    static let address = "Address"
    static let state = "State"
    static let city = "City"
    static let zip = "Zip"
    
//    {"licensecontractid":1291,"firstname":"amrish","lastname":"sadsad","email":"asdasd@dsfs.ggh","Phone":"4354353454","Address":"fghfghfgh","State":"AZ","City":"43543543","Zip":"34534"}
}

// Invite Member Api
struct InviteMemberApi {
    static let baseApi = (Apis.baseUrl) + "license/invitemember"
    static let licenseContractID = "LicenseContractID"
    static let userEmail = "UserEmail"
}

// Remove Member Api
struct RemoveMemberApi {
    static let baseApi = (Apis.baseUrl) + "license/removemember"
    static let licenseContractMemberID = "LicenseContractMemberID"
}

// Add Vehicle Info Api
struct AddVehicleApi {
    static let baseApi = (Apis.baseUrl) + "license/addUpdateVehicle"
    static let licenseContractID = "LicenseContractID"
    static let vehicleDetailID = "VehicleDetailID"
    static let vehicleMake = "VehicleMake"
    static let vehicleModel = "VehicleModel"
    static let vehicleColor = "VehicleColor"
    static let vehicleLicensePlate = "VehicleLicensePlate"
    static let vehicleState = "VehicleState"
    static let vehicleType = "VehicleType"
}

// Delete Vehicle Api
struct DeleteVehicleApi {
    static let baseApi = (Apis.baseUrl) + "license/deleteVehicle"
    static let vehicleDetailID = "VehicleDetailID"
}

// Property License Agreement
struct GenerateContractApi {
    static let baseApi = (Apis.baseUrl) + "License/generateContractv2"
    static let licenseContractID = "LicenseContractID"
}

// Generate Club Membership Card
struct GenerateClubMembershipCardApi {
    static let baseApi = (Apis.baseUrl) + "club/generateclubmembershipcard"
    static let licenseContractID = "LicenseContractID"
}

// List Your Property Api
struct ListYourPropertyApi {
    //https://services.myoutdooragent.com/api/account/listyourproperty
    static let baseApi = (Apis.baseUrl) + "account/listyourproperty"
    static let email = "Email"
    static let landownerType = "LandownerType"
    static let firstName = "FirstName"
    static let lastName = "LastName"
    static let address = "Address"
    static let city = "City"
    static let state = "State"
    static let zip = "Zip"
    static let phone = "Phone"
    static let subscriptionType = "SubscriptionType"
}

// Contact Us Api
struct ContactUsApi {
    static let baseApi = (Apis.baseUrl) + "account/ContactUs"
    static let name = "Name"
    static let email = "Email"
    static let body = "Body"
    static let Purpose = "Purpose"
}

// MARK: - Maps
struct MapApis {
    static let baseUrl = "https://maps.myoutdooragent.com/arcgisweb/rest/services/MOA/MOA_Map_Live/MapServer/"      // Live
    //static let baseUrl = "https://maps.myoutdooragent.com/arcgisweb/rest/services/MOATest/MOA_Map_Test/MapServer/"    //Test
}

// Point Layer Api
struct PointLayerApi {
    static let baseApi = (MapApis.baseUrl) + "1/query?"
    static let Where = "where"
    static let outFields = "outFields"
    static let returnGeometry = "returnGeometry"
    static let f = "f"
}

// Poly Layer Api
struct PolyLayerApi {
    static let baseApi = (MapApis.baseUrl) + "2/query?"
    static let Where = "where"
    static let outFields = "outFields"
    static let returnGeometry = "returnGeometry"
    static let f = "f"
}


// Access Point Api
struct AccessPointApi {
    static let baseApi = (MapApis.baseUrl) + "0/query?"
    static let Where = "where"
    static let outFields = "outFields"
    static let returnGeometry = "returnGeometry"
    static let f = "f"
}
// Access Permit Shapes Api
struct PermitShapesApi {
    static let baseApi = (MapApis.baseUrl) + "4/query?"
    static let Where = "where"
    static let outFields = "outFields"
    static let returnGeometry = "returnGeometry"
    static let f = "f"
}
// Multipolygon Api 1
struct MultiPolygonApi {
    static let baseApi = (MapApis.baseUrl) + "2/query?"
   // static let baseApi = "https://maps.myoutdooragent.com/arcgisweb/rest/services/MOATest/MOA_Map_Test/MapServer/" + "2/query?"
    static let Where = "where"
    static let spatialRel = "spatialRel"
    static let outFields = "outFields"
    static let f = "f"
}
// Multipolygon Api 2
struct MultiPolygonApi2 {
    static let baseApi = (MapApis.baseUrl) + "4/query?"
   // static let baseApi = "https://maps.myoutdooragent.com/arcgisweb/rest/services/MOATest/MOA_Map_Test/MapServer/" + "2/query?"
    static let Where = "where"
    static let spatialRel = "spatialRel"
    static let outFields = "outFields"
    static let f = "f"
}
// NonMotorized Api
struct NonMotorized {
    static let baseApi = (MapApis.baseUrl) + "3/query?"
    static let Where = "where"
    static let outFields = "outFields"
    static let returnGeometry = "returnGeometry"
    static let f = "f"
}

struct SelectedStateMap {
    static let baseApi = ("https://maps.myoutdooragent.com/arcgisweb/rest/services/RLMS/LicenseMapBackground/MapServer/" + "36/query?")
    static let f = "f"
    static let outFields = "outFields"
    static let spatialRel = "spatialRel"
    static let Where = "where"
}
// Cluster Api
struct ClusterApi {
    static let baseApi = (MapApis.baseUrl) + ""
}

// RLU Map Detail Api
struct MapDetailApi {
    static let baseApi = (Apis.baseUrl) + "property/rlumapdetail"
    static let productNo = "ProductNo"
}
