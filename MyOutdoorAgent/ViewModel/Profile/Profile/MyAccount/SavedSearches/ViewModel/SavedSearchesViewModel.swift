//  SavedSearchesViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit

protocol SavedSearchesViewModelDelegate : AnyObject {
    func savedSearchSuccessCalled(_ tableView: UITableView)
    func savedSearchErrorCalled(_ error: String)
    func deleteSearchSuccessCalled(_ success: String, _ userSearchID: Int, _ index: IndexPath)
    func deleteSearchErrorCalled(_ error: String)
}

class SavedSearchesViewModel {
    
    weak var delegate: SavedSearchesViewModelDelegate?
    var savedSearchesArr = [SavedSearchesModelClass]()
    
    init(_ delegate: SavedSearchesViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Saved Searches Api
    func savedSearchesApi(_ view: UIView, _ tableView: UITableView, completion : @escaping([SavedSearchesModelClass]) -> Void) {
        ApiStore.shared.savedSearchesApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
                self.savedSearchesArr = responseModel.model!
                self.delegate?.savedSearchSuccessCalled(tableView)
                completion(self.savedSearchesArr)
            } else {
                self.delegate?.savedSearchErrorCalled(responseModel.message!)
            }
        }
    }
    
    // MARK: - Delete Searches Api
    func deleteSearchesApi(_ view: UIView, _ userSearchID: Int, _ index: IndexPath) {
        ApiStore.shared.deleteSearchesApi(view, userSearchID) { responseModel in
            print(responseModel)
            responseModel.statusCode == 200
            ? self.delegate?.deleteSearchSuccessCalled(AppAlerts.searchDelSuccess.title, userSearchID, index)
            : self.delegate?.deleteSearchErrorCalled(responseModel.message!)
        }
    }
}

//MARK: - Optional Delegates Defination
extension SavedSearchesViewModelDelegate {
    func savedSearchSuccessCalled(_ tableView: UITableView) {
    }
    func savedSearchErrorCalled(_ error: String) {
    }
    func deleteSearchSuccessCalled(_ success: String, _ userSearchID: Int, _ index: IndexPath) {
    }
    func deleteSearchErrorCalled(_ error: String) {
    }
}
