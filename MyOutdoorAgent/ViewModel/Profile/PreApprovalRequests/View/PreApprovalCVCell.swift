//  PreApprovalCVCell.swift
//  MyOutdoorAgent
//  Created by CS on 08/08/22.

import UIKit
import PKHUD

protocol PreApprovalCVCellDelegate : AnyObject {
    func returnCancelCompletion(_ listCount: Int)
}

class PreApprovalCVCell: UICollectionViewCell {
    
    // MARK: - Objects
    var preApprovalReqArr = [PreApprovalReqModelClass]()
    weak var delegate : PreApprovalCVCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var reqDate: UILabel!
    @IBOutlet weak var topHeaderV: UIImageView!
    @IBOutlet weak var cancelV: UIView!
    @IBOutlet weak var requestedDateLbl: UILabel!
    @IBOutlet weak var acreLbl: UILabel!
    @IBOutlet weak var licenseTermLbl: UILabel!
    @IBOutlet weak var mainImgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var topImgWidth: NSLayoutConstraint!
    @IBOutlet weak var topImgHeight: NSLayoutConstraint!
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    // -- Set up delegates and datasource
    func setUpCollectionCell(_ collection : UICollectionView, _ responseModel : [PreApprovalReqModelClass]) {
        collection.delegate = self
        collection.dataSource = self
        preApprovalReqArr = responseModel
    }
}

// MARK: - UICollectionViewDelegates and UICollectionViewDatasource
extension PreApprovalCVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preApprovalReqArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if preApprovalReqArr[indexPath.row].requestType == "PreSale" {
           var data = [String: Any]()
            data["preSaleToken"] = preApprovalReqArr[indexPath.row].preSaleToken
            data["id"] = preApprovalReqArr[indexPath.row].preApprRequestID
            LocalStore.shared.selectedPropertyIndex = 3
            isComingFrom = "other"
            UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
        }else{
            
            var data = [String: Any]()
            data["publicKey"] = preApprovalReqArr[indexPath.row].publicKey
            data["id"] = preApprovalReqArr[indexPath.row].preApprRequestID
            LocalStore.shared.selectedPropertyIndex = 3
            isComingFrom = "other"
            UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
        }
       
    }
}

// MARK: - ConfigureCell
extension PreApprovalCVCell {
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.preApprovalCell.name, for: indexPath)
        guard let cell = dequeCell as? PreApprovalCVCell else { return UICollectionViewCell() }
        setView(cell, preApprovalReqArr, indexPath, collectionView, self)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PreApprovalCVCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = PreApprovalLayout().setCollectionLayout(collectionView, collectionViewLayout)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
