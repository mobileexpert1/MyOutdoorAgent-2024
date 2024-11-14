//  MyLicencesVC.swift
//  MyOutdoorAgent
//  Created by CS on 08/08/22.

import UIKit
import PKHUD
import WebKit

class MyLicencesVC: AbstractView {
    
    // MARK: - Objects
    var cell = SearchCollVCell()
    private var myLicensesViewModel: MyLicensesViewModel?
    var allLicense = [ActiveMemeberPendindCombimeModelClass]()
    
    // MARK: - Variables
    var webView: WKWebView!
    
    // MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var customView: CustomNavBar!
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var pendingLbl: UILabel!
    @IBOutlet weak var expiredLbl: UILabel!
    @IBOutlet weak var activeV: UIView!
    @IBOutlet weak var memberV: UIView!
    @IBOutlet weak var pendingV: UIView!
    @IBOutlet weak var expiredV: UIView!
    @IBOutlet weak var noCountLbl: UILabel!
    @IBOutlet var acceptLicensePopUpView: AcceptLicensePDFView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerCell()
        activeMemberPendingApiCall()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
        
    }
    
//    private func onViewAppear() {
//        collectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        self.setView(Colors.bgGreenColor.value, .white, .white, .black, .white, .black, .white, .black)
//        self.myLicensesViewModel?.activeLicensesApi(self.view, self.collectionV) { responseModel in
//            self.cell.setUpActiveCollectionCell(self.collectionV, responseModel, self.activeV.tag)
//        }
//    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customView, titleIsHidden: false, titleText: "My Active License(s)", navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
        myLicensesViewModel = MyLicensesViewModel(self)
        cell.delegate = self
    }
    
    private func registerCell() {
        collectionV.register(UINib(nibName: CustomCells.searchCell.name, bundle: nil), forCellWithReuseIdentifier: CustomCells.searchCell.name)
    }
    func activeMemberPendingApiCall() {
        self.myLicensesViewModel?.activeLicensesApi(self.view, self.collectionV) { [self] responseModel in
            allLicense.append(contentsOf: responseModel)
            noLicenseFound()
            self.cell.setUpActiveCollectionCell(self.collectionV, responseModel, self.activeV.tag)
            self.myLicensesViewModel?.memberLicenseApi(self.view, self.collectionV) { [self] responseModel in
                allLicense.append(contentsOf: responseModel)
                noLicenseFound()
                self.cell.setUpMemberCollectionCell(self.collectionV, responseModel, self.memberV.tag)
                self.myLicensesViewModel?.pendingLicenseApi(self.view, self.collectionV) { [self] responseModel in
                    allLicense.append(contentsOf: responseModel)
                    noLicenseFound()
                    self.cell.setUpPendingCollectionCell(self.collectionV, responseModel, self.pendingV.tag)
                }
            }
        }
       
        
        noLicenseFound()
    }
    func noLicenseFound() {
        if allLicense.count == 0 {
            HUD.hide()
            self.noCountLbl.isHidden = false
           // collectionV.isHidden = true
            self.noCountLbl.text = "No License Available"
            collectionV.reloadData()
        } else {
            self.noCountLbl.isHidden = true
                //collectionV.isHidden = false
            collectionV.reloadData()
        }
        
    }
    // MARK: - Action Block
    private func actionBlock() {
        // -- Active Licenses
        activeV.actionBlock { [self] in
            self.collectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setView(Colors.bgGreenColor.value, .white, .white, .black, .white, .black, .white, .black)
            self.setcustomNav(customView: self.customView, titleIsHidden: false, titleText: "My Active License(s)", navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
            activeMemberPendingApiCall()
            
        }
        
        // -- Member Licenses
        memberV.actionBlock { [self] in
            self.collectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setView(.white, .black, Colors.bgGreenColor.value, .white, .white, .black, .white, .black)
            activeMemberPendingApiCall()
        }
        
        // -- Pending Licenses
        pendingV.actionBlock { [self] in
            self.collectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setView(.white, .black, .white, .black, Colors.bgGreenColor.value, .white, .white, .black)
            activeMemberPendingApiCall()
        }
        
        // -- Expired Licenses
        expiredV.actionBlock {
            self.collectionV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setView(.white, .black, .white, .black, .white, .black, Colors.bgGreenColor.value, .white)
            self.setcustomNav(customView: self.customView, titleIsHidden: false, titleText: "My Expired License(s)", navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
            self.myLicensesViewModel?.expiredLicensesApi(self.view, self.collectionV) { responseModel in
                self.cell.setUpExpiredCollectionCell(self.collectionV, responseModel, self.expiredV.tag)
            }
        }
    }
    
    // MARK: - Functions
    private func setView(_ activeVBGColor: UIColor, _ activeLblColor: UIColor, _ memberVBGColor: UIColor, _ memberLblColor: UIColor, _ pendingVBGColor: UIColor, _ pendingLblColor: UIColor, _ expiredVBGColor: UIColor, _ expiredLblColor: UIColor) {
        self.activeV.backgroundColor = activeVBGColor
        self.activeLbl.textColor = activeLblColor
        self.memberV.backgroundColor = memberVBGColor
        self.memberLbl.textColor = memberLblColor
        self.pendingV.backgroundColor = pendingVBGColor
        self.pendingLbl.textColor = pendingLblColor
        self.expiredV.backgroundColor = expiredVBGColor
        self.expiredLbl.textColor = expiredLblColor
    }
}

// MARK: - ViewWillLayoutSubviews
extension MyLicencesVC {
    
    // ViewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MyLicensesLayout().setLayout(collectionV)
    }
}

// MARK: - MyLicensesViewModelDelegate
extension MyLicencesVC: MyLicensesViewModelDelegate {
    func multiPolygon2SuccessCalled() {
        HUD.hide()
    }
    
    func multiPolygon2ErrorCalled() {
        
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
    
    func polyLayerSuccessCalled() {
        HUD.hide()
    }
    
    func polyLayerErrorCalled() {
        HUD.hide()
    }
    
    func pointLayerSuccessCalled() {
        HUD.hide()
    }
    
    func pointLayerErrorCalled() {
        HUD.hide()
    }
    
    func activeLicenseSuccess(_ collectionView: UICollectionView) {
        HUD.hide()
        self.noCountLbl.isHidden = true
        collectionView.reloadData()
    }
    
    func memberLicenseSuccess(_ collectionView: UICollectionView) {
        HUD.hide()
        self.noCountLbl.isHidden = true
        collectionView.reloadData()
    }
    
    func pendingLicenseSuccess(_ collectionView: UICollectionView) {
        HUD.hide()
        self.noCountLbl.isHidden = true
        collectionView.reloadData()
    }
    
    func expiredLicensesSuccess(_ collectionView: UICollectionView) {
        HUD.hide()
        self.noCountLbl.isHidden = true
        collectionView.reloadData()
    }
    
    func activeLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
        HUD.hide()
      //  self.noCountLbl.isHidden = false
      //  self.noCountLbl.text = AppAlerts.noActiveLicense.title
       // cell.viewTag = tag
      //  collectionView.reloadData()
    }
    
    func memberLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
        //HUD.hide()
//self.noCountLbl.isHidden = false
     //   self.noCountLbl.text = AppAlerts.noMemberLicense.title
       // cell.viewTag = tag
       // collectionView.reloadData()
    }
    
    func pendingLicenseErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
       // HUD.hide()
        //self.noCountLbl.isHidden = false
       // self.noCountLbl.text = AppAlerts.noPendingLicense.title
      //  cell.viewTag = tag
      //  collectionView.reloadData()
    }
    
    func expiredLicensesErrorCalled(_ collectionView: UICollectionView, _ tag : Int) {
        HUD.hide()
        self.noCountLbl.isHidden = false
        self.noCountLbl.text = AppAlerts.noExpiredLicense.title
        cell.viewTag = tag
        collectionView.reloadData()
    }
    func acceptLicenseSuccessCalled() {
        HUD.hide()
        collectionV.reloadData()
    }
    func acceptLicenseErrorCalled(_ error: String) {
        HUD.flash(.labeledError(title: EMPTY_STR, subtitle: error), delay: 1.0)
    }
}

// MARK: - ActiveLicenseCellDelegate
extension MyLicencesVC : ActiveLicenseCellDelegate, WKUIDelegate {
    func returnActiveViewCompletion(_ agreementName: String, _ licenseContractID: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // -- Pass LicenseAgreement to PDF View
            self.viewTransition(self.acceptLicensePopUpView)
            self.showActiveWebView(agreementName, licenseContractID)
        }
    }
    
    func showActiveWebView(_ agreementName: String, _ licenseContractID: Int) {
        self.webView = WKWebView(frame: self.acceptLicensePopUpView.pdfView.bounds, configuration: WKWebViewConfiguration())
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.acceptLicensePopUpView.pdfView.addSubview(self.webView)
        self.webView.allowsBackForwardNavigationGestures = true
        let myURL = URL(string: agreementName)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
        
        // -- Accept Button
        self.acceptLicensePopUpView.acceptView.actionBlock {
            ApiStore.shared.acceptManualPaymentApi(self.view, licenseContractID) { responseModel in
                print(responseModel)
                if responseModel.statusCode == 200 {
                    HUD.hide()
                    self.removeView(self.acceptLicensePopUpView)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.myLicensesViewModel?.activeLicensesApi(self.view, self.collectionV) { [self] responseModel in
                            self.cell.setUpActiveCollectionCell(self.collectionV, responseModel, self.activeV.tag)
                            collectionV.reloadData()
                        }
                    }
                } else {
                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: responseModel.message!), delay: 1.0)
                }
            }
        }
        
        // -- Cross Button
        self.acceptLicensePopUpView.crossBtn.actionBlock {
            self.removeView(self.acceptLicensePopUpView)
        }
    }
    
    func returnPendingViewCompletion(_ agreementName: String, _ licenseContractID: Int, _ userAccountID: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // -- Pass LicenseAgreement to PDF View
            self.viewTransition(self.acceptLicensePopUpView)
            self.showPendingWebView(agreementName, licenseContractID)
        }
    }
    
    func showPendingWebView(_ agreementName: String, _ licenseContractID: Int) {
        self.webView = WKWebView(frame: self.acceptLicensePopUpView.pdfView.bounds, configuration: WKWebViewConfiguration())
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.acceptLicensePopUpView.pdfView.addSubview(self.webView)
        self.webView.allowsBackForwardNavigationGestures = true
        let myURL = URL(string: agreementName)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
        
        // -- Accept Button
        self.acceptLicensePopUpView.acceptView.actionBlock {
            ApiStore.shared.acceptLicensesReqApi(self.view, licenseContractID, LocalStore.shared.userAccountId) { responseModel in
                print(responseModel)
                if responseModel.statusCode == 200 {
                    HUD.hide()
                    self.removeView(self.acceptLicensePopUpView)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
//                        self.myLicensesViewModel?.pendingLicenseApi(self.view, self.collectionV) { responseModel in
//                            self.cell.setUpPendingCollectionCell(self.collectionV, responseModel, self.pendingV.tag)
//                        }
                        activeMemberPendingApiCall()
                        
                    }
                } else {
                    HUD.flash(.labeledError(title: EMPTY_STR, subtitle: responseModel.message!), delay: 1.0)
                }
            }
        }
        
        // -- Cross Button
        self.acceptLicensePopUpView.crossBtn.actionBlock {
            self.removeView(self.acceptLicensePopUpView)
        }
    }
}

// MARK: - WKNavigationDelegate
extension MyLicencesVC : WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.acceptLicensePopUpView.activityIndicatorV.startAnimating()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.acceptLicensePopUpView.activityIndicatorV.stopAnimating()
        self.acceptLicensePopUpView.activityIndicatorV.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.acceptLicensePopUpView.activityIndicatorV.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let btns = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
            if index == 0 {
                self.removeView(self.acceptLicensePopUpView)
            }
        }
    }
}

// MARK: - ViewWillTransition
extension MyLicencesVC {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.acceptLicensePopUpView.pdfViewTop.constant = 20
                self.acceptLicensePopUpView.pdfBottom.constant = 20
                self.acceptLicensePopUpView.crossBtnTop.constant = 10
            case .portrait, .portraitUpsideDown:
                self.acceptLicensePopUpView.pdfViewTop.constant = 40
                self.acceptLicensePopUpView.pdfBottom.constant = 40
                self.acceptLicensePopUpView.crossBtnTop.constant = 30
            default:
                self.acceptLicensePopUpView.pdfViewTop.constant = 40
                self.acceptLicensePopUpView.pdfBottom.constant = 40
                self.acceptLicensePopUpView.crossBtnTop.constant = 30
            }
        } else {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.acceptLicensePopUpView.pdfViewTop.constant = 40
                self.acceptLicensePopUpView.pdfBottom.constant = 40
                self.acceptLicensePopUpView.crossBtnTop.constant = 25
            case .portrait, .portraitUpsideDown:
                self.acceptLicensePopUpView.pdfViewTop.constant = 80
                self.acceptLicensePopUpView.pdfBottom.constant = 80
                self.acceptLicensePopUpView.crossBtnTop.constant = 65
            default:
                self.acceptLicensePopUpView.pdfViewTop.constant = 80
                self.acceptLicensePopUpView.pdfBottom.constant = 80
                self.acceptLicensePopUpView.crossBtnTop.constant = 65
            }
        }
        
        collectionV.reloadData()
    }
}
