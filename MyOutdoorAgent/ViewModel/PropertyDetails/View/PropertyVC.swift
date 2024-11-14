//  PropertyVC.swift
//  MyOutdoorAgent
//  Created by CS on 25/08/22.

import UIKit
import PKHUD
import WebKit
import FSCalendar
import GoogleMaps
import MapKit
import GoogleMapsUtils

var propertyImagesArr = [String]()
var conditionsArr = [String]()
var amenitiesIndexArr = [Int]()
var activityIndexArr = [Int]()
var similarPropProductNoArr = [String]()
var similarPropLocationArr = [String]()
var similarPropImagesArr = [String]()
var similarProperties : [SimilarProperty]?
var amenitiesArr : [Amenity]?
var activitiesArr : [Amenity]?
var membersArr : [Member]?
var clientDocumentss : [ClientDocument]?
var searchViewModelArr: SearchViewModel?

var timer : Timer?

class PropertyVC: AbstractView, WKUIDelegate {
    
    // MARK: - Objects
    var propertyViewModelArr: PropertyViewModel?
    var activityDetailArr : ActivityDetailModelClass?
    var propertyCell = PropertyTVCell()
    
    //MARK: - Variables
    var webView: WKWebView!
    var propertyHeaderTVCell = PropertyHeaderTVCell()
    var btn = [ButtonText.ok.text]
    var proceedBtn = [ButtonText.proceed.text, ButtonText.cancel.text]
    
    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = NSLocale(localeIdentifier: "en_EN") as Locale
        return formatter
    }()
    var numberOfSelectedDays = 1
    var currentSelectedDate = Date()
    var modifiedSelectedDate = Date()
    var isDeselectionStart = false
    var selectedDates = [String]()
    
    
    // MARK: - Outlets
    @IBOutlet weak var propertyTableV: UITableView!
    @IBOutlet var preApprovalPopUpView: PreApprovalPopUpView!
    @IBOutlet var reqTempAccessPopV: RequestTemporaryAccessView!
    @IBOutlet var paymentPdfPopUpView: PaymentPdfPopUpView!
    @IBOutlet var dayPassFunctionalityPopUpV: DayPassFunctionalityPopUpV!
    @IBOutlet var messagePopUpView: LeaveUsMessagePopUpView!
    @IBOutlet var licenseMemberV: LicenseMemberView!
    @IBOutlet var licenseRenewalPopUpV: LicenseRenewalView!
    @IBOutlet var mapDetailPopUpView: MapDetailPopUpView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
      //  propertyCell.mapView.mapType = .normal
      //  propertyCell.setMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setActivityDetailApi()
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.removeView(self.paymentPdfPopUpView)
        self.removeView(self.licenseMemberV)
        self.removeView(self.licenseRenewalPopUpV)
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    // MARK: - ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        setLicenseView()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        showNavigationBar(false)
        propertyCell.mapViewDelegate = self
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        //    self.setActivityDetailApi()
        //}
       
    }
    
    private func onViewAppear() {
        setDelegates()
        setUI()     
      
      
        //propertyHeaderTVCell.startTimer()
    }
    
    private func setUI() {
        if #available(iOS 15.0, *) {
            propertyTableV.sectionHeaderTopPadding = 0.0
        } else {
            propertyTableV.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        }
        HUD.show(.progress, onView: self.view)
    }
    
    private func setDelegates() {
        propertyViewModelArr = PropertyViewModel(self)
        self.licenseRenewalPopUpV.turkeyTxtF.maxLength = 8
        self.licenseRenewalPopUpV.doeTxtF.maxLength = 8
        self.licenseRenewalPopUpV.hogTxtF.maxLength = 8
        self.licenseRenewalPopUpV.buckTxtF.maxLength = 8
        
        self.licenseRenewalPopUpV.turkeyTxtF.delegate = self
        self.licenseRenewalPopUpV.doeTxtF.delegate = self
        self.licenseRenewalPopUpV.hogTxtF.delegate = self
        self.licenseRenewalPopUpV.buckTxtF.delegate = self
    }
    
    private func registerCell() {
        propertyTableV.register(UINib(nibName: CustomCells.propertyTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyTVCell.name)
        propertyTableV.register(UINib(nibName: CustomCells.propertyHeaderTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyHeaderTVCell.name)
    }
    
    private func setLicenseView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.licenseRenewalPopUpV.licenseVTop.constant = 80
            self.licenseRenewalPopUpV.licenseVBottom.constant = 80
            self.licenseMemberV.memberVTop.constant = 80
            self.licenseMemberV.memberVBottom.constant = 80
        } else {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.licenseRenewalPopUpV.licenseVTop.constant = 20
                        self.licenseRenewalPopUpV.licenseVBottom.constant = 20
                        self.licenseMemberV.memberVTop.constant = 20
                        self.licenseMemberV.memberVBottom.constant = 20
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.licenseRenewalPopUpV.licenseVTop.constant = 80
                        self.licenseRenewalPopUpV.licenseVBottom.constant = 80
                        self.licenseMemberV.memberVTop.constant = 80
                        self.licenseMemberV.memberVBottom.constant = 80
                    }
                }
            }
        }
    }
    
    //MARK: - Call Phone Number
    func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Web Services
    func setActivityDetailApi() {
        let data = dataFromLastVC as! [String:Any]
        let publicKey = data["publicKey"] as? String
        let preSaleToken = data["preSaleToken"] as? String
        print("publicKey>>>", publicKey)
        
        self.propertyViewModelArr?.activityDetailApi(self.view, publicKey ?? "", preSaleToken ?? "", completion: { responseModel in
            
            print("responseModel", responseModel)
            self.activityDetailArr = responseModel
            amenitiesArr = self.activityDetailArr?.amenities
            activitiesArr = self.activityDetailArr?.amenities
            similarProperties = self.activityDetailArr?.similarProperties
            membersArr = self.activityDetailArr?.members
            clientDocumentss = self.activityDetailArr?.clientDocuments
            LocalStore.shared.productNo = self.activityDetailArr?.activityDetail?.productNo ?? ""
            LocalStore.shared.productTypeId = self.activityDetailArr?.activityDetail?.productTypeID ?? 0
            print("membersArr>>", membersArr?.count)
            
            propertyImagesArr.removeAll()
            // -- Set Image
            if self.activityDetailArr?.images?.count != nil {
                for i in 0..<(self.activityDetailArr?.images?.count)! {
                    propertyImagesArr.append((self.activityDetailArr?.images?[i].imageFileName)!)
                }
            }
            
            conditionsArr.removeAll()
            if self.activityDetailArr?.specialConditions?.count != nil {
                for j in 0..<((self.activityDetailArr?.specialConditions!.count)!) {
                    conditionsArr.append((self.activityDetailArr?.specialConditions![j].specCndDesc)!)
                }
            }
            
            similarPropProductNoArr.removeAll()
            similarPropLocationArr.removeAll()
            similarPropImagesArr.removeAll()
            if self.activityDetailArr?.similarProperties?.count != nil {
                for k in 0..<((self.activityDetailArr?.similarProperties!.count)!) {
                    similarPropProductNoArr.append((self.activityDetailArr?.similarProperties![k].productNo)!)
                    similarPropLocationArr.append((self.activityDetailArr?.similarProperties![k].countyName)! + " County, " + (self.activityDetailArr?.similarProperties![k].stateName)!)
                    if self.activityDetailArr?.similarProperties![k].imageFilename != nil {
                        similarPropImagesArr.append((self.activityDetailArr?.similarProperties![k].imageFilename)!)
                    } else {
                        similarPropImagesArr.append("none")
                    }
                }
            }
            
            amenitiesIndexArr.removeAll()
            if amenitiesArr?.count != nil {
                for i in 0..<(amenitiesArr!.count) {
                    if (amenitiesArr![i].amenityType == CommonKeys.activity.name){
                        amenitiesIndexArr.append(i)
                    }
                }
                amenitiesArr!.remove(at: amenitiesIndexArr)
            }
            
            activityIndexArr.removeAll()
            if activitiesArr?.count != nil {
                for i in 0..<activitiesArr!.count {
                    if (activitiesArr![i].amenityType == CommonKeys.amenity.name){
                        activityIndexArr.append(i)
                    }
                }
                activitiesArr!.remove(at: activityIndexArr)
            }
            
            self.propertyTableV.delegate = self
            self.propertyTableV.dataSource = self
            self.registerCell()
            self.propertyTableV.reloadData()
        })
    }
}

// MARK: - ViewWillTransition
extension PropertyVC {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Will Transition to size \(size) from super view size \(self.view.frame.size)")
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.paymentPdfPopUpView.pdfViewTop.constant = 20
                self.paymentPdfPopUpView.pdfBottom.constant = 20
                self.paymentPdfPopUpView.crossBtnTop.constant = 10
                self.licenseRenewalPopUpV.licenseVTop.constant = 20
                self.licenseRenewalPopUpV.licenseVBottom.constant = 20
                self.licenseMemberV.memberVTop.constant = 20
                self.licenseMemberV.memberVBottom.constant = 20
            case .portrait, .portraitUpsideDown:
                self.paymentPdfPopUpView.pdfViewTop.constant = 40
                self.paymentPdfPopUpView.pdfBottom.constant = 40
                self.paymentPdfPopUpView.crossBtnTop.constant = 30
                self.licenseRenewalPopUpV.licenseVTop.constant = 80
                self.licenseRenewalPopUpV.licenseVBottom.constant = 80
                self.licenseMemberV.memberVTop.constant = 80
                self.licenseMemberV.memberVBottom.constant = 80
            default:
                self.paymentPdfPopUpView.pdfViewTop.constant = 40
                self.paymentPdfPopUpView.pdfBottom.constant = 40
                self.paymentPdfPopUpView.crossBtnTop.constant = 30
                self.licenseRenewalPopUpV.licenseVTop.constant = 80
                self.licenseRenewalPopUpV.licenseVBottom.constant = 80
                self.licenseMemberV.memberVTop.constant = 80
                self.licenseMemberV.memberVBottom.constant = 80
            }
        } else {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.paymentPdfPopUpView.pdfViewTop.constant = 40
                self.paymentPdfPopUpView.pdfBottom.constant = 40
                self.paymentPdfPopUpView.crossBtnTop.constant = 25
                self.licenseRenewalPopUpV.licenseVTop.constant = 20
                self.licenseRenewalPopUpV.licenseVBottom.constant = 20
                self.licenseMemberV.memberVTop.constant = 20
                self.licenseMemberV.memberVBottom.constant = 20
            case .portrait, .portraitUpsideDown:
                self.paymentPdfPopUpView.pdfViewTop.constant = 80
                self.paymentPdfPopUpView.pdfBottom.constant = 80
                self.paymentPdfPopUpView.crossBtnTop.constant = 65
                self.licenseRenewalPopUpV.licenseVTop.constant = 80
                self.licenseRenewalPopUpV.licenseVBottom.constant = 80
                self.licenseMemberV.memberVTop.constant = 80
                self.licenseMemberV.memberVBottom.constant = 80
            default:
                self.paymentPdfPopUpView.pdfViewTop.constant = 80
                self.paymentPdfPopUpView.pdfBottom.constant = 80
                self.paymentPdfPopUpView.crossBtnTop.constant = 65
                self.licenseRenewalPopUpV.licenseVTop.constant = 80
                self.licenseRenewalPopUpV.licenseVBottom.constant = 80
                self.licenseMemberV.memberVTop.constant = 80
                self.licenseMemberV.memberVBottom.constant = 80
            }
        }
        
        self.setActivityDetailApi()
    }
}

//MARK: - Optional Delegates Defination
extension PropertyVC: PropertyViewModelDelegate {
    func multiPolygon2SuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygon2ErrorCalled() {
        HUD.hide()
    }
    
    func pointLayerSuccessCalled() {
        HUD.hide()
    }
    
    func pointLayerErrorCalled() {
        HUD.hide()
    }
    
    func polyLayerSuccessCalled() {
        HUD.hide()
    }
    
    func polyLayerErrorCalled() {
        HUD.hide()
    }
    
    func multiPolygonSuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygonErrorCalled() {
        HUD.hide()
    }
    
    func rluDetailSuccessCalled() {
        HUD.hide()
    }
    
    func rluDetailErrorCalled() {
        HUD.hide()
    }
    
        func activityDetailSuccessCalled() {
            HUD.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.propertyTableV.reloadData()
            })
        }
        func activityDetailErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func entryFormSuccessCalled() {
            HUD.hide()
            HUD.flash(.label(AppAlerts.successEntryForm.title), delay: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                self.removeView(self.reqTempAccessPopV)
                self.reqTempAccessPopV.selectDateTxtF.text = EMPTY_STR
                var entriesArr : [UITextField]!
                entriesArr = [self.reqTempAccessPopV.firstnameTxtF, self.reqTempAccessPopV.secondnameTxtF,
                              self.reqTempAccessPopV.thirdnameTxtF, self.reqTempAccessPopV.forthnameTxtF,
                              self.reqTempAccessPopV.fifthnameTxtF]
                for field in entriesArr where !field.text!.isEmpty {
                    field.text = EMPTY_STR
                }
                
            }
        }
        func entryFormErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func submitReqSuccessCalled() {
            HUD.hide()
            HUD.flash(.label(AppAlerts.reqSubmitted.title), delay: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.removeView(self.preApprovalPopUpView)
            })
        }
        func submitReqErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func dayPassSuccessCalled(_ daypassTotalCost: Double, _ isAvailable: Bool) {
            HUD.hide()
            if isAvailable == true {
                let totalCost = String(format: "%.2f", daypassTotalCost)
                UIAlertController.showAlert(AppAlerts.success.title, message: AppAlerts.totalCost.title + String(totalCost), buttons: self.proceedBtn) { alert, index in
                    if index == 0 {
                        self.removeView(self.dayPassFunctionalityPopUpV)
                        self.paymentPdf()
                    } else {
                        self.removeView(self.dayPassFunctionalityPopUpV)
                    }
                }
            } else {
                UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.somethingWrong.localizedDescription, buttons: btn) { alert, index in
                    if index == 0 {
                        self.removeView(self.dayPassFunctionalityPopUpV)
                    }
                }
            }
        }
        func dayPassErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func sendMessageSuccessCalled() {
            HUD.hide()
        }
        func sendMessageErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func harvestingSuccessCalled() {
            HUD.hide()
        }
        func harvestingErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func generateContractSuccessCalled() {
            HUD.hide()
        }
        func generateContractErrorCalled(_ error: String) {
            HUD.hide()
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(AppAlerts.alert.title, message: error, buttons: okBtn, completion: nil)
        }
    }

// MARK: - UITextFields Delegates
extension PropertyVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Verify all the conditions
        if let sdcTextField = textField as? TextFieldInset {
            return sdcTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}

// MARK: - setMapDetailViewDelegate
extension PropertyVC: SetMapDetailViewDelegate {
    func setMapDetailView() {
        
    }
    
//    func setMapDetailView() {
//        searchViewModelArr?.rluDetailApi(UIApplication.visibleViewController.view, productNo: productNo, completion: { responseModel in
//            if isLicensed == 1 {
//                let btn = [ButtonText.ok.text]
//                UIAlertController.showAlert("", message: "\(productNo) is currently not available", buttons: btn) { alert, index in
//                    if index == 0 {
//                    }
//                }
//            } else {
//                // Map Detail Pop Up View
//                self.viewTransition(self.mapDetailPopUpView)
//               
//                self.mapDetailPopUpView.displayNameLbl.text = responseModel.productNo
//                self.mapDetailPopUpView.countyLbl.text = responseModel.countyName! + " County, " + responseModel.stateName!
//                self.mapDetailPopUpView.acresLbl.text = responseModel.acres?.description
//                self.mapDetailPopUpView.priceLbl.text = "$" + "" + responseModel.licenseFee!.description
//                
//                // -- Set Image
//                if responseModel.imageFilename == nil {
//                    self.mapDetailPopUpView.rluImageV.image = Images.logoImg.name
//                } else {
//                    var str = (Apis.rluImageUrl) + responseModel.imageFilename!
//                    if let dotRange = str.range(of: "?") {
//                        str.removeSubrange(dotRange.lowerBound..<str.endIndex)
//                        
//                        str.contains(" ")
//                        ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
//                        : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
//                    } else {
//                        str.contains(" ")
//                        ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
//                        : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
//                    }
//                }
//                
//                self.mapDetailPopUpView.rluImageV.actionBlock {
//                    var data = [String: Any]()
//                    data["publicKey"] = responseModel.publicKey
//                    data["id"] = responseModel.productID
//                    isComingFrom = "map"
//                    LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
//                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
//                }
//                
//                // Cross Button
//                self.mapDetailPopUpView.crossBtn.actionBlock {
//                    self.removeView(self.mapDetailPopUpView)
//                }
//                
//                // View Details
//                self.mapDetailPopUpView.viewDetailsBtn.actionBlock {
//                    var data = [String: Any]()
//                    data["publicKey"] = responseModel.publicKey
//                    data["id"] = responseModel.productID
//                    isComingFrom = "map"
//                    LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
//                    UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
//                }
//                
//                // Zoom In
//                self.mapDetailPopUpView.zoomInBtn.actionBlock {
//                    if zoom == true {
//                        //  self.mapView.animate(toZoom: self.mapView.camera.zoom + 2)
//                        zoom = false
//                        self.mapDetailPopUpView.zoomLbl.text = "Zoom Out"
//                        self.removeView(self.mapDetailPopUpView)
//                        self.propertyCell.setSpecificPolygonApi(responseModel.productNo!)
//                    } else {
//                        self.propertyCell.mapView.animate(toZoom: self.propertyCell.mapView.camera.zoom - 2)
//                        zoom = true
//                        self.mapDetailPopUpView.zoomLbl.text = "Zoom In"
//                        self.removeView(self.mapDetailPopUpView)
//                    }
//                }
//                
//                // Directions
//                self.mapDetailPopUpView.directionsBtn.actionBlock {
//                    //if checkLocationPermissions() {
//                    //        print(locationDict.value(forKey: "Location")!)
//                    //       print(index)
//                    
//                    //       let locationCoordinates = (locationDict.value(forKey: "Location")! as AnyObject).components(separatedBy: ",")
//                    
//                    // Create An UIAlertController with Action Sheet
//                    let optionMenuController = UIAlertController(title: nil, message: "Choose Option for maps", preferredStyle: .actionSheet)
//                    
//                    // Create UIAlertAction for UIAlertController
//                    let googleMaps = UIAlertAction(title: "Google Maps", style: .default, handler: {
//                        (alert: UIAlertAction!) -> Void in
//                        self.openGoogleDirectionMap(destinationLat: String(latitude), destinationLng: String(longitude))
//                    })
//                    
//                    let appleMaps = UIAlertAction(title: "Apple Maps", style: .default, handler: {
//                        (alert: UIAlertAction!) -> Void in
//                        
//                        print("self.latitude>>>", latitude)
//                        print("self.longitude>>>", longitude)
//                        
//                        //                        let directionsURL = "http://maps.apple.com/maps?saddr=&daddr=\(self.latitude)\(self.longitude)"
//                        let directionsURL = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
//                        guard let url = URL(string: directionsURL) else {
//                            return
//                        }
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                        } else {
//                            UIApplication.shared.openURL(url)
//                        }
//                        
//                        
//                        
//                        // Pass the coordinate that you want here
//                        //                        let coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude)
//                        //                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
//                        //                        mapItem.name = "Destination"
//                        //                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//                        
//                        /*
//                         
//                         let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)))
//                         source.name = self.productNo
//                         
//                         //let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitudeString] as NSString).doubleValue), longitude: Double(([LatitudeString] as NSString).doubleValue))
//                         
//                         let locc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
//                         
//                         let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locc.latitude, longitude: locc.longitude)))
//                         
//                         destination.name = responseModel.countyName! + " County, " + responseModel.stateName!
//                         
//                         MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//                         
//                         */
//                    })
//                    
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//                        (alert: UIAlertAction!) -> Void in
//                        print("Cancel")
//                    })
//                    
//                    // Add UIAlertAction in UIAlertController
//                    optionMenuController.addAction(googleMaps)
//                    optionMenuController.addAction(appleMaps)
//                    optionMenuController.addAction(cancelAction)
//                    
//                    // Present UIAlertController with Action Sheet
//                    self.present(optionMenuController, animated: true, completion: nil)
//                    //   }
//                    
//                    //}
//                }
//            }
//        })
//    }
    
//    func openGoogleDirectionMap( destinationLat: String,  destinationLng: String) {
//        let LocationManager = CLLocationManager()
//        if let myLat = LocationManager.location?.coordinate.latitude, let myLng = LocationManager.location?.coordinate.longitude {
//            if let tempURL = URL(string: "comgooglemaps://?saddr=&daddr=\(destinationLat),\(destinationLng)&directionsmode=driving") {
//                UIApplication.shared.open(tempURL, options: [:], completionHandler: { (isSuccess) in
//                    if !isSuccess {
//                        if UIApplication.shared.canOpenURL(URL(string: "https://www.google.co.th/maps/dir///")!) {
//                            UIApplication.shared.open(URL(string: "https://www.google.co.th/maps/dir/\(myLat),\(myLng)/\(destinationLat),\(destinationLng)/")!, options: [:], completionHandler: nil)
//                        } else {
//                            print("Can't open URL.")
//                        }
//                    }
//                })
//            } else {
//                print("Can't open GoogleMap Application.")
//            }
//        } else {
//            print("Please allow permission.")
//        }
//    }
}
