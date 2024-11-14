//  PreApprovalReqViewModel.swift
//  MyOutdoorAgent
//  Created by CS on 31/08/22.

import UIKit
import PKHUD

protocol PreApprovalReqModelDelegate : AnyObject {
    func successCalled(_ collectionView: UICollectionView)
    func errorCalled()
}

class PreApprovalReqViewModel {
    
    weak var delegate: PreApprovalReqModelDelegate?
    var preApprovalReqArr = [PreApprovalReqModelClass]()
    
    init(_ delegate: PreApprovalReqModelDelegate) {
        self.delegate = delegate
    }
    
    // -- PreApproval Request Api
    func preApprovalReqApi(_ view: UIView, _ collectionView: UICollectionView, completion : @escaping([PreApprovalReqModelClass]) -> Void) {
        ApiStore.shared.preApprovalReqApi(view) { responseModel in
            print(responseModel)
            if responseModel.model != nil {
               
                self.preApprovalReqArr = responseModel.model!
                self.delegate?.successCalled(collectionView)
                completion(self.preApprovalReqArr)
            } else {
             
                self.delegate?.errorCalled()
            }
        }
    }
}

//MARK: - Optional Delegates Defination
extension PreApprovalReqModelDelegate {
    func successCalled(_ collectionView: UICollectionView) {
    }
    func errorCalled() {
    }
}
