//  PrivacyPolicyVC.swift
//  MyOutdoorAgent
//  Created by CS on 15/11/22.

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController, WKUIDelegate {
    
    // MARK: - Variables
    var webView: WKWebView!
    var allowLoad = true
    
    // MARK: - Outlets
    @IBOutlet weak var privacyPolicyV: UIView!
    @IBOutlet weak var activityIndicatorV: UIActivityIndicatorView!
    @IBOutlet weak var customNavV: CustomNavBar!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
       
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        showWebView()
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavV, titleIsHidden: false, titleText: NavigationTitle.privacyPolicy.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
    }
    
    private func showWebView() {
       
        self.webView = WKWebView(frame: self.privacyPolicyV.bounds, configuration: WKWebViewConfiguration())
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.privacyPolicyV.addSubview(self.webView)
        //vish
       // self.webView.scrollView.subviews.forEach { $0.isUserInteractionEnabled = false }
        let myURL = URL(string: Urls.privacyPolicy.name)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
        
    }
}

// MARK: - WKNavigationDelegate
extension PrivacyPolicyVC : WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicatorV.startAnimating()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicatorV.stopAnimating()
        self.activityIndicatorV.hidesWhenStopped = true
        self.allowLoad = false
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityIndicatorV.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let btns = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
            if index == 0 {
            }
        }
    }
}
