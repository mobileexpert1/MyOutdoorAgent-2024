//  UIAlertController.swift

import UIKit

extension UIAlertController {
    
    // MARK: - Shows alert view with completion block
    class func alert(_ title: String, message: String, buttons: [String], completion: ((_ : UIAlertController, _ : Int) -> Void)?) -> UIAlertController {
        let alertView: UIAlertController? = self.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttons.count {
            alertView?.addAction(UIAlertAction(title: buttons[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i)
                }
            }))
        }
        // Add all other buttons
        return alertView!
    }
    
    // MARK: - Shows alert view with completion block
    class func showAlert(_ title: String, message: String, buttons: [String], completion: ((UIAlertController, Int) -> Void)?) {
        let alertView: UIAlertController? = self.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttons.count {
            alertView?.addAction(UIAlertAction(title: buttons[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i)
                }
            }))
        }
        UIApplication.visibleViewController.present(alertView!, animated: true, completion: nil)
    }
    
    // MARK: - Shows action sheet with completion block
    class func showActionSheet(_ btn: UIView, _ title: String!, cancelButtonTitle: String!, destructiveButtonTitle: String!, otherButtonTitles: [String]!, completion: ((_ alert: UIAlertController, _ buttonIndex: Int) -> Void)?) {
        
        let alertView: UIAlertController? = self.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        var inc: Int = 0
        
        for i in 0..<otherButtonTitles.count {
            alertView?.addAction(UIAlertAction(title: otherButtonTitles[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i + inc)
                }
            }))
            alertView?.view.tintColor = .black
        } // Add all other buttons
        
        if (destructiveButtonTitle.count != 0) {
            inc += 1
            alertView?.addAction(UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, 0)
                }
            })) // Destructive button
        }
        
        if (cancelButtonTitle.count != 0) {
            inc += 1
            alertView?.addAction(UIAlertAction(title: cancelButtonTitle, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, destructiveButtonTitle.count != 0 ? 1 : 0)
                }
            })) // Cancel button
        }
        
        alertView?.popoverPresentationController?.sourceView = btn
        UIApplication.visibleViewController.present(alertView!, animated: true, completion: nil)
    }
}
