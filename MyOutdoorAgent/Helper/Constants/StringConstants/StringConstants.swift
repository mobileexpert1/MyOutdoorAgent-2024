//  MyOutdoorAgent
//  Created by CS on 01/08/22.

import Foundation
import UIKit

let EMPTY_STR = ""
let ZERO_STR = "0"
let MOA = "MOA"
var sortByArr = ["New Releases", "Price: High to Low",  "Price: Low to High", "Acres: High to Low" , "Acres: Low to High"]
let googleKey = "AIzaSyBN8NM34ECWRPo4yfp5DNhLiS6B0QsPgl0"

// MARK: - Custom View
public enum CustomView : String {
    case customNavBar
    case homeTopView
    case searchTopView
}

extension CustomView {
    public var name : String {
        switch self {
        case .customNavBar : return "CustomNavBar"
        case .homeTopView : return "HomeTopView"
        case .searchTopView : return "SearchTopView"
        }
    }
}

// MARK: - Custom Cells
public enum CustomCells : String {
    case helpCell
    case preApprovalCell
    case messageCell
    case searchCell
    case savedSearchesTVCell
    case savedSearchesCVCell
    case homeListCVCell
    case homeTitleCollVCell
    case amenitiesCVCell
    case propertyTVCell
    case propertyHeaderTVCell
    case propertyHeaderCVCell
    case propertyConditionsTVCell
    case propertyAmenitiesTVCell
    case licenseDetailTVCell
    case propertyMapsTVCell
    case messageSendTableViewCell
    case messageTableViewCell
    case vehicleInfoTVCell
    case amenitiesListCVCell
    case inviteMemberCVCell
    case inviteMemberTVCell
    case choosePlanTVCell
    case invoicesTVCell
    case renewalMemberTVCell
}

extension CustomCells {
    public var name : String {
        switch self {
        case .helpCell : return "HelpTblVCell"
        case .preApprovalCell : return "PreApprovalCVCell"
        case .messageCell : return "MessageListCell"
        case .searchCell : return "SearchCollVCell"
        case .savedSearchesTVCell: return "SavedSearchesTVCell"
        case .savedSearchesCVCell: return "SavedSearchesCVCell"
        case .homeListCVCell: return "HomeListCVCell"
        case .homeTitleCollVCell: return "HomeTitleCollVCell"
        case .amenitiesCVCell: return "AmenitiesCVCell"
        case .propertyTVCell: return "PropertyTVCell"
        case .propertyHeaderTVCell: return "PropertyHeaderTVCell"
        case .propertyHeaderCVCell: return "PropertyHeaderCVCell"
        case .propertyConditionsTVCell: return "PropertyConditionsTVCell"
        case .propertyAmenitiesTVCell: return "PropertyAmenitiesTVCell"
        case .licenseDetailTVCell: return "LicenseDetailTVCell"
        case .propertyMapsTVCell: return "PropertyMapsTVCell"
        case .messageSendTableViewCell: return "MessageSendTableViewCell"
        case .messageTableViewCell: return "MessageTableViewCell"
        case .vehicleInfoTVCell: return "VehicleInfoTVCell"
        case .amenitiesListCVCell: return "AmenitiesListCVCell"
        case .inviteMemberCVCell: return "InviteMemberCVCell"
        case .inviteMemberTVCell: return "InviteMemberTVCell"
        case .choosePlanTVCell: return "ChoosePlanTVCell"
        case .invoicesTVCell: return "InvoicesTVCell"
        case .renewalMemberTVCell: return "RenewalMemberTVCell"
        }
    }
}

// MARK: - Color
public enum Colors {
    case grey
    case offWhite
    case green
    case bgGreenColor
    case lightGrey
    case mediumGrey
    case semiGrey
    case secondaryGrey
    case searchColor
    case redColor
    case contactUsColor
}

extension Colors {
    public var value : UIColor {
        switch self {
        case .grey: return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        case .offWhite: return UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        case .green: return UIColor(red: 30/255, green: 185/255, blue: 127/255, alpha: 1.0)
        case .bgGreenColor: return UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
        case .lightGrey: return UIColor(red: 242/255, green: 250/255, blue: 247/255, alpha: 1.0)
        case .mediumGrey: return UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)
        case .semiGrey: return UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        case .secondaryGrey: return UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)
        case .searchColor: return UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
        case .redColor: return UIColor(red: 217/255, green: 45/255, blue: 59/255, alpha: 1.0)
        case .contactUsColor: return UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0)
        }
    }
}

// MARK: - Images
public enum Images {
    case downArrow
    case upArrow
    case adventureSeeker
    case landowner
    case logo
    case logoImg
    case logoImage
    case chatSelected
    case chatUnselected
    case homeSelected
    case homeUnselected
    case profileSelected
    case profileUnselected
    case searchSelected
    case searchUnselected
    case check
    case uncheck
    case requested
    case accepted
    case hide
    case unhide
    case r_expired_rlu
    case r_expired_permit
    case r_pending_rlu
    case r_pending_permit
    case membership_rlu
    case membership_rlu_blue
    case membership_permit_blue
    case membership_permit
    case g_pending_permit
    case g_pending_rlu
    case g_future_permit
    case g_future_rlu
    case g_active_rlu
    case g_active_permit
    case back
    case backimg
    case permit
    case connect
    case twoConnect
    case list
    case map
    case changeimg
}

extension Images {
    public var name : UIImage {
        switch self {
        case .downArrow: return UIImage(named: "down_arrow")!
        case .upArrow: return UIImage(named: "up_arrow")!
        case .adventureSeeker: return UIImage(named: "adventure_seeker")!
        case .landowner: return UIImage(named: "landowner")!
        case .logo: return UIImage(named: "logo")!
        case .logoImg: return UIImage(named: "logo_img")!
        case .logoImage: return UIImage(named: "logo1")!
        case .chatSelected: return UIImage(named: "chat_selected")!
        case .chatUnselected: return UIImage(named: "chat_unselected")!
        case .homeSelected: return UIImage(named: "home_selected")!
        case .homeUnselected: return UIImage(named: "home_unselected")!
        case .profileSelected: return UIImage(named: "profile_selected")!
        case .profileUnselected: return UIImage(named: "profile_unselected")!
        case .searchSelected: return UIImage(named: "search_selected")!
        case .searchUnselected: return UIImage(named: "search_unselected")!
        case .check: return UIImage(named: "check")!
        case .uncheck: return UIImage(named: "uncheck")!
        case .requested: return UIImage(named: "requested")!
        case .accepted: return UIImage(named: "accepted")!
        case .hide: return UIImage(named: "hide")!
        case .unhide: return UIImage(named: "unhide")!
        case .r_expired_rlu: return UIImage(named: "r_expired_rlu")!
        case .r_expired_permit: return UIImage(named: "r_expired_permit")!
        case .r_pending_rlu: return UIImage(named: "r_pending_rlu")!
        case .r_pending_permit: return UIImage(named: "r_pending_permit")!
        case .membership_rlu: return UIImage(named: "membership_rlu")!
        case .membership_permit: return UIImage(named: "membership_permit")!
        case .g_pending_permit: return UIImage(named: "g_pending_permit")!
        case .g_pending_rlu: return UIImage(named: "g_pending_rlu")!
        case .g_future_permit: return UIImage(named: "g_future_permit")!
        case .g_future_rlu: return UIImage(named: "g_future_rlu")!
        case .g_active_rlu: return UIImage(named: "g_active_rlu")!
        case .g_active_permit: return UIImage(named: "g_active_permit")!
        case .back: return UIImage(named: "back")!
        case .backimg: return UIImage(named: "back_img")!
        case .permit: return UIImage(named: "permit")!
        case .connect: return UIImage(named: "connect")!
        case .twoConnect: return UIImage(named: "connect2")!
        case .list: return UIImage(named: "list")!
        case .map: return UIImage(named: "map")!
        case .changeimg: return UIImage(named: "newmp")!
        case .membership_rlu_blue: return UIImage(named: "membership_rlu_blue")!
        case .membership_permit_blue: return UIImage(named: "membership_permit_blue")!
        }
    }
}

// MARK: - AppErrors
public enum AppErrors : String {
    case somethingWrong
    case allFieldsReq
    case validEmail
    case internetConnection
    case sessionExpire
    case confirmEmail
    case emailReq
    case passwordLength
    case accountNotExit
    case passwordValid
    case passNotMatch
    case zipLength
    case validPhone
    case internetIssue
    case editProfile
    case selectDate
    case licenseAgreementError
    case noClubMembers
    case typeMessage
    case firstNameReq
    case lastNameReq
    case addressReq
    case cityReq
    case stateReq
    case phoneReq
    case paymentError
    case unablePaymentError
    case paymentSuccess
    case enterEmail
    case enterMessage
    case propertyNotListed
}

extension AppErrors {
    public var localizedDescription : String {
        switch self {
        case .somethingWrong : return "Something went wrong"
        case .allFieldsReq : return "All fields are required"
        case .validEmail : return "Your email address must be valid"
        case .internetConnection : return "The Internet connection appears to be offline."
        case .sessionExpire : return "Session Expire, Please Relogin"
        case .confirmEmail : return "Your email is not confirmed. Please confirm your email to proceed."
        case .emailReq : return "Email is required"
        case .accountNotExit : return "Account does not exist with this email."
        case .passwordLength : return "Password must be 8 character long"
        case .passwordValid : return "Your password must be greater than 8 Characters and contain special symbols, lower case and upper case letters"
        case .passNotMatch : return "Passwords doesn't match"
        case .zipLength : return "Zip code must be 5 characters long"
        case .validPhone : return "Your phone number must be valid"
        case .internetIssue: return "Kindly Check your Internet Connection"
        case .editProfile: return "Incomplete profile. Phone number and mailing address are required for purchasing."
        case .selectDate: return "Please select entry date"
        case .licenseAgreementError: return "Cannot access Permit Agreement - Missing vehicle info."
        case .noClubMembers: return "No Club Members for the License"
        case .typeMessage: return "Please type your message."
        case .firstNameReq: return "First name is required"
        case .lastNameReq: return "Last name is required"
        case .addressReq: return "Address is required"
        case .cityReq: return "City is required"
        case .stateReq: return "State is required"
        case .phoneReq: return "Phone is required"
        case .paymentError: return "Unable to generate payment token."
        case .unablePaymentError: return "Unable to process your payment."
        case .paymentSuccess: return "Payment Successful."
        case .enterEmail: return "Please enter email."
        case .enterMessage: return "Please enter message"
        case .propertyNotListed: return "Selected property not listed on the map"
        }
    }
}

// MARK: - Alerts
public enum AppAlerts : String {
    case alert
    case cameraAlert
    case signUpSuccess
    case loginSuccess
    case requestDelSuccess
    case deleteReq
    case noPreAppReqFound
    case noActiveLicense
    case noMemberLicense
    case noPendingLicense
    case noExpiredLicense
    case profileUpdate
    case logOutAlert
    case changePassword
    case searchDelSuccess
    case deleteSearch
    case noPropertyError
    case searchSaved
    case editProfile
    case successEntryForm
    case vehicleAdded
    case vehicleAddedSuccess
    case cancelPreApproval
    case cancelReq
    case cancelRequest
    case reqSubmitted
    case remove
    case vehicleRemove
    case vehicleRemoveSuccess
    case paymentFailed
    case paymentSuccess
    case memberRemove
    case memberRemoveSuccess
    case memberAdded
    case memberSuccess
    case selectSearch
    case leaveUsMessage
    case totalCost
    case success
    case messageSuccess
    case authReq
    case loginFirst
    case propertyNotListed
}

extension AppAlerts {
    public var title : String {
        switch self {
        case .alert: return "Alert"
        case .cameraAlert: return "You don't have camera"
        case .signUpSuccess: return "User signed up successfully"
        case .loginSuccess: return "User logged in successfully"
        case .requestDelSuccess: return "Request deleted successfully"
        case .deleteReq: return "Do you want to cancel your request?"
        case .noPreAppReqFound: return "You have not requested any Pre-Approvals."
        case .noActiveLicense: return "No Active License"
        case .noMemberLicense: return "No Member License"
        case .noPendingLicense: return "No Pending License"
        case .noExpiredLicense: return "No Expired License"
        case .profileUpdate: return "Profile Updated Successfully"
        case .logOutAlert: return "Are you sure you want to logout?"
        case .changePassword: return "Password has been reset successfully"
        case .searchDelSuccess: return "Search deleted successfully"
        case .deleteSearch: return "Are you sure you want to delete this search?"
        case .noPropertyError: return "There is no property in this region"
        case .searchSaved: return "Your search is saved"
        case .editProfile: return "Edit Profile"
        case .successEntryForm: return "Your request for temporary access is submitted"
        case .vehicleAdded: return "Vehicle Added"
        case .vehicleAddedSuccess: return "Vehicle added succecsfully"
        case .cancelPreApproval: return "Cancel Pre-Approval?"
        case .cancelReq: return "Cancel Your Request"
        case .cancelRequest: return "Do you want to cancel your request for"
        case .reqSubmitted: return "Pre-Approval Request Submitted."
        case .remove: return "Remove"
        case .vehicleRemove: return "Are you sure you want to remove vehicle from list"
        case .vehicleRemoveSuccess: return "Vehicle removed successfully."
        case .paymentFailed: return "Payment Failed"
        case .paymentSuccess: return "Payment Completed"
        case .memberRemove: return "Are you sure you want to remove from member list."
        case .memberRemoveSuccess: return "Member removed successfully."
        case .memberAdded: return "Member Added"
        case .memberSuccess: return "Member added sucessfuly to this contract"
        case .selectSearch: return "Activity or Amenity is required for saving the search"
        case .leaveUsMessage: return "Leave Us A Message"
        case .totalCost: return "Total cost for selected date(s) : $"
        case .success: return "Success"
        case .messageSuccess: return "Property Agent has been notified. You can view all your messages and responses in the Message Center."
        case .authReq: return "Authentication Required"
        case .loginFirst: return "Please login first to perform this action"
        case .propertyNotListed: return "Property Not Listed"
        }
    }
}

// MARK: - Storyboards
public enum Storyboards : String {
    case main
    case chatView
    case contactUsView
    case privacyPolicyView
    case listYourPropertyView
    case choosePlanView
    case faqView
    case helpView
    case preApprovalReqView
    case myLicencesView
    case propertyView
    case paymentView
    case licensePropertyDetailView
    case licenseMapView
    case savedSearchesView
    case accountSettingsView
    case myAccountView
    case preApprovalReqViews
}

extension Storyboards {
    public var name : String {
        switch self {
        case .main: return "Main"
        case .chatView: return "ChatView"
        case .contactUsView: return "ContactUsView"
        case .privacyPolicyView: return "PrivacyPolicyView"
        case .listYourPropertyView: return "ListYourPropertyView"
        case .choosePlanView: return "ChoosePlanView"
        case .faqView: return "FaqView"
        case .helpView: return "HelpView"
        case .preApprovalReqView: return "PreApprovalReqView"
        case .preApprovalReqViews: return "PreApprovalReqVC"
        case .myLicencesView: return "MyLicencesView"
        case .propertyView: return "PropertyView"
        case .paymentView: return "PaymentView"
        case .licensePropertyDetailView: return "LicensePropertyDetailView"
        case .licenseMapView: return "LicenseMapView"
        case .savedSearchesView: return "SavedSearchesView"
        case .accountSettingsView: return "AccountSettingsView"
        case .myAccountView: return "MyAccountView"
        }
    }
}

// MARK: - Navigations
public enum Navigation : String {
    case homeNav
    case loginNav
}

extension Navigation {
    public var name : String {
        switch self {
        case .homeNav: return "HomeNav"
        case .loginNav: return "LoginNav"
        }
    }
}

// MARK: - Controllers
public enum Controllers : String {
    case form
    case login
    case signUp
    case home
    case faq
    case listYourProperty
    case chat
    case forgotPassword
    case property
    case pendingLicensesPDF
    case accountSettings
    case savedSearchesVC
    case myAccount
    case myLicenses
    case preApprovalReq
    case help
    case contactUs
    case termsOfServiceView
    case searchView
    case listViewSearchView
    case mapView
    case licensePropertyDetailVC
    case paymentVC
    case privacyPolicyVC
    case choosePlanVC
    case licenseMapVC
    case profileView
    case GetVerificationCodeView
    case EnterVerificationCodeView
    case EnterNewPasswordView
}

extension Controllers {
    public var name : String {
        switch self {
        case .form: return "FormView"
        case .login: return "LoginView"
        case .signUp: return "SignupView"
        case .home: return "HomeView"
        case .faq: return "FaqVC"
        case .listYourProperty: return "ListYourPropertyVC"
        case .chat: return "ChatVC"
        case .forgotPassword: return "ForgotPassView"
        case .property: return "PropertyVC"
        case .pendingLicensesPDF: return "PendingLicensesPDFView"
        case .accountSettings: return "AccountSettingsVC"
        case .savedSearchesVC: return "SavedSearchesVC"
        case .myAccount: return "MyAccountVC"
        case .myLicenses: return "MyLicencesVC"
        case .preApprovalReq: return "PreApprovalReqVC"
        case .help: return "HelpVC"
        case .contactUs: return "ContactUsVC"
        case .termsOfServiceView: return "TermsOfServiceView"
        case .searchView: return "SearchView"
        case .listViewSearchView: return "ListViewSearchView"
        case .mapView: return "MapView"
        case .licensePropertyDetailVC: return "LicensePropertyDetailVC"
        case .paymentVC: return "PaymentVC"
        case .privacyPolicyVC: return "PrivacyPolicyVC"
        case .choosePlanVC: return "ChoosePlanVC"
        case .licenseMapVC: return "LicenseMapVC"
        case .profileView: return "ProfileView"
        case .GetVerificationCodeView: return "GetVerificationCodeView"
        case .EnterVerificationCodeView: return "EnterVerificationCodeView"
        case .EnterNewPasswordView: return "EnterNewPasswordView"
        }
    }
}

// MARK: - Navigation Bar Title
public enum NavigationTitle : String {
    case contactUs
    case listYourProperty
    case help
    case preApprovalRequests
    case chat
    case myLicenses
    case myAccount
    case termsOfService
    case privacyPolicy
    case choosePlan
    case propertyMaps
    case payment
    case profile
}

extension NavigationTitle {
    public var name : String {
        switch self {
        case .contactUs : return "Contact Us"
        case .listYourProperty : return "List Your Property"
        case .help : return "Help"
        case .preApprovalRequests : return "Pre Approval Request(s)"
        case .chat : return "Chat"
        case .myLicenses : return "My Licenses"
        case .myAccount : return "My Account"
        case .termsOfService : return "Terms of Service"
        case .privacyPolicy : return "Privacy Policy"
        case .choosePlan : return "Choose your plan"
        case .propertyMaps : return "Property Maps"
        case .payment : return "Payment"
        case .profile : return "Profile"
        }
    }
}

// MARK: - ButtonText
public enum ButtonText : String {
    case ok
    case cancel
    case gallery
    case chooseImage
    case camera
    case login
    case signUp
    case delete
    case viewDetails
    case accountSettings
    case savedSearches
    case yes
    case no
    case accept
    case expired
    case processing
    case listView
    case map
    case cancelRequest
    case contactUs
    case basicPlan
    case proPlan
    case enterprisePlan
    case proceed
}

extension ButtonText {
    public var text : String {
        switch self {
        case .ok: return "Ok"
        case .cancel: return "Cancel"
        case .gallery: return "Gallery"
        case .chooseImage: return "Choose Image"
        case .camera: return "Camera"
        case .login: return "Login"
        case .signUp: return "Sign Up"
        case .delete: return "Delete"
        case .viewDetails: return "View Details"
        case .accountSettings: return "Account Settings"
        case .savedSearches: return "Saved Searches"
        case .yes: return "Yes"
        case .no: return "No"
        case .accept: return "Accept"
        case .expired: return "Expired"
        case .processing: return "Processing"
        case .listView: return "List View"
        case .map: return "Map"
        case .cancelRequest: return "Cancel Request"
        case .contactUs: return "Contact Us"
        case .basicPlan: return "Basic Plan"
        case .proPlan: return "Pro Plan"
        case .enterprisePlan: return "Enterprise Plan"
        case .proceed: return "Proceed"
        }
    }
}

// MARK: - Common Keys
public enum CommonKeys : String {
    case myAccount
    case individual
    case business
    case adventureSeeker
    case landowner
    case lookingProperties
    case leasingProperties
    case home
    case search
    case message
    case profile
    case tokenExpired
    case landStr
    case customizeStr
    case manageStr
    case findReserveSeekerStr
    case customizeSeekerStr
    case manageSeekerStr
    case listYourLandBold
    case customizeBold
    case manageBold
    case findReserveSeekerBold
    case west
    case orbis
    case accepted
    case state
    case pending
    case renewal
    case mailInCheck
    case active
    case selectAmenity
    case searchField
    case contentSize
    case activity
    case amenity
    case southeast
    case selectState
    case selectCounty
    case sortBy
    case typeMessage
}

extension CommonKeys {
    public var name : String {
        switch self {
        case .myAccount: return "My Account"
        case .individual: return "Individual"
        case .business: return "Business"
        case .adventureSeeker: return "Adventure Seeker"
        case .landowner: return "Landowner"
        case .lookingProperties: return "Looking for Properties"
        case .leasingProperties: return "Leasing Properties"
        case .home: return "Home"
        case .search: return "Search"
        case .message: return "Message"
        case .profile: return "My Account"
        case .tokenExpired: return "Token Expired"
        case .landStr: return "1. List your Land: Make it available & searchable to qualified users nationwide"
        case .customizeStr: return "2. Customize: Include specific amenities, set lease dates & pricing"
        case .manageStr: return "3. Manage: approve leases, collect secure payments online"
        case .findReserveSeekerStr: return "1. Find & Reserve: Search available properties and land in your area"
        case .customizeSeekerStr: return "2. Customize: Premium leasing options tailored to your specific recreational needs"
        case .manageSeekerStr: return "3. Manage: Confirm reservations, send secure payments online"
        case .listYourLandBold: return "1. List your Land:"
        case .customizeBold: return "2. Customize:"
        case .manageBold: return "3. Manage:"
        case .findReserveSeekerBold: return "1. Find & Reserve:"
        case .west: return "West"
        case .orbis: return "orbis"
        case .accepted: return "Accepted"
        case .state: return "State"
        case .pending: return "Pending"
        case .renewal: return "Renewal"
        case .mailInCheck: return "Mail-in Check"
        case .active: return "Active"
        case .selectAmenity: return "Select Amenity"
        case .searchField: return "searchField"
        case .contentSize: return "contentSize"
        case .activity: return "Activity"
        case .amenity: return "Amenity"
        case .southeast: return "Southeast"
        case .selectState: return "Select State"
        case .selectCounty: return "Select County"
        case .sortBy: return "Sort By"
        case .typeMessage: return "Type a message"
        }
    }
}

// MARK: - Fonts
public enum Fonts : String {
    case nunitoSansBold
    case nunitoSansSemiBold
    case nunitoSansRegular
}

extension Fonts {
    public var name : String {
        switch self {
        case .nunitoSansBold : return "NunitoSans-Bold"
        case .nunitoSansSemiBold : return "NunitoSans-SemiBold"
        case .nunitoSansRegular : return "NunitoSans-Regular"
        }
    }
}

// MARK: - Urls
public enum Urls : String {
    case termsService
    case privacyPolicy
}

extension Urls {
    public var name : String {
        switch self {
        case .termsService : return "https://myoutdooragent.com/#/app/terms"
        case .privacyPolicy : return "https://myoutdooragent.com/policy"
        }
    }
}

// MARK: - Choose Your Plan
public enum ChoosePlan : String {
    case basicPlanTitle
    case proPlanTitle
    case enterprisePlanTitle
}

extension ChoosePlan {
    public var name : String {
        switch self {
        case .basicPlanTitle : return "Digital management platform for small to medium- sized landowners who are executing recreational access transactions. Limited to one-time agreements, renewed annually to the same group/person each year."
        case .proPlanTitle : return "For medium-sized private landowners and land management consultants wanting more flexibility in their recreational offerings, including the option to set daily access pricing. Comes with MOA on-boarding support. Ability to market recreational access to the public and offer up unique recreational activities."
        case .enterprisePlanTitle : return "A customized, comprehensive recreational management system for major landowners, complete with full MOA administration and tech support. Ideal for large-scale landowners, land management consultants, and land asset managers who need a complete enterprise system across multiple regions, as well as the ability to offer customized, diverse recreational activities."
        }
    }
}
