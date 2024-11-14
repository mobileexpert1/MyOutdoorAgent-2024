//  MyLicensesViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit
import PKHUD

protocol MyLicensesViewModelDelegate : AnyObject {
    func activeLicenseSuccess(_ collectionView: UICollectionView)
    func memberLicenseSuccess(_ collectionView: UICollectionView)
    func pendingLicenseSuccess(_ collectionView: UICollectionView)
    func expiredLicensesSuccess(_ collectionView: UICollectionView)
    func activeLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int)
    func memberLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int)
    func pendingLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int)
    func expiredLicensesErrorCalled(_ collectionView: UICollectionView, _ tag : Int)
    func acceptLicenseSuccessCalled()
    func acceptLicenseErrorCalled(_ error: String)
    func licenseDetailSuccessCalled()
    func licenseDetailErrorCalled(_ error: String)
    func addMembersSuccessCalled()
    func addMembersErrorCalled(_ error: String)
    func inviteMembersSuccessCalled()
    func inviteMembersErrorCalled(_ error: String)
    func removeMembersSuccessCalled()
    func removeMembersErrorCalled(_ error: String)
    func addVehiclesSuccessCalled(_ success: String)
    func addVehiclesErrorCalled(_ error: String)
    func deleteVehiclesSuccessCalled()
    func deleteVehiclesErrorCalled(_ error: String)
    func getStatesSuccessCalled()
    func getStatesErrorCalled(_ error: String)
    func generateContractSuccessCalled()
    func generateContractErrorCalled(_ error: String)
    func generateClubMembershipSuccessCalled()
    func generateClubMembershipErrorCalled(_ error: String)
    func paymentTokenSuccessCalled()
    func paymentErrorCalled(_ error: String)
    func pointLayerSuccessCalled()
    func pointLayerErrorCalled()
    func polyLayerSuccessCalled()
    func polyLayerErrorCalled()
    func multiPolygonSuccessCalled()
    func multiPolygonErrorCalled()
    func rluDetailSuccessCalled()
    func rluDetailErrorCalled()
    func multiPolygon2SuccessCalled()
    func multiPolygon2ErrorCalled()
}

class MyLicensesViewModel {
    
    weak var delegate: MyLicensesViewModelDelegate?
    var okBtn = [ButtonText.ok.text]
    
    // MARK: - Objects
    var activeLicensesArr = [ActiveMemeberPendindCombimeModelClass]()
    var memberLicensesArr = [ActiveMemeberPendindCombimeModelClass]()
    var pendingLicensesArr = [ActiveMemeberPendindCombimeModelClass]()
    var expiredLicensesArr = [ExpiredLicensesModelClass]()
    var acceptLicensesArr : AcceptLicensesReqModel?
    var licensesDetailArr : LicenseDetailModel?
    var addMemberArr: AddMemberModel?
    var inviteMembersArr: InviteMembersModel?
    var removeMembersArr: RemoveMembersModel?
    var addVehicleArr: [AddVehicleModelClass]?
    var deleteVehicleArr: DeleteVehicleModel?
    var getAllStatesArr = [GetAllStatesModelClass]()
    var generateContractArr: GenerateContractModel?
    var clubMembershipArr: ClubMembershipCardModel?
    var paymentTokenArr : GetPaymentTokenModel?
    var pointsArr : PointModel?
    var polyArr : PolyModel?
    var multiPolygonArr : MultipolygonModel?
    var multiPolygonArr2 : MultiPolygonModel2?
    var rluDetailArr : RLUDetailModelClass?
    
    init(_ delegate: MyLicensesViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Active Licenses Api
    func activeLicensesApi(_ view: UIView, _ collectionView: UICollectionView, completion : @escaping([ActiveMemeberPendindCombimeModelClass]) -> Void) {
        ApiStore.shared.myLicensesApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
             //   if responseModel.model?.count != 0 {
                    self.activeLicensesArr = responseModel.model!
                    self.delegate?.activeLicenseSuccess(collectionView)
                    completion(self.activeLicensesArr)
               // }
//                else {
//                    self.delegate?.activeLicenseErrorCalled(collectionView, 0)
//                }
            } else {
             //   HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                    UIApplication.shared.windows.first?.rootViewController = vC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    func pointLayerApi(_ view: UIView, completion : @escaping(PointModel) -> Void) {
        
        ApiStore.shared.pointLayerApi(view) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.pointsArr = responseModel
                self.delegate?.pointLayerSuccessCalled()
                completion(self.pointsArr!)
            } else {
                self.delegate?.pointLayerErrorCalled()
            }
        }
    }
    func polyLayerApi(_ view: UIView, completion : @escaping(PolyModel) -> Void) {
        ApiStore.shared.polyLayerApi(view) { responseModel in
           // print(responseModel)
            if responseModel.features.count != 0 {
                self.polyArr = responseModel
                self.delegate?.polyLayerSuccessCalled()
                completion(self.polyArr!)
            } else {
                self.delegate?.polyLayerErrorCalled()
            }
        }
    }
    func multiPolygonApi(_ view: UIView, rluName: String, completion : @escaping(MultipolygonModel) -> Void) {
        ApiStore.shared.multiPolygonApi(view, rluName: rluName) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.multiPolygonArr = responseModel
                self.delegate?.multiPolygonSuccessCalled()
                completion(self.multiPolygonArr!)
            } else {
                self.delegate?.multiPolygonErrorCalled()
            }
        }
    }
    func multiPolygonApi2(_ view: UIView, rluName: String, completion : @escaping(MultiPolygonModel2) -> Void) {
        ApiStore.shared.multiPolygonApi2(view, rluName: rluName) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.multiPolygonArr2 = responseModel
                self.delegate?.multiPolygon2SuccessCalled()
                completion(self.multiPolygonArr2!)
            } else {
                self.delegate?.multiPolygon2ErrorCalled()
            }
        }
    }
    func rluDetailApi(_ view: UIView, productNo: String, completion : @escaping(RLUDetailModelClass) -> Void) {
        ApiStore.shared.rluDetailApi(view, productNo: productNo) { responseModel in
           // print(responseModel)
            if responseModel.model != nil {
                self.rluDetailArr = responseModel.model
                self.delegate?.rluDetailSuccessCalled()
                completion(self.rluDetailArr!)
            } else {
                self.delegate?.rluDetailErrorCalled()
            }
        }
    }
    // MARK: - Member License Api
    func memberLicenseApi(_ view: UIView, _ collectionView: UICollectionView, completion : @escaping([ActiveMemeberPendindCombimeModelClass]) -> Void) {
        ApiStore.shared.memberLicensesApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
              //  if responseModel.model?.count != 0 {
                    self.memberLicensesArr = responseModel.model!
                    self.delegate?.memberLicenseSuccess(collectionView)
                    completion(self.memberLicensesArr)
            //    }
//                else {
//                    self.delegate?.memberLicenseErrorCalled(collectionView, 1)
//                }
            } else {
              //  HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                    UIApplication.shared.windows.first?.rootViewController = vC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    
    // MARK: - Pending License Api
    func pendingLicenseApi(_ view: UIView, _ collectionView: UICollectionView, completion : @escaping([ActiveMemeberPendindCombimeModelClass]) -> Void) {
        ApiStore.shared.pendingLicensesApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
          //      if responseModel.model?.count != 0 {
                    self.pendingLicensesArr = responseModel.model!
                    self.delegate?.pendingLicenseSuccess(collectionView)
                    completion(self.pendingLicensesArr)
          //      }
 //                   else {
//                    self.delegate?.pendingLicenseErrorCalled(collectionView, 2)
//                }
            } else {
               // HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                    UIApplication.shared.windows.first?.rootViewController = vC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    
    // MARK: - Expired Licenses Api
    func expiredLicensesApi(_ view: UIView, _ collectionView: UICollectionView, completion : @escaping([ExpiredLicensesModelClass]) -> Void) {
        ApiStore.shared.expiredLicensesApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
                if responseModel.model?.count != 0 {
                    self.expiredLicensesArr = responseModel.model!
                    self.delegate?.expiredLicensesSuccess(collectionView)
                    completion(self.expiredLicensesArr)
                } else {
                    self.delegate?.expiredLicensesErrorCalled(collectionView, 3)
                }
            } else {
               // HUD.flash(.labeledError(title: EMPTY_STR, subtitle: AppErrors.somethingWrong.localizedDescription), delay: 1.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.loginNav.name)
                    UIApplication.shared.windows.first?.rootViewController = vC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
    
    // MARK: - Accept Licenses Api
    func acceptLicensesApi(_ view: UIView, _ licenseContractID: Int, _ userAccountID: Int, completion : @escaping(AcceptLicensesReqModel) -> Void ) {
        ApiStore.shared.acceptLicensesReqApi(view, licenseContractID, userAccountID) { responseModel in
            print(responseModel)
            if responseModel.statusCode == 200 {
                self.acceptLicensesArr = responseModel
                self.delegate?.acceptLicenseSuccessCalled()
                completion(self.acceptLicensesArr!)
            } else {
                self.delegate?.acceptLicenseErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - License Detail Api
    func licenseDetailApi(_ view: UIView, _ publicKey: String, completion : @escaping(LicenseDetailModel) -> Void) {
        ApiStore.shared.licenseDetailApi(view, publicKey: publicKey) { responseModel in
            if responseModel.model != nil {
                self.licensesDetailArr = responseModel
                self.delegate?.licenseDetailSuccessCalled()
                completion(self.licensesDetailArr!)
            } else {
                self.delegate?.licenseDetailErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Check Empty TextFields in Add Member View
    func checkValidMemberTF(_ view: UIView, licenseContractID: Int, firstName : String, lastName : String, email : String, phone : String, address : String, state : String, city : String, zip : String) {
        if (firstName.isEmpty) || (lastName.isEmpty) || (email.isEmpty) || (phone.isEmpty) || (address.isEmpty) || (state == CommonKeys.state.name) || (city.isEmpty) || (zip.isEmpty) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        } else if (!email.isEmailValid) {
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validEmail.localizedDescription, buttons: okBtn, completion: nil)
        } else if (!phone.isValidMobile) || ((phone.count) < 10){
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.validPhone.localizedDescription, buttons: okBtn, completion: nil)
        } else if ((zip.count) < 5) || ((zip.count) == 0){
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.zipLength.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            addMembersApi(view, licenseContractID, firstName, lastName, email, phone, address, state, city, zip) { responseModel in
            }
        }
    }
    
    // MARK: - Add Members Api
    func addMembersApi(_ view: UIView, _ licenseContractID: Int, _ firstName : String, _ lastName : String, _ email : String, _ phone : String, _ address : String, _ state : String, _ city : String, _ zip : String,  completion : @escaping(AddMemberModel) -> Void) {
        ApiStore.shared.addMemberApi(view, licenseContractID, firstName, lastName, email, phone, address, state, city, zip) { responseModel in
            if responseModel.statusCode == 200 {
                self.addMemberArr = responseModel
                self.delegate?.addMembersSuccessCalled()
                completion(self.addMemberArr!)
            } else {
                self.delegate?.addMembersErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Invite Members Api
    func inviteMembersApi(_ view: UIView, _ licenseContractId: Int, _ userEmail: String, completion : @escaping(InviteMembersModel) -> Void) {
        ApiStore.shared.inviteMemberApi(view, licenseContractId, userEmail) { responseModel in
            if responseModel.statusCode == 200 {
                self.inviteMembersArr = responseModel
                self.delegate?.inviteMembersSuccessCalled()
                completion(self.inviteMembersArr!)
            } else {
                self.delegate?.inviteMembersErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Remove Members Api
    func removeMembersApi(_ view: UIView, _ licenseContractMemberID: Int, completion : @escaping(RemoveMembersModel) -> Void) {
        ApiStore.shared.removeMemberApi(view, licenseContractMemberID) { responseModel in
            if responseModel.statusCode == 200 {
                self.removeMembersArr = responseModel
                self.delegate?.removeMembersSuccessCalled()
                completion(self.removeMembersArr!)
            } else {
                self.delegate?.removeMembersErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Check All TextFields Validations
    func addVehiclesTFValid(_ view: UIView, _ vehicleState: String, _ licenseContractID: Int, _ vehicleMake: String, _ vehicleModel: String, _ vehicleColor: String, _ vehicleLicensePlate: String) {
        if ((vehicleState == "Select State") || vehicleMake.isEmpty || vehicleModel.isEmpty || vehicleColor.isEmpty || vehicleLicensePlate.isEmpty) {
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.allFieldsReq.localizedDescription, buttons: okBtn, completion: nil)
        } else {
            addVehicleApi(view, licenseContractID, vehicleMake, vehicleModel, vehicleColor, vehicleLicensePlate, vehicleState)
        }
    }
    
    // MARK: - Add Vehicle Api
    func addVehicleApi(_ view: UIView, _ licenseContractID: Int, _ vehicleMake: String, _ vehicleModel: String, _ vehicleColor: String, _ vehicleLicensePlate: String, _ vehicleState: String) {
        ApiStore.shared.addVehicleInfoApi(view, licenseContractID, 0, vehicleMake, vehicleModel, vehicleColor, vehicleLicensePlate, vehicleState, EMPTY_STR) { responseModel in
            responseModel.statusCode == 200
            ? (self.delegate?.addVehiclesSuccessCalled(AppAlerts.vehicleAddedSuccess.title))
            : (self.delegate?.addVehiclesErrorCalled(responseModel.message!))
        }
    }
   
    // MARK: - Delete Vehicles Api
    func deleteVehiclesApi(_ view: UIView, _ vehicleDetailID: Int, completion : @escaping(DeleteVehicleModel) -> Void ) {
        ApiStore.shared.deleteVehicleApi(view, vehicleDetailID) { responseModel in
            if responseModel.statusCode == 200 {
                self.deleteVehicleArr = responseModel
                self.delegate?.deleteVehiclesSuccessCalled()
                completion(self.deleteVehicleArr!)
            } else {
                self.delegate?.deleteVehiclesErrorCalled(responseModel.message)
            }
        }
    }
    
    // MARK: - Get all states Api
    func getAllStatesApi(_ view: UIView, completion : @escaping([GetAllStatesModelClass]) -> Void) {
        ApiStore.shared.getAllStatesApi(view) { responseModel in
            if responseModel.statusCode == 200 {
                self.getAllStatesArr = responseModel.model!
                self.delegate?.getStatesSuccessCalled()
                completion(self.getAllStatesArr)
            } else {
                self.delegate?.getStatesErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Property License Agreement Api
    func generateContractApi(_ view: UIView, _ licenseContractId: Int, completion : @escaping(GenerateContractModel) -> Void) {
        ApiStore.shared.generateContractApi(view, licenseContractId) { responseModel in
            if responseModel.statusCode == 200 {
                self.generateContractArr = responseModel
                self.delegate?.generateContractSuccessCalled()
                completion(self.generateContractArr!)
            } else {
                self.delegate?.generateContractErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Club Membership Card Api
    func generateClubMembershipCardApi(_ view: UIView, _ licenseContractId: Int, completion : @escaping(ClubMembershipCardModel) -> Void) {
        ApiStore.shared.generateClubMembershipCardApi(view, licenseContractId) { responseModel in
            if responseModel.statusCode == 200 {
                self.clubMembershipArr = responseModel
                self.delegate?.generateClubMembershipSuccessCalled()
                completion(self.clubMembershipArr!)
            } else {
                self.delegate?.generateClubMembershipErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Get Payment Token Api
    func getPaymentTokenApi(_ view: UIView, requestType: String, rluNo: String, fundAccountKey: String, clientInvoiceId: Int, userAccountId: Int, email: String, licenseFee: Float, paidBy: String, cancelUrl: String, errorUrl: String, productTypeId: Int, returnUrl: String, productID: Int, invoiceTypeID: Int, completion: @escaping(_ : GetPaymentTokenModel) -> Void) {
        ApiStore.shared.getPaymentTokenApi(view, requestType, rluNo, fundAccountKey, clientInvoiceId, userAccountId, email, licenseFee, paidBy, cancelUrl, errorUrl, productTypeId, returnUrl, productID, invoiceTypeID) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.paymentTokenArr = responseModel
                self.delegate?.paymentTokenSuccessCalled()
                completion(self.paymentTokenArr!)
            } else {
                self.delegate?.paymentErrorCalled(responseModel.message!)
            }
            
        }
    }
}

//MARK: - Optional Delegates Defination
extension MyLicensesViewModelDelegate {
    func activeLicenseSuccess(_ collectionView: UICollectionView) {
    }
    func memberLicenseSuccess(_ collectionView: UICollectionView) {
    }
    func pendingLicenseSuccess(_ collectionView: UICollectionView) {
    }
    func expiredLicensesSuccess(_ collectionView: UICollectionView) {
    }
    func activeLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
    }
    func memberLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
    }
    func pendingLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
    }
    func expiredLicensesErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
    }
    func acceptLicenseSuccessCalled() {
    }
    func acceptLicenseErrorCalled(_ error: String) {
    }
    func licenseDetailSuccessCalled() {
    }
    func licenseDetailErrorCalled(_ error: String) {
    }
    func addMembersSuccessCalled() {
    }
    func addMembersErrorCalled(_ error: String) {
    }
    func inviteMembersSuccessCalled() {
    }
    func inviteMembersErrorCalled(_ error: String) {
    }
    func addVehiclesSuccessCalled(_ success: String) {
    }
    func addVehiclesErrorCalled(_ error: String) {
    }
    func removeMembersSuccessCalled() {
    }
    func removeMembersErrorCalled(_ error: String) {
    }
    func deleteVehiclesSuccessCalled() {
    }
    func deleteVehiclesErrorCalled(_ error: String) {
    }
    func getStatesSuccessCalled() {
    }
    func getStatesErrorCalled(_ error: String) {
    }
    func generateContractSuccessCalled() {
    }
    func generateContractErrorCalled(_ error: String) {
    }
    func generateClubMembershipSuccessCalled() {
    }
    func generateClubMembershipErrorCalled(_ error: String) {
    }
    func paymentTokenSuccessCalled() {
    }
    func paymentErrorCalled(_ error: String) {
    }
}
