//  LicensePropertyDetailVC.swift
//  MyOutdoorAgent
//  Created by CS on 06/10/22.

import UIKit
import PKHUD
import WebKit
import GoogleMapsUtils

var amenitiesLicenseArr : [AmenityDetail]?
var activitiesLicenseArr : [AmenityDetail]?
var clubMemberDetailLicenseArr : [ClubMemberDetail]?
var vehicleDetailArr : [VehicleDetail]?
var memberDetailArr : [LicenseMember]?
var invoiceDetailArr : [AdditionalInvoice]?
var licenseArr : LicenseDetail?
var conditionsLicenseArr = [String]()
var amenitiesLicenseIndexArr = [Int]()
var activityLicenseIndexArr = [Int]()
var mapFiles : [MapFileDetail]?
var mapsArr = [String]()
var isAllowMember = Bool()
var documentData: [ClientDocuments]?


protocol SetMapDetailViewDelegate: AnyObject {
    func setMapDetailView()
}
class LicensePropertyDetailVC: AbstractView {
    
    // MARK: - Objects
    var myLicensesViewModelArr: MyLicensesViewModel?
    var licenseDetailArr : LicenseDetailModelClass?
    var getAllStatesArr = [GetAllStatesModelClass]()
    var okBtn = [ButtonText.ok.text]
    var licenseCell = LicenseDetailTVCell()
    
    
    // MARK: - Variables
    var webView: WKWebView!
    var cell = LicenseDetailTVCell()
    var statesArr = [String]()
    var memberArr = [String]()
    var isRotated = true
    var publicKey = String()
    
    // MARK: - Outlets
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var licensePropertyTV: UITableView!
    @IBOutlet var licensePdfPopUpView: LicensePDFView!
    @IBOutlet var addVehicleInfoPopV: AddVehicleInfoView!
    @IBOutlet var inviteMemberPopV: InviteMemberPopUpV!
    @IBOutlet var addMemberPopV: AddMemberPopUpV!
    
    // MARK: - ViewLifeCycle
   
        override func viewDidLoad() {
            super.viewDidLoad()
            onViewLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            onViewAppear()
           
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            isRotated = false
        }
    override func viewDidAppear(_ animated: Bool) {
        //licenseCell.setMapView(self.view)
    }
        
        // MARK: - Functions
        private func onViewLoad() {
            showNavigationBar(false)
        }
        
        private func onViewAppear() {
            setDelegates()
            setUI()
            setLicenseDetailApi()
            getAllStatesApi()
            isRotated = true
        }
        
        private func setDelegates() {
            myLicensesViewModelArr = MyLicensesViewModel(self)
            cell.delegate = self
            cell.reloadDelegate = self
            self.inviteMemberPopV.emailTxtF.delegate = self
        }
        
        private func registerCell() {
            licensePropertyTV.register(UINib(nibName: CustomCells.licenseDetailTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.licenseDetailTVCell.name)
            inviteMemberPopV.collectionV.register(UINib(nibName: CustomCells.inviteMemberCVCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.inviteMemberCVCell.name)
            inviteMemberPopV.collectionV.dataSource = self
            inviteMemberPopV.collectionV.delegate = self
        }
        
        private func setUI() {
            setcustomNav(customView: customNavBar, titleIsHidden: false, titleText: NavigationTitle.myLicenses.name, navViewColor: .white, mainViewColor: .white, backImg: Images.back.name)
        }
        
        // MARK: - Web Services
        private func setLicenseDetailApi() {
            let data = dataFromLastVC as! [String: Any]
            publicKey = data["publicKey"] as! String   //lsc_upbj5gpj
            myLicensesViewModelArr?.licenseDetailApi(self.view, publicKey, completion: { [self] responseModel in
                self.licenseDetailArr = responseModel.model
                amenitiesLicenseArr = self.licenseDetailArr?.amenities
                activitiesLicenseArr = self.licenseDetailArr?.amenities
                vehicleDetailArr = self.licenseDetailArr?.vehicleDetails
                memberDetailArr = self.licenseDetailArr?.licenseMembers
                invoiceDetailArr = self.licenseDetailArr?.additionalInvoices
                isAllowMember = (self.licenseDetailArr?.licenseDetails?.allowMemberActions)!
                licenseArr = (self.licenseDetailArr?.licenseDetails)
                documentData = self.licenseDetailArr?.clientDocument
                LocalStore.shared.productNo = licenseDetailArr?.licenseDetails?.productNo ?? ""
                LocalStore.shared.productTypeId = licenseDetailArr?.licenseDetails?.productTypeID ?? 0
               
                conditionsLicenseArr.removeAll()
                if self.licenseDetailArr?.specialConditions?.count != nil {
                    for j in 0..<((self.licenseDetailArr?.specialConditions?.count ?? 0)) {
                        conditionsLicenseArr.append((self.licenseDetailArr?.specialConditions?[j].specCndDesc ?? ""))
                    }
                }
                
                mapsArr.removeAll()
                if self.licenseDetailArr?.mapFiles?.count != nil {
                    for j in 0..<((self.licenseDetailArr?.mapFiles?.count ?? 0)) {
                        mapsArr.append((self.licenseDetailArr?.mapFiles![j].mapFileName ?? ""))
                    }
                }
                
                amenitiesLicenseIndexArr.removeAll()
                for i in 0..<(amenitiesLicenseArr!.count) {
                    if (amenitiesLicenseArr![i].amenityType == CommonKeys.activity.name){
                        amenitiesLicenseIndexArr.append(i)
                    }
                }
                amenitiesLicenseArr!.remove(at: amenitiesLicenseIndexArr)
                
                activityLicenseIndexArr.removeAll()
                for i in 0..<activitiesLicenseArr!.count {
                    if (activitiesLicenseArr![i].amenityType == CommonKeys.amenity.name){
                        activityLicenseIndexArr.append(i)
                    }
                }
                activitiesLicenseArr!.remove(at: activityLicenseIndexArr)
                
                self.registerCell()
                self.licensePropertyTV.dataSource = self
                self.licensePropertyTV.delegate = self
                self.licensePropertyTV.estimatedRowHeight = 44
                self.licensePropertyTV.rowHeight = UITableView.automaticDimension
                self.licensePropertyTV.reloadData()
            })
        }
        
        private func getAllStatesApi() {
            self.myLicensesViewModelArr?.getAllStatesApi(self.view, completion: { responseModel in
                self.getAllStatesArr = responseModel
                
                self.statesArr.removeAll()
                for i in 0..<self.getAllStatesArr.count {
                    self.statesArr.append(self.getAllStatesArr[i].stateName ?? "")
                }
                
            })
        }
    }

    // MARK: - MyLicensesViewModelDelegate
extension LicensePropertyDetailVC: MyLicensesViewModelDelegate {
    func multiPolygon2SuccessCalled() {
        
    }
    
    func multiPolygon2ErrorCalled() {
        
    }
    
        func licenseDetailSuccessCalled() {
            HUD.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.licensePropertyTV.reloadData()
            })
        }
        func licenseDetailErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func addMembersSuccessCalled() {
            DispatchQueue.main.async {
                HUD.hide()
                let okBtn = [ButtonText.ok.text]
                UIAlertController.showAlert(AppAlerts.memberAdded.title, message: AppAlerts.memberSuccess.title, buttons: okBtn) { alert, index in
                    if index == 0 {
                        self.setLicenseDetailApi()
                        self.removeView(self.addMemberPopV)
                        
                        let txtFieldArr = [self.addMemberPopV.firstNameTxtF, self.addMemberPopV.lastNameTxtF, self.addMemberPopV.emailTxtF, self.addMemberPopV.addressTxtF, self.addMemberPopV.phoneNumberTxtF, self.addMemberPopV.zipCodeTxtF, self.addMemberPopV.cityTxtF]
                        txtFieldArr.forEach { textFields in
                            textFields?.text = EMPTY_STR
                            self.addMemberPopV.stateLbl.text = CommonKeys.state.name
                        }
                    }
                }
            }
        }
        func addMembersErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func inviteMembersSuccessCalled() {
            DispatchQueue.main.async {
                HUD.hide()
                let okBtn = [ButtonText.ok.text]
                UIAlertController.showAlert(AppAlerts.memberAdded.title, message: AppAlerts.memberSuccess.title, buttons: okBtn) { alert, index in
                    if index == 0 {
                        self.setLicenseDetailApi()
                        self.inviteMemberPopV.collectionV.reloadData()
                        self.inviteMemberPopV.emailTxtF.text = EMPTY_STR
                        self.removeView(self.inviteMemberPopV)
                    }
                }
            }
        }
        func inviteMembersErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func addVehiclesSuccessCalled(_ success: String) {
            DispatchQueue.main.async {
                HUD.hide()
                let okBtn = [ButtonText.ok.text]
                UIAlertController.showAlert(AppAlerts.vehicleAdded.title, message: success, buttons: okBtn) { alert, index in
                    if index == 0 {
                        self.setLicenseDetailApi()
                        self.removeView(self.addVehicleInfoPopV)
                        
                        let txtFieldArr = [self.addVehicleInfoPopV.vehicleMakeTxtF, self.addVehicleInfoPopV.vehicleModelTxtF, self.addVehicleInfoPopV.vehicleColorTxtF, self.addVehicleInfoPopV.vehicleLicensePlateTxtF]
                        txtFieldArr.forEach { textFields in
                            textFields?.text = EMPTY_STR
                            self.addVehicleInfoPopV.selectStateLbl.text = CommonKeys.selectState.name
                        }
                    }
                }
            }
        }
        func addVehiclesErrorCalled(_ error: String) {
            HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
        }
        func getStatesSuccessCalled() {
            HUD.hide()
        }
        func getStatesErrorCalled(_ error: String) {
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
        func generateClubMembershipSuccessCalled() {
            HUD.hide()
        }
        func generateClubMembershipErrorCalled(_ error: String) {
            HUD.hide()
            let okBtn = [ButtonText.ok.text]
            UIAlertController.showAlert(AppAlerts.alert.title, message: error, buttons: okBtn, completion: nil)
        }
    }

    // MARK: - ReloadTableViewDelegate
    extension LicensePropertyDetailVC: ReloadTableViewDelegate {
        func reloadTableViewData() {
            self.setLicenseDetailApi()
        }
    }

    // MARK: - LicenseDetailTVCellDelegate
    extension LicensePropertyDetailVC: LicenseDetailTVCellDelegate, WKUIDelegate {
        func returnPdfViewCompletionForLicenseCell(_ agreementName: String) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // -- Pass LicenseAgreement to PDF View
                self.viewTransition(self.licensePdfPopUpView)
                self.showActiveWebView(agreementName)
            }
        }
        
        func returnMapViewCompletionForLicenseCell(_ agreementName: String) {
            var data = [String: Any]()
            data["agreementName"] = agreementName
            data["publicKey"] = publicKey
            self.pushWithData(Storyboards.licenseMapView.name, Controllers.licenseMapVC.name, data)
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //            // -- Pass LicenseAgreement to PDF View
    //            self.viewTransition(self.licensePdfPopUpView)
    //            self.showMapWebView(agreementName)
    //        }
        }
        
        func showActiveWebView(_ agreementName: String) {
            self.webView = WKWebView(frame: self.licensePdfPopUpView.pdfV.bounds, configuration: WKWebViewConfiguration())
            self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.webView.uiDelegate = self
            self.webView.navigationDelegate = self
            self.licensePdfPopUpView.pdfV.addSubview(self.webView)
            self.webView.allowsBackForwardNavigationGestures = true
            let myURL = URL(string: agreementName)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
            
            // -- Cross Button
            self.licensePdfPopUpView.crossBtn.actionBlock {
                self.removeView(self.licensePdfPopUpView)
                self.removeView(self.webView)
            }
        }
        
        func showMapWebView(_ agreementName: String) {
            self.webView = WKWebView(frame: self.licensePdfPopUpView.pdfV.bounds, configuration: WKWebViewConfiguration())
            self.webView.autoresizingMask = [.flexibleWidth]
            self.webView.uiDelegate = self
            self.webView.navigationDelegate = self
            self.licensePdfPopUpView.pdfV.addSubview(self.webView)
            self.webView.allowsBackForwardNavigationGestures = true
    //        self.webView.isOpaque = false
    //        self.webView.backgroundColor = UIColor.clear
    //        self.webView.scrollView.backgroundColor = UIColor.clear
            let myURL = URL(string: agreementName)
            let myRequest = URLRequest(url: myURL!)
            self.webView.load(myRequest)
            
            // -- Cross Button
            self.licensePdfPopUpView.crossBtn.actionBlock {
                self.removeView(self.licensePdfPopUpView)
            }
        }
    }

    // MARK: - WKNavigationDelegate
    extension LicensePropertyDetailVC: WKNavigationDelegate {
        internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.licensePdfPopUpView.activityV.startAnimating()
        }
        
        internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.licensePdfPopUpView.activityV.stopAnimating()
            self.licensePdfPopUpView.activityV.hidesWhenStopped = true
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            self.licensePdfPopUpView.activityV.startAnimating()
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            let btns = [ButtonText.ok.text]
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
                if index == 0 {
                    self.removeView(self.licensePdfPopUpView)
                }
            }
        }
    }

    // MARK: - ViewWillTransition
    extension LicensePropertyDetailVC {
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            
            if isRotated == true {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    switch UIDevice.current.orientation {
                    case .landscapeLeft, .landscapeRight:
                        self.licensePdfPopUpView.pdfTopHeight.constant = 20
                        self.licensePdfPopUpView.pdfBottomHeight.constant = 20
                        self.licensePdfPopUpView.crossBtnTop.constant = 10
                    case .portrait, .portraitUpsideDown:
                        self.licensePdfPopUpView.pdfTopHeight.constant = 40
                        self.licensePdfPopUpView.pdfBottomHeight.constant = 40
                        self.licensePdfPopUpView.crossBtnTop.constant = 30
                    default:
                        self.licensePdfPopUpView.pdfTopHeight.constant = 40
                        self.licensePdfPopUpView.pdfBottomHeight.constant = 40
                        self.licensePdfPopUpView.crossBtnTop.constant = 30
                    }
                } else {
                    switch UIDevice.current.orientation {
                    case .landscapeLeft, .landscapeRight:
                        self.licensePdfPopUpView.pdfTopHeight.constant = 40
                        self.licensePdfPopUpView.pdfBottomHeight.constant = 40
                        self.licensePdfPopUpView.crossBtnTop.constant = 25
                    case .portrait, .portraitUpsideDown:
                        self.licensePdfPopUpView.pdfTopHeight.constant = 80
                        self.licensePdfPopUpView.pdfBottomHeight.constant = 80
                        self.licensePdfPopUpView.crossBtnTop.constant = 65
                    default:
                        self.licensePdfPopUpView.pdfTopHeight.constant = 80
                        self.licensePdfPopUpView.pdfBottomHeight.constant = 80
                        self.licensePdfPopUpView.crossBtnTop.constant = 65
                    }
                }
                
                self.setLicenseDetailApi()
            }
        }
    }
 
