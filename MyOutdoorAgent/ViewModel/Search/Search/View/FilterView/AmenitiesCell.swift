//  AmenitiesCell.swift
//  MyOutdoorAgent
//  Created by CS on 28/09/22.

import UIKit
import PKHUD

// MARK: - SetView
extension AmenitiesCVCell {
    
    // MARK: - Amenities View
    func setAmenitiesView(_ cell : AmenitiesCVCell, _ amenitiesArr : [GetAllAmenitiesModelClass], _ indexPath : IndexPath, _ collectionView : UICollectionView, _ view: UIView) {
        print("amenitiesArr[indexPath.row].amenityName",amenitiesArr[indexPath.row].amenityName)
        if selectedAmenitiesArr.contains(amenitiesArr[indexPath.row].amenityName ?? "") {
            cell.checkImgV.isHidden = false
        } else {
            cell.checkImgV.isHidden = true
        }
        cell.amenitiesLbl.text = amenitiesArr[indexPath.row].amenityName
        
        // -- Set Image
        if amenitiesArr[indexPath.row].amenityIcon == nil {
            cell.amenitiesImgV.image = Images.logo.name
        } else {
            var str = (Apis.amenitiesUrl) + amenitiesArr[indexPath.row].amenityIcon!
            if let dotRange = str.range(of: "?") {
                str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                
                str.contains(" ")
                ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
                
            } else {
                str.contains(" ")
                ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
            }
        }
    }
    
    // MARK: - Activities View
    func setActivitiesView(_ cell : AmenitiesCVCell, _ activitiesArr : [GetAllAmenitiesModelClass], _ indexPath : IndexPath, _ collectionView : UICollectionView, _ view: UIView) {
        cell.amenitiesLbl.text = activitiesArr[indexPath.row].amenityName
        if selectedAmenitiesArr.contains(activitiesArr[indexPath.row].amenityName ?? "") {
            cell.checkImgV.isHidden = false
        } else {
            cell.checkImgV.isHidden = true
        }
        // -- Set Image
        if activitiesArr[indexPath.row].amenityIcon == nil {
            cell.amenitiesImgV.image = Images.logo.name
        } else {
            var str = (Apis.amenitiesUrl) + activitiesArr[indexPath.row].amenityIcon!
            if let dotRange = str.range(of: "?") {
                str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                
                str.contains(" ")
                ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
                
            } else {
                str.contains(" ")
                ? cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.amenitiesImgV.setNetworkImage(cell.amenitiesImgV, str)
            }
        }
    }
    
}

