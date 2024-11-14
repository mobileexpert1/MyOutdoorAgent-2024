//  SearchListView.swift
//  MyOutdoorAgent
//  Created by CS on 07/11/22.

import UIKit
import FacebookShare

// MARK: - UITableViewDelegate and UITableViewDataSource
extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("IndexPath",indexPath)
        if indexPath.row == (20 * pageCount) - 1 {
           
            pageCount =  pageCount + 1
            print("pageCount",pageCount)
           self.listViewApi(stateName: [], regionName: [], propertyName: self.searchesPropertyArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "", pageNumber: pageCount)
            print("fhgdfh")
           
        }
    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        isLoadingList = false
//    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        
//        if 
//        print("scrollViewDidEndDragging")
//        if ((searchTV.contentOffset.y + searchTV.frame.size.height) >= searchTV.contentSize.height - 500)
//        {
////            if apiResponseCount == 0 {
////                
////            }
//            if !isLoadingList{
//                isLoadingList = true
//                if self.pageCount < 2 {
//                    self.pageCount =  (self.listArr.count / 20) + 1
//                    self.listViewApi(stateName: [], regionName: [], propertyName: self.searchesPropertyArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "", pageNumber: pageCount)
//                }
//            }
//        }
//        
//        
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//                let offsetY = scrollView.contentOffset.y
//                let contentHeight = scrollView.contentSize.height
//                let height = scrollView.frame.size.height
//                
//                if     offsetY > contentHeight - height {
//                    pageCount =  pageCount + 1
//                    self.listViewApi(stateName: [], regionName: [], propertyName: self.searchesPropertyArr, freeText: [], county: [], rlu: [], amenities: [], rluAcresMin: 0, rluAcresMax: 0, priceMin: 0, priceMax: 0, productTypeId: 0, order: EMPTY_STR, sort: "", pageNumber: pageCount)
//                   
//              
//                }
//            }

}

// MARK: - ConfigureCell
extension SearchView {
    func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: "ListSearchTVCell", for: indexPath)
        guard let cell = dequeCell as? ListSearchTVCell else { return UITableViewCell() }
        cell.logoImg.layer.cornerRadius = 8
        cell.logoImg.layer.masksToBounds = true
        setListView(cell, indexPath)
        return cell
    }
    
    private func setListView(_ cell: ListSearchTVCell, _ indexPath: IndexPath) {
        cell.getImages(amenityArr[indexPath.row], collectionView: cell.amenitiesCV)
        
        // -- Set Image
        if listArr[indexPath.row].imagefilename == nil {
            cell.listImgV.image = Images.logoImage.name
        } else {
            if listArr[indexPath.row].imagefilename != nil {
                var str = (Apis.rluImageUrl) + (listArr[indexPath.row].imagefilename)!
                
                if let dotRange = str.range(of: "?") {
                    str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                    
                    str.contains(" ")
                    ? cell.listImgV.setNetworkImage(cell.listImgV, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.listImgV.setNetworkImage(cell.listImgV, str)
                    
                } else {
                    str.contains(" ")
                    ? cell.listImgV.setNetworkImage(cell.listImgV, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.listImgV.setNetworkImage(cell.listImgV, str)
                }
                //                if cell.listImgV.frame.height >= 210 {
                //                    cell.listImgV.frame = CGRect(x: 0, y: 0, width: 140, height: 185)
                //                }
            }
        }
        if  cell.listImgV.image == UIImage(named: "") {
            cell.listImgV.image = Images.logoImage.name
        }
        if listArr[indexPath.row].clientLogoPath == nil {
            cell.logoImg.image = Images.logoImage.name
        } else {
            if listArr[indexPath.row].clientLogoPath != nil {
                //                if listArr[indexPath.row].clientLogoPath == "/Assets/ClientLogo/391_Logo.jpeg"  || listArr[indexPath.row].clientLogoPath ==  "/Assets/ClientLogo/422_Logo.jpeg" || listArr[indexPath.row].clientLogoPath == "/Assets/ClientLogo/392_Logo.jpeg" {
                //                    cell.logoImg.image = Images.logoImage.name
                //                } else {
              //  var str = "https://adminv2.myoutdooragent.com/" + (listArr[indexPath.row].clientLogoPath)!
                var str = "https://client.myoutdooragent.com" + (listArr[indexPath.row].clientLogoPath)!
                
                if let dotRange = str.range(of: "?") {
                    str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                    
                    str.contains(" ")
                    ? cell.logoImg.setNetworkImage(cell.logoImg, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.logoImg.setNetworkImage(cell.logoImg, str)
                    
                } else {
                    str.contains(" ")
                    ? cell.logoImg.setNetworkImage(cell.logoImg, str.replacingOccurrences(of: " ", with: "%20"))
                    : cell.logoImg.setNetworkImage(cell.logoImg, str)
                }
                //                if cell.listImgV.frame.height >= 210 {
                //                    cell.listImgV.frame = CGRect(x: 0, y: 0, width: 140, height: 185)
                //                }
            }
        }
        //   }
        
        if  cell.logoImg.image == UIImage(named: "") {
            cell.logoImg.image = Images.logoImage.name
        }
        // -- Set Available text
        if ((listArr[indexPath.row].productTypeID) != 1) && ((listArr[indexPath.row].activityType) ?? "" != "Day Pass") {
            cell.availableLbl.isHidden = false
            //            UIDevice.current.userInterfaceIdiom == .phone
            //            ? (cell.availableHeight.constant = 15)
            //            : (cell.availableHeight.constant = 20)
        } else {
            cell.availableLbl.isHidden = true
            //  cell.availableHeight.constant = 0
        }
        
        // -- Set License Term and Available text
        if listArr[indexPath.row].activityType ?? "" == "Day Pass" {
            cell.licenseTermLbl.text = "Available On :"
        } else {
            cell.licenseTermLbl.text = "License Term :"
        }
        
        // -- Set Date
        let startDate = (cell.licenseStartDate.text?.setDateFormat((listArr[indexPath.row].licenseStartDate ?? ""), "MMMM", "dd", ", yyyy"))!
        let endDate = ((cell.licenseStartDate.text?.setDateFormat((listArr[indexPath.row].licenseEndDate ?? ""), "MMMM", "dd", ", yyyy"))!)
        cell.licenseStartDate.text = (startDate + " to " + endDate)
        
        // -- Available
        if (listArr[indexPath.row].productTypeID != 1) && (listArr[indexPath.row].activityType ?? "" != "Day Pass") {
            cell.availableLbl.isHidden = false
            //            UIDevice.current.userInterfaceIdiom == .phone
            //            ? (cell.availableHeight.constant = 15)
            //            : (cell.availableHeight.constant = 20)
            if (listArr[indexPath.row].maxSaleQtyAllowed) == (listArr[indexPath.row].saleCount) {
                cell.availableLbl.text = "Available On " + " " + "0"
            }
            
            let maxSaleQtyAllowedStr = listArr[indexPath.row].maxSaleQtyAllowed
            let saleCountStr = listArr[indexPath.row].saleCount
            
            guard let maxSaleQtyAllowed = maxSaleQtyAllowedStr, let saleCount = saleCountStr else {
                return
            }
            
            let availableCount = maxSaleQtyAllowed - saleCount
            
            if availableCount <= 0 {
                cell.availableLbl.text = "Available" + " " + "0"
            } else {
                cell.availableLbl.text = "Available" +  " " + ((availableCount).description) + " of " + (maxSaleQtyAllowed).description
            }
            
        } else {
            cell.availableLbl.isHidden = true
            //  cell.availableHeight.constant = 0
        }
        
        // -- Set Pre Approval Req Text
        if listArr[indexPath.row].hostApprovalRequired != false {
            cell.preApprovalLbl.isHidden = false
                        UIDevice.current.userInterfaceIdiom == .phone
                        ? (cell.preApprovalHeight.constant = 15)
                        : (cell.preApprovalHeight.constant = 20)
            cell.preApprovalLbl.text = "PRE-APPROVAL REQUIRED"
            cell.preApprovalLbl.textColor = Colors.bgGreenColor.value
        } else {
            if listArr[indexPath.row].productTypeID != 1 {
                if (((listArr[indexPath.row].saleCount ?? 0)) >= ((listArr[indexPath.row].maxSaleQtyAllowed ?? 0))) && ((listArr[indexPath.row].activityType) ?? "" != "Day Pass") {
                    cell.preApprovalLbl.isHidden = false
                    //                    UIDevice.current.userInterfaceIdiom == .phone
                    //                    ? (cell.preApprovalHeight.constant = 15)
                    //                    : (cell.preApprovalHeight.constant = 20)
                    cell.preApprovalLbl.text = "SOLD OUT"
                    cell.preApprovalLbl.textColor = Colors.redColor.value
                } else {
                    cell.preApprovalLbl.isHidden = true
                    //  cell.preApprovalHeight.constant = 0
                }
            } else {
                cell.preApprovalLbl.isHidden = true
                // cell.preApprovalHeight.constant = 0
            }
        }
        
        // Set Acres
        if let acresValue = listArr[indexPath.row].acres {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.groupingSeparator = ","
            formatter.decimalSeparator = "."

            // Format the acres value
            if let formattedString = formatter.string(from: NSNumber(value: acresValue)) {
                cell.acresLbl.text = formattedString
            } else {
                cell.acresLbl.text = "N/A" // Handle formatting error if needed
            }
        } else {
            cell.acresLbl.text = "N/A" // Handle the case when acres is nil
        }

        
        //cell.acresLbl.text = Int((listArr[indexPath.row].rluPropertyModel?.acres)!).description
        
        // Set Display Name
        cell.listDisplayNameLbl.text = listArr[indexPath.row].displayName
        
        // Set Location
        cell.listLocationLbl.text = (listArr[indexPath.row].countyName ?? "") + " County, " + ((listArr[indexPath.row].state ?? ""))
        
        // Set Fees
        if let licenseFee = listArr[indexPath.row].licenseFee {
            cell.priceLbl.text = "$" + String(format: "%.2f", Double(licenseFee))
        } else {
            cell.priceLbl.text = "$0.00"
        }
        
        if cell.preApprovalLbl.isHidden == true {
            cell.preApprovalHeight.constant = 0
        } else {
            cell.preApprovalHeight.constant = 10
        }
        cell.mapBtn.addTarget(self, action: #selector(mapDetailClick(_:)), for: .touchUpInside)
        cell.mapBtn.tag = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = [String: Any]()
        data["publicKey"] = self.listArr[indexPath.row].publicKey
        data["id"] = self.listArr[indexPath.row].productID
        LocalStore.shared.selectedPropertyIndex = self.tabBarController?.selectedIndex ?? 0
        isComingFrom = "other"
        UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
    }
    
    @objc func mapDetailClick(_ sender: UIButton) {
        self.searchTopViewInScrollV.toggleBtn.image = Images.list.name
        self.searchTopView.toggleBtn.image = Images.list.name
        self.selectedItem = "map"
        self.searchTV.isHidden = true
        self.noPropertyLbl.isHidden = true
        self.changeFilterLbl.isHidden = true
        self.resetFilterLbl.isHidden = true
        self.reloadBtn.isHidden = true
        self.mapView.isHidden = false
        self.zoomView.isHidden = false
        self.mapHybridView.isHidden = false
        productNo = (listArr[sender.tag].displayName ?? "")
       // self.setMapView()
        if listArr[sender.tag].productTypeID == 1 {
            setMultipolygonApi((listArr[sender.tag].productNo ?? ""))
        } else {
            setMultipolygonApi2((listArr[sender.tag].productNo ?? ""))
        }
      
       // setSpecificPolygonApi((listArr[sender.tag].productNo ?? ""))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
