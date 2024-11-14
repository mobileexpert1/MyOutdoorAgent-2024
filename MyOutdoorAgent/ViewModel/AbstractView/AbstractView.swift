//  AbstractView.swift
//  MyOutdoorAgent
//  Created by CS on 05/08/22.

import UIKit

class AbstractView: UIViewController {
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Navigation Properties
    // -- Navigate to home Page
    func goToHomePage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.executeVC(Storyboards.main.name, Navigation.homeNav.name)
    }
    
    // -- Navigate to login Page
    func goToLoginPage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.executeVC(Storyboards.main.name, Navigation.loginNav.name)
    }
    
    //MARK: - Animate PopUp
    func viewTransition(_ addView: UIView) {
        UIView.transition(with: view, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(addView)
            self.viewConstraints(addView)
        })
    }
    
    // -- Remove View From SuperView
    func removeView(_ viewToRemove: UIView) {
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.7, options: .transitionCrossDissolve, animations: {
                viewToRemove.removeFromSuperview()
            })
        }
    }
    
    // -- Remove View From SuperView with Duration
    func removeViewWithDuration(_ viewToRemove: UIView, _ duration: Double) {
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: duration, options: .transitionCrossDissolve, animations: {
                viewToRemove.removeFromSuperview()
            })
        }
    }
    
    // -- Set PopUp View Constraints
    func viewConstraints(_ View: UIView) {
        View.translatesAutoresizingMaskIntoConstraints = false
        View.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        View.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        View.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        View.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        View.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func loginAlert() {
        let btns = [ButtonText.cancel.text, ButtonText.login.text]
        UIAlertController.showAlert(AppAlerts.authReq.title, message: AppAlerts.loginFirst.title, buttons: btns) { alert, index in
            if index == 1 {
                self.pushOnly(Storyboards.main.name, Controllers.form.name, true)
            }
        }
    }
}
