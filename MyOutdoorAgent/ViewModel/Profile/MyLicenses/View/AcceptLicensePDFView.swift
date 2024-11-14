//  AcceptLicensePDFView.swift
//  MyOutdoorAgent
//  Created by CS on 23/09/22.

import UIKit
import WebKit

class AcceptLicensePDFView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var acceptMainView: UIView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var pdfView: WKWebView!
    @IBOutlet weak var activityIndicatorV: UIActivityIndicatorView!
    @IBOutlet weak var pdfViewTop: NSLayoutConstraint!
    @IBOutlet weak var pdfBottom: NSLayoutConstraint!
    @IBOutlet weak var pdfLeading: NSLayoutConstraint!
    @IBOutlet weak var pdfTrailing: NSLayoutConstraint!
    @IBOutlet weak var crossBtn: UIImageView!
    @IBOutlet weak var crossBtnTop: NSLayoutConstraint!
}
