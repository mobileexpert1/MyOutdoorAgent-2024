//  LicenseDetailTVCell.swift
//  MyOutdoorAgent
//  Created by CS on 06/10/22.

import UIKit
import PKHUD
import GoogleMaps
import WebKit
import GoogleMapsUtils

protocol LicenseDetailTVCellDelegate : AnyObject {
    func returnPdfViewCompletionForLicenseCell(_ agreementName: String)
    func returnMapViewCompletionForLicenseCell(_ agreementName: String)
}

protocol ReloadTableViewDelegate : AnyObject {
    func reloadTableViewData()
}

class LicenseDetailTVCell: UITableViewCell, UIDocumentInteractionControllerDelegate {
 
    
    
    // MARK: - Objects
    
     var myLicensesViewModelArr: MyLicensesViewModel?
  
    
    weak var delegate : LicenseDetailTVCellDelegate?
    weak var reloadDelegate : ReloadTableViewDelegate?
    var clusterArr = [Int]()
    var isLicensedArr = [Int]()
    var coordinatePointArr = [[Double]]()
    var clusterManager: GMUClusterManager!
    let specificLabelMarker = GMSMarker()
   
    let marker = GMSMarker()
    var mapModel : PointModel?
    var currentZoom: Float = 15
   
    weak var mapViewDelegate : SetMapDetailViewDelegate?
    var coordinateMultiplygonArr = [Double]()
    var polyArr : PolyModel?
    var coordinatePolyArr = [[Coordinate]]()
    var coordinateMultiPolyArr = [[[Coordinate]]]()
    var isLicensedPolyArr = [Int]()
    var polygonData: [String: UIColor] = [:]
    var polygonPoints: [CLLocationCoordinate2D] = []
    let polygonLine = GMSPolyline()
    var labelMarkers: [GMSMarker] = []
    var labelMarkers2: [GMSMarker] = []
    var hasCalledGenerateClusterItems = false
    var zoomChangeTimer: Timer?
    var lastZoomLevel: Float = 0
    var polygons: [GMSPolyline] = []
    var latitude = Double()
    var longitude = Double()
   // var licenseViewModelArr: SearchViewModel?
    var isLicensedMultiPolyArr = [Int]()
  
    
    // MARK: - Outlets
    @IBOutlet weak var zoomOut: UILabel!
    @IBOutlet weak var zoomIn: UILabel!
    @IBOutlet weak var noDocumentAvailable: UILabel!
    @IBOutlet weak var documemtTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var documentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var documentTableView: UITableView!
    @IBOutlet weak var inviteMembersV: UIView!
    @IBOutlet weak var addVehiclesV: UIView!
    @IBOutlet weak var licenseDisplayNameLbl: UILabel!
    @IBOutlet weak var noMembersLbl: UILabel!
    @IBOutlet weak var membersTV: UITableView!
    @IBOutlet weak var vehiclesTV: UITableView!
    @IBOutlet weak var noVehiclesLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var licenseHolderLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var clubNameLbl: UILabel!
    @IBOutlet weak var propertyNumberLbl: UILabel!
    @IBOutlet weak var propertyFeesLbl: UILabel!
    @IBOutlet weak var acresLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var licenseStatusV: UIView!
    @IBOutlet weak var licenseStatusLbl: UILabel!
    @IBOutlet weak var paymentStatusV: UIView!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var noGuidelinesLbl: UILabel!
    @IBOutlet weak var guidelinesTV: UITableView!
    @IBOutlet weak var propertyOverviewLbl: UILabel!
    @IBOutlet weak var noActivitiesLbl: UILabel!
    @IBOutlet weak var noAmenitiesLbl: UILabel!
    @IBOutlet weak var activitiesTV: UITableView!
    @IBOutlet weak var amenitiesTV: UITableView!
    @IBOutlet weak var clubMembershipV: UIView!
    @IBOutlet weak var licenseAgreementV: UIView!
    @IBOutlet weak var noMapsLbl: UILabel!
    @IBOutlet weak var noPropertyLbl: UILabel!
    @IBOutlet weak var mapsTV: UITableView!
    @IBOutlet weak var amenitiesHeight: NSLayoutConstraint!
    @IBOutlet weak var activitiesHeight: NSLayoutConstraint!
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    @IBOutlet weak var vehicleHeight: NSLayoutConstraint!
    @IBOutlet weak var memberHeight: NSLayoutConstraint!
    @IBOutlet weak var addVehicleTop: NSLayoutConstraint!
    @IBOutlet weak var memberTop: NSLayoutConstraint!
    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var guideLinesHeight: NSLayoutConstraint!
    @IBOutlet weak var noInvoiceFoundLbl: UILabel!
    @IBOutlet weak var invoiceTV: UITableView!
    @IBOutlet weak var invoicesHeight: NSLayoutConstraint!
    @IBOutlet weak var renewLicenseBtn: UIView!
    @IBOutlet weak var renewLicenseMainV: UIView!
    @IBOutlet weak var renewLicenseHeight: NSLayoutConstraint!
    @IBOutlet weak var renewLicenseTop: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var renewDueDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setMemberTVDelegates()
        registerMemberTV()
        setVehicleTVDelegates()
        registerVehicleTV()
        setInvoiceTVDelegates()
        registerInvoiceTV()
        setConditionTVDelegates()
        registerConditionTV()
        registerAmenitiesTV()
        setAmenitiesTVDelegates()
        registerActivitiesTV()
        setActivitiesTVDelegates()
        registerMapsTV()
        if LocalStore.shared.productTypeId == 1 {
            setMultipolygonApi(LocalStore.shared.productNo)
        } else {
            setMultipolygonApi2(LocalStore.shared.productNo)
        }
     //   setPointLayer()
        documentTableViewRegister()
        setMapsTVDelegates()
        myLicensesViewModelArr = MyLicensesViewModel(self)
        zoomIn.actionBlock {
            self.mapView.animate(toZoom: self.mapView.camera.zoom + 1)
        }
        zoomOut.actionBlock {
            self.mapView.animate(toZoom: self.mapView.camera.zoom - 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func documentTableViewRegister() {
        documentTableView.register(UINib(nibName: "DocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentTableViewCell")
        documentTableView.dataSource = self
        documentTableView.delegate = self
        self.documentTableView.rowHeight = UITableView.automaticDimension
        self.documentTableView.estimatedRowHeight = 44
    }
    // MARK: - Functions
    func setMemberTVDelegates() {
        membersTV.dataSource = self
        membersTV.delegate = self
        membersTV.reloadData()
    }
    
    func registerMemberTV() {
        membersTV.register(UINib(nibName: CustomCells.inviteMemberTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.inviteMemberTVCell.name)
    }
    
    func setVehicleTVDelegates() {
        vehiclesTV.dataSource = self
        vehiclesTV.delegate = self
        vehiclesTV.reloadData()
    }
    
    func registerVehicleTV() {
        vehiclesTV.register(UINib(nibName: CustomCells.vehicleInfoTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.vehicleInfoTVCell.name)
    }
    
    func setInvoiceTVDelegates() {
        invoiceTV.dataSource = self
        invoiceTV.delegate = self
        invoiceTV.reloadData()
    }
    
    func registerInvoiceTV() {
        invoiceTV.register(UINib(nibName: CustomCells.invoicesTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.invoicesTVCell.name)
    }
    
    func setConditionTVDelegates() {
        guidelinesTV.dataSource = self
        guidelinesTV.delegate = self
        guidelinesTV.reloadData()
    }
    
    func registerConditionTV() {
        guidelinesTV.register(UINib(nibName: CustomCells.propertyConditionsTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyConditionsTVCell.name)
    }
    
    func registerAmenitiesTV() {
        amenitiesTV.register(UINib(nibName: CustomCells.propertyAmenitiesTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyAmenitiesTVCell.name)
    }
    
    func setAmenitiesTVDelegates() {
        amenitiesTV.delegate = self
        amenitiesTV.dataSource = self
        amenitiesTV.reloadData()
    }
    
    func registerActivitiesTV() {
        activitiesTV.register(UINib(nibName: CustomCells.propertyAmenitiesTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyAmenitiesTVCell.name)
    }
    
    func setActivitiesTVDelegates() {
        activitiesTV.delegate = self
        activitiesTV.dataSource = self
        activitiesTV.reloadData()
    }
    
    func registerMapsTV() {
        mapsTV.register(UINib(nibName: CustomCells.propertyMapsTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.propertyMapsTVCell.name)
    }
    
    func setMapsTVDelegates() {
        mapsTV.delegate = self
        mapsTV.dataSource = self
        mapsTV.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension LicenseDetailTVCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == guidelinesTV {
            if conditionsLicenseArr.count != 0 {
                UIDevice.current.userInterfaceIdiom  == .phone
                ? (guideLinesHeight.constant = CGFloat(60 + Int(25*conditionsLicenseArr.count)))
                : (guideLinesHeight.constant = CGFloat(75 + Int(25*conditionsLicenseArr.count)))
                return conditionsLicenseArr.count
            }
        }
        
        if tableView == membersTV {
            if memberDetailArr?.count != nil {
                UIDevice.current.userInterfaceIdiom  == .phone
                ? (memberHeight.constant = CGFloat(60 + Int(110*memberDetailArr!.count)))
                : (memberHeight.constant = CGFloat(80 + Int(110*memberDetailArr!.count)))
                return memberDetailArr!.count
            }
        }
        
        if tableView == vehiclesTV {
            if vehicleDetailArr?.count != nil {
                UIDevice.current.userInterfaceIdiom  == .phone
                ? (vehicleHeight.constant = CGFloat(60 + Int(100*vehicleDetailArr!.count)))
                : (vehicleHeight.constant = CGFloat(90 + Int(100*vehicleDetailArr!.count)))
                return vehicleDetailArr!.count
            }
        }
        
        if tableView == invoiceTV {
            if invoiceDetailArr?.count != nil {
                UIDevice.current.userInterfaceIdiom == .phone
                ? (invoicesHeight.constant = CGFloat(55 + Int(90*invoiceDetailArr!.count)))
                : (invoicesHeight.constant = CGFloat(75 + Int(90*invoiceDetailArr!.count)))
                return invoiceDetailArr!.count
            }
        }
        
        if tableView == mapsTV {
            UIDevice.current.userInterfaceIdiom  == .phone
            ? (mapHeight.constant = CGFloat(65 + Int(50*mapsArr.count)))
            : (mapHeight.constant = CGFloat(80 + Int(50*mapsArr.count)))
            return mapsArr.count
        }
        
        if tableView == activitiesTV {
            if activitiesLicenseArr != nil {
                UIDevice.current.userInterfaceIdiom  == .phone
                ? (activitiesHeight.constant = CGFloat(65 + Int(25*activitiesLicenseArr!.count)))
                : (activitiesHeight.constant = CGFloat(85 + Int(25*activitiesLicenseArr!.count)))
                
                return activitiesLicenseArr!.count
            }
        }
        
        if tableView == amenitiesTV {
            if amenitiesLicenseArr != nil {
                UIDevice.current.userInterfaceIdiom  == .phone
                ? (amenitiesHeight.constant = CGFloat(65 + Int(25*amenitiesLicenseArr!.count)))
                : (amenitiesHeight.constant = CGFloat(95 + Int(25*amenitiesLicenseArr!.count)))
                return amenitiesLicenseArr!.count
            }
        }
        if tableView == documentTableView {
            if documentData?.count ?? 0 > 0 {
                noDocumentAvailable.isHidden = true
                documentTableView.isHidden = false
                documentViewHeight.constant = CGFloat((documentData?.count ?? 0) * 50) + 60
            } else {
                documentViewHeight.constant = CGFloat((documentData?.count ?? 0) * 50) + 100
                noDocumentAvailable.isHidden = false
                documentTableView.isHidden = true
            }
           
            let height = CGFloat((documentData?.count ?? 0) * 50)
            documemtTableViewHeight.constant = height
            return documentData?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
}

// MARK: - ConfigureCell
extension LicenseDetailTVCell {
    private func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        if tableView == guidelinesTV {   //Special Conditions TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyConditionsTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyConditionsTVCell else { return UITableViewCell() }
            setConditionsCell(cell, indexPath)
            return cell
        }
        if tableView == membersTV { // Member TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.inviteMemberTVCell.name, for: indexPath)
            guard let cell = dequeCell as? InviteMemberTVCell else { return UITableViewCell() }
            setMemberCell(cell, indexPath)
            return cell
        }
        if tableView == vehiclesTV { // Vehicle TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.vehicleInfoTVCell.name, for: indexPath)
            guard let cell = dequeCell as? VehicleInfoTVCell else { return UITableViewCell() }
            setVehicleCell(cell, indexPath)
            return cell
        }
        if tableView == invoiceTV { // Invoice TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.invoicesTVCell.name, for: indexPath)
            guard let cell = dequeCell as? InvoicesTVCell else { return UITableViewCell() }
            setInvoiceCell(cell, indexPath)
            return cell
        }
        if tableView == mapsTV {  // Maps TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyMapsTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyMapsTVCell else { return UITableViewCell() }
            cell.delegate = self
            setMapsCell(cell, indexPath)
            return cell
        }
         if tableView == documentTableView {
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath)
            guard let cell = dequeCell as? DocumentTableViewCell else { return UITableViewCell() }
            setClientDocument(cell, indexPath)
            return cell
        }
        if tableView == activitiesTV {  // Activities TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyAmenitiesTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyAmenitiesTVCell else { return UITableViewCell() }
            setActivitiesCell(cell, indexPath)
            return cell
        }
        else {        // Amenities TableView
            let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.propertyAmenitiesTVCell.name, for: indexPath)
            guard let cell = dequeCell as? PropertyAmenitiesTVCell else { return UITableViewCell() }
            setAmenitiesCell(cell, indexPath)
            return cell
        }
    }
    func formatPhoneNumber(_ number: String) -> String? {
        // Remove all non-digit characters
        let digits = number.compactMap { $0.isNumber ? String($0) : nil }.joined()
        
        // Ensure we have exactly 10 digits
        guard digits.count == 10 else { return nil }
        
        // Format the phone number
        let areaCode = String(digits.prefix(3))
        let centralOfficeCode = String(digits.dropFirst(3).prefix(3))
        let lineNumber = String(digits.dropFirst(6))
        
        return "(\(areaCode)) \(centralOfficeCode)-\(lineNumber)"
    }
    func setMemberCell(_ cell: InviteMemberTVCell, _ indexPath: IndexPath) {
        if memberDetailArr!.count == 0 {
            noMembersLbl.isHidden = false
        } else {
            noMembersLbl.isHidden = true
            cell.nameLbl.text = (memberDetailArr![indexPath.row].firstName ?? "") + " " +  (memberDetailArr![indexPath.row].lastName ?? "")
            cell.emailLbl.text = memberDetailArr![indexPath.row].email
            cell.phoneLbl.text = formatPhoneNumber(memberDetailArr![indexPath.row].phone ?? "")
          
            // -- Set Invited View
            if memberDetailArr![indexPath.row].isAccepted == false {
                cell.invitedV.isHidden = false
            } else {
                cell.invitedV.isHidden = true
            }
            
            // -- Set Delete Button
            if isAllowMember == true {
                cell.deleteBtn.isHidden = false
            } else {
                cell.deleteBtn.isHidden = true
            }
            
            // -- Delete Action
            cell.deleteBtn.actionBlock {
                let btns = [ButtonText.yes.text, ButtonText.no.text]
                UIAlertController.showAlert(AppAlerts.remove.title, message: AppAlerts.memberRemove.title, buttons: btns) { alert, index in
                    if index == 0 {
                        self.myLicensesViewModelArr?.removeMembersApi(UIApplication.visibleViewController.view, Int(memberDetailArr![indexPath.row].licenseContractMemberID!)!, completion: { responseModel in
                            memberDetailArr?.remove(at: indexPath.row)
                        })
                    }
                }
            }
        }
    }
//    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//        return LicensePropertyDetailVC()
//    }
//    func setClientDocument(_ cell: DocumentTableViewCell, _ indexPath: IndexPath) {
//        cell.documentLabel.setTitle(documentData[indexPath.row].fileName, for: .normal)
//        cell.documentLabel.actionBlock {
//            print(documentData[indexPath.row].documentName ?? "")
//            let urlString = "https://adminv2.myoutdooragent.com/Assets/ClientDocuments/13/" + (documentData[indexPath.row].documentName ?? "")
//
//            if let myURL = URL(string: urlString) {
//                let webView = WKWebView()
//                let request = URLRequest(url: myURL, cachePolicy: .useProtocolCachePolicy)
//                webView.load(request)
//
//                // Create a UIDocumentInteractionController
//                let documentInteractionController = UIDocumentInteractionController(url: myURL)
//                documentInteractionController.delegate = self
//
//                // Present the document interaction controller
//                documentInteractionController.presentPreview(animated: true)
//            }
//        }
//    }
    func setClientDocument(_ cell: DocumentTableViewCell, _ indexPath: IndexPath) {
        cell.documentLabel.setTitle(documentData?[indexPath.row].fileName, for: .normal)
        cell.documentView.actionBlock {
            print("documentName",documentData?[indexPath.row].documentName ?? "")
            print("clientID",documentData?[indexPath.row].clientID ?? "")
            let clientIdValue = "\(documentData?[indexPath.row].clientID ?? 0)"
            print(clientIdValue)
            let urlString = "https://client.myoutdooragent.com/Assets/ClientDocuments/" + clientIdValue + "/" + (documentData?[indexPath.row].documentName ?? "")
                //  https://adminv2.myoutdooragent.com/Assets/ClientDocuments/13/HPL%20DAYPASS.pdf
            print("urlString",urlString)
            if let myURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(myURL) {
                    UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
                }
            }
        }
        cell.documentLabel.actionBlock {
            print("documentName",documentData?[indexPath.row].documentName ?? "")
            print("clientID",documentData?[indexPath.row].clientID ?? "")
            let clientIdValue = "\(documentData?[indexPath.row].clientID ?? 0)"
            print(clientIdValue)
            let urlString = "https://client.myoutdooragent.com/Assets/ClientDocuments/" + clientIdValue + "/" + (documentData?[indexPath.row].documentName ?? "")
                //  https://adminv2.myoutdooragent.com/Assets/ClientDocuments/13/HPL%20DAYPASS.pdf
            print("urlString",urlString)
            if let myURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(myURL) {
                    UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    func setVehicleCell(_ cell: VehicleInfoTVCell, _ indexPath: IndexPath) {
        if vehicleDetailArr!.count == 0 {
            noVehiclesLbl.isHidden = false
        } else {
            noVehiclesLbl.isHidden = true
            cell.makeLbl.text = vehicleDetailArr![indexPath.row].vehicleMake
            cell.modelLbl.text = vehicleDetailArr![indexPath.row].vehicleModel
            cell.colorLbl.text = vehicleDetailArr![indexPath.row].vehicleColor
            cell.licensePlateLbl.text = vehicleDetailArr![indexPath.row].vehicleLicensePlate
            cell.deleteBtn.actionBlock {
                let btns = [ButtonText.yes.text, ButtonText.no.text]
                UIAlertController.showAlert(AppAlerts.remove.title, message: AppAlerts.vehicleRemove.title, buttons: btns) { alert, index in
                    if index == 0 {
                        self.myLicensesViewModelArr?.deleteVehiclesApi(UIApplication.visibleViewController.view, vehicleDetailArr![indexPath.row].vehicleDetailID!, completion: { responseModel in
                            vehicleDetailArr?.remove(at: indexPath.row)
                        })
                    }
                }
            }
        }
    }
    
    func setInvoiceCell(_ cell: InvoicesTVCell, _ indexPath: IndexPath) {
        if invoiceDetailArr!.count == 0 {
            noInvoiceFoundLbl.isHidden = false
        } else {
            noInvoiceFoundLbl.isHidden = true
            cell.invoiceTypeLbl.text = invoiceDetailArr![indexPath.row].typeName
            cell.amountLbl.text = "$" + invoiceDetailArr![indexPath.row].amount!
            
            if invoiceDetailArr![indexPath.row].invoicePaid == false {
                cell.payView.backgroundColor = Colors.bgGreenColor.value
                cell.payLbl.textColor = .white
                cell.payLbl.text = "Pay Now"
                
                cell.payView.actionBlock {
                    //==============================*************************************
                    // Payment Api hit
                    let data1 = UIApplication.visibleViewController.dataFromLastVC as! [String: Any]
                    let publicKey = data1["publicKey"] as! String
                    
                    print("publicKey>>>", publicKey)
                    
                    /*
                    let requestData = {
                         requestType: "MOA",
                         rluNo:
                           props.data.licenseDetails.productNo +
                           " " +
                           props.data.licenseDetails.propertyName,
                         clientInvoiceId: adInvoiceID,
                         userAccountId: currentUser.userAccountID,
                         email: currentUser.email,
                         licenseFee: amount,
                         fundAccountKey: "acct_1GaRZZLWZ7bSejfX",
                         paidBy: firstName + " " + lastName,
                         cancelUrl:
                           window.location.href.replace(/%20/g, "<space>") + "&PaymentStatus=fail",
                         errorUrl: window.location.href.replace(/%20/g, "<space>") + "&Error=fail",
                         productTypeId: props.data.licenseDetails.productTypeID,
                         returnUrl: returnUrl,
                         productID: props.data.licenseDetails.productID,
                         invoiceTypeID: invoiceTypeID,
                       };
                    */
                    
                    
                    self.myLicensesViewModelArr?.getPaymentTokenApi(UIApplication.visibleViewController.view,
                                                                    requestType: MOA,
                                                                    rluNo: ((licenseArr?.productNo ?? EMPTY_STR) + ""),
                                                                    fundAccountKey: "acct_1GaRZZLWZ7bSejfX",
                                                                    clientInvoiceId: (invoiceDetailArr?[indexPath.row].adInvoiceID ?? 0),
                                                                    userAccountId: LocalStore.shared.userAccountId,
                                                                    email: LocalStore.shared.email,
                                                                    licenseFee: Float((invoiceDetailArr?[indexPath.row].amount!)!)!,
                                                                    paidBy: LocalStore.shared.name,
                                                                    cancelUrl: "https://myoutdooragent.com/#/app/property?id="+(publicKey)+"&PaymentStatus=fail",
                                                                    errorUrl: "https://myoutdooragent.com/#/app/property?id="+(publicKey)+"&Error=fail",
                                                                    productTypeId: (licenseArr?.productTypeID ?? 0),
                                                                    returnUrl: "https://myoutdooragent.com/",
                                                                    productID: (licenseArr?.productID ?? 0),
                                                                    invoiceTypeID: (invoiceDetailArr?[indexPath.row].invoiceTypeID ?? 0),
                                                                    completion: { responseModel in
                        
                        if responseModel.message == AppErrors.paymentError.localizedDescription {
                            HUD.hide()
                            let okBtn = [ButtonText.ok.text]
                            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.paymentError.localizedDescription, buttons: okBtn) { alert, index in
                                if index == 0 {
                                   // self.removeView(self.paymentPdfPopUpView)
                                }
                            }
                        } else {
                            let data1 = UIApplication.visibleViewController.dataFromLastVC as! [String: Any]
                            let publicKey = data1["publicKey"] as! String
                            
                            var data = [String: Any]()
                            data["token"] = responseModel.model?.response?.paymentToken
                            data["publicKey"] = publicKey
                            UIApplication.visibleViewController.pushWithData(Storyboards.paymentView.name, Controllers.paymentVC.name, data)
                        }
                    })
                }
            } else {
                cell.payView.backgroundColor = .lightGray
                cell.payLbl.textColor = .black
                cell.payLbl.text = "Paid"
            }
        }
    }
    
    func setConditionsCell(_ cell: PropertyConditionsTVCell, _ indexPath: IndexPath) {
        if conditionsLicenseArr.count == 0 {
            noGuidelinesLbl.isHidden = false
        } else {
            noGuidelinesLbl.isHidden = true
            cell.conditionsLbl.text = conditionsLicenseArr[indexPath.row]
        }
    }
    
    func setMapsCell(_ cell: PropertyMapsTVCell, _ indexPath: IndexPath) {
        if mapsArr.count == 0 {
            noMapsLbl.isHidden = false
        } else {
            noMapsLbl.isHidden = true
            cell.mapNameLbl.text = mapsArr[indexPath.row]
            cell.mapView.actionBlock {
                // -- Open Pdf
                cell.setCellProps(mapsArr, indexPath: indexPath.row)
            }
        }
    }
    
    func setActivitiesCell(_ cell: PropertyAmenitiesTVCell, _ indexPath: IndexPath) {
        if activitiesLicenseArr == nil {
            noActivitiesLbl.isHidden = false
        } else {
            noActivitiesLbl.isHidden = true
            cell.amenityName.text = activitiesLicenseArr![indexPath.row].amenityName
            cell.amenityDescLbl.text = activitiesLicenseArr![indexPath.row].description
            
            // -- Set Image
            if activitiesLicenseArr![indexPath.row].amenityIcon == nil {
                cell.amenitiesImgV.image = Images.logo.name
            } else {
                var str = (Apis.licenseAmenitiesUrl) + activitiesLicenseArr![indexPath.row].amenityIcon!
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
    
    func setAmenitiesCell(_ cell: PropertyAmenitiesTVCell, _ indexPath: IndexPath) {
        if amenitiesLicenseArr == nil {
            noAmenitiesLbl.isHidden = false
        } else {
            noAmenitiesLbl.isHidden = true
            cell.amenityName.text = amenitiesLicenseArr![indexPath.row].amenityName
            cell.amenityDescLbl.text = amenitiesLicenseArr![indexPath.row].description
            
            // -- Set Image
            if amenitiesLicenseArr![indexPath.row].amenityIcon == nil {
                cell.amenitiesImgV.image = Images.logo.name
            } else {
                var str = (Apis.licenseAmenitiesUrl) + amenitiesLicenseArr![indexPath.row].amenityIcon!
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
}

// MARK: - PropertyMapsTVCellDelegate
extension LicenseDetailTVCell : PropertyMapsTVCellDelegate {
    func returnPdfViewCompletion(_ agreementName: String) {
        self.delegate?.returnMapViewCompletionForLicenseCell(agreementName)
    }
}

// MARK: - MyLicensesViewModelDelegate
extension LicenseDetailTVCell: MyLicensesViewModelDelegate {
    func multiPolygon2SuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygon2ErrorCalled() {
        
    }
    
    func multiPolygonSuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygonErrorCalled() {
        
    }
    
    func rluDetailSuccessCalled() {
        HUD.hide()
    }
    
    func rluDetailErrorCalled() {
        
    }
    
    func polyLayerSuccessCalled() {
        HUD.hide()
    }
    
    func polyLayerErrorCalled() {
    
    }
    
    func pointLayerSuccessCalled() {
        HUD.hide()
    }
    
    func pointLayerErrorCalled() {
        
    }
    
    func deleteVehiclesSuccessCalled() {
        HUD.hide()
        DispatchQueue.main.async {
            self.vehiclesTV.reloadData()
            self.reloadDelegate?.reloadTableViewData()
            HUD.flash(.label(AppAlerts.vehicleRemoveSuccess.title), delay: 1.0)
            vehicleDetailArr?.count == 0
            ? (self.noVehiclesLbl.isHidden = false)
            : (self.noVehiclesLbl.isHidden = true)
        }
    }
    func deleteVehiclesErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
    func removeMembersSuccessCalled() {
        HUD.hide()
        DispatchQueue.main.async {
            self.membersTV.reloadData()
            self.reloadDelegate?.reloadTableViewData()
            HUD.flash(.label(AppAlerts.memberRemoveSuccess.title), delay: 1.0)
            memberDetailArr?.count == 0
            ? (self.noMembersLbl.isHidden = false)
            : (self.noMembersLbl.isHidden = true)
        }
    }
    func removeMembersErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}
extension LicenseDetailTVCell {
    func setClusterMap() {
        // Set up the cluster manager with default icon generator and renderer.
        clusterArr.removeAll()
        print("isLicensedArr.count",isLicensedArr.count)
        for i in 0..<self.isLicensedArr.count {
            if self.isLicensedArr[i] == 0 {
                clusterArr.append(self.isLicensedArr[i])
            }
        }
        print("clusterArr.count",clusterArr.count)
        let clusterCount = NSNumber(value: clusterArr.count)
        let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [clusterCount], backgroundColors: [UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.animatesClusters = false
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        clusterManager.setDelegate(self, mapDelegate: self)
        
        // Generate and add random items to the cluster manager.
        self.generateClusterItems(3) {
            HUD.hide()
            self.specificLabelMarker.map = nil
        }
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        self.clusterManager.cluster()
        
       // self.mapDetailPopUpV.zoomLbl.text = "Zoom In"
        //self.zoom = true
    }
   
   func generateClusterItems(_ zoom: Float, completion: @escaping() -> ()) {
       //clusterManager.clearItems()
       
       for i in 0..<coordinatePointArr.count {
           let lat = coordinatePointArr[i][1]
           let lng = coordinatePointArr[i][0]
           
           if (((lat < -90 || lat > 90)) && ((lng < -180 || lng > 180))) {
               print("===================================Invalid lat long================================")
           } else {
               let camera = GMSCameraPosition.camera(withLatitude: coordinatePointArr[0][1], longitude: coordinatePointArr[0][0], zoom: zoom)
               self.mapView?.camera = camera
               
               if isLicensedArr[i] == 1 {
                   let notAvailablePosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                   let notAvailableMarker = GMSMarker(position: notAvailablePosition)
                   //notAvailableMarker.position = notAvailablePosition
                   notAvailableMarker.icon = #imageLiteral(resourceName: "grey_marker")
                   clusterManager.add(notAvailableMarker)
               } else {
                   let availablePosition = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                   let availableMarker = GMSMarker(position: availablePosition)
                   //availableMarker.position = availablePosition
                   availableMarker.icon = #imageLiteral(resourceName: "green_marker")
                   clusterManager.add(availableMarker)
               }
           }
       }
       
       completion()
       if LocalStore.shared.productTypeId == 1 {
           setMultipolygonApi(LocalStore.shared.productNo)
       } else {
           setMultipolygonApi2(LocalStore.shared.productNo)
       }
      
   }
    func setMultipolygonApi(_ rluName: String) {
        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
        myLicensesViewModelArr = MyLicensesViewModel(self)
        
        self.myLicensesViewModelArr?.multiPolygonApi(UIApplication.visibleViewController.view, rluName: rluName, completion: { [self] responseModel in
            self.coordinateMultiplygonArr.removeAll()

            // Safely unwrap the first feature
            guard let firstFeature = responseModel.features?.first,
                  let geometry = firstFeature.geometry else {
                HUD.hide()
                return
            }

            // Handle coordinates based on their type
            guard let coordinates = geometry.coordinates else {
                HUD.hide()
                return
            }

            // Access the first polygon's coordinates
            let firstPolygonCoordinates: [[[Double]]]
            switch coordinates {
            case .twoDimensional(let coords):
                firstPolygonCoordinates = coords
            case .fourDimensional(let coords):
                // Handle four-dimensional coordinates by selecting the first polygon
                firstPolygonCoordinates = coords.first ?? []
            }

            // Check if the coordinates array is not empty
            guard !firstPolygonCoordinates.isEmpty, let firstPolygon = firstPolygonCoordinates.first, !firstPolygon.isEmpty else {
                HUD.hide()
                return
            }

            // Create a path for the polygon
            let path = GMSMutablePath()

            // Iterate through the first polygon's coordinates
            for coordinateArray in firstPolygon {
                guard coordinateArray.count == 2 else {
                    continue
                }

                // Extract longitude and latitude
                let longitude = coordinateArray[0] // First element is longitude
                let latitude = coordinateArray[1]  // Second element is latitude
                
                // Create CLLocationCoordinate2D and add to path
                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }

            // Set camera to the first coordinate
            let initialCoordinate = firstPolygon[0]
            let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate[1], longitude: initialCoordinate[0], zoom: 12)
            self.mapView.camera = camera

            // Create a polygon after iterating through coordinates
            let polygon = GMSPolyline(path: path)

            // Set polygon color based on licensing status
            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
            ? .red
                : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)

            polygon.strokeWidth = 2
            polygon.title = rluName
            polygon.map = self.mapView

            // Create label marker for the polygon
            let labelMarker = GMSMarker(position: camera.target)
            let label = UILabel()
            label.text = polygon.title
            label.textColor = .black
            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
            label.sizeToFit()
            labelMarker.iconView = label
            labelMarker.map = self.mapView
            labelMarkers2.append(labelMarker)
            self.mapView.animate(toZoom: 12)
            HUD.hide()
            // Draw polygons if needed
//            self.drawPolygons {
//                self.mapView.animate(toZoom: 14)
//                HUD.hide()
//            }

            // Optional delays to refresh UI
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                HUD.show(.progress, onView: UIApplication.visibleViewController.view)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self.drawPolygons {
//                        DispatchQueue.main.async {
//                            HUD.hide()
//                            self.mapView.animate(toZoom: 14)
//                        }
//                    }
//                }
//            }
        })
        updateLabelVisibility(for: mapView.camera.zoom)
    }


    func setMultipolygonApi2(_ rluName: String) {
        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
        myLicensesViewModelArr = MyLicensesViewModel(self)
        
        self.myLicensesViewModelArr?.multiPolygonApi2(UIApplication.visibleViewController.view, rluName: rluName, completion: { [self] responseModel in
            self.coordinateMultiplygonArr.removeAll()

            // Safely unwrap the first feature
            guard let firstFeature = responseModel.features?.last,
                  let geometry = firstFeature.geometry else {
                HUD.hide()
                return
            }

            // Extract coordinates based on the type
            guard let coordinates = geometry.coordinates else {
                HUD.hide()
                return
            }

            var firstPolygonCoordinates: [[[Double]]]?

            switch coordinates {
            case .twoDimensional(let coords):
                firstPolygonCoordinates = coords
            case .fourDimensional(let coords):
                firstPolygonCoordinates = coords.first // Get the first polygon's coordinates
            }

            // Ensure we have valid polygon coordinates
            guard let polygonCoordinates = firstPolygonCoordinates?.first else {
                HUD.hide()
                return
            }

            // Set camera to the first coordinate (assuming it has at least one coordinate)
            guard let initialCoordinate = polygonCoordinates.last, initialCoordinate.count == 2 else {
                HUD.hide()
                return
            }

            let camera = GMSCameraPosition.camera(withLatitude: initialCoordinate[1], longitude: initialCoordinate[0], zoom: 12)
            self.mapView.camera = camera

            // Create a path for the polygon
            let path = GMSMutablePath()

            // Iterate through the polygon's coordinates
            for coordinate in polygonCoordinates {
                // Ensure each coordinate is an array of doubles with exactly two elements
                guard coordinate.count == 2 else { continue }

                let longitude = coordinate[0] // First element is longitude
                let latitude = coordinate[1]  // Second element is latitude

                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }

            // Create a polygon after iterating through coordinates
            let polygon = GMSPolyline(path: path)

            // Set polygon color based on licensing status
            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
                ? UIColor(red: 0/255, green: 118/255, blue: 22/255, alpha: 1.0)
                : UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)

            polygon.strokeWidth = 2
            polygon.title = rluName
            polygon.map = self.mapView

            // Create label marker for the polygon
            let labelMarker = GMSMarker(position: camera.target)
            let label = UILabel()
            label.text = polygon.title
            label.textColor = .black
            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
            label.sizeToFit()
            labelMarker.iconView = label
            labelMarker.map = self.mapView
            labelMarkers2.append(labelMarker)
            self.mapView.animate(toZoom: 12)
            HUD.hide()

            // Assuming drawPolygons is still relevant
//            self.drawPolygons {
//                self.mapView.animate(toZoom: 11)
//                HUD.hide()
//            }

            // Additional delays to refresh UI (optional)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                HUD.show(.progress, onView: UIApplication.visibleViewController.view)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self.drawPolygons {
//                        DispatchQueue.main.async {
//                            HUD.hide()
//                            self.mapView.animate(toZoom: 11)
//                        }
//                    }
//                }
//            }
        })
        
        updateLabelVisibility(for: mapView.camera.zoom)
    }



//    func setSpecificPolygonApi(_ rluName: String) {
//        
//        HUD.show(.progress, onView: UIApplication.visibleViewController.view)
//        myLicensesViewModelArr = MyLicensesViewModel(self)
//        myLicensesViewModelArr?.multiPolygonApi(UIApplication.visibleViewController.view, rluName: rluName, completion: { responseModel in
//            self.coordinateMultiplygonArr.removeAll()
//
//            // Safely unwrap the first feature and its coordinates
//            guard let firstFeature = responseModel.features?.first,
//                  let firstPolygonCoordinates = firstFeature.geometry?.coordinates?.first else {
//                HUD.hide()
//                return
//            }
//
//            // Set the camera to the first coordinate of the first polygon
//            guard let firstCoordinate = firstPolygonCoordinates.first as? [Double],
//                  firstCoordinate.count == 2 else {
//                HUD.hide()
//                return
//            }
//
//            // Unpack latitude and longitude
//            let longitude = firstCoordinate[0]
//            let latitude = firstCoordinate[1]
//
//            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
//            self.mapView.camera = camera
//
//            let path = GMSMutablePath()
//
//            // Iterate through the coordinates of the first polygon to create the polygon path
//            for coordinate in firstPolygonCoordinates {
//                guard let coordArray = coordinate as? [Double], coordArray.count == 2 else { continue }
//
//                let lon = coordArray[0] // First element is longitude
//                let lat = coordArray[1]  // Second element is latitude
//
//                path.add(CLLocationCoordinate2D(latitude: lat, longitude: lon))
//            }
//
//            let polygon = GMSPolyline(path: path)
//
//            // Set polygon color based on licensing status
//            polygon.strokeColor = (firstFeature.properties?.isLicensed == 1)
//                ? UIColor(red: 0/255, green: 118/255, blue: 22/255, alpha: 1.0)
//                : UIColor(red: 33/255, green: 174/255, blue: 108/255, alpha: 1.0)
//
//            polygon.strokeWidth = 2
//            polygon.title = rluName
//            polygon.map = self.mapView
//
//            // Create a label marker at the camera target
//            let labelMarker = GMSMarker(position: camera.target)
//            let label = UILabel()
//            label.text = polygon.title
//            label.textColor = .black
//            label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
//            label.sizeToFit()
//            labelMarker.iconView = label
//            labelMarker.map = self.mapView
//
//            self.clusterManager.clearItems()
//            HUD.hide()
//        })
//    }


   
    // Point Layer Api
    func setPointLayer() {
        myLicensesViewModelArr = MyLicensesViewModel(self)
        self.myLicensesViewModelArr?.pointLayerApi(UIApplication.visibleViewController.view, completion: { [self] responseModel in
           self.mapModel = responseModel
        //   print("MapModel",mapModel)
           self.coordinatePointArr.removeAll()
           self.isLicensedArr.removeAll()
           responseModel.features?.forEach({ feature in
               
               self.coordinatePointArr.append(feature.geometry?.coordinates! ?? [])
               self.isLicensedArr.append((feature.properties?.isLicensed)!)
           })
           DispatchQueue.main.async { [self] in
            
               self.setPolyLayer(UIApplication.visibleViewController.view)
           }
       })
   }
   // Poly Layer Api
    func setPolyLayer(_ view: UIView) {
       self.myLicensesViewModelArr?.polyLayerApi(view, completion: { responseModel in
           self.polyArr = responseModel
       
           self.coordinatePolyArr.removeAll()
      
           self.isLicensedPolyArr.removeAll()
           self.isLicensedMultiPolyArr.removeAll()
           DispatchQueue.main.async { [self] in
               self.polyArr?.features.forEach({ feature in
                   if feature.geometry.coordinates.count != 0 {
                       for _ in 0..<feature.geometry.coordinates.count {
                           
                           if feature.geometry.type == "MultiPolygon" {
                          
                           } else {
                         
                           }
                       }
                   }
            
                 
               })
               self.setMapView()
           }
       })
   }
   
   // MARK: - MapView
   func setMapView() {
       HUD.show(.progress, onView:UIApplication.visibleViewController.view)
       self.mapView?.delegate = self
       self.mapView?.settings.compassButton = true
       self.mapView?.settings.allowScrollGesturesDuringRotateOrZoom = true
       self.mapView?.settings.rotateGestures = true
       self.mapView?.settings.scrollGestures = true
       self.mapView?.settings.zoomGestures = true
       self.mapView?.setMinZoom(3, maxZoom: 16)
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                 self.setClusterMap()
             }
   }
    
}
// MARK: - GMUMapViewDelegate and GMUClusterManagerDelegate
extension LicenseDetailTVCell: GMUClusterManagerDelegate {
 

 
   func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
       print("sdgfhdfdhfggfdj@@@@@####!!!!!")
       
       if mapView.camera.zoom >= 10 {
           drawPolygons { [self] in
               clusterManager.clearItems()
           }
           // Reset the flag when zoom level is 10 or greater
           hasCalledGenerateClusterItems = false
       } else {
           polygons.forEach { $0.map = nil }
           
           // Call generateClusterItems only if it hasn't been called yet
           if !hasCalledGenerateClusterItems {
               generateClusterItems(mapView.camera.zoom) { [self] in
                   // After calling, set the flag to true
                   hasCalledGenerateClusterItems = true
               }
           }
       }
       updateLabelVisibility(for: mapView.camera.zoom)

   }
    func updateLabelVisibility(for zoomLevel: Float) {
        guard zoomLevel != lastZoomLevel else { return }
        lastZoomLevel = zoomLevel
        
        let shouldShowLabels = zoomLevel >= 12
        let shouldShowLabels2 = zoomLevel >= 13
        labelMarkers2.forEach{ labelMaker in
            labelMaker.iconView?.isHidden = !shouldShowLabels2
        }
        labelMarkers.forEach { labelMarker in
            labelMarker.iconView?.isHidden = !shouldShowLabels
        }
    }

   // Update visibility on camera position change
   func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       updateLabelVisibility(for: position.zoom)
   }
   
   
   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       mapView.animate(toLocation: marker.position)
       print("zoom====>>>>>>", mapView.camera.zoom)
       if let _ = marker.userData as? GMUCluster {
           if mapView.camera.zoom >= 8.0 {
           } else {
               mapView.animate(toZoom: mapView.camera.zoom + 1)
           }
           NSLog("Did tap cluster")
           return true
       }
     //  print(marker.iconView)
       if let label = marker.iconView as? UILabel {
           let text = label.text ?? "No text available"
           print("Marker icon text: \(text)")
           
           // Retrieve the stroke color of the polygon associated with this label
           if let strokeColor = polygonData[text] {
               // Determine the binary representation
               let colorValue: Int
               if strokeColor == .red {
                   colorValue = 1
               } else if strokeColor == UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1) { // Your specific green
                   colorValue = 0
               } else {
                   print("Unknown color")
                   colorValue = -1 // Use -1 for any unexpected color
               }
               
               print("Polygon stroke color binary value: \(colorValue)")
               isLicensed = colorValue
               // You can now use colorValue as needed
           } else {
               print("No polygon found for this label.")
           }

           productNo = text
       } else {
           print("Marker iconView is not a UILabel")
       }
       
       for i in 0..<coordinatePointArr.count where coordinatePointArr[i][0] == marker.position.longitude && coordinatePointArr[i][1] == marker.position.latitude {
           var tempArr = [Double]()
           tempArr.append(marker.position.longitude)
           tempArr.append(marker.position.latitude)
           
           if self.coordinatePointArr.contains(tempArr) {
               let index = self.coordinatePointArr.firstIndex(of: tempArr)
               productNo = (self.mapModel?.features?[index!].properties?.rluNo)!
               print("productNo:::",productNo)
               isLicensed = (self.mapModel?.features?[index!].properties?.isLicensed)!
               self.latitude = marker.position.latitude
               self.longitude = marker.position.longitude
           }
       }
       NSLog("Did tap marker")
       return false
   }
   func drawPolygons(_ completion: @escaping () -> ()) {
       // Remove the old polygons and labels
       polygons.forEach { $0.map = nil }
       polygons.removeAll()
       labelMarkers.forEach { $0.map = nil }
       labelMarkers.removeAll()

       guard let polyArr = self.polyArr else {
           completion()
           return
       }
       
       let visibleRegion = self.mapView.projection.visibleRegion()
       let visibleBounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)

       polyArr.features.forEach { feature in
           let coordinates = feature.geometry.type == "MultiPolygon"
               ? feature.geometry.coordinates.flatMap { $0[0] }
               : feature.geometry.coordinates[0]

           var polygonPoints: [CLLocationCoordinate2D] = []
           let path = GMSMutablePath()

           coordinates.forEach { internalCoordinate in
               do {
                   let encoded = try JSONEncoder().encode(internalCoordinate)
                   let decoded = try JSONDecoder().decode([Double].self, from: encoded)
                   let point = CLLocationCoordinate2D(latitude: decoded[1], longitude: decoded[0])
                   path.add(point)
                   polygonPoints.append(point)
               } catch {
                   print(error.localizedDescription)
               }
           }

           if polygonPoints.contains(where: { visibleBounds.contains($0) }) {
               let polygon = GMSPolyline(path: path)
               polygon.strokeColor = feature.properties.isLicensed == 1 ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
               let strokeColor = feature.properties.isLicensed == 1 ? .red : UIColor(red: 0/255, green: 119/255, blue: 22/255, alpha: 1)
               polygon.strokeWidth = 2
               polygon.title = feature.properties.rluNo
               polygon.map = self.mapView
               polygons.append(polygon)
               polygonData[polygon.title ?? ""] = strokeColor
               // Calculate the centroid of the polygon
               let centroid = calculateCentroid(of: polygonPoints)

               // Create label marker at the centroid
               let labelMarker = GMSMarker(position: centroid)
               let label = UILabel()
               label.text = polygon.title
               label.textColor = .black
               label.backgroundColor = UIColor(red: 252/255, green: 247/255, blue: 224/255, alpha: 1.0)
               label.sizeToFit()
               labelMarker.iconView = label
               labelMarker.map = mapView
               labelMarkers.append(labelMarker)
               
               // Set initial visibility based on current zoom
               label.isHidden = self.mapView.camera.zoom < 12
           }
       }

       updateLabelVisibility(for: mapView.camera.zoom)
       completion()
   }

   // Function to calculate the centroid of a set of coordinates
   private func calculateCentroid(of points: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
       var totalLatitude: Double = 0
       var totalLongitude: Double = 0

       for point in points {
           totalLatitude += point.latitude
           totalLongitude += point.longitude
       }

       let count = Double(points.count)
       return CLLocationCoordinate2D(latitude: totalLatitude / count, longitude: totalLongitude / count)
   }

   
}
extension LicenseDetailTVCell: GMSMapViewDelegate {
   
   func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
       let marker = GMSMarker(position: centerMapCoordinate)
       marker.map = self.mapView
   }
   
   /* handles Info Window tap */
   func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       print("didTapInfoWindowOf")
   }
   
   /* handles Info Window long press */
   func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
       print("didLongPressInfoWindowOf")
   }
   
   /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        myLicensesViewModelArr = MyLicensesViewModel(self)
        myLicensesViewModelArr?.rluDetailApi(UIApplication.visibleViewController.view, productNo: productNo, completion: { responseModel in
            if isLicensed == 1 {
                let btn = [ButtonText.ok.text]
                UIAlertController.showAlert("", message: "\(productNo) is currently not available", buttons: btn) { alert, index in
                    if index == 0 {
                    }
                }
                //               } else {
                //                   // Map Detail Pop Up View
                //                   self.viewTransition(self.mapDetailPopUpView)
                //
                //                   self.mapDetailPopUpView.displayNameLbl.text = responseModel.productNo
                //                   self.mapDetailPopUpView.countyLbl.text = responseModel.countyName! + " County, " + responseModel.stateName!
                //                   self.mapDetailPopUpView.acresLbl.text = responseModel.acres?.description
                //                   self.mapDetailPopUpView.priceLbl.text = "$" + "" + responseModel.licenseFee!.description
                //
                //                   // -- Set Image
                //                   if responseModel.imageFilename == nil {
                //                       self.mapDetailPopUpView.rluImageV.image = Images.logoImg.name
                //                   } else {
                //                       var str = (Apis.rluImageUrl) + responseModel.imageFilename!
                //                       if let dotRange = str.range(of: "?") {
                //                           str.removeSubrange(dotRange.lowerBound..<str.endIndex)
                //
                //                           str.contains(" ")
                //                           ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
                //                           : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
                //                       } else {
                //                           str.contains(" ")
                //                           ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
                //                           : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
                //                       }
                //                   }
                //
                //                   self.mapDetailPopUpView.rluImageV.actionBlock {
                //                       var data = [String: Any]()
                //                       data["publicKey"] = responseModel.publicKey
                //                       data["id"] = responseModel.productID
                //                       isComingFrom = "map"
                //                       LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
                //                       UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                //                   }
                //
                //                   // Cross Button
                //                   self.mapDetailPopUpView.crossBtn.actionBlock {
                //                       self.removeView(self.mapDetailPopUpView)
                //                   }
                //
                //                   // View Details
                //                   self.mapDetailPopUpView.viewDetailsBtn.actionBlock {
                //                       var data = [String: Any]()
                //                       data["publicKey"] = responseModel.publicKey
                //                       data["id"] = responseModel.productID
                //                       isComingFrom = "map"
                //                       LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
                //                       UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
                //                   }
                //
                //                   // Zoom In
                //                   self.mapDetailPopUpView.zoomInBtn.actionBlock {
                //                       if zoom == true {
                //                           //  self.mapView.animate(toZoom: self.mapView.camera.zoom + 2)
                //                           zoom = false
                //                           self.mapDetailPopUpView.zoomLbl.text = "Zoom Out"
                //                           self.removeView(self.mapDetailPopUpView)
                //                           self.propertyCell.setSpecificPolygonApi(responseModel.productNo!)
                //                       } else {
                //                           self.propertyCell.mapView.animate(toZoom: self.propertyCell.mapView.camera.zoom - 2)
                //                           zoom = true
                //                           self.mapDetailPopUpView.zoomLbl.text = "Zoom In"
                //                           self.removeView(self.mapDetailPopUpView)
                //                       }
                //                   }
                //
                //                   // Directions
                //                   self.mapDetailPopUpView.directionsBtn.actionBlock {
                //                       //if checkLocationPermissions() {
                //                       //        print(locationDict.value(forKey: "Location")!)
                //                       //       print(index)
                //
                //                       //       let locationCoordinates = (locationDict.value(forKey: "Location")! as AnyObject).components(separatedBy: ",")
                //
                //                       // Create An UIAlertController with Action Sheet
                //                       let optionMenuController = UIAlertController(title: nil, message: "Choose Option for maps", preferredStyle: .actionSheet)
                //
                //                       // Create UIAlertAction for UIAlertController
                //                       let googleMaps = UIAlertAction(title: "Google Maps", style: .default, handler: {
                //                           (alert: UIAlertAction!) -> Void in
                //                           self.openGoogleDirectionMap(destinationLat: String(latitude), destinationLng: String(longitude))
                //                       })
                //
                //                       let appleMaps = UIAlertAction(title: "Apple Maps", style: .default, handler: {
                //                           (alert: UIAlertAction!) -> Void in
                //
                //                           print("self.latitude>>>", latitude)
                //                           print("self.longitude>>>", longitude)
                //
                //                           //                        let directionsURL = "http://maps.apple.com/maps?saddr=&daddr=\(self.latitude)\(self.longitude)"
                //                           let directionsURL = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
                //                           guard let url = URL(string: directionsURL) else {
                //                               return
                //                           }
                //                           if #available(iOS 10.0, *) {
                //                               UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //                           } else {
                //                               UIApplication.shared.openURL(url)
                //                           }
                //
                //
                //
                //                           // Pass the coordinate that you want here
                //                           //                        let coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude)
                //                           //                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
                //                           //                        mapItem.name = "Destination"
                //                           //                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                //
                //                           /*
                //
                //                            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)))
                //                            source.name = self.productNo
                //
                //                            //let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitudeString] as NSString).doubleValue), longitude: Double(([LatitudeString] as NSString).doubleValue))
                //
                //                            let locc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
                //
                //                            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locc.latitude, longitude: locc.longitude)))
                //
                //                            destination.name = responseModel.countyName! + " County, " + responseModel.stateName!
                //
                //                            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                //
                //                            */
                //                       })
                //
                //                       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                //                           (alert: UIAlertAction!) -> Void in
                //                           print("Cancel")
                //                       })
                //
                //                       // Add UIAlertAction in UIAlertController
                //                       optionMenuController.addAction(googleMaps)
                //                       optionMenuController.addAction(appleMaps)
                //                       optionMenuController.addAction(cancelAction)
                //
                //                       // Present UIAlertController with Action Sheet
                //                       self.present(optionMenuController, animated: true, completion: nil)
                //                       //   }
                //
                //                       //}
                //                   }
                //               }
            }
        })
        return UIView() 
    }
//       self.mapViewDelegate?.setMapDetailView()
//       return UIView()
   
   
   // MARK: - GMSMarker Dragging
   func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
       print("didBeginDragging")
   }
   func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
       print("didDrag")
   }
   func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
       print("didEndDragging")
   }
   
   // MARK: - GMSMarker position
   func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       marker.position = coordinate
   }
   
   //MARK: - Animate PopUp
//    func viewTransition(_ addView: UIView) {
//        UIView.transition(with: UIApplication.visibleViewController.view, duration: 0.7, options: .transitionCrossDissolve, animations: {
//            UIApplication.visibleViewController.view.addSubview(addView)
//            self.viewConstraints(addView)
//        })
//    }
//
//    // -- Remove View From SuperView
//    func removeView(_ viewToRemove: UIView) {
//        DispatchQueue.main.async {
//            UIView.transition(with: UIApplication.visibleViewController.view, duration: 0.7, options: .transitionCrossDissolve, animations: {
//                viewToRemove.removeFromSuperview()
//            })
//        }
//    }
//
//    // -- Set PopUp View Constraints
//    func viewConstraints(_ View: UIView) {
//        View.translatesAutoresizingMaskIntoConstraints = false
//        View.leftAnchor.constraint(equalTo: UIApplication.visibleViewController.view.leftAnchor, constant: 0).isActive = true
//        View.rightAnchor.constraint(equalTo: UIApplication.visibleViewController.view.rightAnchor, constant: 0).isActive = true
//        View.widthAnchor.constraint(equalTo: UIApplication.visibleViewController.view.widthAnchor, constant: 0).isActive = true
//        View.bottomAnchor.constraint(equalTo: UIApplication.visibleViewController.view.bottomAnchor, constant: 0).isActive = true
//        View.heightAnchor.constraint(equalTo: UIApplication.visibleViewController.view.heightAnchor, multiplier: 1.0, constant: 0).isActive = true
//    }
}

// MARK: - SearchViewModelDelegate
extension LicensePropertyDetailVC {
   func pointLayerSuccessCalled() {
       //HUD.hide()
   }
   func pointLayerErrorCalled() {
       HUD.flash(.labeledError(title: "", subtitle: "error"), delay: 1.0)
   }
   func polyLayerSuccessCalled() {
       // HUD.hide()
   }
   func polyLayerErrorCalled() {
       HUD.flash(.labeledError(title: "", subtitle: "error"), delay: 1.0)
   }
   func multiPolygonSuccessCalled() {
       // HUD.hide
   }
   func multiPolygonErrorCalled() {
       HUD.hide()
       let btn = [ButtonText.ok.text]
       UIAlertController.showAlert(AppAlerts.propertyNotListed.title, message: AppErrors.propertyNotListed.localizedDescription, buttons: btn) { alert, index in
           if index == 0 {
           }
       }
   }
   func rluDetailSuccessCalled() {
       HUD.hide()
   }
   func rluDetailErrorCalled() {
       HUD.hide()
       let btn = [ButtonText.ok.text]
       UIAlertController.showAlert(AppAlerts.propertyNotListed.title, message: AppErrors.propertyNotListed.localizedDescription, buttons: btn, completion: nil)
   }
}

extension LicensePropertyDetailVC : SetMapDetailViewDelegate {
    
    
    func setMapDetailView() {
        //           myLicensesViewModelArr?.rluDetailApi(UIApplication.visibleViewController.view, productNo: productNo, completion: { responseModel in
        //               if isLicensed == 1 {
        //                   let btn = [ButtonText.ok.text]
        //                   UIAlertController.showAlert("", message: "\(productNo) is currently not available", buttons: btn) { alert, index in
        //                       if index == 0 {
        //                       }
        //                   }
        ////               } else {
        ////                   // Map Detail Pop Up View
        ////                   self.viewTransition(self.mapDetailPopUpView)
        ////
        ////                   self.mapDetailPopUpView.displayNameLbl.text = responseModel.productNo
        ////                   self.mapDetailPopUpView.countyLbl.text = responseModel.countyName! + " County, " + responseModel.stateName!
        ////                   self.mapDetailPopUpView.acresLbl.text = responseModel.acres?.description
        ////                   self.mapDetailPopUpView.priceLbl.text = "$" + "" + responseModel.licenseFee!.description
        ////
        ////                   // -- Set Image
        ////                   if responseModel.imageFilename == nil {
        ////                       self.mapDetailPopUpView.rluImageV.image = Images.logoImg.name
        ////                   } else {
        ////                       var str = (Apis.rluImageUrl) + responseModel.imageFilename!
        ////                       if let dotRange = str.range(of: "?") {
        ////                           str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        ////
        ////                           str.contains(" ")
        ////                           ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
        ////                           : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
        ////                       } else {
        ////                           str.contains(" ")
        ////                           ? self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str.replacingOccurrences(of: " ", with: "%20"))
        ////                           : self.mapDetailPopUpView.rluImageV.setNetworkImage(self.mapDetailPopUpView.rluImageV, str)
        ////                       }
        ////                   }
        ////
        ////                   self.mapDetailPopUpView.rluImageV.actionBlock {
        ////                       var data = [String: Any]()
        ////                       data["publicKey"] = responseModel.publicKey
        ////                       data["id"] = responseModel.productID
        ////                       isComingFrom = "map"
        ////                       LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
        ////                       UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
        ////                   }
        ////
        ////                   // Cross Button
        ////                   self.mapDetailPopUpView.crossBtn.actionBlock {
        ////                       self.removeView(self.mapDetailPopUpView)
        ////                   }
        ////
        ////                   // View Details
        ////                   self.mapDetailPopUpView.viewDetailsBtn.actionBlock {
        ////                       var data = [String: Any]()
        ////                       data["publicKey"] = responseModel.publicKey
        ////                       data["id"] = responseModel.productID
        ////                       isComingFrom = "map"
        ////                       LocalStore.shared.selectedPropertyIndex = self.tabBarController!.selectedIndex
        ////                       UIApplication.visibleViewController.pushWithData(Storyboards.propertyView.name, Controllers.property.name, data)
        ////                   }
        ////
        ////                   // Zoom In
        ////                   self.mapDetailPopUpView.zoomInBtn.actionBlock {
        ////                       if zoom == true {
        ////                           //  self.mapView.animate(toZoom: self.mapView.camera.zoom + 2)
        ////                           zoom = false
        ////                           self.mapDetailPopUpView.zoomLbl.text = "Zoom Out"
        ////                           self.removeView(self.mapDetailPopUpView)
        ////                           self.propertyCell.setSpecificPolygonApi(responseModel.productNo!)
        ////                       } else {
        ////                           self.propertyCell.mapView.animate(toZoom: self.propertyCell.mapView.camera.zoom - 2)
        ////                           zoom = true
        ////                           self.mapDetailPopUpView.zoomLbl.text = "Zoom In"
        ////                           self.removeView(self.mapDetailPopUpView)
        ////                       }
        ////                   }
        ////
        ////                   // Directions
        ////                   self.mapDetailPopUpView.directionsBtn.actionBlock {
        ////                       //if checkLocationPermissions() {
        ////                       //        print(locationDict.value(forKey: "Location")!)
        ////                       //       print(index)
        ////
        ////                       //       let locationCoordinates = (locationDict.value(forKey: "Location")! as AnyObject).components(separatedBy: ",")
        ////
        ////                       // Create An UIAlertController with Action Sheet
        ////                       let optionMenuController = UIAlertController(title: nil, message: "Choose Option for maps", preferredStyle: .actionSheet)
        ////
        ////                       // Create UIAlertAction for UIAlertController
        ////                       let googleMaps = UIAlertAction(title: "Google Maps", style: .default, handler: {
        ////                           (alert: UIAlertAction!) -> Void in
        ////                           self.openGoogleDirectionMap(destinationLat: String(latitude), destinationLng: String(longitude))
        ////                       })
        ////
        ////                       let appleMaps = UIAlertAction(title: "Apple Maps", style: .default, handler: {
        ////                           (alert: UIAlertAction!) -> Void in
        ////
        ////                           print("self.latitude>>>", latitude)
        ////                           print("self.longitude>>>", longitude)
        ////
        ////                           //                        let directionsURL = "http://maps.apple.com/maps?saddr=&daddr=\(self.latitude)\(self.longitude)"
        ////                           let directionsURL = "https://maps.apple.com/?daddr=\(latitude),\(longitude)"
        ////                           guard let url = URL(string: directionsURL) else {
        ////                               return
        ////                           }
        ////                           if #available(iOS 10.0, *) {
        ////                               UIApplication.shared.open(url, options: [:], completionHandler: nil)
        ////                           } else {
        ////                               UIApplication.shared.openURL(url)
        ////                           }
        ////
        ////
        ////
        ////                           // Pass the coordinate that you want here
        ////                           //                        let coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude)
        ////                           //                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        ////                           //                        mapItem.name = "Destination"
        ////                           //                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        ////
        ////                           /*
        ////
        ////                            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)))
        ////                            source.name = self.productNo
        ////
        ////                            //let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(([longitudeString] as NSString).doubleValue), longitude: Double(([LatitudeString] as NSString).doubleValue))
        ////
        ////                            let locc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
        ////
        ////                            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locc.latitude, longitude: locc.longitude)))
        ////
        ////                            destination.name = responseModel.countyName! + " County, " + responseModel.stateName!
        ////
        ////                            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        ////
        ////                            */
        ////                       })
        ////
        ////                       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
        ////                           (alert: UIAlertAction!) -> Void in
        ////                           print("Cancel")
        ////                       })
        ////
        ////                       // Add UIAlertAction in UIAlertController
        ////                       optionMenuController.addAction(googleMaps)
        ////                       optionMenuController.addAction(appleMaps)
        ////                       optionMenuController.addAction(cancelAction)
        ////
        ////                       // Present UIAlertController with Action Sheet
        ////                       self.present(optionMenuController, animated: true, completion: nil)
        ////                       //   }
        ////
        ////                       //}
        ////                   }
        ////               }
        //           }
        //       })
        //                                            }
    }
}
