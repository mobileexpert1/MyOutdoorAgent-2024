//  PreApprovalCell.swift
//  MyOutdoorAgent
//  Created by CS on 08/09/22.

import UIKit
import PKHUD

// MARK: - SetView
extension PreApprovalCVCell {
    func setView(_ cell : PreApprovalCVCell, _ preApprovalReqArr : [PreApprovalReqModelClass], _ indexPath : IndexPath, _ collectionView : UICollectionView, _ view: UIView) {
        
        // -- Set Title
        cell.titleLbl.text = preApprovalReqArr[indexPath.row].displayName
        
        if (preApprovalReqArr[indexPath.row].countyName != nil) && (preApprovalReqArr[indexPath.row].stateName != nil) {
            cell.descLbl.text = (preApprovalReqArr[indexPath.row].countyName ?? "") + " County, " + (preApprovalReqArr[indexPath.row].stateName ?? "")
        }
        if preApprovalReqArr[indexPath.row].acres != nil {
            cell.acreLbl.text = Int((preApprovalReqArr[indexPath.row].acres ?? 0.0)).description
        }
        
        // -- Date
        if preApprovalReqArr[indexPath.row].dateSubmitted != nil {
            cell.requestedDateLbl.text = cell.requestedDateLbl.text?.setDateFormat((preApprovalReqArr[indexPath.row].dateSubmitted ?? ""), "MMMM", "dd", ", yyyy")
        }
        
        if (preApprovalReqArr[indexPath.row].licenseStartDate != nil) || (preApprovalReqArr[indexPath.row].licenseEndDate != nil) {
            cell.licenseTermLbl.text =  ((cell.licenseTermLbl.text?.setDateFormat((preApprovalReqArr[indexPath.row].licenseStartDate ?? ""), "MMMM", "dd", ", yyyy"))! + " to " + ((cell.licenseTermLbl.text?.setDateFormat((preApprovalReqArr[indexPath.row].licenseEndDate ?? ""), "MMMM", "dd", ", yyyy"))!))
        }
        
        // -- Set Image
        if preApprovalReqArr[indexPath.row].imageFilename == nil {
            cell.mainImgV.image = Images.logoImg.name
        } else {
            var str = (Apis.rluImageUrl) + (preApprovalReqArr[indexPath.row].imageFilename ?? "")
            print("imageFilename---->",  str)
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
        print(preApprovalReqArr[indexPath.row].requestStatus)
        // -- Check Request Status
        // -- Check if request status is accepted then set view details button otherwise cancel button
        if preApprovalReqArr[indexPath.row].requestStatus == CommonKeys.accepted.name {
            
            if preApprovalReqArr[indexPath.row].requestType == "PreSale" {
                print("PreSale1------" , preApprovalReqArr[indexPath.row].requestType)
                // setViewProperty(cell.cancelV, Colors.green.value)
                cell.reqDate.text = "Vaild Till:"
                setViewAndLbl(cell, UIImage(named: "PreSaleInvite") ?? UIImage(), ButtonText.cancelRequest.text, .white)
                                cell.cancelV.backgroundColor = UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
                //                cell.cancelLbl.text = "View Detail"
                                cell.cancelLbl.textColor = .white
                cell.cancelV.actionBlock {
                    var data = [String: Any]()
                    data["publicKey"] = preApprovalReqArr[indexPath.row].publicKey
                    data["preSaleToken"] = preApprovalReqArr[indexPath.row].preSaleToken
                    
                    isComingFrom = "other"
                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                }
            }else{
                
                print("PreApproval1------" , preApprovalReqArr[indexPath.row].requestType)
                setViewAndLbl(cell, UIImage(named:"Accepted 1") ?? UIImage(), ButtonText.viewDetails.text, .white)
                setViewProperty(cell.cancelV, .clear)
                cell.cancelV.backgroundColor = UIColor(red: 216/255, green: 37/255, blue: 63/255, alpha: 1)
                cell.cancelV.actionBlock {
                    var data = [String: Any]()
                    data["publicKey"] = preApprovalReqArr[indexPath.row].publicKey
                    data["id"] = preApprovalReqArr[indexPath.row].preApprRequestID
                    isComingFrom = "other"
                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                    
                }
            }
            
            
        } else {
            
            if preApprovalReqArr[indexPath.row].requestType == "PreSale" {
                print("PreSale2------" , preApprovalReqArr[indexPath.row].requestType)
                setViewAndLbl(cell,  UIImage(named: "PreSaleInvite") ?? UIImage(), ButtonText.viewDetails.text, .white)
                setViewProperty(cell.cancelV, .clear)
                cell.reqDate.text = "Vaild Till:"
                cell.cancelV.backgroundColor = UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
                // cell.cancelV.backgroundColor = .green
                //                cell.cancelLbl.text = "View Detail"
                //                cell.cancelLbl.textColor = .white
                cell.cancelV.actionBlock {
                    let btns = [ButtonText.yes.text, ButtonText.no.text]
                    var data = [String: Any]()
                    //data["publicKey"] = preApprovalReqArr[indexPath.row].publicKey
                    data["preSaleToken"] = preApprovalReqArr[indexPath.row].preSaleToken
                    data["id"] = preApprovalReqArr[indexPath.row].preApprRequestID
                    LocalStore.shared.selectedPropertyIndex = 3
                    isComingFrom = "other"
                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                    //                    UIAlertController.showAlert(AppAlerts.cancelPreApproval.title, message: AppAlerts.deleteReq.title, buttons: btns) { alert, index in
                    ////                        if index == 0 {
                    ////                            self.preApprovalReqArr.remove(at: indexPath.row)
                    ////                            ApiStore.shared.cancelPreApprovalReqApi(view, cancelReqId: preApprovalReqArr[indexPath.row].preApprRequestID) { responseModel in
                    ////                                if responseModel.statusCode == 200 {
                    ////                                    DispatchQueue.main.async {
                    ////                                        collectionView.reloadData()
                    ////                                        HUD.flash(.label(AppAlerts.requestDelSuccess.title), delay: 1.0)
                    ////                                        self.delegate?.returnCancelCompletion(self.preApprovalReqArr.count)
                    ////                                    }
                    ////                                } else {
                    ////                                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: responseModel.message!), delay: 1.0)
                    ////                                }
                    ////                            }
                    ////                        }
                    //                    }
                }
            }else{
                
                print("PreApproval233------" , preApprovalReqArr[indexPath.row].requestType)
                setViewAndLbl(cell, Images.requested.name, ButtonText.cancelRequest.text, .white)
                setViewProperty(cell.cancelV, .clear)
                cell.cancelV.backgroundColor = UIColor(red: 216/255, green: 37/255, blue: 63/255, alpha: 1)
                cell.cancelV.actionBlock {
                    let btns = [ButtonText.yes.text, ButtonText.no.text]
                    UIAlertController.showAlert(AppAlerts.cancelPreApproval.title, message: AppAlerts.deleteReq.title, buttons: btns) { alert, index in
                        if index == 0 {
                            self.preApprovalReqArr.remove(at: indexPath.row)
                            ApiStore.shared.cancelPreApprovalReqApi(view, cancelReqId: preApprovalReqArr[indexPath.row].preApprRequestID ?? 0) { responseModel in
                                if responseModel.statusCode == 200 {
                                    DispatchQueue.main.async {
                                        collectionView.reloadData()
                                        HUD.flash(.label(AppAlerts.requestDelSuccess.title), delay: 1.0)
                                        self.delegate?.returnCancelCompletion(self.preApprovalReqArr.count)
                                    }
                                } else {
                                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: responseModel.message!), delay: 1.0)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
        
        // -- Set Header Image
        if preApprovalReqArr[indexPath.row].requestStatus == CommonKeys.accepted.name {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 150)
            : (cell.topImgWidth.constant = 90)
        } else {
            UIDevice.current.userInterfaceIdiom == .pad
            ? (cell.topImgWidth.constant = 152)
            : (cell.topImgWidth.constant = 95)
        }
        
        // -- Set Height according to text
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                cell.dateHeight.constant = 10
            default:
                cell.dateHeight.constant = 25
            }
        } else {
            cell.dateHeight.constant = 15
        }
    }
    
    // MARK: - SetView
    func setViewProperty(_ view: UIView, _ borderColor: UIColor) {
        view.cornerRadius = 5
        view.borderColor = borderColor
        view.borderWidth = 0.5
    }
    
    func setViewAndLbl(_ cell: PreApprovalCVCell, _ image: UIImage, _ text: String, _ color: UIColor) {
        cell.topHeaderV.image = image
        cell.cancelLbl.text = text
        cell.cancelLbl.textColor = color
    }
}
