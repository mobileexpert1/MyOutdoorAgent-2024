//  PaymentVC.swift
//  MyOutdoorAgent
//  Created by CS on 27/10/22.

import UIKit
import WebKit

class PaymentVC: UIViewController, WKUIDelegate {
    
    //MARK: - Variables
    var webView: WKWebView!
    var btns = [ButtonText.ok.text]
    var publicId = String()
    
    // MARK: - Outlets
    @IBOutlet weak var customNavView: CustomNavBar!
    @IBOutlet weak var paymentV: UIView!
    @IBOutlet weak var activityV: UIActivityIndicatorView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let data = dataFromLastVC as! [String:Any]
        let token = data["token"] as! String
        print("token",token)
        publicId = data["publicKey"] as? String ?? ""
        print("publicKey",publicId)
        showActiveWebView(Apis.openPaymentTokenUrl + token)
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavView, titleIsHidden: false, titleText: NavigationTitle.payment.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
    }
    
    private func showActiveWebView(_ paymentToken: String) {
        webView = WKWebView(frame: self.paymentV.bounds, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        paymentV.addSubview(self.webView)
        webView.allowsBackForwardNavigationGestures = true
        let myURL = URL(string: paymentToken)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

// MARK: - WKNavigationDelegate
extension PaymentVC : WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityV.startAnimating()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url{
            print("currentURL .,.,.,.,.",currentURL)
        }
        
        self.activityV.stopAnimating()
        self.activityV.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityV.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
            if index == 0 {
                self.popOnly()
            }
        }
    }
//    "https://myoutdooragent.com/#/app/property?id="+publicId+"&PaymentStatus=fail"
//    "https://myoutdooragent.com/"
//    if (urlString == URL(string: "https://testoneconnect.myoutdooragent.com/")) || (urlString ==  URL(string: "https://testoneconnect.myoutdooragent.com/#/app/property?id="+publicId+"&PaymentStatus=fail")) {
//        print("urlString------>>>>>>>>",urlString)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url
        print("urlString--------",urlString)
        if (urlString == URL(string: "https://oneconnect.myoutdooragent.com/")) || (urlString ==  URL(string: "https://oneconnect.myoutdooragent.com/#/app/property?id="+publicId+"&PaymentStatus=fail")) {
            print("urlString------>>>>>>>>",urlString)
            
            UIAlertController.showAlert(AppAlerts.paymentFailed.title, message: AppErrors.unablePaymentError.localizedDescription, buttons: btns) { alert, index in
                if index == 0 {
                    self.popOnly()
                   // self.pushOnly(Storyboards.myLicencesView.name, Controllers.myLicenses.name, true)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
                }
            }
        }
        
        if urlString == URL(string:"https://myoutdooragent.com/property?id=" + publicId + "&PaymentTransactionKey=paid&ClientToken=paid&ClientInvoiceID=paid&TransactionID=paid&PaymentMethod=paid&PaymentStatus=paid") {
            UIAlertController.showAlert(AppAlerts.paymentSuccess.title, message: AppErrors.paymentSuccess.localizedDescription, buttons: btns) { alert, index in
                if index == 0 {
                    self.pushOnly(Storyboards.myLicencesView.name, Controllers.myLicenses.name, true)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
                }
            }
        }
//        if urlString == URL(string: "https://testoneconnect.myoutdooragent.com/Error") {
//            UIAlertController.showAlert(AppErrors.paymentError.localizedDescription, message: AppErrors.paymentError.localizedDescription, buttons: btns) { alert, index in
//                if index == 0 {
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
//                }
//            }
//        }
 
      //  if urlString == URL(string: "https://oneconnect.myoutdooragent.com/Recipient") {
        if urlString == URL(string: "https://oneconnect.myoutdooragent.com/MOA/Recipient"){
            UIAlertController.showAlert(AppAlerts.paymentSuccess.title, message: AppErrors.paymentSuccess.localizedDescription, buttons: btns) { alert, index in
                if index == 0 {
                    self.pushOnly(Storyboards.myLicencesView.name, Controllers.myLicenses.name, true)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
//                    let vC = UIStoryboard(name: Storyboards.main.name, bundle: Bundle.main).instantiateViewController(withIdentifier: Navigation.homeNav.name)
//                    UIApplication.shared.windows.first?.rootViewController = vC
//                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
        }
        decisionHandler(.allow)
    }
}

