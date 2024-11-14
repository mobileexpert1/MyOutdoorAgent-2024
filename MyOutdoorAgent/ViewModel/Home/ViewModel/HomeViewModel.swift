//  HomeViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit
import PKHUD
import FirebaseAuth
import GoogleSignIn

protocol HomeViewModelDelegate : AnyObject {
    func regionSuccessCalled()
    func regionErrorCalled()
    func allAmenitiesSuccessCalled()
    func allAmenitiesErrorCalled(_ error: String)
    func searchSuccessCalled()
    func searchErrorCalled(_ error: String)
    func searchAutoSuccessCalled()
    func searchAutoErrorCalled(_ error: String)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    var rLURegionArr = [SelectRegionWisePropertiesModelClass]()
    var allAmenitiesArr = [GetAllAmenitiesModelClass]()
    var searchArr = [SearchHomeModelClass]()
    var searchAutoArr = [SearchAutoFillModelClass]()
    
    init(_ delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Get All Amenities Api
    func getAllAmenitiesApi(_ view: UIView, completion : @escaping([GetAllAmenitiesModelClass]) -> Void) {
        ApiStore.shared.getAllAmenitiesApi(view) { responseModel in
            if responseModel.model != nil {
                if responseModel.model?.count != 0 {
                    self.allAmenitiesArr = responseModel.model!
                    self.delegate?.allAmenitiesSuccessCalled()
                    completion(self.allAmenitiesArr)
                } else {
                    self.delegate?.allAmenitiesErrorCalled(responseModel.message!)
                }
            } else {
                self.delegate?.allAmenitiesErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Search home Api
    func searchApi(_ view: UIView, stateName: [String], regionName: [String], propertyName: [String], freeText: [String], county: [String], rlu: [String], amenities: [String], rluAcresMin: Int, rluAcresMax: Int, priceMin: Int, priceMax: Int, productTypeId: Int, order: String, sort: String, pageNumber:Int, completion : @escaping([SearchHomeModelClass]) -> Void) {
        ApiStore.shared.searchHomeApi(view, stateName, regionName, propertyName, freeText, county, rlu, amenities, rluAcresMin, rluAcresMax, priceMin, priceMax, LocalStore.shared.userAccountId, EMPTY_STR, EMPTY_STR, productTypeId, order, sort, pageNumber: pageNumber) { responseModel in
            if responseModel.model != nil {
                self.searchArr = responseModel.model
                self.delegate?.searchSuccessCalled()
                completion(self.searchArr)
            } else {
                self.delegate?.searchErrorCalled(responseModel.message ?? "")
            }
        }
    }
    
    // MARK: - Select Regionwise Properties Api
    func selectRegionwiseProperties(_ view: UIView, completion : @escaping([SelectRegionWisePropertiesModelClass]) -> Void) {
        ApiStore.shared.selectRegionwisePropertiesApi(view) { responseModel in
            if responseModel.model != nil {
                self.rLURegionArr = responseModel.model!
                self.delegate?.regionSuccessCalled()
                completion(self.rLURegionArr)
            } else {
                self.delegate?.regionErrorCalled()
            }
        }
    }
    
    // MARK: - Search Auto Fill Api
    func searchAutoFillApi(_ view: UIView, _ searchText: String, completion : @escaping([SearchAutoFillModelClass]) -> Void) {
        ApiStore.shared.searchAutofillApi(view, searchText) { responseModel in
            if responseModel.model != nil {
                self.searchAutoArr = responseModel.model!
                self.delegate?.searchAutoSuccessCalled()
                completion(self.searchAutoArr)
            } else {
                self.delegate?.searchAutoErrorCalled(responseModel.message!)
            }
        }
    }
    
    func emptyLocalStore() {
        LocalStore.shared.emailHandler = EMPTY_STR
        LocalStore.shared.passwordHandler = EMPTY_STR
        LocalStore.shared.isSocialHandler = EMPTY_STR
        LocalStore.shared.userId = EMPTY_STR
        LocalStore.shared.userProfileId = 0
        LocalStore.shared.userAccountId = 0
        LocalStore.shared.email = EMPTY_STR
        LocalStore.shared.name = EMPTY_STR
        LocalStore.shared.fisrtName = EMPTY_STR
        LocalStore.shared.lastName = EMPTY_STR
        LocalStore.shared.streetAddress = EMPTY_STR
        LocalStore.shared.city = EMPTY_STR
        LocalStore.shared.streetAdd = EMPTY_STR
        LocalStore.shared.state = CommonKeys.state.name
        LocalStore.shared.zipcode = EMPTY_STR
        LocalStore.shared.mobileNo = EMPTY_STR
        LocalStore.shared.address = EMPTY_STR
        LocalStore.shared.clubname = EMPTY_STR
        LocalStore.shared.rluSearchName = EMPTY_STR
        LocalStore.shared.countySearchName = EMPTY_STR
        LocalStore.shared.regionSearchName = EMPTY_STR
        LocalStore.shared.propertySearchName = EMPTY_STR
        LocalStore.shared.freeTextSearchName = EMPTY_STR
    }
    
    // -- Navigate to login Page
    func goToLoginPage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.executeVC(Storyboards.main.name, Navigation.loginNav.name)
    }
    
    func logOutSuccessCalled() {
        DispatchQueue.main.async {
            HUD.hide()
            GIDSignIn.sharedInstance.signOut()
            do {
                try Auth.auth().signOut()
                self.emptyLocalStore()
                self.goToLoginPage()
            } catch let error as NSError {
                print ("Error signing out from Firebase: %@", error)
            }
        }
    }
    
    func deleteAccountApi(_ view: UIView, completion : @escaping([SearchAutoFillModelClass]) -> Void) {
        ApiStore.shared.deleteAccountApi(view) { responseModel in
            self.logOutSuccessCalled()
        }
    }
}

//MARK: - Optional Delegates Defination
extension HomeViewModelDelegate {
    func regionSuccessCalled() {
    }
    func regionErrorCalled() {
    }
    func allAmenitiesSuccessCalled() {
    }
    func allAmenitiesErrorCalled(_ error: String) {
    }
    func searchSuccessCalled() {
    }
    func searchErrorCalled(_ error: String) {
    }
    func searchAutoSuccessCalled() {
    }
    func searchAutoErrorCalled(_ error: String) {
    }
}
