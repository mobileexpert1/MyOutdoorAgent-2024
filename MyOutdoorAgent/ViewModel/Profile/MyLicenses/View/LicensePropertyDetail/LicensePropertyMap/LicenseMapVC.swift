//  LicenseMapVC.swift
//  MyOutdoorAgent
//  Created by CS on 22/11/22.

import UIKit
import WebKit

class LicenseMapVC: UIViewController {
    
    // MARK: - Variables
    var webView: WKWebView!
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var activityV: UIActivityIndicatorView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let data = dataFromLastVC as! [String: Any]
        let agreementName = data["agreementName"] as! String
        showMapWebView(agreementName)
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
    }
    
    private func setUI() {
        showNavigationBar(false)
        backBtn.actionBlock {
            self.popOnly()
        }
    }
    
    func showMapWebView(_ agreementName: String) {
        self.webView = WKWebView(frame: self.mapView.bounds, configuration: WKWebViewConfiguration())
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.mapView.addSubview(self.webView)
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.white
        self.webView.scrollView.backgroundColor = UIColor.white
        if #available(iOS 15.0, *) {
            self.webView.underPageBackgroundColor = .white
        } else {
        }
        let myURL = URL(string: agreementName)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }
}

// MARK: - WKNavigationDelegate
extension LicenseMapVC : WKNavigationDelegate, WKUIDelegate {
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityV.startAnimating()
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityV.stopAnimating()
        self.activityV.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityV.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let btns = [ButtonText.ok.text]
        UIAlertController.showAlert(AppAlerts.alert.title, message: AppErrors.internetIssue.localizedDescription, buttons: btns) { alert, index in
            if index == 0 {
                self.popOnly()
            }
        }
    }
}
