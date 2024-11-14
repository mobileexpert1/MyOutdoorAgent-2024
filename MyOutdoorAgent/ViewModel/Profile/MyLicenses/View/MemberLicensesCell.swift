//  MemberLicensesCell.swift
//  MyOutdoorAgent
//  Created by CS on 07/09/22.

import UIKit

class MemberLicensesCell {
    func setView(_ cell : SearchCollVCell, _ memberLicensesArr : [ActiveMemeberPendindCombimeModelClass], _ indexPath : IndexPath) {
        cell.titleLbl.text = memberLicensesArr[indexPath.row].displayName
        cell.descLbl.text = (memberLicensesArr[indexPath.row].countyName ?? "") + ", " + (memberLicensesArr[indexPath.row].stateName ?? "")
        cell.acreLbl.text = Int((memberLicensesArr[indexPath.row].acres)!).description
     //   cell.topHeaderV.image = Images.membership_rlu.name
        // -- Set Top image
       // (cell.topHeaderV.image = Images.membership_rlu_blue.name)
        
        memberLicensesArr[indexPath.row].productTypeID == 1
        ? (cell.topHeaderV.image = Images.membership_rlu_blue.name)
        : (cell.topHeaderV.image = Images.membership_permit_blue.name)
        
        // -- Set Image
        if memberLicensesArr[indexPath.row].imageFilename == nil {
            cell.mainImgV.image = Images.logoImg.name
        } else {
            var str = (Apis.rluImageUrl) + memberLicensesArr[indexPath.row].imageFilename!
            if let dotRange = str.range(of: "?") {
                str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                
                str.contains(" ")
                ? cell.mainImgV.setNetworkImage(cell.mainImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.mainImgV.setNetworkImage(cell.mainImgV, str)
                
            } else {
                str.contains(" ")
                ? cell.mainImgV.setNetworkImage(cell.mainImgV, str.replacingOccurrences(of: " ", with: "%20"))
                : cell.mainImgV.setNetworkImage(cell.mainImgV, str)
            }
        }
        
        // -- Set Date
        let startDate = (cell.licenseLbl.text?.setDateFormat((memberLicensesArr[indexPath.row].licenseStartDate!), "MMMM", "dd", ", yyyy"))!
        let endDate = ((cell.licenseLbl.text?.setDateFormat((memberLicensesArr[indexPath.row].licenseEndDate!), "MMMM", "dd", ", yyyy"))!)
        cell.licenseLbl.text = (startDate + " to " + endDate)
        
        // -- Set Header Image
        if memberLicensesArr[indexPath.row].productTypeID == 1 {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 180)
            : (cell.topImgWidth.constant = 105)
        } else {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 210)
            : (cell.topImgWidth.constant = 120)
        }
        
        // -- Set Button
        cell.mainBtn.text = ButtonText.viewDetails.text
        cell.mainBtn.textColor = .white
        cell.mainBtnView.borderColor = Colors.green.value
        cell.mainBtnView.actionBlock {
            var data = [String: Any]()
            data["publicKey"] = memberLicensesArr[indexPath.row].publicKey
            
            UIApplication.visibleViewController.pushWithData(Storyboards.licensePropertyDetailView.name, Controllers.licensePropertyDetailVC.name, data)
        }
//        cell.mainBtnView.actionBlock {
//            var data = [String: Any]()
//            data["publicKey"] = memberLicensesArr[indexPath.row].publicKey
//            
//            UIApplication.visibleViewController.pushWithData(Storyboards.licensePropertyDetailView.name, Controllers.licensePropertyDetailVC.name, data)
//        }
        // -- Set Height according to text
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            switch UIDevice.current.orientation {
//            case .landscapeLeft, .landscapeRight:
//                cell.dateHeight.constant = 15
//            default:
//                cell.dateHeight.constant = 25
//            }
//        } else {
//            cell.dateHeight.constant = 15
//        }
    }
}
