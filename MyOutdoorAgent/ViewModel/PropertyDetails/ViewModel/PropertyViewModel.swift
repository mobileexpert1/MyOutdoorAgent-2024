//  PropertyViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 25/08/22.

import Foundation
import UIKit

protocol PropertyViewModelDelegate : AnyObject {
    func activityDetailSuccessCalled()
    func activityDetailErrorCalled(_ error: String)
    func entryFormSuccessCalled()
    func entryFormErrorCalled(_ error: String)
    func submitReqSuccessCalled()
    func submitReqErrorCalled(_ error: String)
    func paymentTokenSuccessCalled()
    func paymentErrorCalled(_ error: String)
    func dayPassSuccessCalled(_ daypassTotalCost: Double, _ isAvailable: Bool)
    func dayPassErrorCalled(_ error: String)
    func sendMessageSuccessCalled()
    func sendMessageErrorCalled(_ error: String)
    func generateContractSuccessCalled()
    func generateContractErrorCalled(_ error: String)
    func harvestingSuccessCalled()
    func harvestingErrorCalled(_ error: String)
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

class PropertyViewModel {
    
    weak var delegate: PropertyViewModelDelegate?
    var activityDetailArr : ActivityDetailModelClass?
    var entryFormArr : RightOfEntryModel?
    var submitArr : SubmitPreApprovalReqModel?
    var paymentTokenArr : GetPaymentTokenModel?
    var DayPassModel : DayPassModel?
    var messagesArr : SendMessageModel?
    var generateContractArr: GenerateContractModel?
    var harvestingArr: AddHarvestingDetailModel?
    var pointsArr : PointModel?
    var polyArr : PolyModel?
    var multiPolygonArr : MultipolygonModel?
    var multiPolygonArr2 : MultiPolygonModel2?
    var rluDetailArr : RLUDetailModelClass?
    
    init(_ delegate: PropertyViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Activity Detail Api
    func activityDetailApi(_ view: UIView, _ publicKey: String, _ token: String, completion : @escaping(ActivityDetailModelClass) -> Void) {
        ApiStore.shared.activityDetailApi(view, publicKey, token) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
                self.activityDetailArr = responseModel.model
                self.delegate?.activityDetailSuccessCalled()
                completion(self.activityDetailArr!)
            } else {
                self.delegate?.activityDetailErrorCalled(responseModel.message ?? "")
            }
        }
    }
    
  
    
    
    // MARK: - Right of Entry Form Api
    func rightOfEntryFormApi(_ view: UIView, _ productID: Int, _ dateOfAccessRequested: String, _ roEUsersLists: String, completion: @escaping(_ : RightOfEntryModel) -> Void) {
        ApiStore.shared.rightOfEntryFormApi(view, 0, productID, 1, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, EMPTY_STR, dateOfAccessRequested, "Amit Sharma", EMPTY_STR, roEUsersLists) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.entryFormArr = responseModel
                self.delegate?.entryFormSuccessCalled()
                completion(self.entryFormArr!)
            } else {
                self.delegate?.entryFormErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Submit Pre Approval Request Api
    func submitPreApprovalReqApi(_ view : UIView, _ userAccountId: Int, _ licenseActivityId: Int, requestComment: String, _ productId: Int, completion: @escaping(_ : SubmitPreApprovalReqModel) -> Void) {
        ApiStore.shared.submitPreApprovalReqApi(view, userAccountId, licenseActivityId, requestComment, productId) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.submitArr = responseModel
                self.delegate?.submitReqSuccessCalled()
                completion(self.submitArr!)
            } else {
                self.delegate?.submitReqErrorCalled(responseModel.message!)
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
    
    // MARK: - Day Pass Availability Api
    func dayPassAvailabilityApi(_ view: UIView, _ licenseActivityID: Int, _ dateOfArrival: String, _ daysCount: Int, completion: @escaping(_ : DayPassModel) -> Void) {
        ApiStore.shared.dayPassAvailabilityApi(view, licenseActivityID, dateOfArrival, daysCount) { responseModel in
            print(responseModel)
            
            if responseModel.statusCode == 200 {
                self.DayPassModel = responseModel
                self.delegate?.dayPassSuccessCalled(responseModel.model.daypassTotalCost, responseModel.model.isAvailable)
                completion(self.DayPassModel!)
            } else {
                self.delegate?.dayPassErrorCalled(responseModel.message)
            }
            
        }
    }
    
    // MARK: - Send Message Api
    func sendMessageApi(_ view: UIView, _ productID: Int, _ messageText: String, completion : @escaping(SendMessageModel) -> Void) {
        ApiStore.shared.sendMessageApi(view, productID, messageText) { responseModel in
            print(responseModel)
            if responseModel?.model != nil {
                self.messagesArr = responseModel
                self.delegate?.sendMessageSuccessCalled()
                completion(self.messagesArr!)
            } else {
                self.delegate?.sendMessageErrorCalled((responseModel?.message) ?? "")
            }
        }
    }
    
    // MARK: - Add Harvesting Api
    func addHarvestingApi(_ view: UIView, _ huntingSeason: Int, _ buckCount: String, _ doeCount: String, _ turkeyCount: String, _ bearCount: String, _ productId: Int, completion : @escaping(AddHarvestingDetailModel) -> Void) {
        ApiStore.shared.addHarvestingDetailsApi(view, huntingSeason, buckCount, doeCount, turkeyCount, bearCount, productId) { responseModel in
            if responseModel.statusCode == 200 {
                self.harvestingArr = responseModel
                self.delegate?.harvestingSuccessCalled()
                completion(self.harvestingArr!)
            } else {
                self.delegate?.harvestingErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Property License Agreement Api
    func generateLicenseContractApi(_ view: UIView, _ licenseActivityID: Int, completion : @escaping(GenerateContractModel) -> Void) {
        ApiStore.shared.generateLicenseContractApi(view, licenseActivityID) { responseModel in
            if responseModel.statusCode == 200 {
                self.generateContractArr = responseModel
                self.delegate?.generateContractSuccessCalled()
                completion(self.generateContractArr!)
            } else {
                self.delegate?.generateContractErrorCalled(responseModel.message!)
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
}

//MARK: - Optional Delegates Defination
extension PropertyViewModelDelegate {
    func activityDetailSuccessCalled() {
    }
    func activityDetailErrorCalled(_ error: String) {
    }
    func entryFormSuccessCalled() {
    }
    func entryFormErrorCalled(_ error: String) {
    }
    func submitReqSuccessCalled() {
    }
    func submitReqErrorCalled(_ error: String) {
    }
    func paymentTokenSuccessCalled() {
    }
    func paymentErrorCalled(_ error: String) {
    }
    func dayPassSuccessCalled(_ daypassTotalCost: Double, _ isAvailable: Bool) {
    }
    func dayPassErrorCalled(_ error: String) {
    }
    func sendMessageSuccessCalled(_ tableView: UITableView) {
    }
    func sendMessageErrorCalled(_ error: String) {
    }
    func generateContractSuccessCalled() {
    }
    func generateContractErrorCalled(_ error: String) {
    }
    func harvestingSuccessCalled() {
    }
    func harvestingErrorCalled(_ error: String) {
    }
}
