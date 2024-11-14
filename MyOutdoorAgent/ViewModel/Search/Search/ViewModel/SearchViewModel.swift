//  SearchViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol SearchViewModelDelegate : AnyObject {
    func searchAutoSuccessCalled()
    func searchAutoErrorCalled(_ error: String)
    func statesSuccessCalled()
    func statesErrorCalled(_ error: String)
    func allAmenitiesSuccessCalled()
    func allAmenitiesErrorCalled(_ error: String)
    func saveSearchSuccessCalled()
    func saveSearchErrorCalled(_ error: String)
    func searchSuccessCalled()
    func searchErrorCalled(_ error: String)
    func countySuccessCalled()
    func countyErrorCalled(_ error: String)
    func pointLayerSuccessCalled()
    func pointLayerErrorCalled()
    func polyLayerSuccessCalled()
    func polyLayerErrorCalled()
    func multiPolygonSuccessCalled()
    func multiPolygonErrorCalled()
    func rluDetailSuccessCalled()
    func rluDetailErrorCalled()
    func accessPointSuccessCalled()
    func accessPointErrorCalled()
    func permitShapesSuccessCalled()
    func permitShapesErrorCalled()
    func multiPolygon2SuccessCalled()
    func multiPolygon2ErrorCalled()
    func selectedStaeMapSuccessCalled()
    func selectedStaeMapErrorCalled()
    func nonMotorizedSuccessCalled()
    func nonMotorizedErrorCalled()
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    var searchAutoArr = [SearchAutoFillModelClass]()
    var statesArr = [AvailableStatesModelClass]()
    var allAmenitiesArr = [GetAllAmenitiesModelClass]()
    var saveSearchArr : SaveSearchModel?
    var searchArr = [SearchHomeModelClass]()
    var countyArr: GetAvailableCountyByStatesModel?
    var pointsArr : PointModel?
    var polyArr : PolyModel?
    var nonMotorizedArr : NonMotorizedModel?
    var multiPolygonArr : MultipolygonModel?
    var multiPolygonArr2 : MultiPolygonModel2?
    var selectedStaeteMapArr : SelectStateMapModel?
    var rluDetailArr : RLUDetailModelClass?
    var accessPoinyArr : AcessPointModel?
    var permitShapesArr : PermitShapesModel?
    
    init(_ delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Handle Check box
    func handleCheckBox(handler : inout Bool, checkBox : inout UIImageView) {
        handler = !handler
        let resultChecker = self.toggleCheckBox(value: handler)
        checkBox.image = resultChecker
    }
    
    func toggleCheckBox(value: Bool) -> UIImage {
        if value {
            return Images.uncheck.name
        } else {
            return Images.check.name
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
    
    // MARK: - Available States Api
    func availableStatesApi(_ view: UIView, completion : @escaping([AvailableStatesModelClass]) -> Void) {
        ApiStore.shared.availableStatesApi(view) { responseModel in
            if responseModel.model != nil {
                if responseModel.model?.count != 0 {
                    self.statesArr = responseModel.model!
                    self.delegate?.statesSuccessCalled()
                    completion(self.statesArr)
                } else {
                    self.delegate?.statesErrorCalled(responseModel.message!)
                }
            } else {
                self.delegate?.statesErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Get All Amenities Api
    func getAllAmenitiesApi(_ view: UIView, completion : @escaping([GetAllAmenitiesModelClass]) -> Void) {
        ApiStore.shared.getAllAmenitiesApi(view) { responseModel in
           // print(responseModel)
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
    
    // MARK: - Save Search Api
    func saveSearchApi(_ view: UIView, _ stateName: [String], _ regionName: [String], _ propertyName: [String], _ freeText: [String], _ county: [String], _ rlu: [String], _ amenities: [String], _ rLUAcresMin: Int, _ rLUAcresMax: Int, _ priceMin: Int, _ priceMax: Int, _ userAccountID: Int, _ iPAddress: String, _ client: String, _ productTypeID: Int, _ searchName: String,  completion : @escaping(SaveSearchModel) -> Void) {
        ApiStore.shared.saveSearchApi(view, stateName, regionName, propertyName, freeText, county, rlu, amenities, rLUAcresMin, rLUAcresMax, priceMin, priceMax, userAccountID, iPAddress, client, productTypeID, searchName) { responseModel in
            if responseModel.statusCode == 200 {
                self.saveSearchArr = responseModel
                self.delegate?.saveSearchSuccessCalled()
                completion(self.saveSearchArr!)
            } else {
                self.delegate?.saveSearchErrorCalled(responseModel.message!)
            }
        }
    }
    
    
    // MARK: - Search home Api
    func searchApi(_ view: UIView, stateName: [String], regionName: [String], propertyName: [String], freeText: [String], county: [String], rlu: [String], amenities: [String], rluAcresMin: Int, rluAcresMax: Int, priceMin: Int, priceMax: Int, productTypeId: Int, order: String, sort: String ,pageNumber: Int, completion : @escaping([SearchHomeModelClass]) -> Void) {
        ApiStore.shared.searchHomeApi(view, stateName, regionName, propertyName, freeText, county, rlu, amenities, rluAcresMin, rluAcresMax, priceMin, priceMax, LocalStore.shared.userAccountId, EMPTY_STR, EMPTY_STR, productTypeId, order, sort, pageNumber: pageNumber) { responseModel in
            if responseModel.statusCode == 200 {
                self.searchArr = responseModel.model
                self.delegate?.searchSuccessCalled()
                completion(self.searchArr)
            } else {
                self.delegate?.searchErrorCalled(responseModel.message ?? "")
            }
        }
    }
    
    // MARK: - Get Available County By States Api
    func getAvailableCountyByStateApi(_ view: UIView, stateAbbr: String, completion : @escaping(GetAvailableCountyByStatesModel) -> Void) {
        ApiStore.shared.getAvailableCountiesByStatesApi(view, stateAbbr) { responseModel in
           // print(responseModel)
            if responseModel.statusCode == 200 {
                self.countyArr = responseModel
                self.delegate?.countySuccessCalled()
                completion(self.countyArr!)
            } else {
                self.delegate?.countyErrorCalled(responseModel.message)
            }
        }
    }
    
    // MARK: - Point Layer Api
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
    
    // MARK: - Poly Layer Api
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
    // MARK: - Non Motorized Api
    func nonMotorizedApi(_ view: UIView, completion : @escaping(NonMotorizedModel) -> Void) {
        ApiStore.shared.nonMotorizedApi(view) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.nonMotorizedArr = responseModel
                self.delegate?.nonMotorizedSuccessCalled()
                completion(self.nonMotorizedArr!)
            } else {
                self.delegate?.nonMotorizedErrorCalled()
            }
        }
    }
    // MARK: - MultiPolygon Api
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
    // MARK: - MultiPolygon Api 2
    func multiPolygonApi2(_ view: UIView, rluName: String, completion : @escaping(MultiPolygonModel2) -> Void) {
        ApiStore.shared.multiPolygonApi2(view, rluName: rluName) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.multiPolygonArr2 = responseModel
                self.delegate?.selectedStaeMapSuccessCalled()
                completion(self.multiPolygonArr2!)
            } else {
                self.delegate?.multiPolygon2ErrorCalled()
            }
        }
    }
    // MARK: - SelectedSateMap Api
    func selectedSateMap(_ view: UIView, rluName: String, completion : @escaping(SelectStateMapModel) -> Void) {
        ApiStore.shared.selectedStateMap(view, rluName: rluName) { responseModel in
            // print(responseModel)
            if responseModel.features?.count != 0 {
                self.selectedStaeteMapArr = responseModel
                self.delegate?.selectedStaeMapSuccessCalled()
                completion(self.selectedStaeteMapArr!)
            } else {
                self.delegate?.selectedStaeMapErrorCalled()
            }
        }
    }
    // MARK: - RLU Detail Api
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
    // MARK: - Access Point
    func accessPointApi(_ view: UIView, completion : @escaping(AcessPointModel) -> Void) {
        ApiStore.shared.accessPointApi(view) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.accessPoinyArr = responseModel
                self.delegate?.accessPointSuccessCalled()
                completion(self.accessPoinyArr!)
            } else {
                self.delegate?.accessPointErrorCalled()
            }
        }
    }
    // MARK: - Permit Shapes
    func permitShapesApi(_ view: UIView, completion : @escaping(PermitShapesModel) -> Void) {
        ApiStore.shared.permitShapesApi(view) { responseModel in
           // print(responseModel)
            if responseModel.features?.count != 0 {
                self.permitShapesArr = responseModel
                self.delegate?.permitShapesSuccessCalled()
                completion(self.permitShapesArr!)
            } else {
                self.delegate?.permitShapesErrorCalled()
            }
        }
    }
}

// MARK: - Optional Delegates Defination
extension SearchViewModelDelegate {
    func searchAutoSuccessCalled() {
    }
    func searchAutoErrorCalled(_ error: String) {
    }
    func statesSuccessCalled() {
    }
    func statesErrorCalled(_ error: String) {
    }
    func allAmenitiesSuccessCalled() {
    }
    func allAmenitiesErrorCalled(_ error: String) {
    }
    func saveSearchSuccessCalled() {
    }
    func saveSearchErrorCalled(_ error: String) {
    }
    func searchSuccessCalled() {
    }
    func searchErrorCalled(_ error: String) {
    }
    func countySuccessCalled() {
    }
    func countyErrorCalled(_ error: String) {
    }
    func pointLayerSuccessCalled() {
    }
    func pointLayerErrorCalled() {
    }
    func polyLayerSuccessCalled() {
    }
    func polyLayerErrorCalled() {
    }
    func multiPolygonSuccessCalled() {
    }
    func multiPolygonErrorCalled() {
    }
    func rluDetailSuccessCalled() {
    }
    func rluDetailErrorCalled() {
    }
}

